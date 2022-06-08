
# Force XDG

This repository/package contains a list of fixes which should already by implemented in different applications by default, but are not. We can only speculate as to why some developers don't know about the XDG Base Directory specification in this time and age.

## Usage
Navigate into this repository, run `./setup.sh`. Source the copied `${XDG_DATA_HOME}/force_xdg/environment` from your shell's runscript file. You're done.

You can see what the script would do without actually doing anything by running `./setup.sh -n` instead.

If you decided to use `${FORCE_XDG_BIN_HOME}` instead of the default `${XDG_BIN_HOME}`, make sure to add it to your `${PATH}` too.

## Notes

You can `git pull` this repository, and re-run the setup to update the scripts at any time. Alternatively you can place the git directory as `${XDG_DATA_HOME}/force_xdg` manually, and then you may pull the changes directly. You still need to run `./setup.sh` to deploy the fixes, but this allows customizability.


## Project structure

```
force_xdg.git/
├── Makefile
├── README.md
├── bin/
│   ├── ...
├── config_home/
│   ├── app_one/
│   │   ├── force_xdg
│   │   └── app_onerc
│   └── app_two/
│       └── app_tworc
├── data_home/
│   └── force_xdg/
│       └── env.d/
│           └── app_three
├── oneshot_fixes/
│   └── app_four.sh
├── other/
│   ├── colours.sh
│   └── locales/
│       └── en_ISO.UTF-8
├── setup.sh
└── xdg_paths
```

Some applications are fixed in the initialization file, and in that case we want to inject our fixes into their configuration location: 
- Ideally we only add a file called `force_xdg` in their rc directory, and source this from their main rc file, if possible.
- Otherwise, we add the fixes directly in their own rc, with a guarding `>>> force_xdg` and `<<< force_xdg` around our injected code, in comments (if at all possible).

A lot of applications can be fixed by the usage of environment variables. We store all these fixes under `data_home/force_xdg/env.d/`, and only generate a single enviornment file which the user can source from wherever they choose to. Ideally, it's placed systemwide at `/etc/env.d/99-force_xdg`.

Some applications need to be set up in some way or another before they actually work, but only the first time. We place these fixes under `oneshot_fixes/`, and run them once the user activates the fix for the first time.

We should keep account of which applications are actively fixed under the configuration home of `force_xdg`.

Files under the directory `./others` are not intended to be automatically deployed on your system, but are common enough to be in your config files with other tweaks that they are worth taking a look at.

## Contributing

Grep for `TODO` and `FIXME` from the root directory of this repository. 

Fixes should be POSIX compatible, and shell-agnostic. This means we can't use functions nor aliases.

We should assume the `XDG_*` variables have been set previously, and fail otherwise. We should avoid dependencies to fix stuff.
