
# Force XDG

This repository/package contains a list of fixes which should already by implemented in different applications by default, but are not. We can only speculate as to why some developers don't know about the XDG Base Directory specification in this time and age.

## Usage
Navigate into this repository, run `./setup.sh`. Source the copied `${XDG_DATA_HOME}/force_xdg/environment` from your shell's runscript file. You're done.

You can see what the script would do without actually doing anything by running `./setup.sh -n` instead.

If you decided to use `${FORCE_XDG_BIN_HOME}` instead of the default `${XDG_BIN_HOME}`, make sure to add it to your `${PATH}` too.

## Notes

You can `git pull` this repository, and re-run the setup to update the scripts at any time. Alternatively you can place the git directory as `${XDG_DATA_HOME}/force_xdg` manually, and then you may pull the changes directly. You still need to run `./setup.sh` to deploy the fixes, but this allows customizability.

Note that there are some more nice things in this repository, under the directory `./others`. These scripts are not intended to be automatically deployed on your system, but are common enough to be in your config files with other tweaks that they are worth taking a look at.


