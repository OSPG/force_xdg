#!/bin/sh
[ -L "$HOME/.ssh" ] || exit 0  # already done :)

[ -e "${XDG_DATA_HOME:?}/ssh" ] && exit 1  # we can't move it! :(

mv ~/.ssh ${XDG_DATA_HOME}/ssh
ln -s ${XDG_DATA_HOME}/ssh ~/.ssh

