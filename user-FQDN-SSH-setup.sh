#!/bin/bash
# Run as sudo
# ------------------------------------------------------------------------------
set -e
trap 'last_command=$current_command; current_command=$BASH_COMMAND' DEBUG
trap 'echo "\"${last_command}\" command filed with exit code $?."' EXIT

LOGFILE=/home/david/sysadmin/server/setup-lamp/user-FQDN-SSH-setup.log

function create_logfile {
  echo "Log: User/FQDN/SSH Setup Script" > ${LOGFILE}
  echo "===============================" >> ${LOGFILE}
  echo "Generated: $(date)" >> ${LOGFILE}
  echo "---------------------------------------" >> ${LOGFILE}
}

# Prompt for username & password, set up new user with sudo privilege
function create_user {
  read -rp "Enter the username of the new user account:" NEW_USERNAME
  PASSWORDS_MATCH=0
  while [ "${PASSWORDS_MATCH}" -eq "0" ]; do
    read -s -rp "Enter new UNIX password:" NEW_PASSWORD
    printf "\n"
    read -s -rp "Retype new UNIX password:" PASSWORD_CONFIRMATION
    printf "\n"
    if [[ "${NEW_PASSWORD}" != "${PASSWORD_CONFIRMATION}" ]]; then
      echo "Passwords do not match! Please try again."
    else
      PASSWORDS_MATCH=1
    fi
  done
  adduser --disabled-password "${NEW_USERNAME}"
  echo "${NEW_USERNAME}:${password}" | chpasswd
  usermod -aG sudo "${NEW_USERNAME}"
}

function set_fqdn {
  read -rp $'Enter the required FQDN:\n' USER_FQDN
  echo ${USER_FQDN}
  sed -i 's/127.0.1.1.*/127.0.1.1\t'"${USER_FQDN}"'/g' /etc/hosts
  hostnamectl set-hostname ${USER_FQDN}
  hostname -F /etc/hostname
  systemctl restart systemd-logind.service
}

function install_SSH {
  sudo apt install openssh-client
  sudo apt install openssh-server
}

# Add a public key to enable access without password.
function add_remote_SSH_public_key {
  read -rp $'Paste in the public SSH key for the new user:\n' SSH_KEY
  local USERNAME=${1}
  sudo -u "${USERNAME}" -H mkdir -p ~/.ssh; chmod 700 ~/.ssh; touch ~/.ssh/authorized_keys
  sudo -u "${USERNAME}" -H echo ${SSH_KEY} >> ~/.ssh/authorized_keys
  chmod 600 /home/${USERNAME}/.ssh/authorized_keys
}

# Lockdown SSH access to key-based access only and lock root access.
# NB: Run this function AFTER setting up the user public key `add_SSH_public_key`
function lockdown_SSH {
  sed -re 's/^(\#?)(PasswordAuthentication)([[:space:]]+)yes/\2\3no/' -i."$(echo 'bak')" /etc/ssh/sshd_config
  sed -re 's/^(\#?)(PermitRootLogin)([[:space:]]+)(.*)/PermitRootLogin no/' -i /etc/ssh/sshd_config
  echo "IMPORTANT: Check that you have SSH access to this server BEFORE closing the current connection."
}

function run {
  create_logfile
  create_user
  set_fqdn
  install_SSH
  add_remote_SSH_public_key
  lockdown_SSH
}

echo "This script sets up a new user and locks down SSH access."
read -p "Do you want to continue (y/n)?" CONT
if [ "$CONT" = "y" ]; then
  clear
  echo "Starting..."
  run 2>&1 | tee -a ${LOGFILE}
else
  echo "Cancelled";
fi
