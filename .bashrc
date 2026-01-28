# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

# User specific environment
if ! [[ "$PATH" =~ "$HOME/.local/bin:$HOME/bin:" ]]
then
    PATH="$HOME/.local/bin:$HOME/bin:$PATH"
fi
export PATH

# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=

# User specific aliases and functions
if [ -d ~/.bashrc.d ]; then
	for rc in ~/.bashrc.d/*; do
		if [ -f "$rc" ]; then
			. "$rc"
		fi
	done
fi

unset rc

alias nvim="/usr/local/bin/nvim-linux-x86_64.appimage"
# Generate compile_commands.json for CMake projects
alias cmakecc='mkdir -p build && cd build && cmake -DCMAKE_EXPORT_COMPILE_COMMANDS=ON .. && ln -sf ../build/compile_commands.json .. && cd ..'
. "$HOME/.cargo/env"


# Enhanced .bashrc for C++ Development
# Add this to your existing ~/.bashrc file

# Colors for prompt
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
NC='\033[0m' # No Color

# Function to get git branch and status
git_prompt() {
    local git_status=""
    local git_branch=""
    
    # Check if we're in a git repository
    if git rev-parse --git-dir > /dev/null 2>&1; then
        # Get the current branch
        git_branch=$(git branch 2>/dev/null | grep '^*' | cut -d' ' -f2-)
        
        # Get git status
        local git_dirty=""
        local git_staged=""
        local git_untracked=""
        
        # Check for staged changes
        if ! git diff --cached --quiet 2>/dev/null; then
            git_staged="+"
        fi
        
        # Check for unstaged changes
        if ! git diff --quiet 2>/dev/null; then
            git_dirty="*"
        fi
        
        # Check for untracked files
        if [ -n "$(git ls-files --others --exclude-standard 2>/dev/null)" ]; then
            git_untracked="?"
        fi
        
        # Combine status indicators
        local status_indicators="${git_staged}${git_dirty}${git_untracked}"
        
        # Choose color based on status
        if [ -n "$status_indicators" ]; then
            git_status=" ${RED}(${git_branch}${status_indicators})${NC}"
        else
            git_status=" ${GREEN}(${git_branch})${NC}"
        fi
    fi
    
    echo -e "$git_status"
}

# Function to shorten path (show only last 2 directories)
short_pwd() {
    local pwd_length=40
    local pwd_path="$PWD"
    
    # Replace home directory with ~
    pwd_path="${pwd_path/#$HOME/\~}"
    
    # If path is longer than pwd_length, truncate it
    if [ ${#pwd_path} -gt $pwd_length ]; then
        echo "...${pwd_path: -$pwd_length}"
    else
        echo "$pwd_path"
    fi
}

# Custom prompt
PS1='\[\033[1;34m\]\u@\h\[\033[0m\]:\[\033[1;36m\]$(short_pwd)\[\033[0m\]$(git_prompt)\n\[\033[1;32m\]$ \[\033[0m\]'

# Useful aliases for C++ development
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

# Git aliases
alias gs='git status'
alias ga='git add'
alias gc='git commit'
alias gp='git push'
alias gl='git log --oneline'
alias gd='git diff'
alias gb='git branch'
alias gco='git checkout'

# C++ development aliases
alias cppcompile='g++ -std=c++20 -Wall -Wextra -O2'
alias cppcompile-debug='g++ -std=c++20 -Wall -Wextra -g -O0'
alias cpprun='g++ -std=c++20 -Wall -Wextra -O2 -o temp && ./temp'

# Make output
alias make-parallel='make -j$(nproc)'

# Directory navigation
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

# Container based nvim mounting 
alias mountNvim="python3.12 /storage/kyle.meyer/neovim_for_container_stuff/neovim-lsp/src/setup_container.py"
alias setup-host-tools="python3.12 /storage/kyle.meyer/neovim_for_container_stuff/neovim-lsp/src/setup_host_tools.py --force"
alias verify-host-tools="python3.12 /storage/kyle.meyer/neovim_for_container_stuff/setup_host_tools.py --verify-only"

# History settings
HISTCONTROL=ignoreboth
HISTSIZE=1000
HISTFILESIZE=2000

# Append to history file, don't overwrite it
shopt -s histappend

# Check window size after each command
shopt -s checkwinsize

# Enable programmable completion features
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

# Function to create a new C++ file with basic template
cpp-new() {
    if [ $# -eq 0 ]; then
        echo "Usage: cpp-new <filename>"
        return 1
    fi
    
    cat > "$1.cpp" << 'EOF'
#include <iostream>

int main() {
    std::cout << "Hello, World!" << std::endl;
    return 0;
}
EOF
    echo "Created $1.cpp"
}

# Function to compile and run C++ file quickly
cpp-quick() {
    if [ $# -eq 0 ]; then
        echo "Usage: cpp-quick <filename.cpp>"
        return 1
    fi
    
    echo "Compiling $1..."
    if g++ -std=c++20 -Wall -Wextra -O2 -o "${1%.*}" "$1"; then
        echo "Running ${1%.*}..."
        "./${1%.*}"
    else
        echo "Compilation failed!"
    fi
}

# Show git status on cd (if in a git repository)
cd() {
    builtin cd "$@"
    if git rev-parse --git-dir > /dev/null 2>&1; then
        echo -e "\n${CYAN}Git Status:${NC}"
        git status -s
    fi
}

# Welcome message
echo -e "${GREEN}Enhanced terminal loaded!${NC}"
echo -e "${YELLOW}C++ development aliases available:${NC}"
echo -e "  cpp-new <name>     - Create new C++ file"
echo -e "  cpp-quick <file>   - Compile and run C++ file"
echo -e "  cppcompile         - Compile with C++20 standard"
echo -e "  gs, ga, gc, gp     - Git shortcuts"
export LD_LIBRARY_PATH=/usr/local/lib:$LD_LIBRARY_PATH
