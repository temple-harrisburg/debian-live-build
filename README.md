# debian-live-build
Config repository for use with live-build utility

## Usage

### Burn an image to USB
1. Download the latest release from the [releases page](https://github.com/temple-harrisburg/debian-live-build/releases)
2. Insert your installation medium (likely USB flash drive)
3. Use a program such as Rufus or `dd` to burn the downloaded ISO image to the install medium

### Build
> [!IMPORTANT]
> Building has only been confirmed to work on Debian. Building on different OSs can be achieved via a Debian Docker container or Virtual Machine.

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

## Directories

### `/config`
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

