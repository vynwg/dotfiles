function fish_greeting
    if not test "$once_in_a_lifetime" = "true"
        set -Ux once_in_a_lifetime true
	neofetch
    else
        set -Ux once_in_a_lifetime
    end
end
