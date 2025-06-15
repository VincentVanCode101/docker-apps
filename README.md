# Dockerized CLI/GUI Tools

Run Linux-only CLI and GUI applications seamlessly on macOS, Linux, or any Docker-enabled system. No more dealing with broken packages, missing dependencies, or inconsistent setups across machines.

## Why Use This?

- **Cross-Platform Consistency**: Same image runs anywhere Docker does—macOS, Linux, CI.
- **Linux-Only Tools on macOS**: Run native Linux binaries without hacks.
- **Clean Host System**: Nothing installed globally; no pollution in `/usr/local`.
- **Prune-Proof**: Save and restore all tools as a single tarball, safe from `docker system prune`.

---

## Project Structure

```text
<project-root>/
├── bin/                  # symlinks to launcher script
│   ├── tokei             # → ../dc-runner
│   └── gnome-calculator  # → ../dc-runner
├── dc-runner             # generic build+run wrapper
├── build-all             # build every tool
├── build-single-tool     # build a single tool by name
├── save-all              # export all images to a tarball
├── extract-all           # import images from tarball
├── rebuild-symlinks      # regenerate bin/* from config.sh
├── tokei/                # example CLI container
│   ├── Dockerfile
│   └── config.sh         # IMAGE_TAG, DOCKER_EXTRA_OPTS
└── gnome-calculator/     # example GUI container
    ├── Dockerfile
    └── config.sh
````

---

## Getting Started

1. **Clone the repo:**

   ```bash
   git clone git@github.com:VincentVanCode101/docker-apps.git
   cd docker-apps
   ```

2. **Make scripts executable:**

   ```bash
   chmod +x dc-runner build-all build-single-tool save-all extract-all rebuild-symlinks
   ```

3. **Generate symlinks for tools:**

   ```bash
   ./rebuild-symlinks
   ```

4. **Add to your shell's `$PATH`:**

   ```bash
   echo 'export PATH="$HOME/docker-apps/bin:$PATH"' >> ~/.bashrc
   source ~/.bashrc
   ```

---

## Usage

### 🔧 Build Tools

* Build all:

  ```bash
  ./build-all
  ```

* Build one:

  ```bash
  ./build-single-tool tokei
  ```

### 🚀 Run Tools

Just call the tool directly. It will auto-build if needed.

```bash
tokei --files
gnome-calculator
```

---

### 💾 Save All Images

```bash
./save-all
# Creates: ./docker-apps-YYYYMMDD.tar.gz
```

---

### 🔄 Restore Images

```bash
./extract-all              # uses latest tarball
# or
./extract-all ./some/path.tar.gz
```

---

### 🧼 Clean Up Docker

```bash
docker system prune -a
```

Use `extract-all` afterward to restore tool images.

---

## Adding a New Tool

1. **Create a directory**:

   ```bash
   mkdir ./<tool-name>
   ```

2. **Write a `Dockerfile`** for the tool.

3. **Add a `config.sh`**:

   ```bash
   IMAGE_TAG=<tool-name>:latest
   DOCKER_EXTRA_OPTS=""  # Optional: env vars, mounts, etc.
   ```

4. **Regenerate symlinks:**

   ```bash
   ./rebuild-symlinks
   ```

5. **Build and run:**

   ```bash
   <tool-name> --build
   <tool-name> <args>
   ```

---

## GUI Support on macOS (via XQuartz)

1. **Install & start** [XQuartz](https://www.xquartz.org/)

2. **Enable root access to X server:**

   ```bash
   xhost +local:root
   ```

3. **Update your `config.sh`:**

   ```bash
   XSOCK=/tmp/.X11-unix
   XAUTH_HOST="$HOME/.Xauthority"

   DOCKER_EXTRA_OPTS="-it \
     -e DISPLAY=$DISPLAY \
     -e XAUTHORITY=/root/.Xauthority \
     -v $XSOCK:$XSOCK \
     -v $XAUTH_HOST:/root/.Xauthority:ro"
   ```

4. **Run the GUI app:**

   ```bash
   gnome-calculator
   ```

---
