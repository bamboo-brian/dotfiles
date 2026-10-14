#!/usr/bin/env python3
"""Check TOML and exercise macOS installer behavior in disposable homes."""
import os
from pathlib import Path
import shutil
import subprocess
import tempfile
import tomllib

REPO = Path(__file__).resolve().parents[1]
SOURCE = REPO / 'aerospace/.aerospace.toml'
INSTALL = REPO / 'scripts/install-aerospace.sh'
BASH = shutil.which('bash')

config = tomllib.loads(SOURCE.read_text())
bindings = config['mode']['main']['binding']
assert config['persistent-workspaces'] == []
assert config['focus-follows-mouse']['enabled'] is True
for workspace in range(1, 11):
    key = workspace % 10
    assert bindings[f'cmd-alt-{key}'] == f'workspace {workspace}'
    assert bindings[f'cmd-alt-shift-{key}'] == f'move-node-to-workspace --focus-follows-window {workspace}'
assert config['key-mapping']['preset'] == 'qwerty'
for key, direction in [('h', 'left'), ('j', 'down'), ('k', 'up'), ('l', 'right')]:
    assert bindings[f'cmd-{key}'] == f'focus --boundaries all-monitors-outer-frame {direction}'
    assert f'--boundaries all-monitors-outer-frame {direction}' in bindings[f'cmd-shift-{key}']
assert config['on-focus-changed'] == [
    'move-mouse window-lazy-center || move-mouse monitor-lazy-center'
]
assert bindings['cmd-alt-h'] == 'workspace prev'
assert bindings['cmd-alt-l'] == 'workspace next'
assert bindings['cmd-alt-f'] == 'fullscreen'
for key, direction in [('h', 'left'), ('j', 'down'), ('k', 'up'), ('l', 'right')]:
    assert bindings[f'cmd-ctrl-{key}'] == f'join-with {direction}'
assert bindings['cmd-ctrl-alt-h'] == 'move-workspace-to-monitor --wrap-around prev'
assert bindings['cmd-ctrl-alt-l'] == 'move-workspace-to-monitor --wrap-around next'
# Preserve the ordinary application shortcuts the user chose to keep.
for key in ['c', 'v', 's', 'z', 'a', 't', 'space', 'tab', 'f']:
    assert f'cmd-{key}' not in bindings

