# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH=/Users/aarduain/.oh-my-zsh

fpath=(~/.oh-my-zsh $fpath)
fpath=(~/.oh-my-zsh/completions $fpath)
#zstyle ':completion:*:*:git:*' script ~/.git-completion.bash
#autoload -Uz compinit && compinit
# Set name of the theme to load. Optionally, if you set this to "random"
# it'll load a random theme each time that oh-my-zsh is loaded.
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
ZSH_THEME="agnoster"
DEFAULT_USER="aarduain"

alias la='ls -la'
alias apache-restart='sudo /opt/local/apache2/bin/apachectl -k restart'
alias apache-start='sudo /opt/local/apache2/bin/apachectl -k start'
alias apache-stop='sudo /opt/local/apache2/bin/apachectl -k stop'
alias cdd='cd -'
alias ..='cd ..'
alias ...='cd ../../../'
alias ....='cd ../../../../'
alias .....='cd ../../../../'
alias .4='cd ../../../../'
alias .5='cd ../../../../..'
alias vim="/usr/local/bin/mvim -v"
alias vi="/usr/local/bin/mvim -v"
export SERVER='aarduain.com'
export SERVERDIR='/web/aarduain.com'
export SANDBOX=$SERVERDIR
export DBSERVER='localhost'
export EDITOR='vim'
alias SB='source ~/.zshrc'
alias lt='ls -altr'
alias pj='phantomjs --webdriver=4444 --ignore-ssl-errors=true --ssl-protocol=any'
alias selenium='java -jar /usr/local/lib/node_modules/selenium-server-standalone/index.jar'
alias cd='cd -P'
alias ag='ag --path-to-agignore ~/.agignore'
set -o vi

# MacPorts Installer addition on 2015-05-04_at_15:34:11: adding an appropriate PATH variable for use with MacPorts.
export PATH="/opt/local/bin:/opt/local/sbin:$PATH"
export PATH="/opt/local/lib/percona/bin:$PATH"
export PATH="/opt/local/lib/php/pear/bin:$PATH"
export PATH="/Users/aarduain:$PATH"
export PATH="/Users/aarduain/bin/scripts:$PATH"
export PATH="/Users/aarduain/bin:$PATH"
export PATH="/Users/aarduain/.vimpkg/bin:$PATH"
export PATH="/Users/aarduain/Jmeter/bin:$PATH"
export PATH="/Users/aarduain/bin/chromedriver:$PATH"
# Finished adapting your PATH environment variable for use with MacPorts.

#run bashrc on startup
#if [ -a ~/.zshrc ]; then
#source ~/.zshrc
#fi
# Look for keys and add them to a list
# If we found some keys, then load them up.
keychain --nogui $HOME/.ssh/id_rsa

function startSelenium() {
	if [ -z $(pgrep -f selenium) ]; then
		echo "Starting Selenium Standalone Server With ChromeDriver: "
		nohup java -jar /usr/local/lib/node_modules/selenium-server-standalone/index.jar -Dwebdriver.chrome.driver=/Users/aarduain/bin/chromedriver >> /var/log/selenium-server.log &
	else
		echo "Selenium Standalone Server already running: "`pgrep -f selenium`
	fi
}

function startPhantomJs() {
	if [ -z $(pgrep phantom) ]; then
		echo "Starting PhantomJS: "
		nohup phantomjs --webdriver=4444 --ignore-ssl-errors --ssl-protocol=any  > /Users/aarduain/phantomjs.log &
	else
		echo "PhantomJS already running: "`pgrep phantomjs`
	fi
}

