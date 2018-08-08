#！/bin/bash

PROGNAME=$(basename $0)

TITLE="System Information Report For $HOSTNAME"
CURRENT_TIME=$(date + "%x %r %Z")
TIME_STAMP="Generated $CURRENT_TIME, by $USER"

report_uptime () {
  cat <<- _EOF_
          <H2>System Uptime</H2>
          <PRE>$(uptime)</PRE>
          _EOF_
      return
}

report_disk_space () {
  cat <<- _EOF_
          <H2>Disk Space Utilization</H2>
          <PRE>$(df -h)</PRE>
          _EOF_
      return
}

report_home_space () {
  if [[ $(id -u) -eq 0 ]]; then
    cat <<- _EOF_
          <H2>Home Space Utitization (All Users)</H2>
          <PRE>$(du -sh /home/*)</PRE>
          _EOF_
  else
    cat <<- _EOF_
            <H2>Home Space Utitization ($USER)</H2>
            <PRE>$(du -sh $HOME)</PRE>
            _EOF_
  fi
  return        
}

usage() {
  echo "$PROGNAME: usage: $PROGNAME [-f file | -i]"
  return
}

write_html_page () {
  cat <<- _EOF_
  <HTML>
    <head>
      <title>$TITLE</title>
    </head>
    <body>
      <h1>$TITLE</h1>
      <p>$TIME_STAMP</p>
      $(report_uptime)
      $(report_disk_space)
      $(report_home_space)
    </body>
  </HTML>
}

interactive=
filename=

# process command line options

while [[ -n $1 ]]; do
  case $1 in
    -f | --file)  shift
                  filename=$1
                  ;;
    -i | --interactive) interactive=1
                        ;;
    -h | --help) usage
                 exit
                 ;;
    *) usage >&2
       exit 1
       ;;
  esac
  shift
done

# interactive mode

if [[ -n $interactive ]]; then
  while true; do
    read -p "Enter name of output file: " filename
    if [[ -e $filename ]]; then
      read -p "'$filename' exists. Overwrite?[y/n/q] > "
      case $REPLY in
        Y|y) break
             ;;
        Q|q) echo "Program terminated"
             exit
             ;;
        *)   continue
             ;;
      esac
    fi
  done
fi

# output html page

if [[ -n $filename ]]; then
  if touch $filename && [[ -f $filename ]]; then
    write_html_page > $filename
  else
    echo "$PROGNAME: Cannot write file 'filename'" >&2
    exit 1
  fi
else
  write_html_page
fi
