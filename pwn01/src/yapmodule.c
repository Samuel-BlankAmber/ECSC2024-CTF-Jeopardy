#define PY_SSIZE_T_CLEAN
#include <Python.h>

#define STACKSIZE 128
#define STACKTRACE_SIZE 0x4000
#define BUFSIZE 0x20000

#define DEBUG

enum YamlTypes {
  Unknown,
  Mapping,
  List,
};

struct IndentationLevel {
  enum YamlTypes type;
  unsigned int level;
  PyObject* object;
  PyObject* last_key;
};

struct YapCtx {
  uint32_t cur_level;
  uint32_t cur_line;
  struct IndentationLevel indent_stack[STACKSIZE];
  int debug_mode;
  char parsed_fname[0x200];
};


static PyObject *YapInvalidYamlError;

#define min(a,b)                \
  ({ __typeof__ (a) _a = (a);   \
    __typeof__ (b) _b = (b);    \
    _a < _b ? _a : _b; })




void exception_preface(char** scorr, char* buf, void* start) {
  *scorr += snprintf(*scorr, STACKTRACE_SIZE - (*scorr - buf), "\nDEBUG: exception triggered at %p\n", start);

  PyObject *sys_module = PyImport_ImportModule("sys");
  if (sys_module == NULL) exit(-1);
  // Get the 'modules' dictionary from 'sys'
  PyObject *modules_dict = PyObject_GetAttrString(sys_module, "modules");
  if (modules_dict == NULL || !PyDict_Check(modules_dict)) exit(-1);

  // Iterate over the dictionary and print module names
  PyObject *key, *value;
  Py_ssize_t pos = 0;
  while (PyDict_Next(modules_dict, &pos, &key, &value)) {
    if (PyUnicode_Check(key)) {
      const char *module_name = PyUnicode_AsUTF8(key);
      *scorr += snprintf(*scorr, STACKTRACE_SIZE - (*scorr - buf), "Imported module: '%s' at %p\n", module_name, value);
    }
  }

  // Clean up references
  Py_DECREF(modules_dict);
  Py_DECREF(sys_module);
}


void format_exception(struct YapCtx* ctx, const char* fmt, ...) {
  va_list args;
  char buf[STACKTRACE_SIZE];
  va_start(args, fmt);

  if (ctx->debug_mode == 1) {
    char* scorr = buf;

    scorr += vsnprintf(scorr, STACKTRACE_SIZE, fmt, args);

    void *addr = __builtin_extract_return_addr (__builtin_return_address (0));


    exception_preface(&scorr, buf, addr);
    scorr += snprintf(scorr, STACKTRACE_SIZE - (scorr - buf),
                      "\nDEBUG: exception triggered at %p\n\nctx (%p) "
                      "= {\n\tcur_level = %d\n\tcur_line = %d\n\tindent_stack = [\n", addr, ctx, ctx->cur_level, ctx->cur_line);
    for (unsigned int i = 0; i < min(ctx->cur_level, STACKSIZE); i++) {
      struct IndentationLevel* cur = &ctx->indent_stack[i];
      scorr += snprintf(scorr, STACKTRACE_SIZE - (scorr - buf), "\t\t{level = %d, type = %d, object = %p, last_key = %p}\n", cur->level, cur->type, cur->object, cur->last_key);
    }
    scorr += snprintf(scorr, STACKTRACE_SIZE - (scorr - buf), "\t]\n}");
    PyErr_Format(YapInvalidYamlError, "%s", buf);
  } else {
    vsnprintf(buf, STACKTRACE_SIZE, fmt, args);
    PyErr_Format(YapInvalidYamlError, "%s", buf);
  }
  va_end(args);
}


#ifdef DEBUG
void print_context(struct YapCtx* ctx) {
  printf("ctx = {\n\tcur_level = %d\n\tcur_line = %d\n\tindent_stack = [\n", ctx->cur_level, ctx->cur_line);
  for (unsigned int i = 0; i < ctx->cur_level + 1; i++) {
    struct IndentationLevel* cur = &ctx->indent_stack[i];
    printf("\t\t{level = %d, type = %d, object = %p, last_key = %p}\n", cur->level, cur->type, cur->object, cur->last_key);
  }
  puts("\t]\n}");
}
#endif


char* skip_whitespace(char* scorr) {
  while (1) {
    char c = *scorr;
    if (c == ' ' || c == '\t') {
      scorr++; continue;
    }
    return scorr;
  }
}


