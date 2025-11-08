# ──────────────────────────────────────────────────────
# Environment setup (asdf, conda, ruby build flags)
# ──────────────────────────────────────────────────────

# Load asdf if installed
if [ -d "${HOME}/.asdf" ] ; then
    . "${HOME}/.asdf/asdf.sh"
fi

# Add global npm binaries (used by commitizen, eslint, etc.) to PATH
export PATH="`npm prefix --location=global`/bin:$PATH"

# Load Java plugin for asdf (sets JAVA_HOME)
if [ -d "${HOME}/.asdf/plugins/java" ] ; then
    . "${HOME}/.asdf/plugins/java/set-java-home.zsh"
fi

# Initialize conda (prefer hook; fallback to profile script or manual PATH)
__conda_setup="$(${HOME}/miniconda3/bin/conda shell.zsh hook 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "${HOME}/miniconda3/etc/profile.d/conda.sh" ]; then
        . "${HOME}/miniconda3/etc/profile.d/conda.sh"
    else
        export PATH="${HOME}/miniconda3/bin:$PATH"
    fi
fi
unset __conda_setup

# ──────────────────────────────────────────────────────
# Ruby build environment for asdf/frum compatibility
# ──────────────────────────────────────────────────────

# SEE: https://github.com/TaKO8Ki/frum/issues/126#issuecomment-1876168762
# SEE: https://github.com/asdf-vm/asdf-ruby/issues/328#issuecomment-1688750889
export CPATH="$(brew --prefix)/include"
export LIBRARY_PATH="$(brew --prefix)/lib"
RUBY_CONFIGURE_OPTS="\
    --with-zlib-dir=$(brew --prefix zlib) \
    --with-openssl-dir=$(brew --prefix openssl@3) \
    --with-readline-dir=$(brew --prefix readline) \
    --with-libyaml-dir=$(brew --prefix libyaml)"

# ──────────────────────────────────────────────────────
# Tools installed in user space
# ──────────────────────────────────────────────────────

# Add latest DuckDB CLI to PATH
export PATH="${HOME}/.duckdb/cli/latest:${PATH}"
