# Update service 1.2
## License
This software is licensed under [CC BY-NC-SA 4.0](https://creativecommons.org/licenses/by-nc-sa/4.0/) license.

## Install
Check out [pre-release packages](https://github.com/idigitallegacy/updatem-226/releases/tag/prerelease) and install one of them using: `sudo dpkg -i [package_name]`

## Usage
To use this software, make sure you have installed apt manager, systemd and bash. This software uses these packages to update the system automatically.

The only thing you are allowed to modify is pretty-described-by-itself `/etc/updatem-226/updatem-226.conf` config file.

To disable this service, use `sudo systemctl disable updatem-226`.

## Removing
Use `sudo dpkg -r updatem-226`.
