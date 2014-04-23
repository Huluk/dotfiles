source ~/.profile

ERLANG_HOME=/usr/share/erlang
export PATH=$PATH:$ERLANG_HOME/bin
export PATH=$PATH:/opt/local/bin

ff(){
    open -a /Applications/Firefox.app/ "http://$1"
}

lsg(){
    ls -R $1 | grep ":$" | sed -e 's/:$//' -e 's/[^-][^\/]*\//--/g' -e 's/^/ /' -e 's/-/|/'
}

# search

dw(){
    open -a /Applications/Firefox.app/ "http://de.wiktionary.org/?search=$1"
}

ew(){
    open -a /Applications/Firefox.app/ "http://en.wiktionary.org/?search=$1"
}

eow(){
    open -a /Applications/Firefox.app/ "http://eo.wiktionary.org/?search=$1"
}

de(){
    open -a /Applications/Firefox.app/ "http://de.wikipedia.org/?search=$1"
}

en(){
    open -a /Applications/Firefox.app/ "http://en.wikipedia.org/?search=$1"
}

eo(){
    open -a /Applications/Firefox.app/ "http://eo.wikipedia.org/?search=$1"
}

rd(){
    open -a /Applications/Firefox.app/ "http://ruby-doc.org/core/classes/$1.html"
}
rb(){
    open -a /Applications/Firefox.app/ "http://ruby-doc.org/core/classes/$1.html"
}

l(){
    open -a /Applications/Firefox.app/ "http://dict.leo.org/?search=$1"
}

g(){
    open -a /Applications/Firefox.app/ "http://www.google.com/search?q=$1"
}

du(){
    open -a /Applications/Firefox.app/ "http://www.duden.de/suchen/dudenonline/$1"
}

rb(){
    open -a /Applications/Firefox.app/ "
}
