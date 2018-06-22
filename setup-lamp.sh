#!/bin/bash
# Set up a LAMP stack
# Run as sudo
# ------------------------------------------------------------------------------
set -e
# keep track of the last executed command
trap 'last_command=$current_command; current_command=$BASH_COMMAND' DEBUG
# echo an error message before exiting
trap 'echo "\"${last_command}\" command filed with exit code $?."' EXIT

apt update
apt upgrade

# CUR_DIR=$(pwd)
THIS=$(readlink -f ${BASH_SOURCE[0]})
PROJECT_ROOT=$(dirname $THIS)

function include {
  local include=$1
  if [[ -s ${PROJECT_ROOT}/includes/${include} ]];then
    . ${PROJECT_ROOT}/includes/${include}
  else
    echo "Error:${CUR_DIR}/includes/${include} not found."
    exit 1
  fi
}

function run {
  include apache
  include php
  include mariadb
  include report
}

echo "This script is potentially dangerous. It sets up a LAMP stack."
echo "Don't run if you already have a LAMP stack on this machine."
echo ""
read -p "Do you want to continue (y/n)?" CONT
if [ "$CONT" = "y" ]; then
  clear
  echo "Starting..."
  run 2>&1 | tee -a $HOME/lamp-setup.log
else
  echo "Cancelled";
fi
