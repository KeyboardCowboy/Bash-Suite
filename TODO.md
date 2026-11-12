# TODO

1. Fix the kept git helpers in `bin/`:
   - `gitco`: glob bug when collecting branch names.
   - `gitPrune`, `gitTrim`: also skip `main`; drop the hardcoded home path;
     `gitTrim` uses bash syntax under a `#!/bin/sh` shebang.
   - `gitTicket`: quote variables.
2. Consider merging `gitPrune` and `gitTrim` into one script.
3. Consider `autoload zmv` in `interactive.bash` (replaces the retired `rename`).
