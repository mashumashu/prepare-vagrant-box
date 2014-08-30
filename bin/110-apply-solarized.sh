#!/bin/bash

readonly VIM_SOLARIZED_DIR="/var/tmp/vim-colors-solarized-master"
readonly DIR_SOLARIZED_DIR="/var/tmp/dircolors-solarized-master"

rm -rf $VIM_SOLARIZED_DIR
rm -rf $DIR_SOLARIZED_DIR

# main
if [ ! -f "$VIM_SOLARIZED_DIR.zip" -o ! -f "$DIR_SOLARIZED_DIR.zip" ]; then
  echo ">> [error] No exist necessary files($VIM_SOLARIZED_DIR, $DIR_SOLARIZED_DIR)"
  exit 1
fi

cd /var/tmp
rm -f /root/.vimrc

## vim-colors-solarized-master
unzip "$VIM_SOLARIZED_DIR.zip"
mkdir -p /root/.vim/colors
cp -fp "$VIM_SOLARIZED_DIR/colors/solarized.vim" /root/.vim/colors/

if [ ! -f "/root/.vimrc" ]; then
  {
    echo "syntax enable"
    echo "set background=dark"
    echo "colorscheme solarized"
  } >>/root/.vimrc
fi

## dircolors-solarized-master
unzip "$DIR_SOLARIZED_DIR.zip"
rm -rf /root/dircolors-solarized
rm -rf /root/.dircolors
mv $DIR_SOLARIZED /root/dircolors-solarized
ln -s /root/dircolors-solarized/dircolors.256dark /root/.dircolors

