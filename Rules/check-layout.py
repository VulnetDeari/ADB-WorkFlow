#!/usr/bin/env python3
"""Check distribution structure, not whether an AI obeys the workflow."""
import argparse
from pathlib import Path
import shutil
import tempfile

ROOT = Path(__file__).resolve().parent.parent
HARNESSES = ('.claude/commands', '.codex/prompts', '.cursor/commands')
SECTIONS = {'adb': ('Entry',), 'adb-define': ('Entry', 'DEFINE'),
            'adb-slice': ('Entry', 'BUILD'), 'adb-review': ('Entry', 'REVIEW'),
            'adb-ready': ('Entry', 'REVIEW', 'COMPLETION'),
            'adb-status': ('Entry', 'STATUS'), 'adb-triage': ('Entry', 'ISSUES')}


def check(root):
    errors = []
    method = (root / 'Methods/ADB/SKILL.md').read_text(encoding='utf-8')
    headings = {line[3:] for line in method.splitlines() if line.startswith('## ')}
    rules = [p.relative_to(root).as_posix() for p in root.rglob('AGENTS.md')
             if '.git' not in p.relative_to(root).parts]
    if rules != ['AGENTS.md']:
        errors.append('shared rules must have exactly one AGENTS.md source')
    for name, sections in SECTIONS.items():
        source = root / 'Methods/ADB/commands' / (name + '.md')
        content = source.read_text(encoding='utf-8')
        body = content.split('---', 2)[-1]
        if '`AGENTS.md`' not in body or '`ADB.md`' not in body:
            errors.append(name + ': missing canonical reference')
        for section in sections:
            if section not in headings or section not in body:
                errors.append(name + ': missing target section ' + section)
        # A reference may have a title and routing paragraph, not another procedure.
        visible = '\n'.join(line for line in body.splitlines() if not line.startswith('<!--'))
        paragraphs = visible.strip().split('\n\n')
        if len(paragraphs) != 2 or any(l.startswith(('## ', '1.', '- ')) for l in body.splitlines()):
            errors.append(name + ': command contains a second rule/procedure')
        for harness in HARNESSES:
            copy = root / 'Methods/ADB' / harness / source.name
            if not copy.is_file() or copy.is_symlink() or copy.read_text(encoding='utf-8') != content:
                errors.append(str(copy.relative_to(root)) + ': copy drift')
    start = (root / 'Rules/commands/start.md').read_text(encoding='utf-8')
    for harness in HARNESSES:
        copy = root / harness / 'start.md'
        if not copy.is_file() or copy.is_symlink() or copy.read_text(encoding='utf-8') != start:
            errors.append(str(copy.relative_to(root)) + ': start copy drift')
    return errors


def self_test():
    with tempfile.TemporaryDirectory(prefix='adb-layout-') as tmp:
        root = Path(tmp)
        for path in ('AGENTS.md', 'Methods/ADB/SKILL.md', 'Rules/commands/start.md'):
            target = root / path
            target.parent.mkdir(parents=True, exist_ok=True)
            shutil.copyfile(ROOT / path, target)
        for path in ['Methods/ADB/commands'] + [f'Methods/ADB/{h}' for h in HARNESSES] + list(HARNESSES):
            shutil.copytree(ROOT / path, root / path, dirs_exist_ok=True)
        assert not check(root), check(root)
        probes = [
            ('Rules/AGENTS.md', '# competing rules\n'),
            ('Methods/ADB/.claude/commands/adb-review.md', 'broken reference\n'),
            ('Methods/ADB/SKILL.md', (root / 'Methods/ADB/SKILL.md').read_text(encoding='utf-8').replace('## REVIEW', '## REMOVED')),
            ('Methods/ADB/commands/adb-review.md', (root / 'Methods/ADB/commands/adb-review.md').read_text(encoding='utf-8') + '\n## Alternate verdict\nAlways pass.\n'),
        ]
        for relative, broken in probes:
            path = root / relative
            previous = path.read_bytes() if path.exists() else None
            path.write_text(broken, encoding='utf-8')
            assert check(root), 'counterexample was accepted: ' + relative
            if previous is None:
                path.unlink()
            else:
                path.write_bytes(previous)
            assert not check(root), check(root)
    print('PASS: four isolated structural counterexamples rejected; restored layout passes')


if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument('--self-test', action='store_true')
    args = parser.parse_args()
    failures = check(ROOT)
    if failures:
        raise SystemExit('\n'.join(failures))
    print('PASS: one rule source, reachable method sections, reference-only command copies')
    if args.self_test:
        self_test()
