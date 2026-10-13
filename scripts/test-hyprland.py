#!/usr/bin/env python3
"""Exercise the standalone installer in disposable homes and validate Lua behavior."""
import os
from pathlib import Path
import shutil
import subprocess
import tempfile

REPO = Path(__file__).resolve().parents[1]
INSTALL = REPO / 'scripts/install-hyprland.sh'
BASH = shutil.which('bash')
LUA = shutil.which('lua')
HYPRLAND = shutil.which('Hyprland')


def run(args, env, succeeds=True):
    result = subprocess.run(args, env=env, text=True, capture_output=True)
    assert (result.returncode == 0) == succeeds, result.stdout + result.stderr
    return result


with tempfile.TemporaryDirectory(prefix='dotfiles-hypr-test-') as temp:
    base = Path(temp)
    bin_dir = base / 'bin'
    bin_dir.mkdir()
    for command in ['dirname', 'find', 'readlink', 'mkdir', 'mktemp', 'cp', 'mv', 'stow']:
        executable = shutil.which(command)
        assert executable, f'Missing test dependency: {command}'
        (bin_dir / command).symlink_to(executable)

    def environment(name, system='Linux', installed=True, custom=False):
        home = base / name
        home.mkdir()
        config = home / ('custom-config' if custom else '.config')
        uname = bin_dir / 'uname'
        uname.write_text(f'#!/bin/sh\nprintf "%s\\n" "{system}"\n')
        uname.chmod(0o755)
        hyprland = bin_dir / 'Hyprland'
        if hyprland.exists():
            hyprland.unlink()
        if installed:
            hyprland.write_text('#!/bin/sh\nexit 0\n')
            hyprland.chmod(0o755)
        env = dict(os.environ, HOME=str(home), PATH=str(bin_dir))
        env.pop('XDG_CONFIG_HOME', None)
        if custom:
            env['XDG_CONFIG_HOME'] = str(config)
        return env, config

    for name, system, installed in [('macos', 'Darwin', True), ('absent', 'Linux', False)]:
        env, config = environment(name, system, installed)
        run([BASH, str(INSTALL)], env)
        assert not config.exists(), 'Skipped install changed configuration'

    env, config = environment('fresh')
    run([BASH, str(INSTALL)], env)
    hypr = config / 'hypr'
    assert hypr.is_dir() and not hypr.is_symlink()
    assert (hypr / 'shared').is_dir() and not (hypr / 'shared').is_symlink()
    assert (hypr / 'hyprland.lua').resolve() == REPO / 'hyprland/.config/hypr/hyprland.lua'
    run([BASH, str(INSTALL)], env)
    assert not list(config.glob('hypr.backup.*'))

    # Replacing files preserves a complete snapshot and local hooks.
    env, config = environment('conflicts', custom=True)
    hypr = config / 'hypr'
    (hypr / 'shared').mkdir(parents=True)
    (hypr / 'hyprland.lua').write_text('-- original entrypoint\n')
    (hypr / 'shared/binds.lua').write_text('-- original binds\n')
    (hypr / 'xdph.conf').write_text('unrelated portal config\n')
    options = 'return { monitors = { "DP-3", "HDMI-A-1" }, commands = { terminal = "ghostty", launcher = "" } }\n'
    (hypr / 'local-options.lua').write_text(options)
    settings = 'hl.unbind("SUPER + W")\nhl.bind("SUPER + W", hl.dsp.exec_cmd("replacement"))\n'
    (hypr / 'local-settings.lua').write_text(settings)
    run([BASH, str(INSTALL)], env)
    backups = list(config.glob('hypr.backup.*'))
    assert len(backups) == 1
    backup = backups[0] / 'original'
    assert (backup / 'hyprland.lua').read_text() == '-- original entrypoint\n'
    assert (backup / 'shared/binds.lua').read_text() == '-- original binds\n'
    for name in ['local-options.lua', 'local-settings.lua', 'xdph.conf']:
        assert (backup / name).read_bytes() == (hypr / name).read_bytes()
    run([BASH, str(INSTALL)], env)
    assert len(list(config.glob('hypr.backup.*'))) == 1
    assert (hypr / 'local-options.lua').read_text() == options
    assert (hypr / 'local-settings.lua').read_text() == settings

    if LUA:
        mock = base / 'check.lua'
        mock.write_text('''
local binds = {}
local function dispatcher(name)
    return setmetatable({}, {
        __index = function(_, key) return dispatcher(name .. "." .. key) end,
        __call = function(_, arg) return { name = name, arg = arg } end,
    })
end
hl = setmetatable({
    dsp = dispatcher("dsp"),
    bind = function(key, action, flags)
        assert(not binds[key], "duplicate binding: " .. key)
        binds[key] = { action = action, flags = flags }
    end,
    unbind = function(key) binds[key] = nil end,
}, { __index = function() return function() end end })
dofile(arg[1])
assert(binds["SUPER + H"])
assert(not binds["SUPER + Space"])
if arg[2] == "local" then
    assert(binds["SUPER + Return"].action.arg == "ghostty")
    assert(binds["SUPER + code:10"].action.arg.monitor == "DP-3")
    assert(binds["SUPER + code:11"].action.arg.monitor == "HDMI-A-1")
    assert(not binds["SUPER + code:12"])
    assert(binds["SUPER + W"].action.arg == "replacement")
else
    assert(not binds["SUPER + Return"])
    assert(not binds["SUPER + code:10"])
end
''')
        run([LUA, str(mock), str(hypr / 'hyprland.lua'), 'local'], env)
        fresh_env = dict(env, HOME=str(base / 'fresh'))
        fresh_env.pop('XDG_CONFIG_HOME', None)
        run([LUA, str(mock), str(base / 'fresh/.config/hypr/hyprland.lua'), 'fresh'], fresh_env)
        (hypr / 'local-options.lua').write_text('return { workspace_count = 11 }\n')
        run([LUA, str(mock), str(hypr / 'hyprland.lua')], env, succeeds=False)
        (hypr / 'local-options.lua').write_text('invalid lua !!!\n')
        run([LUA, str(mock), str(hypr / 'hyprland.lua')], env, succeeds=False)
        (hypr / 'local-options.lua').write_text(options)
        if HYPRLAND:
            for verify_env, entrypoint in [(env, hypr / 'hyprland.lua'), (fresh_env, base / 'fresh/.config/hypr/hyprland.lua')]:
                result = run([HYPRLAND, '--verify-config', '-c', str(entrypoint)], verify_env)
                assert 'config ok' in result.stdout, result.stdout + result.stderr

    # Directory symlinks are never followed into another configuration.
    env, config = environment('symlink')
    config.mkdir()
    external = base / 'external'
    external.mkdir()
    (config / 'hypr').symlink_to(external)
    run([BASH, str(INSTALL)], env, succeeds=False)
    assert not list(external.iterdir())

    env, config = environment('shared-symlink')
    hypr = config / 'hypr'
    hypr.mkdir(parents=True)
    (external / 'sentinel').write_text('preserve')
    (hypr / 'shared').symlink_to(external)
    run([BASH, str(INSTALL)], env)
    assert (external / 'sentinel').read_text() == 'preserve'
    assert not (hypr / 'shared').is_symlink()

print('Hyprland installer and configuration checks passed.')