enum YamlTypes get_type(struct YapCtx* ctx) {
  return ctx->indent_stack[ctx->cur_level].type;
}

int allocate_new(struct YapCtx* ctx, enum YamlTypes newtype) {
  switch (newtype) {
  case Mapping: {
    ctx->indent_stack[ctx->cur_level].object = PyDict_New();
    break;
  }
  case List: {
    ctx->indent_stack[ctx->cur_level].object = PyList_New(0);
    break;
  }
  }
  if (ctx->indent_stack[ctx->cur_level].object == NULL) {
    PyErr_Format(PyExc_RuntimeError, "Cannot allocate new object (line %d)", ctx->cur_line);
    return -1;
  }
  return 0;
}

int set_preclevel_key(struct YapCtx* ctx) {
  if (ctx->cur_level == 0) {
    format_exception(ctx, "Expected other at line %d", ctx->cur_line);
    return -1;
  }
  struct IndentationLevel* prec = &ctx->indent_stack[ctx->cur_level - 1];
  if (!PyDict_Check(prec->object)) {
    format_exception(ctx, "Expected dict, found other at line %d", ctx->cur_line);
    return -1;
  }
  return PyDict_SetItem(prec->object, prec->last_key, ctx->indent_stack[ctx->cur_level].object);
}



int match_level(uint32_t curlevel, struct YapCtx* ctx, enum YamlTypes newtype) {
  // Unwind stack
  if (ctx->indent_stack[ctx->cur_level].level > curlevel) {
    while (1) {
      if (ctx->cur_level == 0) {
        format_exception(ctx, "Invalid indentation level at line %d", ctx->cur_line);
        return -1;
      }
      ctx->cur_level--;
      if (curlevel == ctx->indent_stack[ctx->cur_level].level) break;
    }
  }
  if (ctx->indent_stack[ctx->cur_level].level == curlevel) {
    enum YamlTypes oldtype = get_type(ctx);
    if (oldtype == Unknown) {
      ctx->indent_stack[ctx->cur_level].type = newtype;
      return allocate_new(ctx, newtype);
    }
    if (newtype != oldtype) {
      format_exception(ctx, "Mixing lists and mappings at line %d", ctx->cur_line);
      return -1;
    }
    return 0;
  }

  // clvl < curlevel
  if (ctx->cur_level >= STACKSIZE) {
    format_exception(ctx, "Exceeded stack size at line %d", ctx->cur_line);
    return -1;
  }

  ctx->cur_level++;
  ctx->indent_stack[ctx->cur_level].level = curlevel;
  ctx->indent_stack[ctx->cur_level].type = newtype;
  ctx->indent_stack[ctx->cur_level].last_key = NULL;

  if (newtype != Unknown) {
    if (allocate_new(ctx, newtype) < 0) return -1;
    return set_preclevel_key(ctx);
  } else {
    ctx->indent_stack[ctx->cur_level].object = NULL;
    return 0;
  }
}



PyObject* parse_single_elem(char* scorr, struct YapCtx* ctx) {
  char* endptr;
  unsigned long long l;
  if (*scorr == '\0') {
    return Py_None;
  }
  if (!strcasecmp(scorr, "true")) {
    return Py_True;
  }
  if (!strcasecmp(scorr, "false")) {
    return Py_False;
  }
  if (!strcasecmp(scorr, "null")) {
    return Py_None;
  }

  l = strtoll(scorr, &endptr, 0);
  if (*endptr == '\0') {
    return PyLong_FromLong(l);
  }
  return PyUnicode_FromString(scorr);
}


int parse_elem_or_mapping(char* scorr, struct YapCtx* ctx) {
  char* sep = strstr(scorr, ":");

  if (sep == NULL) {
    // this is an element.
    if (ctx->cur_level == 0) {
      format_exception(ctx, "Cannot have level 0 objects at line %d", ctx->cur_line);
      return -1;
    }

    PyObject* curlist = ctx->indent_stack[ctx->cur_level - 1].object;
    if (curlist == NULL) {
      format_exception(ctx,
                       "Expected non null list at level %d (%d) at line %d",
                       ctx->cur_level - 1, ctx->indent_stack[ctx->cur_level - 1].level, ctx->cur_line
                       );
      return -1;
    }
    PyObject* val = parse_single_elem(scorr, ctx);
    if (val == NULL) return -1;

    if (!PyList_Check(curlist)) {
      format_exception(ctx, "Expected list, got other at line %d", ctx->cur_line);
      return -1;
    }
    return PyList_Append(curlist, val);
  }

  // this is a mapping
  char* value_s = skip_whitespace(sep + 1);
  *sep = '\0';
  PyObject* key = Py_BuildValue("s", scorr);
  ctx->indent_stack[ctx->cur_level].last_key = key;
  PyObject* value = parse_single_elem(value_s, ctx);
  return PyDict_SetItem(ctx->indent_stack[ctx->cur_level].object, key, value);
}

