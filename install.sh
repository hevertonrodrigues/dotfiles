#! /bin/bash

NO_COLOR="\033[1;0m"
GREEN="\033[0;32m"
BLUE="\033[0;34m"
RED="\033[0;31m"
WHITE="\033[0;37m"
GRAY="\033[1;30m"


#apps instalados com homebrew
APPS=(wget git ack ant autoconf automake cask cowsay cscope ctags emacs mongodb mysql node openssl sqlite postgresql funcoeszz)

echo -ne "\n${GREEN}Initializing...\n\n"
echo -e "Creating backup + creating symlinks to new dotfiles..."

cd ~/.dotfiles/files
for file in *; do
  echo "~/.$file"
  if [ -s ~/.$file ]; then mv ~/.$file ~/.$file.bkp; fi
  ln -s ~/.dotfiles/files/$file ~/.$file
done

if [[ "$OSTYPE" == "darwin"* ]]; then
  ~/.dotfiles/.osx
fi

echo -e "${GRAY}Installing Homebrew..."
ruby -e "$(curl -fsSL https://raw.github.com/Homebrew/homebrew/go/install)"

echo -e "Installing Homebrew applications"


installApp(){
  brew install $*
}

echo -ne "${BLUE}You wanna install all apps ${RED}[y/N]: ${GREEN}"
read -n1 all
vAll=$(echo $all | tr '[:upper:]' '[:lower:]')
echo -e "\n";

for i in "${APPS[@]}"
do
  if [ "$vAll" = "y" ]; then
    installApp $i;
  else
    viewText=$(echo $i | tr '[:lower:]' '[:upper:]')

    echo -ne "${BLUE}You wanna install:${WHITE} $viewText ${RED}[y/N]: ${GREEN}"
    read -n1 response
    echo -e "\n";
    value=$(echo $response | tr '[:upper:]' '[:lower:]')
    if [ "$value" = 'y' ]; then
      installApp $i;
    fi
  fi
done


#brew install wget git ack ant autoconf automake cask cowsay cscope ctags emacs mongodb mysql node openssl sqlite postgresql
#brew install macvim --with-cscope --with-lua --override-system-vim


echo -ne "\n${GREEN}Done! :-)${NO_COLOR}\n\n"
