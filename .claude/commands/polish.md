# polish — linter + responsiveness check

After making any code changes, run this command to:
1. Fix all auto-correctable linter issues
2. Verify and fix frontend responsiveness for desktop and mobile

---

## Step 1 — Linter (Ruby / ERB / JS)

Run RuboCop with auto-correct on all changed files:

```bash
bundle exec rubocop -A
```

If RuboCop reports offenses it cannot auto-correct, fix them manually:
- Extract long methods (> 10 lines) into private helpers
- Replace `and`/`or` with `&&`/`||`
- Remove trailing whitespace and enforce frozen string literals where applicable
- Follow the project's existing naming conventions

Also run Brakeman to catch security issues introduced by the changes:

```bash
bundle exec brakeman -q --no-pager
```

Fix any HIGH or MEDIUM severity warnings before proceeding.

---

## Step 2 — Frontend responsiveness review

For every ERB view or partial touched in this session:

1. **Audit Tailwind classes**: ensure every layout element uses responsive prefixes where needed (`sm:`, `md:`, `lg:`). The project targets mobile-first, so base classes are for small screens and prefixes scale up.

2. **Check these patterns** in the changed views:
   - Fixed widths (`w-64`, `w-96`) → replace with `max-w-*` + `w-full` unless intentional
   - `flex` rows that should stack on mobile → add `flex-col sm:flex-row` (or `md:flex-row`)
   - Text sizes that are too large on mobile → add `text-sm md:text-base` ladder
   - Grids: use `grid-cols-1 sm:grid-cols-2 lg:grid-cols-3` pattern
   - Padding/margin: use `p-3 md:p-6` ladder instead of large fixed values
   - Overflow: add `overflow-x-auto` to tables and wide containers
   - Navigation / modals: ensure they are usable at 375px (iPhone SE viewport)

3. **Verify the dev server is running** (`bin/dev`) and open the changed pages in a browser using the screenshot tool or browser preview at:
   - Desktop: 1280 × 800
   - Mobile: 375 × 812 (iPhone SE / 13 mini)

   Check that:
   - No horizontal scroll appears on mobile
   - Text is readable (≥ 14px rendered)
   - Buttons and tap targets are ≥ 44 × 44 px on mobile
   - Cards and lists stack properly on narrow viewports
   - The dark theme (`#0f1923` bg, `#1a2535` cards) renders correctly on both

4. **Fix any issues found** directly in the ERB/HTML, then re-run Step 1 to lint the changes.

---

## Step 3 — Final check

```bash
bundle exec rubocop
```

Must exit with **0 offenses**. If it does not, fix remaining issues and repeat.

Report a summary of:
- Files changed by RuboCop auto-correct
- Any manual fixes applied
- Responsive issues found and corrected
