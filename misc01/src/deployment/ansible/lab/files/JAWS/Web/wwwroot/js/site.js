async function executeCommand(command) {
  const response = await fetch("/command", {
    method: "POST",
    headers: {
      "Content-Type": "application/json",
    },
    body: JSON.stringify({ command: command }),
  });
  const data = await response.json();
  if (data.error && data.error.length > 0) {
    throw new Error(data.error);
  }
  return data.output;
}

$("#terminal").terminal(
  async function repl(command) {
    if (command.trim() !== "") {
      try {
        var result = await executeCommand(command.trim());
        if (result) {
          this.echo(result);
        }
      } catch (e) {
        console.error(e);
        this.error(new String(e));
      }
    }
  },
  {
    greetings:
      "Just A Web Shell (JAWS) [Version 0.0.1-alpha]\n(c) Generic Software Solutions Corporation. All rights reserved.\n",
    prompt: "> ",
  }
);

$.terminal.syntax("powershell");
$.terminal.prism_formatters = {
  prompt: false,
  echo: false,
  animation: false,
  command: true,
};
