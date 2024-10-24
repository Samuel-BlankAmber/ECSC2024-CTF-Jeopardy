CC := gcc
CFLAGS := -Wall -Wextra -Werror -std=gnu17 -O0 -fPIE -pie
LFLAGS := -Wl,-z,relro,-z,now
SRCDIR := src
OBJDIR := obj
BINDIR := bin
INCDIR := include
BINARY := $(BINDIR)/secret-keeper

SRCS := $(wildcard $(SRCDIR)/*.c)
OBJS := $(SRCS:$(SRCDIR)/%.c=$(OBJDIR)/%.o)

CFLAGS += -I$(INCDIR)

# Debug mode
DEBUG := 0
ifeq ($(DEBUG), 1)
	CFLAGS += -g -O0 -DDEBUG
endif

all: $(BINARY)

$(BINARY): $(OBJS) | $(BINDIR)
	@echo "Linking final binary: $@"
	$(CC) $(CFLAGS) $^ -o $@ $(LFLAGS)

$(OBJS): $(OBJDIR)/%.o : $(SRCDIR)/%.c | $(OBJDIR)
	@echo "Compiling object $@"
	$(CC) $(CFLAGS) -MMD -MP -c $< -o $@

# Directories targets
$(BINDIR):
	@echo "MKDIR $@"
	@mkdir -p $@

$(OBJDIR):
	@echo "MKDIR $@"
	@mkdir -p $@

clean:
	@echo "RM $(OBJDIR) $(BINDIR)"
	rm -rf $(OBJDIR) $(BINDIR)

# Include dependency files
-include $(OBJS:.o=.d)

.PHONY: all clean
