// Usage: node patch-app.js <extracted-app-dir>
// Neutralizes Windows-only behavior in the upstream Electron main process.
const fs = require('fs');
const path = require('path');

const file = path.join(process.argv[2], 'build/obf-app/main.js');
let src = fs.readFileSync(file, 'utf8');

function replaceOnce(from, to) {
  const count = src.split(from).length - 1;
  if (count !== 1) throw new Error(`expected 1 match, found ${count}: ${from}`);
  src = src.replace(from, () => to);
}

// Windows updater (downloads .exe, needs elevation)
replaceOnce('updater.startUpdateChecks(mainWindow)', 'void 0');

// Remote page could run arbitrary shell commands via IPC
replaceOnce(
  "ipcMain.handle('run-shell-command', async (event, command) => {",
  "ipcMain.handle('run-shell-command', async (event, command) => {\n  return { stdout: '', stderr: '', error: 'run-shell-command disabled on Linux build' };",
);

fs.writeFileSync(file, src);
console.log('patched', file);
