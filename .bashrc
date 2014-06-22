# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# don't put duplicate lines in the history. See bash(1) for more options
# ... or force ignoredups and ignorespace
HISTCONTROL=ignoredups:ignorespace

# append to the history file, don't overwrite it
shopt -s histappend
HISTSIZE=10000000
SAVEHIST=10000000
HISTFILE=~/.history

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

if [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
fi

if [ -d /etc/profile.d ]; then
	for file in /etc/profile.d/*.sh; do
		source $file
	done
fi

# hack for now
source /usr/share/bash-completion/bash_completion

#if [ -d /etc/bash_completion.d ]; then
#	for file in /etc/bash_completion.d/*; do
#		source $file
#	done
#fi

# Fedora 19 workaround for __git_ps1
source /usr/share/git-core/contrib/completion/git-prompt.sh

xrandr --output HDMI-0 --primary

#export JAVA_HOME=/usr/java/jre1.7.0_40
export FLIP_HOME=/home/stellarhopper/xprotolab/flip.3.2.1/bin
export PATH=$PATH:/home/stellarhopper/android-sdk/adt-bundle-linux-x86_64-20131030/sdk/platform-tools:/home/stellarhopper/android-sdk/adt-bundle-linux-x86_64-20131030/sdk/tools

KVER=$(uname -r | perl -ne 'if(/(\d+.\d+.\d+)-(\w+\+?)(-*.*)?/){print "$1-$2"}')

##################################################
# Fancy PWD display function
##################################################
# The home directory (HOME) is replaced with a ~
# The last pwdmaxlen characters of the PWD are displayed
# Leading partial directory names are striped off
# /home/me/stuff          -> ~/stuff               if USER=me
# /usr/share/big_dir_name -> ../share/big_dir_name if pwdmaxlen=20
##################################################
bash_prompt_command() {
    ss=$?
    #echo "ss = $?"

    local NONE="\[\033[0m\]"    # unsets color to term's fg color

    # regular colors
    local K="\[\033[0;30m\]"    # black
    local R="\[\033[0;31m\]"    # red
    local G="\[\033[0;32m\]"    # green
    local Y="\[\033[0;33m\]"    # yellow
    local B="\[\033[0;34m\]"    # blue
    local M="\[\033[0;35m\]"    # magenta
    local C="\[\033[0;36m\]"    # cyan
    local W="\[\033[0;37m\]"    # white

    # emphasized (bolded) colors
    local EMK="\[\033[1;30m\]"
    local EMR="\[\033[1;31m\]"
    local EMG="\[\033[1;32m\]"
    local EMY="\[\033[1;33m\]"
    local EMB="\[\033[1;34m\]"
    local EMM="\[\033[1;35m\]"
    local EMC="\[\033[1;36m\]"
    local EMW="\[\033[1;37m\]"

    # background colors
    local BGK="\[\033[40m\]"
    local BGR="\[\033[41m\]"
    local BGG="\[\033[42m\]"
    local BGY="\[\033[43m\]"
    local BGB="\[\033[44m\]"
    local BGM="\[\033[45m\]"
    local BGC="\[\033[46m\]"
    local BGW="\[\033[47m\]"

    local UC=$C                 # user's color
    [ $UID -eq "0" ] && UC=$M   # root's color
    local PC=$UC
    [ $ss -ne "0" ] && PC=$EMR   # Last command error color
    local ERRNUM=''
    [ $ss -ne "0" ] && ERRNUM="[$ss]"

    export GIT_PS1_SHOWDIRTYSTATE=1
    BRANCH='$(__git_ps1 "[%s]")'

    # How many characters of the $PWD should be kept
    local pwdmaxlen=25
    # Indicate that there has been dir truncation
    local trunc_symbol=".."
    local dir=${PWD##*/}
    pwdmaxlen=$(( ( pwdmaxlen < ${#dir} ) ? ${#dir} : pwdmaxlen ))
    NEW_PWD=${PWD/#$HOME/\~}
    local pwdoffset=$(( ${#NEW_PWD} - pwdmaxlen ))
    if [ ${pwdoffset} -gt "0" ]
    then
        NEW_PWD=${NEW_PWD:$pwdoffset:$pwdmaxlen}
        NEW_PWD=${trunc_symbol}/${NEW_PWD#*/}
    fi
    PS1="${EMR}[\t]${EMG}[${UC}\u${EMG}@\h${G}<${KVER}>${EMG}::${EMY}\${NEW_PWD}${EMG}]${EMC}${BRANCH}${PC}${ERRNUM}\\$ ${NONE}"
}

PROMPT_COMMAND=bash_prompt_command

#aliases
alias mcms='make clean; make; sync'
alias findme='yum search'
alias getme='sudo yum install'
alias upd='sudo yum update'

alias brc='source /home/$(whoami)/.bashrc'
alias ebrc='vim /home/$(whoami)/.bashrc +125'
alias eclr='echo -n'

alias ll='ls -l'
alias la='ls -la'
alias l='ls'
alias cd..='cd ..'
alias ..='cd ..'
alias .='echo $PWD'

alias vps='ssh -X 23.29.127.117 -p 4444'
alias discourse='ssh -X discourse@206.124.28.251'
alias vm='ssh -X 192.168.122.67'

alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

alias pubkey='cat ~/.ssh/id_rsa.pub'

mkcd () {
    mkdir -p "$*"
    cd "$*"
}

cleandir () {
    cd "$*"
    rm -rf *
    cd ..
}

checkpatch ()
{
    git diff --no-ext-diff origin/master | /home/vverma7/linux/scripts/checkpatch.pl --no-tree --no-signoff --terse -
}

checkfile ()
{
    /home/vverma7/linux/scripts/checkpatch.pl --no-tree --no-signoff --terse -f $*
}

psgrep()
{
    ps -A | grep $*
}

greptree()
{
    #find . -name \*.[ch] | xargs grep -Hn $*
    find . -name "*.c" -o -name "*.h" -o -name "*.pl" -o -name "*.py" -o -name "*.sh" -o -name "*.rb" | xargs -I {} grep -l $* {} | xargs -I {} bash -c "echo ""; echo \"-------{}--------\"; grep -n $* {};"
}

ln2web()
{
	webdir=/home/vverma7/www
	target=`readlink -f $*`
	if [ -e $webdir/$target ]; then
		rm $webdir/$target
	fi
	ln -sf $target $webdir
}

ssh-connect()
{
	host=vverma7@10.232.118.235
	[ -n "$1" ] && host=$1
	ip=$(echo $host | cut -d@ -f2)
	while true; do
		ping -c 1 $ip 2>&1 > /dev/null
		[ $? -eq 0 ] && break
		echo "Host $ip unavailable"
	done
	ssh $host
}

ww-save()
{
        file="~/.ww"
        [ ! -e $file ] && touch $file
        echo $PWD > $file
}

ww()
{
        file="~/.ww"
        wwpath="~"
        [ -e $file ] && wwpath=`cat $file`
        cd $wwpath
}

build-tags() {
	rm -f cscope.* tags
	#cscope -b -q -k -R > /dev/null
	#ctags -R --c++-kinds=+p --fields=+iaS --extra=+q --verbose ./ > /dev/null
	arch=$(uname -m | cut -d_ -f1)
	make ARCH=$arch cscope
	make ARCH=$arch tags
}

popcorn()
{
	LD_LIBRARY_PATH=/home/stellarhopper/popcorn-app/:$LD_LIBRARY_PATH ./build/releases/Popcorn-Time/linux64/Popcorn-Time/Popcorn-Time
}
