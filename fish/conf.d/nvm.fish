# Existing nvm install lives in ~/.config/nvm (XDG). Official nvm is bash-only;
# bass applies nvm.sh into this fish session. Default Node/corepack go on PATH.
set -gx NVM_DIR "$HOME/.config/nvm"

if test -s "$NVM_DIR/nvm.sh"
    set -l nvm_which (bash -c 'export NVM_DIR="$0"; . "$NVM_DIR/nvm.sh" --no-use; nvm which default 2>/dev/null' "$NVM_DIR")
    if test -n "$nvm_which"; and test -x "$nvm_which"
        fish_add_path -g (dirname $nvm_which)
    end
end

function nvm --description 'Node Version Manager'
    if not functions -q bass
        echo "nvm: bass.fish is required" >&2
        return 1
    end
    if not test -s "$NVM_DIR/nvm.sh"
        echo "nvm: $NVM_DIR/nvm.sh not found" >&2
        return 1
    end
    bass source "$NVM_DIR/nvm.sh" --no-use ';' nvm $argv
end

if status is-interactive
    nvm use default --silent >/dev/null 2>&1
end
