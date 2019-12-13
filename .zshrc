export PATH="~/.cabal/bin/:$PATH"
export TERM="xterm-256color"
export ZSH=~/.oh-my-zsh

# all of our zsh files
typeset -U config_files
config_files=($HOME/.dotfiles/**/*.zsh)

# load the path files
for file in ${(M)config_files:#*/path.zsh}
do
  source $file
done

# load everything but the path and completion files
for file in ${${config_files:#*/path.zsh}:#*/completion.zsh}
do
  source $file
done

# initialize autocomplete here, otherwise functions won't be loaded
autoload -U compinit
compinit

# load every completion after autocomplete loads
for file in ${(M)config_files:#*/completion.zsh}
do
  source $file
done

unset config_files

plugins=(git command-not-found cabal pip vi-mode)

source $ZSH/oh-my-zsh.sh

COMPLETION_WAITING_DOTS="true"

. ~/z.sh

ENABLE_CORRECTION="true"
