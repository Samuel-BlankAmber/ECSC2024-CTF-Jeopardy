using System.Net.Mime;
using System.Text;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Filters;

namespace backend.Controllers
{
    public class NewFile {
        public Object? metadata { get; set; }
        public required string Filename { get; set; }
        public required string Key { get; set; }
        public required string Value { get; set; }
    }

    [ApiController]
    [Route("[controller]")]
    public class FilesController : Controller
    {
        public override void OnActionExecuting(ActionExecutingContext ctx)
        {
            base.OnActionExecuting(ctx);
            ctx.HttpContext.Session.SetString("lastActionTime", DateTime.UtcNow.ToLongDateString());
            var sessionDir = Path.Combine("/tmp/vault", ctx.HttpContext.Session.Id);
            ctx.HttpContext.Session.SetString("sessionDir", sessionDir);
            Directory.CreateDirectory(sessionDir);
        }

        [HttpGet(Name = "GetFiles")]
        public string[] Get()
        {
            var files = from path in Directory.GetFiles(HttpContext.Session.GetString("sessionDir")!) select Path.GetFileName(path);
            return files.ToArray<string>();
        }

        [HttpGet("{filename}")]
        public ActionResult GetFile(string filename) {
            var sessionDir = HttpContext.Session.GetString("sessionDir")!;
            filename = Path.GetFileName(filename); // Avoid path traversal
            var path = Path.Combine(sessionDir, filename);
            return PhysicalFile(path, MediaTypeNames.Text.Plain, filename);
        }

        [HttpGet("{filename}/content")]
        public string GetFileContent(string filename) {
            var sessionDir = HttpContext.Session.GetString("sessionDir")!;
            filename = Path.GetFileName(filename);
            var path = Path.Combine(sessionDir, filename);
            var fw = new FileWrapper
            {
                source = path,
            };
            return fw.content;
        }

        [HttpPost(Name = "PostFiles")]
        public void Post([FromBody] NewFile fileData) {
            var metadataLength = fileData.metadata != null
                ? fileData.metadata.ToString()!.Length
                : 0;

            if (fileData.Key.Length > 30 || fileData.Value.Length > 30) {
                throw new OverflowException("Key or Value are more than 30 characters");
            }
            if (metadataLength > 300) {
                throw new OverflowException("metadata are more than 300");
            }

            var payload = $"{fileData.Key}|{fileData.Value}|{fileData.metadata?.ToString()!}";
            var count = payload.Length - payload.Replace("|", "").Length;
            if (count != 2) {
                throw new ArgumentException("Can't use '|' character");
            }

            var sessionDir = HttpContext.Session.GetString("sessionDir")!;
            var filename = Path.GetFileName(fileData.Filename); // Avoid path traversal
            var path = Path.Combine(sessionDir, filename);
            var fw = new FileWrapper
            {
                source = path,
            };

            fw.content = payload;
        }

        [HttpPost("{filename}")]
        public void BackupFile(string filename)
        {
            var sessionDir = HttpContext.Session.GetString("sessionDir")!;
            filename = Path.GetFileName(filename);
            var path = Path.Combine(sessionDir, filename);
            var backupDir = Path.Combine("/tmp/backup/", HttpContext.Session.Id);
            var backupPath = Path.Combine(backupDir, filename);
            Directory.CreateDirectory(backupDir);
            var fw = new FileWrapper
            {
                source = path,
            };
            fw.path = backupPath;
        }

        [HttpDelete("{filename}")]
        public void DeleteFile(string filename) {
            var sessionDir = HttpContext.Session.GetString("sessionDir")!;
            filename = Path.GetFileName(filename); // Avoid path traversal
            var path = Path.Combine(sessionDir, filename);
            var fw = new FileWrapper
            {
                source = path,
            };
            fw.stored = false;
        }
    }
}
