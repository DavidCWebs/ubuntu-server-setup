SSH Connection
==============
Notes on SSH connection.

Config options in `/etc/ssh/sshd_config`, which contains configuration data for sshd. The file format and configuration options are described in sshd_config(5). To view, type: `man sshd_config`.

>PermitRootLogin
>Specifies whether root can log in using ssh(1).  The argument must be “yes”, “prohibit-password”, “without-password”, “forced-commands-only”, or “no”.  The default is “prohibit-password”.
>
>If this option is set to “prohibit-password” or “without-password”, password and keyboard-interactive authentication are disabled for root.
>
>If this option is set to “forced-commands-only”, root login with public key authentication will be allowed, but only if the command option has been specified (which may be useful for taking remote backups even if root login is normally not allowed).  All other authentication methods are disabled for root.
>
>If this option is set to “no”, root is not allowed to log in.
