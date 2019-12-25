#!/usr/bin/env zsh
# ~/.config/zsh/04-prompt.zsh

autoload -Uz promptinit
promptinit

# Prompt setup for grml:

# set colors for use in prompts (modern zshs allow for the use of %F{red}foo%f
# in prompts to get a red "foo" embedded, but it's good to keep these for
# backwards compatibility).
if is437; then
    BLUE="%F{blue}"
    RED="%F{red}"
    GREEN="%F{green}"
    CYAN="%F{cyan}"
    MAGENTA="%F{magenta}"
    YELLOW="%F{yellow}"
    WHITE="%F{white}"
    NO_COLOR="%f"
elif zrcautoload colors && colors 2>/dev/null ; then
    BLUE="%{${fg[blue]}%}"
    RED="%{${fg_bold[red]}%}"
    GREEN="%{${fg[green]}%}"
    CYAN="%{${fg[cyan]}%}"
    MAGENTA="%{${fg[magenta]}%}"
    YELLOW="%{${fg[yellow]}%}"
    WHITE="%{${fg[white]}%}"
    NO_COLOR="%{${reset_color}%}"
else
    BLUE=$'%{\e[1;34m%}'
    RED=$'%{\e[1;31m%}'
    GREEN=$'%{\e[1;32m%}'
    CYAN=$'%{\e[1;36m%}'
    WHITE=$'%{\e[1;37m%}'
    MAGENTA=$'%{\e[1;35m%}'
    YELLOW=$'%{\e[1;33m%}'
    NO_COLOR=$'%{\e[0m%}'
fi

# First, the easy ones: PS2..4:

# secondary prompt, printed when the shell needs more information to complete a
# command.
PS2='\`%_> '
# selection prompt used within a select loop.
PS3='?# '
# the execution trace prompt (setopt xtrace). default: '+%N:%i>'
PS4='+%N:%i:%_> '

# Some additional features to use with our prompt:
#
#    - battery status
#    - debian_chroot
#    - vcs_info setup and version specific fixes

# display battery status on right side of prompt using 'GRML_DISPLAY_BATTERY=1' in .zshrc.pre

function battery () {
if [[ $GRML_DISPLAY_BATTERY -gt 0 ]] ; then
    if islinux ; then
        batterylinux
    elif isopenbsd ; then
        batteryopenbsd
    elif isfreebsd ; then
        batteryfreebsd
    elif isdarwin ; then
        batterydarwin
    else
        #not yet supported
        GRML_DISPLAY_BATTERY=0
    fi
fi
}

function batterylinux () {
GRML_BATTERY_LEVEL=''
local batteries bat capacity
batteries=( /sys/class/power_supply/BAT*(N) )
if (( $#batteries > 0 )) ; then
    for bat in $batteries ; do
        if [[ -e $bat/capacity ]]; then
            capacity=$(< $bat/capacity)
        else
            typeset -F energy_full=$(< $bat/energy_full)
            typeset -F energy_now=$(< $bat/energy_now)
            typeset -i capacity=$(( 100 * $energy_now / $energy_full))
        fi
        case $(< $bat/status) in
        Charging)
            GRML_BATTERY_LEVEL+=" ^"
            ;;
        Discharging)
            if (( capacity < 20 )) ; then
                GRML_BATTERY_LEVEL+=" !v"
            else
                GRML_BATTERY_LEVEL+=" v"
            fi
            ;;
        *) # Full, Unknown
            GRML_BATTERY_LEVEL+=" ="
            ;;
        esac
        GRML_BATTERY_LEVEL+="${capacity}%%"
    done
fi
}

function batteryopenbsd () {
GRML_BATTERY_LEVEL=''
local bat batfull batwarn batnow num
for num in 0 1 ; do
    bat=$(sysctl -n hw.sensors.acpibat${num} 2>/dev/null)
    if [[ -n $bat ]]; then
        batfull=${"$(sysctl -n hw.sensors.acpibat${num}.amphour0)"%% *}
        batwarn=${"$(sysctl -n hw.sensors.acpibat${num}.amphour1)"%% *}
        batnow=${"$(sysctl -n hw.sensors.acpibat${num}.amphour3)"%% *}
        case "$(sysctl -n hw.sensors.acpibat${num}.raw0)" in
            *" discharging"*)
                if (( batnow < batwarn )) ; then
                    GRML_BATTERY_LEVEL+=" !v"
                else
                    GRML_BATTERY_LEVEL+=" v"
                fi
                ;;
            *" charging"*)
                GRML_BATTERY_LEVEL+=" ^"
                ;;
            *)
                GRML_BATTERY_LEVEL+=" ="
                ;;
        esac
        GRML_BATTERY_LEVEL+="${$(( 100 * batnow / batfull ))%%.*}%%"
    fi
