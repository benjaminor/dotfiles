if test -e ~/conda3/etc/fish/conf.d/conda.fish
	source ~/conda3/etc/fish/conf.d/conda.fish
end

set shell_config "$HOME/.config/shell"

if functions -q bass
	bass source ~/.profile
	bass source "$shell_config/.commonrc"
	bass source /etc/profile
end

if type -q awk
	set functions_file "$shell_config/functions.sh"
	set personal_functions_file "$HOME/.functions_personal"
	if test -e $functions_file
		for line in (awk '/function .*\(\)/ {print substr($2, 1, length($2)-2)}' $functions_file)
			function $line
				bass source $functions_file ';' $_ $argv
			end
		end
	end
	if test -e $personal_functions_file
		for line in (awk '/function .*\(\)/ {print substr($2, 1, length($2)-2)}' $personal_functions_file)
			function $line
				bass source $personal_functions_file ';' $_ $argv
			end
		end
	end

end

# bob-the-fish customization
set -g theme_show_exit_status yes
set -g theme_color_scheme solarized-light
set -g theme_nerd_fonts yes
set -g theme_display_git_ahead_verbose yes
set -g theme_display_git_dirty_verbose yes
set -g theme_display_git_stashed_verbose yes

# cheat.sh
# cht aready defined in functions.sh
# register completions (on-the-fly, non-cached, because the actual command won't be cached anyway
complete -c cht -xa '(curl -s cheat.sh/:list)'

# direnv support for fish
eval (direnv hook fish)

source "$HOME/.config/broot/launcher/fish/br" > /dev/null 2> /dev/null; or true

# opam configuration
source "$HOME/.opam/opam-init/init.fish" > /dev/null 2> /dev/null; or true
