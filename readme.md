Set Up LAMP Stack
=================
Use at your own risk. Pull requests welcome. This script sets up:

* Apache
* MariaDB
* PHP

Enables Apache SSL, Headers & Rewrite modules.

PHP modules `libapache2-mod-php`, `php-mcrypt`, `php-mysql`, `php-mbstring` and `php-curl` are also installed.

MariaDB is sourced here: http://lon1.mirrors.digitalocean.com/mariadb/repo/10.1/ubuntu xenial main. A good refinement to this package would be to build in a way to choose download mirrors by location and OS.

`mysql_secure_installation` runs after MariaDB is installed, and the MariaDB repo is pinned here `/etc/apt/preferences.d/mariadb.pref` to avoid conflicts with MySQL package when updating.

## Usage
* Clone this repo
* Move into the repo, e.g. `cd ubuntu-server-setup`
* Make `user-FQDN-SSH-setup.sh` and `setup-lamp.sh` executable: `chmod +x setup-lamp.sh; chmod +x user-FQDN-SSH-setup.sh`
* Run `sudo ./user-FQDN-SSH-setup.sh` to set up a new user with sudo privileges, a FQDN and SSH setup
* Run `sudo ./setup-lamp.sh` to set up a LAMP stack

## User, FQDN and SSH Setup

### SSH Connection
During the script execution you will be prompted for your public key.

SSH setup disallows password login and sets `PermitRootLogin no`. From `man SSH`:

>PermitRootLogin
>Specifies whether root can log in using ssh(1).  The argument must be “yes”, “prohibit-password”, “without-password”, “forced-commands-only”, or “no”.  The default is “prohibit-password”.
>
>If this option is set to “prohibit-password” or “without-password”, password and keyboard-interactive authentication are disabled for root.
>
>If this option is set to “forced-commands-only”, root login with public key authentication will be allowed, but only if the command option has been specified (which may be useful for taking remote backups even if root login is normally not allowed).  All other authentication methods are disabled for root.
>
>If this option is set to “no”, root is not allowed to log in.

Be sure to check that you have SSH access to the server after running the script and BEFORE closing your current connection.

Resources
---------
* [FQDN][1]

[1]: https://github.com/DigitalOcean-User-Projects/Articles-and-Tutorials/blob/master/set_hostname_fqdn_on_ubuntu_centos.md
