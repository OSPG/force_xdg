final: prev: let
  xdgDefaults =
    ''--run 'export XDG_CACHE_HOME="''${XDG_CACHE_HOME:-$HOME/.cache}"' '' +
    ''--run 'export XDG_CONFIG_HOME="''${XDG_CONFIG_HOME:-$HOME/.config}"' '' +
    ''--run 'export XDG_DATA_HOME="''${XDG_DATA_HOME:-$HOME/.local/share}"' '' +
    ''--run 'export XDG_RUNTIME_DIR="''${XDG_RUNTIME_DIR:-/run/user/$(id -u)}"' '' +  # /run/user/${id} is convention, not spec 
    ''--run 'export XDG_STATE_HOME="''${XDG_STATE_HOME:-$HOME/.local/state}"' '';

  wraps = drv: binVars:
    let
      joined = final.symlinkJoin {
        name = drv.name + "-xdg";
        paths = [ drv ];
        buildInputs = [ final.makeWrapper ];
        postBuild = builtins.concatStringsSep "\n" (
          map ({ bin, vars }:
            "wrapProgram $out/bin/${bin} " +
            xdgDefaults +
            builtins.concatStringsSep " " (
              map ({ name, value }: "--set-default ${name} '${value}'") vars
            )
          ) binVars
        );
      };
    in drv // joined // {
      override      = f: wraps (drv.override f) binVars;
      overrideAttrs = f: wraps (drv.overrideAttrs f) binVars;
      passthru      = drv.passthru or {};
      meta          = drv.meta or {};
    };

  wrap = drv: bin: vars: wraps drv [{ inherit bin vars; }];

  xdgPkgs = {
    ack = wrap prev.ack "ack" [
      { name = "ACKRC"; value = "$XDG_CONFIG_HOME/ack/ackrc"; }
    ];

    android-tools = wrap prev.android-tools "adb" [
      { name = "ANDROID_SDK_HOME"; value = "$XDG_CONFIG_HOME/android"; }
      { name = "ADB_VENDOR_KEY";   value = "$XDG_CONFIG_HOME/android"; }
    ];

    aspell = wrap prev.aspell "aspell" [
      { name = "ASPELL_CONF"; value = "per-conf $XDG_CONFIG_HOME/aspell/aspell.conf; personal $XDG_CONFIG_HOME/aspell/en.pws; repl $XDG_CONFIG_HOME/aspell/en.prepl"; }
    ];

    awscli2 = wrap prev.awscli2 "aws" [
      { name = "AWS_CONFIG_FILE";             value = "$XDG_CONFIG_HOME/aws/config"; }
      { name = "AWS_SHARED_CREDENTIALS_FILE"; value = "$XDG_CONFIG_HOME/aws/credentials"; }
    ];

    bash = wrap prev.bash "bash" [
      { name = "BASH_COMPLETION_USER_FILE"; value = "$XDG_CONFIG_HOME/bash-completion/bash_completion"; }
    ];

    bundler = wrap prev.bundler "bundle" [
      { name = "BUNDLE_USER_CONFIG"; value = "$XDG_CONFIG_HOME/bundler"; }
      { name = "BUNDLE_USER_CACHE";  value = "$XDG_CACHE_HOME/bundler"; }
      { name = "BUNDLE_USER_PLUGIN"; value = "$XDG_DATA_HOME/bundler"; }
    ];

    cabal-install = wrap prev.cabal-install "cabal" [
      { name = "CABAL_CONFIG"; value = "$XDG_CONFIG_HOME/cabal/config"; }
      { name = "CABAL_DIR";    value = "$XDG_CACHE_HOME/cabal"; }
    ];

    cargo = wrap prev.cargo "cargo" [
      { name = "CARGO_HOME"; value = "$XDG_DATA_HOME/cargo"; }
    ];

    cgdb = wrap prev.cgdb "cgdb" [
      { name = "CGDB_DIR"; value = "$XDG_CONFIG_HOME/cgdb"; }
    ];

    conda = wrap prev.conda "conda" [
      { name = "CONDARC"; value = "$XDG_CONFIG_HOME/conda/condarc"; }
    ];

    docker = wrap prev.docker "docker" [
      { name = "DOCKER_CONFIG";        value = "$XDG_CONFIG_HOME/docker"; }
      { name = "MACHINE_STORAGE_PATH"; value = "$XDG_DATA_HOME/docker/machine"; }
    ];

    elinks = wrap prev.elinks "elinks" [
      { name = "ELINKS_CONFDIR"; value = "$XDG_CONFIG_HOME/elinks"; }
    ];

    electrum = wrap prev.electrum "electrum" [
      { name = "ELECTRUMDIR"; value = "$XDG_DATA_HOME/electrum"; }
    ];

    emacs = wrap prev.emacs "emacs" [
      { name = "SPACEMACSDIR"; value = "$XDG_CONFIG_HOME/spacemacs"; }
    ];

    emscripten = wrap prev.emscripten "emcc" [
      { name = "EM_CONFIG"; value = "$XDG_CONFIG_HOME/emscripten/config"; }
      { name = "EM_CACHE";  value = "$XDG_CACHE_HOME/emscripten/cache"; }
      { name = "EM_PORTS";  value = "$XDG_DATA_HOME/emscripten/cache"; }
    ];

    fceux = wrap prev.fceux "fceux" [
      { name = "FCEUX_HOME"; value = "$XDG_CONFIG_HOME/fceux"; }
    ];

    ffmpeg = wrap prev.ffmpeg "ffmpeg" [
      { name = "FFMPEG_DATADIR"; value = "$XDG_CONFIG_HOME/ffmpeg"; }
    ];

    get_iplayer = wrap prev.get_iplayer "get_iplayer" [
      { name = "GETIPLAYERUSERPREFS"; value = "$XDG_DATA_HOME/get_iplayer"; }
    ];

    gnupg = wrap prev.gnupg "gpg" [
      { name = "GNUPGHOME"; value = "$XDG_DATA_HOME/gnupg"; }
    ];

    go = wrap prev.go "go" [
      { name = "GOPATH"; value = "$XDG_DATA_HOME/go"; }
    ];

    gpodder = wrap prev.gpodder "gpodder" [
      { name = "GPODDER_HOME"; value = "$XDG_DATA_HOME/gpodder"; }
    ];

    gradle = wrap prev.gradle "gradle" [
      { name = "GRADLE_USER_HOME"; value = "$XDG_DATA_HOME/gradle"; }
    ];

    gq = wrap prev.gq "gq" [
      { name = "GQRC";    value = "$XDG_CONFIG_HOME/gqrc"; }
      { name = "GQSTATE"; value = "$XDG_STATE_HOME/gq/state"; }
    ];

    hledger = wrap prev.hledger "hledger" [
      { name = "LEDGER_FILE"; value = "$XDG_DATA_HOME/hledger/journal"; }
    ];

    imapfilter = wrap prev.imapfilter "imapfilter" [
      { name = "IMAPFILTER_HOME"; value = "$XDG_CONFIG_HOME/imapfilter"; }
    ];

    jdk = wrap prev.jdk "java" [
      { name = "_JAVA_OPTIONS"; value = "-Djava.util.prefs.userRoot=$XDG_CONFIG_HOME/java"; }
    ];

    julia = wrap prev.julia "julia" [
      { name = "JULIA_DEPOT_PATH"; value = "$XDG_DATA_HOME/julia"; }
    ];

    kodi = wrap prev.kodi "kodi" [
      { name = "KODI_DATA"; value = "$XDG_DATA_HOME/kodi"; }
    ];

    # ipfs was renamed to kubo in nixpkgs
    kubo = wrap prev.kubo "ipfs" [
      { name = "IPFS_PATH"; value = "$XDG_DATA_HOME/ipfs"; }
    ];

    leiningen = wrap prev.leiningen "lein" [
      { name = "LEIN_HOME"; value = "$XDG_DATA_HOME/leiningen"; }
    ];

    less = wrap prev.less "less" [
      { name = "LESSHISTFILE"; value = "$XDG_STATE_HOME/less/history"; }
      { name = "LESSKEY";      value = "$XDG_CONFIG_HOME/less/lesskey"; }
    ];

    lynx = wrap prev.lynx "lynx" [
      { name = "LYNX_CFG_PATH"; value = "$XDG_CONFIG_HOME/lynx/lynxrc"; }
    ];

    maxima = wrap prev.maxima "maxima" [
      { name = "MAXIMA_USERDIR"; value = "$XDG_CONFIG_HOME/maxima"; }
    ];

    mednafen = wrap prev.mednafen "mednafen" [
      { name = "MEDNAFEN_HOME"; value = "$XDG_CONFIG_HOME/mednafen"; }
    ];

    minikube = wrap prev.minikube "minikube" [
      { name = "MINIKUBE_HOME"; value = "$XDG_DATA_HOME/minikube"; }
    ];

    most = wrap prev.most "most" [
      { name = "MOST_INITFILE"; value = "$XDG_CONFIG_HOME/mostrc"; }
    ];

    mplayer = wrap prev.mplayer "mplayer" [
      { name = "MPLAYER_HOME"; value = "$XDG_CONFIG_HOME/mplayer"; }
    ];

    # nixpkgs uses a versioned alias; adjust to mysql80/mysql84 if needed
    mysql = wrap prev.mysql "mysql" [
      { name = "MYSQL_HISTFILE"; value = "$XDG_STATE_HOME/mysql/history"; }
    ];

    nodejs = wrap prev.nodejs "node" [
      { name = "NODE_REPL_HISTORY";     value = "$XDG_STATE_HOME/node/history"; }
      { name = "NPM_CONFIG_USERCONFIG"; value = "$XDG_CONFIG_HOME/npm/npmrc"; }
    ];

    octave = wrap prev.octave "octave" [
      { name = "OCTAVE_HISTFILE";      value = "$XDG_STATE_HOME/octave/history"; }
      { name = "OCTAVE_SITE_INITFILE"; value = "$XDG_CONFIG_HOME/octave/octaverc"; }
    ];

    opam = wrap prev.opam "opam" [
      { name = "OPAMROOT"; value = "$XDG_DATA_HOME/opam"; }
    ];

    parallel = wrap prev.parallel "parallel" [
      { name = "PARALLEL_HOME"; value = "$XDG_CONFIG_HOME/parallel"; }
    ];

    pass = wrap prev.pass "pass" [
      { name = "PASSWORD_STORE_DIR"; value = "$XDG_DATA_HOME/pass/password-store"; }
    ];

    postgresql = wrap prev.postgresql "psql" [
      { name = "PGPASSFILE";    value = "$XDG_CONFIG_HOME/postgresql/pass"; }
      { name = "PGSERVICEFILE"; value = "$XDG_CONFIG_HOME/postgresql/pg_service.conf"; }
      { name = "PSQL_HISTORY";  value = "$XDG_STATE_HOME/postgresql/history"; }
      { name = "PSQLRC";        value = "$XDG_CONFIG_HOME/postgresql/psqlrc"; }
    ];

    python3 = wrap prev.python3 "python3" [
      { name = "PYTHONSTARTUP";  value = "$XDG_CONFIG_HOME/python/pythonrc"; }
      { name = "PYTHONHISTFILE"; value = "$XDG_STATE_HOME/python/history"; }
    ];

    racket = wrap prev.racket "racket" [
      { name = "PLTUSERHOME"; value = "$XDG_DATA_HOME/racket"; }
    ];

    recoll = wrap prev.recoll "recoll" [
      { name = "RECOLL_CONFDIR"; value = "$XDG_CONFIG_HOME/recoll"; }
    ];

    redis = wrap prev.redis "redis-cli" [
      { name = "REDISCLI_HISTFILE"; value = "$XDG_STATE_HOME/redis/history"; }
      { name = "REDISCLI_RCFILE";   value = "$XDG_CONFIG_HOME/redis/redisclirc"; }
    ];

    ripgrep = wrap prev.ripgrep "rg" [
      { name = "RIPGREP_CONFIG_PATH"; value = "$XDG_CONFIG_HOME/ripgrep/config"; }
    ];

    rlwrap = wrap prev.rlwrap "rlwrap" [
      { name = "RLWRAP_HOME"; value = "$XDG_DATA_HOME/rlwrap"; }
    ];

    # RXVT_SOCKET uses XDG_RUNTIME_DIR which may not exist on non-systemd systems
    "rxvt-unicode" = wrap prev."rxvt-unicode" "urxvtd" [
      { name = "RXVT_SOCKET"; value = "$XDG_RUNTIME_DIR/urxvtd"; }
    ];

    # irb and gem live in the same ruby package
    ruby = wraps prev.ruby [
      { bin = "irb"; vars = [{ name = "IRBRC"; value = "$XDG_CONFIG_HOME/irb/irbrc"; }]; }
      { bin = "gem"; vars = [
        { name = "GEM_HOME";       value = "$XDG_DATA_HOME/gem"; }
        { name = "GEM_SPEC_CACHE"; value = "$XDG_CACHE_HOME/gem"; }
      ]; }
    ];

    rustup = wrap prev.rustup "rustup" [
      { name = "CARGO_HOME";  value = "$XDG_DATA_HOME/cargo"; }
      { name = "RUSTUP_HOME"; value = "$XDG_DATA_HOME/rustup"; }
    ];

    screen = wrap prev.screen "screen" [
      { name = "SCREENRC"; value = "$XDG_CONFIG_HOME/screen/screenrc"; }
    ];

    sqlite = wrap prev.sqlite "sqlite3" [
      { name = "SQLITE_HISTORY"; value = "$XDG_STATE_HOME/sqlite/history"; }
    ];

    stack = wrap prev.stack "stack" [
      { name = "STACK_ROOT"; value = "$XDG_DATA_HOME/stack"; }
    ];

    taskwarrior3 = wrap prev.taskwarrior3 "task" [
      { name = "TASKDATA"; value = "$XDG_DATA_HOME/task"; }
      { name = "TASKRC";   value = "$XDG_CONFIG_HOME/task/taskrc"; }
    ];

    texmacs = wrap prev.texmacs "texmacs" [
      { name = "TEXMACS_HOME_PATH"; value = "$XDG_STATE_HOME/texmacs"; }
    ];

    timewarrior = wrap prev.timewarrior "timew" [
      { name = "TIMEWARRIORDB"; value = "$XDG_CONFIG_HOME/time"; }
    ];

    uncrustify = wrap prev.uncrustify "uncrustify" [
      { name = "UNCRUSTIFY_CONFIG"; value = "$XDG_CONFIG_HOME/uncrustify/uncrustify.cfg"; }
    ];

    unison = wrap prev.unison "unison" [
      { name = "UNISON"; value = "$XDG_DATA_HOME/unison"; }
    ];

    vagrant = wrap prev.vagrant "vagrant" [
      { name = "VAGRANT_ALIAS_FILE"; value = "$XDG_DATA_HOME/vagrant/aliases"; }
      { name = "VAGRANT_HOME";       value = "$XDG_DATA_HOME/vagrant"; }
    ];

    vscode = wrap prev.vscode "code" [
      { name = "VSCODE_PORTABLE"; value = "$XDG_DATA_HOME/vscode"; }
    ];

    wakatime-cli = wrap prev.wakatime-cli "wakatime-cli" [
      { name = "WAKATIME_HOME"; value = "$XDG_CONFIG_HOME/wakatime"; }
    ];

    wget = wrap prev.wget "wget" [
      { name = "WGETRC"; value = "$XDG_CONFIG_HOME/wget/config"; }
    ];

    wine = wrap prev.wine "wine" [
      { name = "WINEPREFIX"; value = "$XDG_DATA_HOME/wine/prefixes/default"; }
    ];

    "zoom-us" = wrap prev."zoom-us" "zoom" [
      { name = "SSB_HOME"; value = "$XDG_DATA_HOME/zoom"; }
    ];

    zsh = wrap prev.zsh "zsh" [
      { name = "HISTFILE"; value = "$XDG_STATE_HOME/zsh/history"; }
      { name = "ZDOTDIR";  value = "$XDG_CONFIG_HOME/zsh"; }
    ];

    # these variables are read by libraries or affect too many unrelated
    # programs to scope per-binary
    # use environment.sessionVariables instead ?
    #
    # cuda      → CUDA_CACHE_PATH                  (CUDA runtime library)
    # gtk       → GTK_RC_FILES, GTK2_RC_FILES      (all GTK applications)
    # kde       → KDEHOME                          (all KDE applications)
    # libdvdcss → DVDCSS_CACHE                     (library, no binary)
    # libice    → ICEAUTHORITY                     (X11 session management)
    # libx11    → XCOMPOSEFILE, XCOMPOSECACHE      (X11 input)
    # readline  → INPUTRC                          (many readline consumers)
    # tex       → TEXMFHOME, TEXMFVAR, TEXMFCONFIG (all TeX programs)
    # terminfo  → TERMINFO, TERMINFO_DIRS          (all terminal programs)
    # x11       → XINITRC, XSERVERRC               (X11 startup)
    # xauthority → XAUTHORITY                      (X11 authentication)

    # these are shell functions, not standalone binaries
    #
    # nvm → NVM_DIR  (sourced shell function, not in nixpkgs)
    # z   → _Z_DATA  (z.sh is sourced into the shell)
  };

in xdgPkgs // { inherit xdgPkgs; }
