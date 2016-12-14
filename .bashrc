export SERVER='aarduain.com'
export SERVERDIR='/web/aarduain.com'
export SANDBOX=$SERVERDIR
export DBSERVER='localhost'
export EDITOR='mvim'
alias SB='. ~/.bashrc'
alias la='ls -altr'
alias pj='phantomjs --webdriver=4444'
alias selenium='java -jar ~/Desktop/Work\ Setup/selenium-server-standalone-2.45.0.jar'

function codecept_start() 
{
	cd ~/codecept
	php codecept.phar run -c projects/ets $1\/$2\/$3 --debug --steps
}

function workon() {
if test ! -d "$SANDBOX/public.$1"
then
    echo "public.$1: Does not exist" >&2
    return
fi
cd $SANDBOX
echo "`date` workon $@" >> $SERVERDIR/worklog
rm public
ln -s public.$1 public
if test -h ~/$1
then
    cd ~/$1/public
else
    cd -P public
fi
pwd
}
complete -W "$(echo `ls  $SANDBOX/git`)" workon

if [ -f $(brew --prefix)/etc/bash_completion ]; then
	. $(brew --prefix)/etc/bash_completion
fi
source ~/git-completion.bash
