#!/bin/bash
#
#Linux Bai write proxy tool
#
APT_CONF="/etc/apt/apt.conf"
WGETRC="/home/`whoami`/.wgetrc"
BASHRC="/home/`whoami`/.bashrc"
GITWRAP="/home/`whoami`/.git/gitwrap.sh"
PASSWORD=
PROXY_PORT=8080
USERNAME=

file_backup() {

  if [ $# -ne 2 ]; then
    echo "target file and mode not given."
    echo "aborted."
    return 1
  fi

  if [ "$2" = "cp" ]; then
    if [ -f "$1" ]; then
      cp -f "$1" "$1.bak"
    else
      echo "$1 not found."
      echo "aborted."
      return 1
    fi
  elif [ "$2" = "mv" ]; then
    if [ -f "$1" ]; then
        if [  "$1" = $APT_CONF ]; then
           sudo  mv -f "$1" "$1.bak"
        else
            mv -f "$1" "$1.bak"
        fi
    fi
  else
    echo "mode $2 not defined."
    echo "aborted."
    return 1
  fi
}


edit_aptconf() {

  file_backup "$APT_CONF" "mv"

  if [ ${#USERNAME} = 0 ] ; then
        echo "Acquire::ftp::proxy \"ftp://${PROXY_SERVER}:${PROXY_PORT}/\";" | sudo tee $APT_CONF 1>/dev/null
        echo "Acquire::http::proxy \"http://${PROXY_SERVER}:${PROXY_PORT}/\";" | sudo tee -a $APT_CONF 1>/dev/null
        echo "Acquire::https::proxy \"https://${PROXY_SERVER}:${PROXY_PORT}/\";" | sudo tee -a $APT_CONF 1>/dev/null
  else
        echo "Acquire::ftp::proxy \"ftp://${USERNAME}:${PASSWORD}@${PROXY_SERVER}:${PROXY_PORT}/\";" | sudo tee $APT_CONF 1>/dev/null
        echo "Acquire::http::proxy \"http://${USERNAME}:${PASSWORD}@${PROXY_SERVER}:${PROXY_PORT}/\";" | sudo tee -a $APT_CONF 1>/dev/null
        echo "Acquire::https::proxy \"https://${USERNAME}:${PASSWORD}@${PROXY_SERVER}:${PROXY_PORT}/\";" | sudo tee -a $APT_CONF 1>/dev/null
  fi

  sudo chmod 644 $APT_CONF
  echo "$APT_CONF edited."
}


edit_wgetrc() {

  file_backup "$WGETRC" "mv"

  if [ ${#USERNAME} = 0 ] ; then
        echo "use_proxy = on" > $WGETRC
        echo "http_proxy = http://${PROXY_SERVER}:${PROXY_PORT}" >> $WGETRC
        echo "https_proxy = https://${PROXY_SERVER}:${PROXY_PORT}" >> $WGETRC
        echo "ftp_proxy = ftp://${PROXY_SERVER}:${PROXY_PORT}" >> $WGETRC
  else
        echo "use_proxy = on" > $WGETRC
        echo "proxy_user = ${USERNAME}" >> $WGETRC
        echo "proxy_passwd = ${PASSWORD}" >> $WGETRC
        echo "http_proxy = http://${PROXY_SERVER}:${PROXY_PORT}" >> $WGETRC
        echo "https_proxy = https://${PROXY_SERVER}:${PROXY_PORT}" >> $WGETRC
        echo "ftp_proxy = ftp://${PROXY_SERVER}:${PROXY_PORT}" >> $WGETRC
  fi

  chmod 644 $WGETRC
  chown `whoami` $WGETRC
  echo "`whoami`: $WGETRC edited."
}


edit_bashrc() {

  file_backup "$BASHRC" "cp"

  sed -i "/export ftp_proxy=/d" $BASHRC
  sed -i "/export http_proxy=/d" $BASHRC
  sed -i "/export https_proxy=/d" $BASHRC
  sed -i "/grepf/d" $BASHRC
  sed -i "/dw\=/d" $BASHRC

  if [ ${#USERNAME} = 0 ] ; then
        echo "export ftp_proxy=\"ftp://${PROXY_SERVER}:${PROXY_PORT}/\"" >> $BASHRC
        echo "export http_proxy=\"http://${PROXY_SERVER}:${PROXY_PORT}/\"" >> $BASHRC
        echo "export https_proxy=\"https://${PROXY_SERVER}:${PROXY_PORT}/\"" >> $BASHRC
  else
        echo "export ftp_proxy=\"ftp://${USERNAME}:${PASSWORD}@${PROXY_SERVER}:${PROXY_PORT}/\"" >> $BASHRC
        echo "export http_proxy=\"http://${USERNAME}:${PASSWORD}@${PROXY_SERVER}:${PROXY_PORT}/\"" >> $BASHRC
        echo "export https_proxy=\"https://${USERNAME}:${PASSWORD}@${PROXY_SERVER}:${PROXY_PORT}/\"" >> $BASHRC
  fi
  echo -e "alias grepf=\"find -type f ! -path './.svn/*' ! -path './.git/*' ! -path './.repo/*' | xargs grep -n --color\"" >> $BASHRC
  echo "alias dw='curl_dw'" >> $BASHRC
  sudo cp ../ubuntu/curl_dw /usr/bin

  chmod 644 $BASHRC
  chown `whoami` $WGETRC
  echo "$BASHRC edite"
}


edit_gitwrap() {

  #file_backup "$GITWRAP" "mv"

  #echo "#!/bin/sh" > $GITWRAP
  #echo "# Configuration." >> $GITWRAP
  #echo "" >> $GITWRAP
  #echo "_proxy=${PROXY_SERVER}" >> $GITWRAP
  #echo "_proxyport=8080" >> $GITWRAP
  #echo "_proxyauth=${USERNAME}:${PASSWORD}" >> $GITWRAP
  #echo "" >> $GITWRAP
  #echo "exec socat STDIO SOCKS4:\$_proxy:\$1:\$2,socksport=\$_proxyport,proxyauth=\$_proxyauth" >> $GITWRAP

  #chmod 755 $GITWRAP
  #chown `whoami` $WGETRC
  #echo "$GITWRAP edited."
  echo ${USERNAME}
  if [ ! ${#USERNAME} = 0 ] ; then
        git config --global https.proxy "https://${USERNAME}:${PASSWORD}@${PROXY_SERVER}:${PROXY_PORT}/"
        git config --global http.proxy "http://${USERNAME}:${PASSWORD}@${PROXY_SERVER}:${PROXY_PORT}/"
  else
        git config --global https.proxy "https://${PROXY_SERVER}:${PROXY_PORT}/"
        git config --global http.proxy "http://${PROXY_SERVER}:${PROXY_PORT}/"
  fi
}


get_input() {

  read -p " Put your proxy server name. (ex. proxy.xxxxx.com): " PROXY_SERVER
  read -p " username: " USERNAME
  read -p " password: " PASSWORD

  if [ ${#PROXY_SERVER} = 0 ] ; then
    echo "proxy is{$PROXY_SERVER},please entry your proxy"
#   return 1
  fi

  if [ ${#USERNAME} = 0 ] || [ ${#PASSWORD} = 0 ] ; then
    echo ""
    echo "username or password empty."
#   return 1
  fi

  export PROXY_SERVER
  export USERNAME
  export PASSWORD

  echo ""
  echo "proxy server = ${PROXY_SERVER}:${PROXY_PORT}"
  echo "username = ${USERNAME}"
  echo "password = ${PASSWORD}"
  echo "Configuration will begin next, please wait... ..."
}


main(){

  if [ "`whoami`" != "root" ]; then
    echo "need root privilege to edit $APT_CONF"
  fi

  get_input
  if [ $? -ne 0 ]; then
    echo "aborted."
    return 1
  fi

  edit_wgetrc
  #edit_gitwrap
  edit_aptconf
  edit_bashrc

  echo ""
  echo "Done. Do not forget \"source ~/.bashrc\" to apply the changes ！！！"
}

main
