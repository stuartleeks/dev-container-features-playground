#!/bin/sh
set -e

echo "Activating feature 'azure-cli-persistence-sync'"
echo "User: ${_REMOTE_USER}     User home: ${_REMOTE_USER_HOME}"

if [  -z "$_REMOTE_USER" ] || [ -z "$_REMOTE_USER_HOME" ]; then
  echo "***********************************************************************************"
  echo "*** Require _REMOTE_USER and _REMOTE_USER_HOME to be set (by dev container CLI) ***"
  echo "***********************************************************************************"
  exit 1
fi

# Set HISTFILE for bash
cat << EOF >> "$_REMOTE_USER_HOME/.bashrc"

# shell-history-persistence start 
if [[ -n "\$HISTFILE_OLD" && "\$HISTFILE_OLD" != "\$HISTFILE" ]]; then
    # Assume that azure-cli-persistence has created the HISTFILE_OLD env var
    # that points to the previously configured location for the history file
    # Test if we have a marker file indicating that we've copied the history 
    # contents over. If not, copy and create the marker file
    if [[ ! -f "\$HISTFILE_OLD.marker" ]]; then
        # Append to the history file from the old file
        echo "Copying history file contents from \$HISTFILE to \$HISTFILE_OLD"
        cat "\$HISTFILE_OLD" >> "\$HISTFILE"
        echo "This marker file is created to indicate to shell-history-sync that it has already copied the content" >  "\$HISTFILE_OLD.marker"
    fi
fi
# shell-history-persistence end
EOF
sudo chown -R $_REMOTE_USER $_REMOTE_USER_HOME/.bashrc

