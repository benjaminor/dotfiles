if test -e ~/anaconda3/etc/fish/conf.d/conda.fish
	source ~/anaconda3/etc/fish/conf.d/conda.fish
end

if functions -q bass
	bass source ~/.profile
	bass source ~/.commonrc
	bass source /etc/profile
end

set -g theme_show_exit_status yes
