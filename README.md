# debian-live-build
Config repository for use with [`live-build`]() utility

## Usage
1. Obtain an image either by downloading one from the [releases page](https://github.com/temple-harrisburg/debian-live-build/releases) or by building your own ISO from the steps below.
2. Insert your installation medium (likely USB flash drive)
3. Use a program such as Rufus or `dd` to burn the downloaded ISO image to the install medium

## Development

### 0. Prerequisites
- Debian (Bare-metal, VM or Docker)
- [`live-build`](https://packages.debian.org/search?keywords=live%2Dbuild)
- (optional) An installation medium (e.g. USB flash drive)


### 1. Make modifications

See the "Directories" subheading below for more information.

View the [Debian Live Manual](https://live-team.pages.debian.net/live-manual/html/live-manual/index.en.html) for more information.

### 2. Build Image
> [!IMPORTANT]
> Building has only been confirmed to work on Debian. Building on different OSs can be achieved via a Debian Docker container or Virtual Machine.

#### 2.1 Example: Build on a Debian host machine (bare-metal/VM/WSL)
1. Install `live-build`
```sh
sudo apt update
sudo apt install live-build
```

2. Run `lb config` with this repository's `main` branch as the config source
```sh
lb config --config https://github.com/temple-harrisburg/debian-live-build::main
```

3. Build image
```
sudo lb build
```

### 2.2 Example: Build within a Docker container

Docker can be used to build a `live-build` image on any supported OS and architecture. 

1. Prepare a Docker image.

The Docker image should include the required dependencies and start 

```dockerfile
FROM debian:latest

RUN <<EOF
apt-install --yes zstd debian-archive-keyring live-build
EOF

RUN mkdir /entrypoint.d
COPY <<EOF /entrypoint.d/entrypoint.sh
cd /workdir
lb config
lb build
EOF

RUN chmod +x /entrypoint.d/entrypoint.sh

WORKDIR /workdir # The directory where our live-build config will be mounted

ENTRYPOINT ["/bin/bash", "-c", "entrypoint.d/entrypoint.sh"]
```

2. Build the Docker image
```sh
docker build --tag live-build:latest .
```


3. Clone the configuration repo

```sh
git clone https://github.com/temple-harrisburg/debian-live-build.git
cd debian-live-build
```

4. Run the build within a Docker container

>[!IMPORTANT] 
> The container must be run with the --cap-add=SYS_ADMIN option in order to enable mounting volumes within a chroot. See "CAP_SYS_ADMIN" in the [capabilities man page](https://man7.org/linux/man-pages/man7/capabilities.7.html).

```sh
lb clean # Remove previous build, if any
docker run --rm --cap-add=SYS_ADMIN -v "${PWD}:/workdir" live-build:latest
```


### 3. Test

Install the built image in a testing machine, either physical or virtual, and evaluate.

**Tips**:
- In the Debian graphical installer, use Shift+F2 to switch to a text-based virtual console. Use Shift+F1 to change back.
- Logs are located:
    - In the installation medium at `/var/log/syslog`
    - In the installed system at `/var/log/installer/syslog`


## Directories

#### `/config/includes.installer`

The files in this directory are copied to the root of the `debian-installer` stage.


#### `/config/includes.binary`

> [!NOTE]
> The `/boot/grub/grub.cfg` passes the parameter `preseed/file` with a path to a `preseed_*.cfg` file.
> Preseed files must be placed in the `/config/includes.installer` directory in order for `debian-installer` to load them.

The files in this directory are copied to the root of the created ISO image.

### `/auto`

The scripts in this directory are referenced by `live-build` to create reproducible builds. Arguments defined in `auto/config` are passed to invocations of `lb config` in the directory root, `auto/build` to `lb build`, and `auto/clean` to `lb clean`.

See [Debian Live Manual, Chapter 6.1.1](https://live-team.pages.debian.net/live-manual/html/live-manual/managing-a-configuration.en.html#333)