function mysqlConn()  {
	if [ -z "$1" ]; then
		echo "Provide a group suffix to connect! (live, stage, sb, local)"
	else
		mycli --defaults-group-suffix=$1
	fi
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

function tomcatControl() {
	local tomcatVer="7.0.54"
	local tomcatDir="/Users/aarduain/tomcat/apache-tomcat-$tomcatVer"
	local currentDb=$(readlink $tomcatDir/conf/server.xml | cut -d'-' -f1)
	local currentCon=$(readlink $tomcatDir/conf/context.xml)
	local currentServ=$(readlink $tomcatDir/conf/server.xml)
	if [ "$1" = "start" ]; then
		if [ -z "$2" -o "$2" = "$currentDb" ]; then
			if [[ -z $(ps aux | grep '[a]pache-tomcat') ]]; then
				echo "Starting tomcat with $currentDb database"
				$tomcatDir/bin/startup.sh
			else
				echo "Tomcat already running with $currentDb database"
			fi
		elif [ -e "$tomcatDir/conf/$2-context.xml" -a -e "$tomcatDir/conf/$2-server.xml" ]; then
			if [ "$currentCon" != "$tomcatDir/conf/$2-context.xml" ]; then
				echo "Changing context.xml link from $currentCon to $2-context.xml"
				cd $tomcatDir/conf
				ln -sf $2-context.xml context.xml
				cd -
			fi
			if [ "$currentServ" != "$tomcatDir/conf/$2-server.xml" ]; then
				echo "Changing server.xml link from $currentServ to $2-server.xml"
				cd $tomcatDir/conf
				ln -sf $2-server.xml server.xml
				cd -
			fi
			echo "Starting tomcat with $2 database"
			$tomcatDir/bin/startup.sh
		else
			echo "Error: There are no configuration files for database $2. Make sure it is a valid database and then try running 'tomcatControl create $2'."
		fi
	elif [ "$1" = "stop" ]; then
		if [[ -z $(ps aux | grep -o '[a]pache-tomcat') ]]; then
			echo "Tomcat is not running"
		else
			echo "Stopping Tomcat running with $currentDb database"
			$tomcatDir/bin/shutdown.sh
		fi
	elif [ "$1" = "restart" ]; then
		if [[ -z $(ps aux | grep '[a]pache-tomcat') ]]; then
			echo "Tomcat is not running"
		else
			echo "Stopping Tomcat running with $currentDb database"
			$tomcatDir/bin/shutdown.sh
		fi
		if [ -z "$2" -o "$2" = "$currentDb" ]; then
			echo "Restarting tomcat with $currentDb database"
			$tomcatDir/bin/startup.sh
		elif [ -e "$tomcatDir/conf/$2-context.xml" -a -e "$tomcatDir/conf/$2-server.xml" ]; then
			if [ "$currentCon" != "$tomcatDir/conf/$2-context.xml" ]; then
				echo "Changing context.xml link from $currentCon to $2-context.xml"
				cd $tomcatDir/conf
				ln -sf $2-context.xml context.xml
				cd -
			fi
			if [ "$currentServ" != "$tomcatDir/conf/$2-server.xml" ]; then
				echo "Changing server.xml link from $currentServ to $2-server.xml"
				cd $tomcatDir/conf
				ln -sf $2-server.xml server.xml
				cd -
			fi
			echo "Restarting tomcat with $2 database"
			$tomcatDir/bin/startup.sh
		else
			echo "Error: There are no configuration files for database $2. Make sure it is a valid database and then try running 'tomcatControl create $2'."
		fi
	elif [ "$1" = "create" ]; then
		if [ -z "$2" ]; then
			echo "Error: 'tomcatControl create' requires the name of a database to create configuration files for."
		elif [ -e "$tomcatDir/conf/$2-context.xml" -o -e "$tomcatDir/conf/$2-server.xml" ]; then
			echo "Error: Configuration files for $2 database already exists. Try running 'tomcatControl start $2'."
		else
			echo "Creating configuration files for $2 database"
			cp $tomcatDir/conf/context.xml $tomcatDir/conf/$2-context.xml
			cp $tomcatDir/conf/server.xml $tomcatDir/conf/$2-server.xml
			/opt/local/bin/gsed -i -r -e "s/$currentDb/$2/g" $tomcatDir/conf/$2-context.xml
			/opt/local/bin/gsed -i -r -e "s/$currentDb/$2/g" $tomcatDir/conf/$2-server.xml
		fi
	else
		echo "Error: Illegal option. 'tomcatControl action [database]'. Available options are 'start, stop, restart, create'."
	fi
}

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion. Case
# sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git vi-mode gitfast)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
# export SSH_KEY_PATH="~/.ssh/rsa_id"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
PATH=/opt/local/bin:$PATH
