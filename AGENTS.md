# Repository guidelines

- Ensure setup scripts are idempotent and safe to rerun.
- Use Bash with `set -Eeuo pipefail`.
- Use the shared logging helpers in `lib/logging.sh`.
- Add new setup steps to `<distribution>/setup.sh` in dependency order.