grep LS_COLORS /root/.bashrc >/dev/null
if [ $? -ne 0 ]; then
  sed -i".org" -e '/^# Source/,$d' /root/.bashrc
  {
    echo ""
    echo "# Customize - Add alias"
    echo ""
    echo "alias vi='vim'"
    echo "vim_version=\$(vim --version | head -1 | sed 's/^.*\ \([0-9]\)\.\([0-9]\)\ .*$/\1\2/')"
    echo 'alias lessc="/usr/share/vim/vim${vim_version}/macros/less.sh"'
    echo ""
    echo "# Customize - Debug Prompt"
    echo ""
    echo "export PS4='+ (\${BASH_SOURCE}:\${LINENO}): \${FUNCNAME:+\$FUNCNAME(): }'"
    echo ""
    echo "# Customize - Environment Variable"
    echo ""
    echo "export EDITOR='vim'"
    echo 'export GREP_OPTIONS="--binary-files=without-match --color=auto"'
    echo ""
    echo "# Customize - Add LS_COLORS"
    echo ""
    echo "LS_COLORS='no=00;38;5;244:rs=0:di=00;38;5;33:ln=00;38;5;37:mh=00:pi=48;5;230;38;5;136;01:so=48;5;230;38;5;136;01:do=48;5;230;38;5;136;01:bd=48;5;230;38;5;244;01:cd=48;5;230;38;5;244;01:or=48;5;235;38;5;160:su=48;5;160;38;5;230:sg=48;5;136;38;5;230:ca=30;41:tw=48;5;64;38;5;230:ow=48;5;235;38;5;33:st=48;5;33;38;5;230:ex=00;38;5;64:*.tar=00;38;5;61:*.tgz=00;38;5;61:*.arj=00;38;5;61:*.taz=00;38;5;61:*.lzh=00;38;5;61:*.lzma=00;38;5;61:*.tlz=00;38;5;61:*.txz=00;38;5;61:*.zip=00;38;5;61:*.z=00;38;5;61:*.Z=00;38;5;61:*.dz=00;38;5;61:*.gz=00;38;5;61:*.lz=00;38;5;61:*.xz=00;38;5;61:*.bz2=00;38;5;61:*.bz=00;38;5;61:*.tbz=00;38;5;61:*.tbz2=00;38;5;61:*.tz=00;38;5;61:*.deb=00;38;5;61:*.rpm=00;38;5;61:*.jar=00;38;5;61:*.rar=00;38;5;61:*.ace=00;38;5;61:*.zoo=00;38;5;61:*.cpio=00;38;5;61:*.7z=00;38;5;61:*.rz=00;38;5;61:*.apk=00;38;5;61:*.gem=00;38;5;61:*.jpg=00;38;5;136:*.JPG=00;38;5;136:*.jpeg=00;38;5;136:*.gif=00;38;5;136:*.bmp=00;38;5;136:*.pbm=00;38;5;136:*.pgm=00;38;5;136:*.ppm=00;38;5;136:*.tga=00;38;5;136:*.xbm=00;38;5;136:*.xpm=00;38;5;136:*.tif=00;38;5;136:*.tiff=00;38;5;136:*.png=00;38;5;136:*.svg=00;38;5;136:*.svgz=00;38;5;136:*.mng=00;38;5;136:*.pcx=00;38;5;136:*.dl=00;38;5;136:*.xcf=00;38;5;136:*.xwd=00;38;5;136:*.yuv=00;38;5;136:*.cgm=00;38;5;136:*.emf=00;38;5;136:*.eps=00;38;5;136:*.CR2=00;38;5;136:*.ico=00;38;5;136:*.tex=00;38;5;245:*.rdf=00;38;5;245:*.owl=00;38;5;245:*.n3=00;38;5;245:*.ttl=00;38;5;245:*.nt=00;38;5;245:*.torrent=00;38;5;245:*.xml=00;38;5;245:*Makefile=00;38;5;245:*Rakefile=00;38;5;245:*build.xml=00;38;5;245:*rc=00;38;5;245:*1=00;38;5;245:*.nfo=00;38;5;245:*README=00;38;5;245:*README.txt=00;38;5;245:*readme.txt=00;38;5;245:*.md=00;38;5;245:*README.markdown=00;38;5;245:*.ini=00;38;5;245:*.yml=00;38;5;245:*.cfg=00;38;5;245:*.conf=00;38;5;245:*.c=00;38;5;245:*.cpp=00;38;5;245:*.cc=00;38;5;245:*.log=00;38;5;240:*.bak=00;38;5;240:*.aux=00;38;5;240:*.lof=00;38;5;240:*.lol=00;38;5;240:*.lot=00;38;5;240:*.out=00;38;5;240:*.toc=00;38;5;240:*.bbl=00;38;5;240:*.blg=00;38;5;240:*~=00;38;5;240:*#=00;38;5;240:*.part=00;38;5;240:*.incomplete=00;38;5;240:*.swp=00;38;5;240:*.tmp=00;38;5;240:*.temp=00;38;5;240:*.o=00;38;5;240:*.pyc=00;38;5;240:*.class=00;38;5;240:*.cache=00;38;5;240:*.aac=00;38;5;166:*.au=00;38;5;166:*.flac=00;38;5;166:*.mid=00;38;5;166:*.midi=00;38;5;166:*.mka=00;38;5;166:*.mp3=00;38;5;166:*.mpc=00;38;5;166:*.ogg=00;38;5;166:*.ra=00;38;5;166:*.wav=00;38;5;166:*.m4a=00;38;5;166:*.axa=00;38;5;166:*.oga=00;38;5;166:*.spx=00;38;5;166:*.xspf=00;38;5;166:*.mov=00;38;5;166:*.mpg=00;38;5;166:*.mpeg=00;38;5;166:*.m2v=00;38;5;166:*.mkv=00;38;5;166:*.ogm=00;38;5;166:*.mp4=00;38;5;166:*.m4v=00;38;5;166:*.mp4v=00;38;5;166:*.vob=00;38;5;166:*.qt=00;38;5;166:*.nuv=00;38;5;166:*.wmv=00;38;5;166:*.asf=00;38;5;166:*.rm=00;38;5;166:*.rmvb=00;38;5;166:*.flc=00;38;5;166:*.avi=00;38;5;166:*.fli=00;38;5;166:*.flv=00;38;5;166:*.gl=00;38;5;166:*.m2ts=00;38;5;166:*.divx=00;38;5;166:*.webm=00;38;5;166:*.axv=00;38;5;166:*.anx=00;38;5;166:*.ogv=00;38;5;166:*.ogx=00;38;5;166:'"
    echo "export LS_COLORS"
    echo ""
    echo "if [ -f ~/.dircolors ]; then"
    echo "    if type dircolors > /dev/null 2>&1; then"
    echo "        eval \$(dircolors ~/.dircolors)"
    echo "    elif type gdircolors > /dev/null 2>&1; then"
    echo "        eval \$(gdircolors ~/.dircolors)"
    echo "    fi"
    echo "fi"
    echo ""
    echo "# Source global definitions"
    echo ""
    echo "if [ -f /etc/bashrc ]; then"
    echo "        . /etc/bashrc"
    echo "fi"
  } >>/root/.bashrc
fi

# verify
echo ""
echo ">> verify vim-colors-solarized manually."
echo '-----------------------------'
ls -l ~/.vim/colors/
cat /root/.vimrc
echo '-----------------------------'
echo ""
echo ">> verify dircolors-solarized manually."
echo '-----------------------------'
ls -l /root/.dircolors
cat /root/.bashrc
echo '-----------------------------'
echo ""

exit 0
