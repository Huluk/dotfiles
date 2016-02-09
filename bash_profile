ERLANG_HOME=/usr/share/erlang
export PATH=$PATH:$ERLANG_HOME/bin
export PATH=$PATH:/opt/local/bin

lsg(){
    ls -R $1 | grep ":$" | sed -e 's/:$//' -e 's/[^-][^\/]*\//--/g' -e 's/^/ /' -e 's/-/|/'
}
