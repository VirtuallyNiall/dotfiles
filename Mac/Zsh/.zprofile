# -- .NET --
export PATH="$HOME/.dotnet/tools:$PATH"

# -- Homebrew --
eval "$(/opt/homebrew/bin/brew shellenv)"

# -- JetBrains --
export PATH="$HOME/Library/Application Support/JetBrains/Toolbox/scripts:$PATH"

# -- NodeJS --
export PATH="/opt/homebrew/opt/node@22/bin:$PATH"

# -- Orbstack --
source "$HOME/.orbstack/shell/init.zsh" 2>/dev/null || :