with tempfile.TemporaryDirectory(prefix='dotfiles-aerospace-test-') as temp:
    base = Path(temp)
    bin_dir = base / 'bin'
    bin_dir.mkdir()
    for name in ['dirname', 'mktemp', 'mv', 'stow']:
        path = shutil.which(name)
        assert path, f'Missing test dependency: {name}'
        (bin_dir / name).symlink_to(path)

    def environment(name, system='Darwin', installed=True, custom=False):
        home = base / name
        home.mkdir()
        uname = bin_dir / 'uname'
        uname.write_text(f'#!/bin/sh\nprintf "%s\\n" "{system}"\n')
        uname.chmod(0o755)
        cli = bin_dir / 'aerospace'
        if cli.exists():
            cli.unlink()
        if installed:
            cli.write_text('#!/bin/sh\nexit 0\n')
            cli.chmod(0o755)
        env = dict(os.environ, HOME=str(home), PATH=str(bin_dir))
        env.pop('XDG_CONFIG_HOME', None)
        config_home = home / ('custom-config' if custom else '.config')
        if custom:
            env['XDG_CONFIG_HOME'] = str(config_home)
        return env, home, config_home / 'aerospace/aerospace.toml'

    def install(env, succeeds=True):
        result = subprocess.run([BASH, str(INSTALL)], env=env, capture_output=True, text=True)
        assert (result.returncode == 0) == succeeds, result.stdout + result.stderr

    for name, system, installed in [('linux', 'Linux', True), ('absent', 'Darwin', False)]:
        env, home, _ = environment(name, system, installed)
        install(env)
        assert not list(home.iterdir()), 'Skipped install changed the home directory'

    env, home, _ = environment('move-follow')
    cli = bin_dir / 'aerospace'
    cli.write_text("""#!/bin/sh
printf '%s\\n' "$*" >> "$AEROSPACE_TEST_LOG"
case "$1" in
  list-windows)
    case "$AEROSPACE_TEST_CASE" in
      empty) exit 0 ;;
      *) printf '123\\n' ;;
    esac ;;
  move)
    if [ "$AEROSPACE_TEST_CASE" = failed ]; then exit 1; fi
    printf '456\\n' > "$AEROSPACE_TEST_FOCUS" ;;
  focus) printf '%s\\n' "$3" > "$AEROSPACE_TEST_FOCUS" ;;
  move-mouse)
    IFS= read -r focused < "$AEROSPACE_TEST_FOCUS"
    [ "$focused" = 123 ] || exit 1 ;;
esac
""")
    cli.chmod(0o755)
    log = home / 'commands.log'
    focus = home / 'focus.txt'
    env.update(AEROSPACE_TEST_LOG=str(log), AEROSPACE_TEST_FOCUS=str(focus))
    for key, direction in [('h', 'left'), ('j', 'down'), ('k', 'up'), ('l', 'right')]:
        binding = bindings[f'cmd-shift-{key}']
        assert binding.startswith('exec-and-forget ')
        script = binding[len('exec-and-forget'):].lstrip()
        for scenario in ['swapped', 'empty', 'failed']:
            log.write_text('')
            focus.write_text('123\n')
            env['AEROSPACE_TEST_CASE'] = scenario
            result = subprocess.run([BASH, '-c', script], env=env, capture_output=True, text=True)
            commands = log.read_text().splitlines()
            assert commands[0] == 'list-windows --focused --format %{window-id}'
            if scenario == 'empty':
                assert len(commands) == 1
            elif scenario == 'failed':
                assert result.returncode != 0 and len(commands) == 2
            else:
                assert result.returncode == 0, result.stderr
                assert commands[1:] == [
                    f'move --window-id 123 --boundaries all-monitors-outer-frame {direction}',
                    'focus --window-id 123',
                    'move-mouse window-lazy-center',
                ]
                assert focus.read_text() == '123\n'

    env, home, _ = environment('fresh')
    install(env)
    target = home / '.aerospace.toml'
    assert target.is_symlink() and target.resolve() == SOURCE
    install(env)
    assert not list(home.glob('.aerospace.backup.*'))

    for custom in [False, True]:
        env, home, alternate = environment(f'conflicts-{custom}', custom=custom)
        target = home / '.aerospace.toml'
        target.write_text('original home config\n')
        alternate.parent.mkdir(parents=True)
        alternate.write_text('original XDG config\n')
        unrelated = alternate.parent / 'notes.txt'
        unrelated.write_text('preserve\n')
        install(env)
        backups = list(home.glob('.aerospace.backup.*'))
        assert len(backups) == 1
        assert (backups[0] / 'home-config.toml').read_text() == 'original home config\n'
        assert (backups[0] / 'xdg-config.toml').read_text() == 'original XDG config\n'
        assert target.resolve() == SOURCE and not alternate.exists()
        assert unrelated.read_text() == 'preserve\n'
        install(env)
        assert len(list(home.glob('.aerospace.backup.*'))) == 1

    env, home, alternate = environment('alternate-only')
    alternate.parent.mkdir(parents=True)
    alternate.write_text('original alternate\n')
    install(env)
    assert not alternate.exists()
    assert (home / '.aerospace.toml').resolve() == SOURCE
    assert len(list(home.glob('.aerospace.backup.*'))) == 1

    env, home, _ = environment('foreign-link')
    foreign = base / 'foreign.toml'
    foreign.write_text('untouched foreign source\n')
    (home / '.aerospace.toml').symlink_to(foreign)
    install(env)
    assert foreign.read_text() == 'untouched foreign source\n'
    backup = next(home.glob('.aerospace.backup.*')) / 'home-config.toml'
    assert backup.is_symlink() and backup.resolve() == foreign

    env, home, _ = environment('broken-link')
    (home / '.aerospace.toml').symlink_to(base / 'missing.toml')
    install(env)
    assert (home / '.aerospace.toml').resolve() == SOURCE
    assert len(list(home.glob('.aerospace.backup.*'))) == 1

    env, home, _ = environment('directory')
    (home / '.aerospace.toml').mkdir()
    install(env, succeeds=False)
    assert (home / '.aerospace.toml').is_dir()
    assert not list(home.glob('.aerospace.backup.*'))

print('AeroSpace TOML and installer checks passed.')
