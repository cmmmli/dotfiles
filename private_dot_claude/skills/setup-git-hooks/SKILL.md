---
name: setup-git-hooks
description: Set up lefthook pre-commit hooks that lint and format staged files, then run typecheck and tests. Use when the user wants pre-commit hooks, commit-time lint/format/typecheck/tests, or mentions lefthook, husky, or lint-staged.
---

# Set up Git hooks with lefthook

The user prefers lefthook. Never install husky or lint-staged: lefthook passes staged files with `{staged_files}` and re-stages fixes with `stage_fixed`, so lint-staged is unnecessary.

## 1. Read the repo first

- Package manager: `pnpm-lock.yaml` → pnpm, `package-lock.json` → npm, `yarn.lock` → yarn, `bun.lock*` → bun.
- Existing scripts in `package.json` (`lint`, `format`, `typecheck`, `test`) and existing configs (ESLint, Prettier, Biome). Reuse them instead of adding parallel tools.
- `git config core.hooksPath`. If something (often a past `husky init`) set it, lefthook installs into the wrong place. Ask before unsetting it if you did not set it yourself.

## 2. Add only what is missing

Install lefthook as a devDependency. Add a formatter, linter, or typecheck only when the repo has none and the user wants it:

- Prettier: write `.prettierrc` that matches the current code style (quotes, line width, trailing commas) so the first format run changes as little as possible. Do not use generic defaults.
- ESLint for plain HTML/JS: `@eslint/js` + `globals`, plus `eslint-plugin-html` to lint inline `<script>`.
- TypeScript tests without a build: a `tsconfig.json` with `noEmit` and a `typecheck` script running `tsc`.

## 3. Make the hooks install on `install`

lefthook's npm postinstall runs `lefthook install` (skipped when `CI` is set, and a failure only warns).

- pnpm 10+ blocks dependency build scripts. Add lefthook to `pnpm-workspace.yaml` (`allowBuilds: { lefthook: true }`, or `onlyBuiltDependencies` on older pnpm) and reinstall.
- Otherwise, add `"prepare": "lefthook install"`.

Confirm `.git/hooks/pre-commit` exists afterwards.

## 4. Write `lefthook.yml`

Lint and format only staged files, then run the whole-repo checks. Jobs run in order.

```yaml
pre-commit:
  jobs:
    - name: lint
      glob: '*.{js,ts,html}'
      run: pnpm exec eslint --fix {staged_files}
      stage_fixed: true
    - name: format
      run: pnpm exec prettier --ignore-unknown --write {staged_files}
      stage_fixed: true
    - name: typecheck
      run: pnpm typecheck
    - name: test
      run: pnpm test
```

Adapt the commands to the package manager and the tools found in step 1. Drop jobs whose script does not exist and tell the user.

## 5. Format once, separately

Run the formatter over the whole repo and review the diff before committing. If a hand-written file grows a lot (for example, one-line CSS rules expanded), tell the user. Fix lint errors at their cause; relax a rule only when the pattern is intentional (for example, `no-empty` with `allowEmptyCatch`).

## 6. Verify both directions

- Commit the setup. The hook must run every job and pass.
- Stage a file with a deliberate lint error and try to commit. The hook must block it. Then remove the file.

Never bypass the hook with `--no-verify`. Document `lint` / `format` / `test` and the hook in the README and the repo's CLAUDE.md.
