# Security Policy

## Supported Versions

Only the latest release receives security fixes.

| Version | Supported |
| ------- | --------- |
| 1.1.x   | Yes       |
| < 1.1   | No        |

## Reporting a Vulnerability

Please do not open a public issue for security problems.

Report privately through GitHub's **Security > Report a vulnerability** form on
this repository (private vulnerability reporting). Include:

- A description of the issue and its impact
- Steps to reproduce, or a proof of concept
- Your platform (Termux, Arch, Ubuntu/Debian, macOS, etc.) and the output of
  `vimx --version` and `vimx doctor` if relevant

This is a small project maintained in spare time. Best-effort targets:

- Acknowledgement within 7 days
- Status update within 14 days
- Fix or mitigation for confirmed issues in the next release, with credit in
  the release notes if you want it

## Scope

In scope:

- The installer (`install.sh`, `commands/`, `lib/`)
- The `vimx` command-line tool
- Configuration files shipped in this repository (`init.vim`, `core/`, `langs/`,
  `utils/`, `coc-settings*.json`)

Out of scope:

- Vulnerabilities in third-party plugins, language servers, or package managers
  (report those to their upstream projects)
- `rbot`, which is a separate project with its own repository and policy
- Issues that require a user to deliberately run untrusted code they supplied
  themselves (for example, a local `rbot` source they chose to build)

## Security Considerations for Users

vimx is an installer and configuration manager. Several of its features run code
from the network or require elevated privileges. Please keep these in mind:

- **`curl ... | bash` runs whatever is on the `main` branch at that moment.**
  Read `install.sh` first, or clone the repository and run it locally:

  ```bash
  git clone https://github.com/aidomx/vimx.git
  cd vimx && less install.sh && bash install.sh
  ```

- **The installer uses `sudo`** to install packages (`apt`, `pacman`) and to
  copy the `vimx` command into `/usr/bin`. Only run it on machines you control.
  It asks for your password up front rather than in the background.

- **Plugins and tools are not pinned.** vim-plug, plugins listed in
  `core/plugins.vim`, coc extensions, and global npm packages (for example
  `prettier`) are installed from their upstream sources at whatever version is
  current. A compromised upstream release would reach your editor on the next
  install or update. Pin versions in your own fork if this matters to you.

- **`vim-plug` is downloaded from `raw.githubusercontent.com`** without a
  checksum check.

- **Optional `rbot` installation clones and runs an `install.sh`** from the URL
  or path you give it. Only use sources you trust.

- **Editor configuration can execute code.** Vimscript in `init.vim` and the
  files it sources runs with your user's permissions every time Vim starts. Do
  not paste configuration from untrusted sources.

- **Temporary files** are created with `mktemp` in `${TMPDIR:-/tmp}`. Install
  logs and syntax-check scripts are removed after use.

## Disclosure

Once a fix is released, a public advisory will describe the issue, affected
versions, and the fixed version. Please give us a reasonable window to ship a
fix before disclosing publicly.

