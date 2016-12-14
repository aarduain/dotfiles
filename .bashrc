export SERVER='aarduain.com'
export SERVERDIR='/web/aarduain01.alchemy-eng.com'
export SANDBOX='/web/aarduain01.alchemy-eng.com'
export DBSERVER='localhost'
export EDITOR='vim'
export CODECEPTION='/web/aarduain01.alchemy-eng.com/git/ets/www/tests/codeception/'
alias SB='. ~/.bashrc'
alias cd='cd -P'

function codecept_start() 
{
	cd ~/codecept
	php $CODECEPTION/codecept.phar run -c projects/$1 $2 $3\/$4 --debug --steps
}