int parse_line(char* line, struct YapCtx* ctx) {
  char* scorr = skip_whitespace(line);
  uint32_t lvl = scorr - line;
  int ret = 0;
  enum YamlTypes newtype = Unknown;
  if (*scorr == '-') {
    newtype = List;
  } else if (isalnum(*scorr)) {
    newtype = Mapping;
  }
  if (newtype == Unknown) {
    format_exception(ctx, "Bad char at line %d, col %d: %c", ctx->cur_line, scorr - line, *scorr);
    return -1;
  }

  ret = match_level(lvl, ctx, newtype);
  if (ret < 0) return ret;

  if (newtype == List) {
    scorr = skip_whitespace(scorr + 1);
    enum YamlTypes nested = (strstr(scorr, ":") == NULL) ? Unknown : Mapping;
    ret = match_level(scorr - line, ctx, nested);
    if (ret < 0) return ret;
  }

  return parse_elem_or_mapping(scorr, ctx);
}

PyObject* parse(char* buf, int debug_mode, const char* fname) {
  struct YapCtx ctx;
  memset(&ctx, 0, sizeof(ctx));
  ctx.cur_level = 0;
  ctx.cur_line = 1;
  ctx.debug_mode = debug_mode;
  ctx.indent_stack[0].level = 0;
  ctx.indent_stack[0].type = Unknown;
  ctx.indent_stack[0].object = NULL;
  ctx.indent_stack[0].last_key = NULL;
  strncpy((char*) &ctx.parsed_fname, fname, 0x200 - 1);



  for (char* line = strtok(buf, "\n"); line != NULL; line = strtok(NULL, "\n")) {
    if (parse_line(line, &ctx) != 0) return NULL;
    ctx.cur_line++;
  }

  if (ctx.indent_stack[0].object == NULL) {
    format_exception(&ctx, "Something globally failed");
  }
  return ctx.indent_stack[0].object;
}


static PyObject* yap_load(PyObject* self, PyObject* args, PyObject* kwargs) {
  const char* fname;
  FILE* fp;
  char buf[BUFSIZE];

  memset(buf, 0, BUFSIZE);

  static char *kwlist[] = {"filename", "debug", NULL};

  PyObject* debug_mode = NULL;
  // Parse the input Python object as a C string
  if (!PyArg_ParseTupleAndKeywords(args, kwargs, "s|O!", kwlist, &fname, &PyBool_Type, &debug_mode)) {
    return NULL;
  }

  fp = fopen(fname, "r");
  if (!fp) {
    PyErr_SetFromErrno(PyExc_RuntimeError);
    return NULL;
  }

  if (fread(buf, BUFSIZE + 0x100, 1, fp) < 0) {
    PyErr_SetFromErrno(PyExc_RuntimeError);
    fclose(fp);
    return NULL;
  }
  fclose(fp);

  return parse(buf, debug_mode == Py_True, fname);
}


static PyMethodDef yapMethods[] = {
  {"load", (PyCFunction) yap_load, METH_VARARGS | METH_KEYWORDS, "Load yaml from file"},
  {NULL, NULL, 0, NULL}
};


static struct PyModuleDef yapmodule = {
    PyModuleDef_HEAD_INIT,
    "yap",
    "Faster C implementation for yaml load",
    -1,
    yapMethods
};




PyMODINIT_FUNC PyInit_yap(void) {
  PyObject* module;

  module = PyModule_Create(&yapmodule);
  if (module == NULL) return NULL;

  YapInvalidYamlError = PyErr_NewException("yap.InvalidYamlError", NULL, NULL);
  Py_XINCREF(YapInvalidYamlError);
  if (PyModule_AddObject(module, "InvalidYamlError", YapInvalidYamlError) < 0) {
    Py_XDECREF(YapInvalidYamlError);
    Py_CLEAR(YapInvalidYamlError);
    Py_DECREF(module);
    return NULL;
  }

  return module;
}
