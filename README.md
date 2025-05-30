# Dockerized CLI/GUI Tools

Run Linux-only CLI and GUI applications seamlessly on macOS, Linux, or any Docker-enabled host—no more wrestling with `brew` vs. `apt-get`, missing Homebrew formulas, or platform quirks.

## Why Dockerize Your Tools?

* **Cross‑Platform Consistency**: Build once on Ubuntu, Alpine or whatever, run everywhere. Your macOS, Linux, or CI environment doesn’t need special tool installs.
* **Linux‑Only Support**: Use tools that only ship Linux binaries on your Mac without compiling or hacky workarounds.
* **Zero Host Footprint**: Keep your host clean. No extra packages cluttered in `/usr/local` or messing with system libraries.
* **Prune‑Proof**: Safely stash and restore all your CLI/GUI apps in a single tarball, immune to `docker system prune`.

## Project Layout

```text
~/docker-apps/
├── bin/                  # your PATH for launcher symlinks
│   ├── tokei             # → ../dc-runner
│   └── gnome-calculator  # → ../dc-runner
├── dc-runner             # generic build+run script
├── build-all             # build every tool
├── save-all              # save all images to a tarball
├── extract-all           # restore images from the tarball
├── rebuild-symlinks      # regenerate bin/* from config.sh
├── tokei/                # tokei container
│   ├── Dockerfile
│   └── config.sh         # IMAGE_TAG, DOCKER_EXTRA_OPTS
└── gnome-calculator/     # GUI example
    ├── Dockerfile
    └── config.sh
```

## Getting Started

1. **Clone** this repo:

   ```bash
   git clone <repo-url> ~/docker-apps
   cd ~/docker-apps
   ```
2. **Make scripts executable**:

   ```bash
   chmod +x dc-runner build-all save-all extract-all rebuild-symlinks
   ```
3. **Generate symlinks**:

   ```bash
   ./rebuild-symlinks
   ```
4. **Add to your shell’s PATH** (`~/.bashrc` or `~/.zshrc`):

   ```bash
   export PATH="$HOME/docker-apps/bin:$PATH"
   ```
5. **Reload shell**:

   ```bash
   source ~/.bashrc  # or ~/.zshrc
   ```

## Common Commands

* **Build all tools**:

  ```bash
  ./build-all
  ```

* **Build specific \<tool-name\>/Dockerfile**:

  ```bash
  ./bin/tokei --build
  ```
* **Run (or build+run) a tool**:

  ```bash
  tokei --files
  gnome-calculator
  ```

* **Save all images**:

  ```bash
  ./save-all
  # Creates ~/docker-apps/docker-apps-YYYYMMDD.tar.gz
  ```

* **Prune Docker**:

  ```bash
  docker system prune -a
  ```

* **Restore from archive**:

  ```bash
  ./extract-all        # loads the latest backup
  # or ./extract-all path/to/archive.tar.gz
  ```

## Adding Your Own Tool

1. **Create folder** `./<tool-name>`.
2. **Write** `Dockerfile` with your installation steps.
3. **Define** `config.sh`:

   ```bash
   IMAGE_TAG=<tool-name>:<tool-tag>
   DOCKER_EXTRA_OPTS="-e KEY=VAL"
   ```
4. **Regenerate symlinks**:

   ```bash
   ./rebuild-symlinks
   ```
5. **Run or build**:

   ```bash
   <tool-name> --build
   <tool-name> <args>
   ```

## GUI Apps on macOS (XQuartz)

1. **Install & start** [XQuartz](https://www.xquartz.org/).
2. **Allow local root**:

   ```bash
   xhost +local:root
   ```
3. **In `config.sh`**, mount X socket & auth:

   ```bash
   XSOCK=/tmp/.X11-unix
   XAUTH_HOST="$HOME/.Xauthority"
   DOCKER_EXTRA_OPTS="-it \
     -e DISPLAY=$DISPLAY \
     -e XAUTHORITY=/root/.Xauthority \
     -v $XSOCK:$XSOCK \
     -v $XAUTH_HOST:/root/.Xauthority:ro"
   ```
4. **Run**:

   ```bash
   gnome-calculator
   ```

## License

MIT © Chris
