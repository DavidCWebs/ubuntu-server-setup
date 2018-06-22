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
* Move into the repo, e.g. `cd setup-lamp`
* Make `install` executable: `sudo chmod +x install`
* Run `sudo ./setup-lamp.sh`

Resources
---------
* [FQDN][1]

[1]: https://github.com/DigitalOcean-User-Projects/Articles-and-Tutorials/blob/master/set_hostname_fqdn_on_ubuntu_centos.md
