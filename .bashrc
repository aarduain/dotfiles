export SERVER='aarduain.com'
export SERVERDIR='/web/aarduain.com'
export SANDBOX=$SERVERDIR
export DBSERVER='localhost'
export EDITOR='vi'
alias SB='. ~/.bashrc'
alias lt='ls -altr'
alias pj='phantomjs --webdriver=4444'
alias selenium='java -jar ~/Desktop/Work\ Setup/selenium-server-standalone-2.45.0.jar'
alias buildTests='codecept build -c ~/workingcopy/../tests/codeception/projects/ets'
alias runAccept='codecept run -c ~/workingcopy/../tests/codeception/projects/ets acceptance'
alias runFunc='codecept run -c ~/workingcopy/../tests/codeception/projects/ets functional'
alias cd='cd -P'
stty -ixon -ixoff


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
