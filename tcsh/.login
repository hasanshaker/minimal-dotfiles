#!/usr/bin/env tcsh
# Query terminal size; useful for serial lines.
if ( -x /usr/bin/resizewin ) /usr/bin/resizewin -z

# Display a random cookie on each login.
if ( -x /usr/bin/fortune ) /usr/bin/fortune freebsd-tips
