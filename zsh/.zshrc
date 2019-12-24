#!/usr/bin/env zsh
# initial setup file for only interective zsh
# This file is read after .zprofile file is read.

() {
    for config_file ($ZDOTDIR/*.zsh) source $config_file
}

# Initialize colors.
# Could use `$fg[red]' to get the code for foreground color red.
autoload -Uz colors
colors

# hook
#  http://d.hatena.ne.jp/kiririmode/20120327/p1
autoload -Uz add-zsh-hook

# Make cd push the old directory onto the directory stack.
setopt auto_pushd

# Exchanges the meanings of ‘+’ and ‘-’ when used with a number to specify a directory in the stack.
setopt pushd_minus

# Don’t push multiple copies of the same directory onto the directory stack.
setopt pushd_ignore_dups

# Have pushd with no arguments act like ‘pushd $HOME’.
setopt pushd_to_home

# Try to correct the spelling of commands. Note that, when the HASH_LIST_ALL option is not set or
# when some directories in the path are not readable, this may falsely report spelling errors the first time some commands are used.
setopt correct

# Try to correct the spelling of all arguments in a line.
# The shell variable CORRECT_IGNORE_FILE may be set to a pattern to match file names that will never be offered as corrections.
setopt correct_all

# no_clobber is an option that we can use to disallow an operation to overwriting any existing files.
setopt no_clobber

# Expand expressions in braces which would not otherwise undergo brace expansion to a lexically ordered list of all the characters.
setopt brace_ccl

# Print eight bit characters literally in completion lists, etc.
# This option is not necessary if your system correctly returns the printability of eight bit characters (see man page ctype(3)).
# setopt print_eight_bit

# If the argument to a cd command (or an implied cd with the AUTO_CD option set)
# is not a directory, and does not begin with a slash, try to expand the expression as if it were preceded by a ‘~’
# setopt cdable_vars

# Any parameter that is set to the absolute name of a directory immediately becomes a name for that directory,
# that will be used by the ‘%~’ and related prompt sequences, and will be available when completion is performed
# on a word starting with ‘~’. (Otherwise, the parameter must be used in the form ‘~param’ first.)
# setopt auto_name_dirs

# Causes field splitting to be performed on unquoted parameter expansions. Note that this option has nothing to do with word splitting.
setopt sh_word_split

# Allow the character sequence ‘’’’ to signify a single quote within singly quoted strings.
# Note this does not apply in quoted strings using the format $’...’, where a backslashed single quote can be used.
setopt rc_quotes

# Perform implicit tees or cats when multiple redirections are attempted
setopt multios

# When the last character resulting from a completion is a slash and the next character typed is a word delimiter,
# a slash, or a character that ends a command (such as a semicolon or an ampersand), remove the slash.
setopt auto_remove_slash

# beep
setopt no_beep
setopt no_list_beep
setopt no_hist_beep

# Perform = filename expansion.
setopt equals

# Perform a path search even on command names with slashes in them. Thus if ‘/usr/local/bin’ is in the user’s path,
# and he or she types ‘X11/xinit’, the command ‘/usr/local/bin/X11/xinit’ will be executed (assuming it exists).
# Commands explicitly beginning with ‘/’, ‘./’ or ‘../’ are not subject to the path search.
# This also applies to the ‘.’ and source builtins. Note that subdirectories of the current directory are always
# searched for executables specified in this form. This takes place before any search indicated by this option,
# and regardless of whether ‘.’ or the current directory appear in the command search path.
setopt path_dirs

# Print the exit value of programs with non-zero exit status. This is only available at the command line in interactive shells.
setopt print_exit_value

# If querying the user before executing ‘rm *’ or ‘rm path/*’, first wait ten seconds and ignore anything typed in that time.
# This avoids the problem of reflexively answering ‘yes’ to the query when one didn’t really mean it.
# The wait and query can always be avoided by expanding the ‘*’ in ZLE (with tab).
setopt rm_star_wait

# Report the status of background jobs immediately, rather than waiting until just before printing a prompt.
setopt notify

# Print job notifications in the long format by default.
setopt long_list_jobs

# Treat single word simple commands without redirection as candidates for resumption of an existing job.
setopt auto_resume

# Do not exit on end-of-file. Require the use of exit or logout instead. However, ten consecutive EOFs will cause the shell to exit anyway,
# to avoid the shell hanging if its tty goes away.Also, if this option is set and the Zsh Line Editor is used, widgets implemented by shell
# functions can be bound to EOF (normally Control-D) without printing the normal warning message.
# This works only for normal widgets, not for completion widgets.
setopt ignore_eof

# Treat the ‘#’, ‘~’ and ‘^’ characters as part of patterns for filename generation, etc.
# (An initial unquoted ‘~’ always produces named directory expansion.)
setopt extended_glob

# Append a trailing ‘/’ to all directory names resulting from filename generation (globbing).
setopt mark_dirs
