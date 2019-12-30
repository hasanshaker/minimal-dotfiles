#!/usr/bin/env zsh
# ~/.config/zsh/03-history.zsh

HISTFILE=${HISTFILE:-${ZDOTDIR:-${HOME}}/.zsh_history}
HISTSIZE=5000
SAVEHIST=10000 # useful for setopt append_history

DIRSTACKSIZE=${DIRSTACKSIZE:-20}
DIRSTACKFILE=${DIRSTACKFILE:-${ZDOTDIR:-${HOME}}/.zdirs}

# Do not enter command lines into the history list if they are duplicates of the previous event.
setopt hist_ignore_dups

# If a new command line being added to the history list duplicates an older one, the older command
# is removed from the list (even if it is not the previous event).
setopt hist_ignore_all_dups
setopt hist_save_nodups

# If the internal history needs to be trimmed to add the current command line, setting this option will
# cause the oldest history event that has a duplicate to be lost before losing a unique event from the list.
# You should be sure to set the value of HISTSIZE to a larger number than SAVEHIST in order to give you some
# room for the duplicated events, otherwise this option will behave just like HIST_IGNORE_ALL_DUPS once the
# history fills up with unique events.
setopt hist_expire_dups_first

# When searching for history entries in the line editor, do not display duplicates of a line previously found,
# even if the duplicates are not contiguous.
setopt hist_find_no_dups

# This option both imports new commands from the history file, and also causes your typed commands to be
# appended to the history file (the latter is like specifying INC_APPEND_HISTORY, which should be turned off
# if this option is in effect). The history lines are also output with timestamps ala EXTENDED_HISTORY
# (which makes it easier to find the spot where we left off reading the file after it gets re-written).
# By default, history movement commands visit the imported lines as well as the local lines,
# but you can toggle this on and off with the set-local-history zle binding. It is also possible to create a zle
# widget that will make some commands ignore imported commands, and some include them.
# If you find that you want more control over when commands get imported, you may wish to turn
# SHARE_HISTORY off, INC_APPEND_HISTORY or INC_APPEND_HISTORY_TIME (see above) on, and then manually
# import commands whenever you need them using ‘fc -RI’.
setopt share_history

# Remove superfluous blanks from each command line being added to the history list.
setopt hist_reduce_blanks

# This option works like APPEND_HISTORY except that new history lines are added to the $HISTFILE incrementally
# (as soon as they are entered), rather than waiting until the shell exits. The file will still be periodically
# re-written to trim it when the number of lines grows 20% beyond the value specified by $SAVEHIST
# (see also the HIST_SAVE_BY_COPY option).
setopt inc_append_history

# Remove the history (fc -l) command from the history list when invoked. Note that the command lingers in the
# internal history until the next command is entered before it vanishes, allowing you to briefly reuse or edit the line.
setopt hist_no_store

# Remove function definitions from the history list. Note that the function lingers in the internal history until the next
# command is entered before it vanishes, allowing you to briefly reuse or edit the definition.
setopt hist_no_functions

# Save each command’s beginning timestamp (in seconds since the epoch) and the duration (in seconds) to the history file.
# The format of this prefixed data is: ‘: <beginning time>:<elapsed seconds>;<command>’.
setopt extended_history

# Remove command lines from the history list when the first character on the line is a space, or when one of the expanded
# aliases contains a leading space. Only normal aliases (not global or suffix aliases) have this behaviour.
# Note that the command lingers in the internal history until the next command is entered before it vanishes,
# allowing you to briefly reuse or edit the line. If you want to make it vanish right away without entering another command,
# type a space and press return.
setopt hist_ignore_space

# If this is set, zsh sessions will append their history list to the history file, rather than replace it.
# Thus, multiple parallel zsh sessions will all have the new entries from their history lists added to the history file,
# in the order that they exit. The file will still be periodically re-written to trim it when the number of lines grows
# 20% beyond the value specified by $SAVEHIST (see also the HIST_SAVE_BY_COPY option).
setopt append_history

# Whenever the user enters a line with history expansion, don’t execute the line directly; instead,
# perform history expansion and reload the line into the editing buffer.
setopt hist_verify

# Perform textual history expansion, csh-style, treating the character ‘!’ specially.
setopt bang_hist
