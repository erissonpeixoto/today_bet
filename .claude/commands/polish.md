Execute the following steps in order after any code changes in this Rails project:

**Step 1 — Auto-fix linter**

Run `bundle exec rubocop -A` and fix any remaining offenses that could not be auto-corrected. Then run `bundle exec brakeman -q --no-pager` and fix any HIGH or MEDIUM severity warnings.

**Step 2 — Responsiveness audit**

Read every ERB view or partial changed in this conversation. For each file, check and fix:
- `flex` rows that don't stack on mobile → use `flex-col sm:flex-row`
- Fixed widths like `w-64` on containers → replace with `max-w-* w-full`
- Grids without breakpoints → use `grid-cols-1 sm:grid-cols-2 lg:grid-cols-3`
- Large padding/margin without mobile ladder → use `p-3 md:p-6` pattern
- Tables or wide containers without `overflow-x-auto`
- Tap targets smaller than 44px on mobile (buttons, links)
- Text that is too large on small screens → add responsive text size ladder

The project is mobile-first with Tailwind. Base classes target small screens; prefixes (`sm:`, `md:`, `lg:`) scale up.

**Step 3 — Final linter check**

Run `bundle exec rubocop` (no `-A`). It must exit with 0 offenses. If not, fix and repeat.

**Step 4 — Report**

Print a short summary:
- Files auto-corrected by RuboCop
- Manual fixes applied
- Responsive issues found and corrected
