alias SB='. ~/.bashrc'
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
alias vim="/Applications/MacVim.app/Contents/MacOS/Vim"
set -o vi

# MacPorts Installer addition on 2015-05-04_at_15:34:11: adding an appropriate PATH variable for use with MacPorts.
export PATH="/opt/local/bin:/opt/local/sbin:$PATH"
export PATH="/opt/local/lib/percona/bin:$PATH"
export PATH="/opt/local/lib/php/pear/bin:$PATH"
export PATH="/Users/aarduain:$PATH"
export PATH="/Users/aarduain/bin/scripts:$PATH"
export PATH="/Users/aarduain/bin:$PATH"
# Finished adapting your PATH environment variable for use with MacPorts.

#run bashrc on startup
if [ -a ~/.bashrc ]; then
	. ~/.bashrc
fi
# Look for keys and add them to a list
unset MY_KEYS
[[ -f $HOME/.ssh/id_dsa ]] && MY_KEYS="$MY_KEYS id_dsa"
[[ -f $HOME/.ssh/id_rsa ]] && MY_KEYS="$MY_KEYS id_rsa"

# If we found some keys, then load them up.
if [ "$MY_KEYS" ] ; then
 if [ -x $(type -P keychain) ] ; then
   keychain --nogui $MY_KEYS
 fi

 [[ -f $HOME/.keychain/$HOSTNAME-sh ]] && \
   source $HOME/.keychain/$HOSTNAME-sh
 [[ -f $HOME/.keychain/$HOSTNAME-sh-gpg ]] && \
   source  $HOME/.keychain/$HOSTNAME-sh-gpg
fi


function startSelenium() {
	if [ -z $(pgrep -f selenium) ]; then
		echo "Starting Selenium Standalone Server: "
		nohup java -jar ~/Downloads/selenium-server-standalone-2.45.0.jar >> /var/log/selenium-server.log &
	else
		echo "Selenium Standalone Server already running: "`pgrep -f selenium`
	fi
}

function startPhantomJs() {
	if [ -z $(pgrep phantom) ]; then
		echo "Starting PhantomJS: "
		nohup ~/bin/phantomjs --webdriver=4444 >> /var/log/phantomjs.log &
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

# Prompt coloring

if [[ $COLORTERM = gnome-* && $TERM = xterm ]] && infocmp gnome-256color >/dev/null 2>&1; then
	export TERM='gnome-256color';
elif infocmp xterm-256color >/dev/null 2>&1; then
	export TERM='xterm-256color';
fi;

prompt_git() {
	local s='';
	local branchName='';

	# Check if the current directory is in a Git repository.
	if [ $(git rev-parse --is-inside-work-tree &>/dev/null; echo "${?}") == '0' ]; then

		# check if the current directory is in .git before running git checks
		if [ "$(git rev-parse --is-inside-git-dir 2> /dev/null)" == 'false' ]; then

			# Ensure the index is up to date.
			git update-index --really-refresh -q &>/dev/null;

			# Check for uncommitted changes in the index.
			if ! $(git diff --quiet --ignore-submodules --cached); then
				s+='+';
			fi;

			# Check for unstaged changes.
			if ! $(git diff-files --quiet --ignore-submodules --); then
				s+='!';
			fi;

			# Check for untracked files.
			if [ -n "$(git ls-files --others --exclude-standard)" ]; then
				s+='?';
			fi;

			# Check for stashed files.
			if $(git rev-parse --verify refs/stash &>/dev/null); then
				s+='$';
			fi;

		fi;

		# Get the short symbolic ref.
		# If HEAD isn’t a symbolic ref, get the short SHA for the latest commit
		# Otherwise, just give up.
		branchName="$(git symbolic-ref --quiet --short HEAD 2> /dev/null || \
			git rev-parse --short HEAD 2> /dev/null || \
			echo '(unknown)')";

		[ -n "${s}" ] && s=" [${s}]";

		echo -e "${1}${branchName}${2}${s}";
	else
		return;
	fi;
}

if tput setaf 1 &> /dev/null; then
	tput sgr0; # reset colors
	bold=$(tput bold);
	reset=$(tput sgr0);
	# Solarized colors, taken from http://git.io/solarized-colors.
	black=$(tput setaf 0);
	blue=$(tput setaf 33);
	cyan=$(tput setaf 37);
	green=$(tput setaf 64);
	orange=$(tput setaf 166);
	purple=$(tput setaf 125);
	red=$(tput setaf 124);
	violet=$(tput setaf 61);
	white=$(tput setaf 15);
	yellow=$(tput setaf 136);
else
	bold='';
	reset="\e[0m";
	black="\e[1;30m";
	blue="\e[1;34m";
	cyan="\e[1;36m";
	green="\e[1;32m";
	orange="\e[1;33m";
	purple="\e[1;35m";
	red="\e[1;31m";
	violet="\e[1;35m";
	white="\e[1;37m";
	yellow="\e[1;33m";
fi;

# Highlight the user name when logged in as root.
if [[ "${USER}" == "root" ]]; then
	userStyle="${red}";
else
	userStyle="${orange}";
fi;

# Highlight the hostname when connected via SSH.
if [[ "${SSH_TTY}" ]]; then
	hostStyle="${bold}${red}";
else
	hostStyle="${yellow}";
fi;

# Set the terminal title to the current working directory.
PS1="\[\033]0;\w\007\]";
PS1+="\[${bold}\]\n"; # newline
PS1+="\[${userStyle}\]\u"; # username
PS1+="\[${white}\] at ";
PS1+="\[${hostStyle}\]\h"; # host
PS1+="\[${white}\] in ";
PS1+="\[${green}\]\w"; # working directory
PS1+="\$(prompt_git \"\[${white}\] on \[${violet}\]\" \"\[${blue}\]\")"; # Git repository details
PS1+="\n";
PS1+="\[${white}\]\$ \[${reset}\]"; # `$` (and reset color)
export PS1;

PS2="\[${yellow}\]→ \[${reset}\]";
export PS2;
export PATH=$PATH:~/.nexustools
