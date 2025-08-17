source ~/py_envs/bin/activate

#  Plugins 
# oh-my-zsh plugins are loaded  in ~/.hyde.zshrc file, see the file for more information

#  Aliases 
# Add aliases here
alias cp='cp --reflink=auto'
alias grep='grep --color=auto'
alias ls='ls --color=auto --file-type'
alias sudo='sudo-rs'

#  This is your file 
# Add your configurations here
export NVM_DIR="$HOME/.config/nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

export PATH="/usr/bin:/usr/local/bin:$HOME/.cargo/bin:$PATH"

# pnpm
export PNPM_HOME="/home/victor/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end

[[ "$TERM_PROGRAM" == "vscode" ]] && unset ARGV0
