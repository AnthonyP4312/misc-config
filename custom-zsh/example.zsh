# You can put files here to add functionality separated per file, which
# will be ignored by git.
# Files on the custom/ directory will be automatically loaded by the init
# script, in alphabetical order.

# For example: add yourself some shortcuts to projects you often work on.
#
# brainstormr=~/Projects/development/planetargon/brainstormr
# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples



SSH_ENV=$HOME/.ssh/environment

# start the ssh-agent
function start_agent {
    echo "Initializing new SSH agent..."
    # spawn ssh-agent
    /usr/bin/ssh-agent | sed 's/^echo/#echo/' > "${SSH_ENV}"
    echo succeeded
    chmod 600 "${SSH_ENV}"
    . "${SSH_ENV}" > /dev/null
    /usr/bin/ssh-add
}

if [ -f "${SSH_ENV}" ]; then
     . "${SSH_ENV}" > /dev/null
	 ps -ef | grep ${SSH_AGENT_PID} | grep ssh-agent$ > /dev/null || {
	    start_agent;
	}
else
    start_agent;
fi

alias backlight="/sys/class/backlight/intel_backlight/brightness";
# alias discord="/opt/Discord/Discord &"
alias cdp='cd ~/projects/node';
alias pi='ssh kinzo@73.47.72.133 -p 804';
alias startssh=start_agent;
alias newProject='git clone anthonyp4312@bitbucket.org:motivis/typescript-base.git; cd typescript-base';
alias cdc='cd ~/projects/clojurescript/';
alias cdclj='cd ~/projects/clojure/';
alias bamboo='ssh -i "~/bamboo-ssh/MotivisLRS-Cert.pem" ubuntu@ec2-52-90-234-45.compute-1.amazonaws.com'

export PATH="/opt/Discord:/home/anthony/.cabal/bin:/home/anthony/.google-cloud-sdk/bin:/home/anthony/.postman:$PATH"
