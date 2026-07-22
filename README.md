# debian-live-build
Config repository for use with live-build utility

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