done
}

function batteryfreebsd () {
GRML_BATTERY_LEVEL=''
local num
local -A table
for num in 0 1 ; do
    table=( ${=${${${${${(M)${(f)"$(acpiconf -i $num 2>&1)"}:#(State|Remaining capacity):*}%%( ##|%)}//:[ $'\t']##/@}// /-}//@/ }} )
    if [[ -n $table ]] && [[ $table[State] != "not-present" ]] ; then
        case $table[State] in
            *discharging*)
                if (( $table[Remaining-capacity] < 20 )) ; then
                    GRML_BATTERY_LEVEL+=" !v"
                else
                    GRML_BATTERY_LEVEL+=" v"
                fi
                ;;
            *charging*)
                GRML_BATTERY_LEVEL+=" ^"
                ;;
            *)
                GRML_BATTERY_LEVEL+=" ="
                ;;
        esac
        GRML_BATTERY_LEVEL+="$table[Remaining-capacity]%%"
    fi
done
}

function batterydarwin () {
GRML_BATTERY_LEVEL=''
local -a table
table=( ${$(pmset -g ps)[(w)7,8]%%(\%|);} )
if [[ -n $table[2] ]] ; then
    case $table[2] in
        charging)
            GRML_BATTERY_LEVEL+=" ^"
            ;;
        discharging)
            if (( $table[1] < 20 )) ; then
                GRML_BATTERY_LEVEL+=" !v"
            else
                GRML_BATTERY_LEVEL+=" v"
            fi
            ;;
        *)
            GRML_BATTERY_LEVEL+=" ="
            ;;
    esac
    GRML_BATTERY_LEVEL+="$table[1]%%"
fi
}

# set variable debian_chroot if running in a chroot with /etc/debian_chroot
if [[ -z "$debian_chroot" ]] && [[ -r /etc/debian_chroot ]] ; then
    debian_chroot=$(</etc/debian_chroot)
fi

# gather version control information for inclusion in a prompt

if zrcautoload vcs_info; then
    # `vcs_info' in zsh versions 4.3.10 and below have a broken `_realpath'
    # function, which can cause a lot of trouble with our directory-based
    # profiles. So:
    if [[ ${ZSH_VERSION} == 4.3.<-10> ]] ; then
        function VCS_INFO_realpath () {
            setopt localoptions NO_shwordsplit chaselinks
            ( builtin cd -q $1 2> /dev/null && pwd; )
        }
    fi

    zstyle ':vcs_info:*' max-exports 2

    if [[ -o restricted ]]; then
        zstyle ':vcs_info:*' enable NONE
    fi
fi

typeset -A grml_vcs_coloured_formats
typeset -A grml_vcs_plain_formats

grml_vcs_plain_formats=(
    format "(%s%)-[%b] "    "zsh: %r"
    actionformat "(%s%)-[%b|%a] " "zsh: %r"
    rev-branchformat "%b:%r"
)

grml_vcs_coloured_formats=(
    format "${MAGENTA}(${NO_COLOR}%s${MAGENTA})${YELLOW}-${MAGENTA}[${GREEN}%b${MAGENTA}]${NO_COLOR} "
    actionformat "${MAGENTA}(${NO_COLOR}%s${MAGENTA})${YELLOW}-${MAGENTA}[${GREEN}%b${YELLOW}|${RED}%a${MAGENTA}]${NO_COLOR} "
    rev-branchformat "%b${RED}:${YELLOW}%r"
)

typeset GRML_VCS_COLOUR_MODE=xxx

function grml_vcs_info_toggle_colour () {
    emulate -L zsh
    if [[ $GRML_VCS_COLOUR_MODE == plain ]]; then
        grml_vcs_info_set_formats coloured
    else
        grml_vcs_info_set_formats plain
    fi
    return 0
}

function grml_vcs_info_set_formats () {
    emulate -L zsh
    #setopt localoptions xtrace
    local mode=$1 AF F BF
    if [[ $mode == coloured ]]; then
        AF=${grml_vcs_coloured_formats[actionformat]}
        F=${grml_vcs_coloured_formats[format]}
        BF=${grml_vcs_coloured_formats[rev-branchformat]}
        GRML_VCS_COLOUR_MODE=coloured
    else
        AF=${grml_vcs_plain_formats[actionformat]}
        F=${grml_vcs_plain_formats[format]}
        BF=${grml_vcs_plain_formats[rev-branchformat]}
        GRML_VCS_COLOUR_MODE=plain
    fi

    zstyle ':vcs_info:*'              actionformats "$AF" "zsh: %r"
    zstyle ':vcs_info:*'              formats       "$F"  "zsh: %r"
    zstyle ':vcs_info:(sv[nk]|bzr):*' branchformat  "$BF"
    return 0
}

# Change vcs_info formats for the grml prompt. The 2nd format sets up
# $vcs_info_msg_1_ to contain "zsh: repo-name" used to set our screen title.
if [[ "$TERM" == dumb ]] ; then
    grml_vcs_info_set_formats plain
else
    grml_vcs_info_set_formats coloured
fi

# Now for the fun part: The grml prompt themes in `promptsys' mode of operation

# This actually defines three prompts:
#
#    - grml
#    - grml-large
#    - grml-chroot
#
# They all share the same code and only differ with respect to which items they
# contain. The main source of documentation is the `prompt_grml_help' function
# below, which gets called when the user does this: prompt -h grml

function prompt_grml_help () {
    <<__EOF0__
  prompt grml
    This is the prompt as used by the grml-live system <http://grml.org>. It is
    a rather simple one-line prompt, that by default looks something like this:
        <user>@<host> <current-working-directory>[ <vcs_info-data>]%
    The prompt itself integrates with zsh's prompt themes system (as you are
    witnessing right now) and is configurable to a certain degree. In
    particular, these aspects are customisable:
        - The items used in the prompt (e.g. you can remove \`user' from
          the list of activated items, which will cause the user name to
          be omitted from the prompt string).
        - The attributes used with the items are customisable via strings
          used before and after the actual item.
    The available items are: at, battery, change-root, date, grml-chroot,
    history, host, jobs, newline, path, percent, rc, rc-always, sad-smiley,
    shell-level, time, user, vcs
    The actual configuration is done via zsh's \`zstyle' mechanism. The
    context, that is used while looking up styles is:
        ':prompt:grml:<left-or-right>:<subcontext>'
    Here <left-or-right> is either \`left' or \`right', signifying whether the
    style should affect the left or the right prompt. <subcontext> is either
    \`setup' or 'items:<item>', where \`<item>' is one of the available items.
    The styles:
        - use-rprompt (boolean): If \`true' (the default), print a sad smiley
          in $RPROMPT if the last command a returned non-successful error code.
          (This in only valid if <left-or-right> is "right"; ignored otherwise)
        - items (list): The list of items used in the prompt. If \`vcs' is
          present in the list, the theme's code invokes \`vcs_info'
          accordingly. Default (left): rc change-root user at host path vcs
          percent; Default (right): sad-smiley
        - strip-sensitive-characters (boolean): If the \`prompt_subst' option
          is active in zsh, the shell performs lots of expansions on prompt
          variable strings, including command substitution. So if you don't
          control where some of your prompt strings is coming from, this is
          an exploitable weakness. Grml's zsh setup does not set this option
          and it is off in the shell in zsh-mode by default. If it *is* turned
          on however, this style becomes active, and there are two flavours of
          it: On per default is a global variant in the '*:setup' context. This
          strips characters after the whole prompt string was constructed. There
          is a second variant in the '*:items:<item>', that is off by default.
          It allows fine grained control over which items' data is stripped.
          The characters that are stripped are: \$ and \`.
    Available styles in 'items:<item>' are: pre, post. These are strings that
    are inserted before (pre) and after (post) the item in question. Thus, the
    following would cause the user name to be printed in red instead of the
    default blue:
        zstyle ':prompt:grml:*:items:user' pre '%F{red}'
    Note, that the \`post' style may remain at its default value, because its
    default value is '%f', which turns the foreground text attribute off (which
    is exactly, what is still required with the new \`pre' value).
__EOF0__
}

function prompt_grml-chroot_help () {
    <<__EOF0__
  prompt grml-chroot
    This is a variation of the grml prompt, see: prompt -h grml
    The main difference is the default value of the \`items' style. The rest
    behaves exactly the same. Here are the defaults for \`grml-chroot':
        - left: grml-chroot user at host path percent
        - right: (empty list)
__EOF0__
}

function prompt_grml-large_help () {
    <<__EOF0__
  prompt grml-large
    This is a variation of the grml prompt, see: prompt -h grml
    The main difference is the default value of the \`items' style. In
    particular, this theme uses _two_ lines instead of one with the plain
    \`grml' theme. The rest behaves exactly the same. Here are the defaults
    for \`grml-large':
        - left: rc jobs history shell-level change-root time date newline user
                at host path vcs percent
        - right: sad-smiley
__EOF0__
}

function grml_prompt_setup () {
    emulate -L zsh
    autoload -Uz vcs_info
    # The following autoload is disabled for now, since this setup includes a
    # static version of the ‘add-zsh-hook’ function above. It needs to be
    # re-enabled as soon as that static definition is removed again.
    #autoload -Uz add-zsh-hook
    add-zsh-hook precmd prompt_$1_precmd
}

function prompt_grml_setup () {
    grml_prompt_setup grml
}

function prompt_grml-chroot_setup () {
    grml_prompt_setup grml-chroot
}

function prompt_grml-large_setup () {
    grml_prompt_setup grml-large
}

# These maps define default tokens and pre-/post-decoration for items to be
# used within the themes. All defaults may be customised in a context sensitive
# matter by using zsh's `zstyle' mechanism.
typeset -gA grml_prompt_pre_default \
            grml_prompt_post_default \
            grml_prompt_token_default \
            grml_prompt_token_function

grml_prompt_pre_default=(
    at                ''
    battery           ' '
    change-root       ''
    date              '%F{blue}'
    grml-chroot       '%F{red}'
    history           '%F{green}'
    host              ''
    jobs              '%F{cyan}'
    newline           ''
    path              '%B'
    percent           ''
    rc                '%B%F{red}'
    rc-always         ''
    sad-smiley        ''
    shell-level       '%F{red}'
    time              '%F{blue}'
    user              '%B%F{blue}'
    vcs               ''
)

grml_prompt_post_default=(
    at                ''
    battery           ''
    change-root       ''
    date              '%f'
    grml-chroot       '%f '
    history           '%f'
    host              ''
    jobs              '%f'
    newline           ''
    path              '%b'
    percent           ''
    rc                '%f%b'
    rc-always         ''
    sad-smiley        ''
    shell-level       '%f'
    time              '%f'
    user              '%f%b'
    vcs               ''
)

grml_prompt_token_default=(
    at                '@'
    battery           'GRML_BATTERY_LEVEL'
    change-root       'debian_chroot'
    date              '%D{%Y-%m-%d}'
    grml-chroot       'GRML_CHROOT'
    history           '{history#%!} '
    host              '%m '
    jobs              '[%j running job(s)] '
    newline           $'\n'
    path              '%40<..<%~%<< '
    percent           '%# '
    rc                '%(?..%? )'
    rc-always         '%?'
    sad-smiley        '%(?..:()'
    shell-level       '%(3L.+ .)'
    time              '%D{%H:%M:%S} '
    user              '%n'
    vcs               '0'
)

function grml_theme_has_token () {
    if (( ARGC != 1 )); then
        printf 'usage: grml_theme_has_token <name>\n'
        return 1
    fi
    (( ${+grml_prompt_token_default[$1]} ))
}

function GRML_theme_add_token_usage () {
    <<__EOF0__
  Usage: grml_theme_add_token <name> [-f|-i] <token/function> [<pre> <post>]
    <name> is the name for the newly added token. If the \`-f' or \`-i' options
    are used, <token/function> is the name of the function (see below for
    details). Otherwise it is the literal token string to be used. <pre> and
    <post> are optional.
  Options:
    -f <function>   Use a function named \`<function>' each time the token
                    is to be expanded.
    -i <function>   Use a function named \`<function>' to initialise the
                    value of the token _once_ at runtime.
    The functions are called with one argument: the token's new name. The
    return value is expected in the \$REPLY parameter. The use of these
    options is mutually exclusive.
    There is a utility function \`grml_theme_has_token', which you can use
    to test if a token exists before trying to add it. This can be a guard
    for situations in which a \`grml_theme_add_token' call may happen more
    than once.
  Example:
    To add a new token \`day' that expands to the current weekday in the
    current locale in green foreground colour, use this:
      grml_theme_add_token day '%D{%A}' '%F{green}' '%f'
    Another example would be support for \$VIRTUAL_ENV:
      function virtual_env_prompt () {
        REPLY=\${VIRTUAL_ENV+\${VIRTUAL_ENV:t} }
      }
      grml_theme_add_token virtual-env -f virtual_env_prompt
    After that, you will be able to use a changed \`items' style to
    assemble your prompt.
__EOF0__
}
