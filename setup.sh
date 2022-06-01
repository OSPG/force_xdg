#!/bin/sh
# 
# Make sure you run this script from the same location 
# the setup file is in
#

# just to silence the output
pushd() { command pushd "$@" >/dev/null; }
popd() { command popd "$@" >/dev/null; }


#
# preparing the script
# 
. ./environment  # required for XDG variables
[ "$1" = "-n" ] && DRY=1
test DRY && printf 'Doing a dry run, no changes will be done\n\n'

#
# updates the current xdg data
#
force_xdg_home=${XDG_DATA_HOME}/force_xdg
[ "$(pwd)" = "${force_xdg_home}" ] || LOCALLY=1
test LOCALLY && printf 'Detected we are in the force_xdg data directory. No need to copy it over\n'

test DRY || mkdir -p ${force_xdg_home}
test DRY || test LOCALLY || cp -rT . ${force_xdg_home}  # careful! may override stuff!

#
# adds fixes to programs in the respective paths
# 
# all changes will link to this program's fixes, 
# so that updates are easy to maintain
# note that symlinks can't override regular files, so if you want
# custom changes, just make a normal file instead of a symlink
#
pushd data_home
	for app in *; do
		test DRY || mkdir -p ${XDG_DATA_HOME}/${app}
		for f in ${app}/*; do
			printf 'Linking %s to %s\n' "${force_xdg_home}/data_home/${f}" "${XDG_DATA_HOME}/${f}"
			test DRY || ln -sf "${force_xdg_home}/data_home/${f}" "${XDG_DATA_HOME}/${f}"
		done
	done
popd
printf 'Completed linking data files\n\n'

#
# some applications work best with complete workarounds
#
pushd bin
	for f in *; do
		test DRY || mkdir -p ${XDG_DATA_HOME}/${app}
		printf 'Linking %s to %s\n' "${force_xdg_home}/bin/${f}" "${XDG_BIN_HOME}/${f}"
		test DRY || ln -sf "${force_xdg_home}/bin/${f}" "${XDG_BIN_HOME}/${f}"
	done
popd
printf 'Completed linking aliases files\n\n'

# travel safely :)
printf 'Completed successfully\n'

