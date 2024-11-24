export ZSHRC="~/.zshrc"
alias rezsh='source "$ZSHRC" && echo reloaded ZSH' 
alias vimZ='vim "$ZSHRC"'
alias vimVim="vim ~/.vimrc"
alias vimT="vim ~/.tmux.conf"
export TERM=xterm-256color

silent() {
  "$@" > /dev/null 2>&1
}

deepdelete() {
  if [[ "$1" == "--dry-run" || "$1" == "-dr" ]]; then
    echo "Dry run mode: Listing files that would be deleted:"
    find . -type f | sort
  else
    find . -type f -exec gshred -z -n 10 -uv {} +
  fi
}

deepDeleteImgs () {
	if [[ "$1" == "--dry-run" || "$1" == "-dr" ]]
	then
		echo "Dry run mode: Listing files that would be deleted:"
		find . -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.gif" -o -iname "*.bmp" -o -iname "*.tiff" -o -iname "*.webp" \) | sort
	else
		find . -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.gif" -o -iname "*.bmp" -o -iname "*.tiff" -o -iname "*.webp" \) -exec gshred -z -n 10 -uv {} +
	fi
}

retouch() {
  mkdir -p ./subdir/deepersubdir
  touch ./file ./subdir/file2 ./myImg.jpg ./subdir/deepersubdir/anotherImg.jpg ./subdir/someVid.mp4
}

