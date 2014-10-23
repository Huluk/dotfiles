A vim plugin that lets you add colored labels to your markdown todo
lists. Also includes a command for adding weekly tasks to the specified
days.

Usage:

    # Today
    - stuff

    # Tuesday
    
    # Always
    - get up

    # All Tuesdays
    - sports

run command :NewWeek (mapped to <Leader>nw)

    # Today
    - stuff
    - get up

    # Tuesday
    - sports

    # Always
    - get up

    # All Tuesdays
    - sports

New Command: :CountDone

    # Done
    - nearly everything --- 2
    - test --- 1/5

adds another entry

    # Done
    - nearly everything --- 2
    - test --- 1/5
    - count result: 3

Looks like this:

![Todo list](https://dl.dropboxusercontent.com/u/83659/nino.github.io-files/todolist.png)
