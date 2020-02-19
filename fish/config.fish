if test -e ~/conda3/etc/fish/conf.d/conda.fish
	source ~/conda3/etc/fish/conf.d/conda.fish
end

if functions -q bass
	bass source ~/.profile
	bass source ~/.commonrc
	bass source /etc/profile
end

if type -q awk
	set shell_config "$HOME/.config/shell"
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


set -g theme_show_exit_status yes
set -g theme_color_scheme solarized-light

# cheat.sh
# cht aready defined in functions.sh
# register completions (on-the-fly, non-cached, because the actual command won't be cached anyway
complete -c cht -xa '(curl -s cheat.sh/:list)'

# direnv support for fish
eval (direnv hook fish)

source /home/ben/.config/broot/launcher/fish/br

# opam configuration
source /home/ben/.opam/opam-init/init.fish > /dev/null 2> /dev/null; or true
