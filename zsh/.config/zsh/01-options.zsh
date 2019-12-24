#!/usr/bin/env zsh
# ~/.config/zsh/01-options.zsh

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

# Try to make the completion list smaller (occupying less lines) by printing the matches in columns with different widths.
setopt list_packed

# When listing files that are possible completions, show the type of each file with a trailing identifying mark.
setopt list_types

# Automatically list choices on an ambiguous completion.
setopt auto_list

# All unquoted arguments of the form ‘anything=expression’ appearing after the command name have filename expansion
# (that is, where expression has a leading ‘~’ or ‘=’) performed on expression as if it were a parameter assignment.
# The argument is not otherwise treated specially; it is passed to the command as a single argument,
# and not used as an actual parameter assignment. For example, in echo foo=~/bar:~/rod, both occurrences of ~ would be replaced.
# Note that this happens anyway with typeset and similar statements.This option respects the setting of the KSH_TYPESET option.
# In other words, if both options are in effect, arguments looking like assignments will not undergo word splitting.
setopt magic_equal_subst

# If a parameter name was completed and a following character (normally a space) automatically inserted, and the next character
# typed is one of those that have to come directly after the name (like ‘}’, ‘:’, etc.), the automatically added character is deleted,
# so that the character typed comes immediately after the parameter name. Completion in a brace expansion is affected similarly:
# the added character is a ‘,’, which will be removed if ‘}’ is typed next.
setopt auto_param_keys

# If a parameter is completed whose content is the name of a directory, then add a trailing slash instead of a space.
setopt auto_param_slash

# Resolve symbolic links to their true values when changing directory. This also has the effect of CHASE_DOTS,
# i.e. a ‘..’ path segment will be treated as referring to the physical parent, even if the preceding path segment is a symbolic link.
setopt chase_links

# Automatically use menu completion after the second consecutive request for completion,
# for example by pressing the tab key repeatedly. This option is overridden by MENU_COMPLETE.
setopt auto_menu

# If unset, the cursor is set to the end of the word if completion is started. Otherwise it stays there and completion is done from both ends.
setopt complete_in_word

# If a completion is performed with the cursor within a word, and a full completion is inserted,
# the cursor is moved to the end of the word. That is, the cursor is moved to the end of the word
# if either a single match is inserted or menu completion is performed.
setopt always_to_end

# If unset, key functions that list completions try to return to the last prompt if given a numeric argument.
# If set these functions try to return to the last prompt if given no numeric argument.
setopt always_last_prompt

# When the current word has a glob pattern, do not insert all the words resulting from the expansion
# but generate matches as for completion and cycle through them like MENU_COMPLETE. The matches are generated as if a ‘*’
# was added to the end of the word, or inserted at the cursor when COMPLETE_IN_WORD is set.
# This actually uses pattern matching, not globbing, so it works not only for files but for any completion,
# such as options, user names, etc.Note that when the pattern matcher is used, matching control
# (for example, case-insensitive or anchored matching) cannot be used.
# This limitation only applies when the current word contains a pattern;
# simply turning on the GLOB_COMPLETE option does not have this effect.
setopt glob_complete
