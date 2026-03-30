/**
 * Tests for scripts/hooks/desktop-notify.js
 */

const assert = require('assert');
const fs = require('fs');
const Module = require('module');
const path = require('path');

const modulePath = path.join(__dirname, '..', '..', 'scripts', 'hooks', 'desktop-notify.js');
const moduleSource = fs.readFileSync(modulePath, 'utf8');

function test(name, fn) {
  try {
    fn();
    console.log(`  ✓ ${name}`);
    return true;
  } catch (error) {
    console.log(`  ✗ ${name}`);
    console.log(`    Error: ${error.message}`);
    return false;
  }
}

function loadDesktopNotify({ procVersion = 'Linux version microsoft', spawnImpl, isMacOS = false }) {
  const logs = [];
  const mod = new Module(modulePath, module);
  mod.filename = modulePath;
  mod.paths = Module._nodeModulePaths(path.dirname(modulePath));

  const originalRequire = mod.require.bind(mod);
  mod.require = request => {
    if (request === 'child_process') {
      return { spawnSync: spawnImpl };
    }
    if (request === '../lib/utils') {
      return {
        isMacOS,
        log: message => logs.push(message),
      };
    }
    if (request === 'fs') {
      return {
        ...fs,
        readFileSync(target, encoding) {
          if (target === '/proc/version') {
            return procVersion;
          }
          return fs.readFileSync(target, encoding);
        }
      };
    }
    return originalRequire(request);
  };

  const platformDescriptor = Object.getOwnPropertyDescriptor(process, 'platform');
  Object.defineProperty(process, 'platform', {
    configurable: true,
    value: 'linux',
  });

  try {
    mod._compile(moduleSource, modulePath);
  } finally {
    Object.defineProperty(process, 'platform', platformDescriptor);
  }

  return { run: mod.exports.run, logs };
}

let passed = 0;
let failed = 0;

if (
  test('successful WSL toast does not log BurntToast install guidance', () => {
    const calls = [];
    const { run, logs } = loadDesktopNotify({
      spawnImpl(command, args) {
        calls.push({ command, args });
        if (calls.length === 1) {
          return { status: 0, stderr: Buffer.from('') };
        }
        return { status: 0, stderr: Buffer.from('') };
      }
    });

    const payload = JSON.stringify({ last_assistant_message: 'Build completed successfully' });
    assert.strictEqual(run(payload), payload);
    assert.strictEqual(calls.length, 2, 'Expected PowerShell probe and notification send');
    assert.strictEqual(logs.length, 0, `Expected no warnings, got: ${logs.join('\n')}`);
  })
)
  passed++;
else failed++;

if (
  test('failed WSL toast logs failure and install guidance once', () => {
    const { run, logs } = loadDesktopNotify({
      spawnImpl(command, args) {
        if (args[1] === 'exit 0') {
          return { status: 0, stderr: Buffer.from('') };
        }
        return { status: 1, stderr: Buffer.from('module missing') };
      }
    });

    const payload = JSON.stringify({ last_assistant_message: 'Done' });
    assert.strictEqual(run(payload), payload);
    assert.ok(logs.some(message => message.includes('BurntToast failed')), 'Expected BurntToast failure log');
    assert.ok(logs.some(message => message.includes('Install BurntToast module')), 'Expected install tip');
  })
)
  passed++;
else failed++;

console.log(`\nPassed: ${passed}`);
console.log(`Failed: ${failed}`);
process.exit(failed > 0 ? 1 : 0);
