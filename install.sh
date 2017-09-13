#! /bin/bash

NO_COLOR="\033[1;0m"
GREEN="\033[0;32m"
BLUE="\033[0;34m"
RED="\033[0;31m"
WHITE="\033[0;37m"
GRAY="\033[1;30m"


#apps instalados com homebrew
APPS=(wget git ack ant autoconf automake cask cowsay cscope ctags emacs mongodb mysql node openssl sqlite postgresql funcoeszz "macvim --with-cscope --with-lua --override-system-vim")



echo -ne "\n${GREEN}Initializing...\n\n"

echo -e "Installing Oh My ZSH"

curl -L http://install.ohmyz.sh | sh


echo -e "Creating backup + creating symlinks to new dotfiles..."

cd ~/.dotfiles/files
for file in *; do
  echo "~/.$file"
  if [ -s ~/.$file ]; then mv ~/.$file ~/.$file.bkp; fi
  ln -s ~/.dotfiles/files/$file ~/.$file
done


#custom mac preferences
if [[ "$OSTYPE" == "darwin"* ]]; then

  echo -e "${GRAY}Installing Homebrew..."
  #ruby -e "$(curl -fsSL https://raw.github.com/Homebrew/homebrew/go/install)"
  ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

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

  # Install iTerm2
  echo -e "${GRAY}Installing iTerm2..."
  wget https://iterm2.com/downloads/stable/iTerm2-3_0_15.zip -P ~/Downloads/
  unzip ~/Downloads/iTerm2-3_0_15.zip -d /Applications/
  rm -f ~/Downloads/iTerm2-3_0_15.zip


  echo -e "${GRAY}Customizing AppleScript..."
  echo $(sudo chmod +x files/macos)
  echo $(sudo files/macos)


  #~/.dotfiles/.osx
fi


echo -ne "\n${GREEN}Done! :-)${NO_COLOR}\n\n"
