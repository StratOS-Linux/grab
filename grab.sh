#! /bin/sh

# OUTDATED #
#-- grab --#
# A fetch tool written in shell
# Meant for use in StratOS (An Arch-based distro made by Linux hobbyists)
# Dependencies:
#   - none :)

IFS=''
shopt -s expand_aliases
alias echo="echo -e"
echo

# Number from base16 colors
color_line=5
color_text=11
color_title=4
color_ascii=3

# specs_right() {
# 	box_title_left WM		"bspwm             "
# 	box_title_left TERM		"Alacritty         "
# 	box_title_left FONT		"Iosevka           "
# 	box_title_left THM		"Gruvbox           "
# 	box_title_left SHL		"oh-my-zsh         "
# 	box_title_left PKGS		"859 (pacman)      "
# 	box_title_left UPT		"1d 13h 57m        "
# }
# specs_left() {
# 	box_title_right OS		"        Arch Linux"
# 	box_title_right HOST	"   Swift SFX14-41G"
# 	box_title_right KRNL	"             6.5.7"
# 	box_title_right CPU		"     Ryzen 5 5600X"
# 	box_title_right "GPU 0" "   NVIDIA RTX 3050"
# 	box_title_right "GPU 1" " AMD Radeon Vega 7"
# 	box_title_right RAM		"5888MiB / 15341MiB"
# }

specs_right() {
	box_title_left WM "bspwm "
	box_title_left TERM Alacritty
	box_title_left FONT "Iosevka "
	box_title_left THM Gruvbox
	box_title_left SHL oh-my-zsh
	box_title_left PKGS "859 (pacman)"
	box_title_left UPT "1d 13h 57m"
}
specs_left() {
	box_title_right OS		"Arch Linux"
	box_title_right HOST	"Swift SFX14-41G"
	box_title_right KRNL	"   6.5.7"
	box_title_right CPU		'Ryzen 5 5600X'
	box_title_right "GPU 0" "NVIDIA RTX 3050"
	box_title_right "GPU 1" "AMD Radeon Vega 7"
	box_title_right RAM		"5888MiB / 15341MiB"
}

ascii="              &BGBB#&   #B#&
               &#GPGGB#  BGG#
                  #GGGGB#BGGG#
                   #GGGGGGGGGG&
                    &BGGGGGGGGGGBBB###BB&
                      BGPPGG5J7!!7Y5PPPY7YB&
                     #G?~557^:....:^^~?PP5GG&
                   &B5!:^!^::......~?JYBBBGGG#
                  #G5~:::::......:5&@@@@@@@&##&
                 BGP!:::::......!B
                #GG?:::::.....:J&
               &GGP~::::.....!G
               BGG5^::::...~5
              #GGG5^:::...!#
             #GGGGP~:::...P
         &&#BGGGGGG7:::..^#
     &&#BGY?!~~!7J5J:::..~&
   &######BGPPP555PPJ^::.!&
                     #5!::~JG&
                       &GJ7JY55#
                            &&"

#############
## Theming ##
#############
color() {
	echo `tput setaf $1`$2`tput sgr0`
}

# Apply color to ascii art:
res=""
while read a; do
	res+="`color $color_ascii $a`
"
done<<<"$ascii"
ascii=$res
#
# Box characters
lh=`color $color_line ─`	# horizontal line
lv=`color $color_line │`	# vertical line
ctl=`color $color_line ╭`	# corner top left
ctr=`color $color_line ╮`	# corner top right
cbl=`color $color_line ╰`	# corner bottom left
cbr=`color $color_line ╯`	# corner bottom right
ts=`color $color_line `	# title start
te=`color $color_line `

#############
## Helpers ##
#############
pl() {
	extra_spaces=$[$2 - ${#1}]
	echo $extra_spaces
	echo "$1`multi_char ' ' $extra_spaces`"
}
pr() {
	extra_spaces=$[$2 - ${#1}]
	echo $extra_spaces
	echo "`multi_char ' ' $extra_spaces`$1"
}

# Outputs char n times
# (char, n)
multi_char() {
	for (( i=1; i <= $2; ++i ))
	do
		printf $1
	done
}

# Counts the characters in the longest line after stripping all \e (color) flags
# (text)
count_chars() {
	echo $1 | sed "s/$(echo -e "\e")[^m]*m//g" | wc -L
}

pad_left() {
	res=""
	max_width=`count_chars $1`
	while read -r l1; do
		extra_spaces=$[max_width - `count_chars $l1`]
		res+="`multi_char ' ' $extra_spaces`$l1\n"
	done <<<"$1"
	echo "$res"
}
pad_right() {
	res=""
	max_width=`count_chars $1`
	while read -r l1; do
		extra_spaces=$[max_width - `count_chars $l1` + $2]
		res+="$l1`multi_char ' ' $extra_spaces`\n"
	done <<<"$1"
	echo "$res"
}

##########
## Main ##
##########
horizontal_print() {
	# Find the text that has more lines
	if [ "`printf "$1" | wc -l`" -gt "`printf "$2" | wc -l`" ]; then
		t1="$1"
		t2="$2"
		reverse=true
	else
		t1="$2"
		t2="$1"
		reverse=false
	fi

	# Add empty lines to the shorter text one
	extra_lines=$[`printf "$t1" | wc -l` - `printf "$t2" | wc -l`]
	max_width=`count_chars $t2`
	t2+="\n`multi_char "$(multi_char ' ' $max_width)\n" $extra_lines`"

	# Take a line from each text and echo them next to each other
	i=1
	while read -r l1; do
		l2="`echo "$t2" | sed "${i}!d"`"
		$reverse && echo "$l1" "$l2" || echo "$l2" "$l1"
		i=$[i+1]
	done <<<"$t1"
}

# Creates a box with title left aligned
# (title, text)
box_title_left() {
	title=`color $color_title $1`
	shift
	content=`color $color_text $@`
	c="$lv $content $lv"
	l=$[`count_chars $title`+7]
	printf "$ctl$lh$ts $title $te"
	printf "`multi_char ${lh} $[$(count_chars $c)-l]`$ctr\n"
	printf "$lv $content $lv\n"
	printf "$cbl`multi_char ${lh} $[$(count_chars $c)-2]`$cbr\n"
}

# Creates a box with title right aligned
# (title, text)
box_title_right() {
	title=`color $color_title $1`
	shift
	content=`color $color_text $@`
	c="$lv $content $lv"
	l=$[`count_chars $title`+7]
	printf $ctl`multi_char ${lh} $[$(count_chars $c)-l]`
	printf "$ts $title $te$lh$ctr\n"
	printf "$lv $content $lv\n"
	printf "$cbl`multi_char ${lh} $[$(count_chars $c)-2]`$cbr\n"
}

#########
## Run ##
#########
l="`specs_left`"
r="`specs_right`"
z="$(horizontal_print "`pad_right "$ascii" 3`" "$r")"
horizontal_print "`pad_left "$l"`" "$z"
# horizontal_print "`specs_left`" "`specs_left`"
