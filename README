# LuaSQLite3

LuaSQLite3 provides a means to manipulate SQLite3 
databases directly from lua using Lua 5.

There are two modules, identical except that one links
SQLite3 dynamically, the other statically.

The module lsqlite3 links SQLite3 dynamically.
To use this module you need the SQLite3 library.
You can get it from http://www.sqlite.org/

The module lsqlite3complete links SQLite3 statically.
The SQLite3 amalgamation source code is included in 
the LuaSQLite3 distribution.

Lua 5 is available from http://www.lua.org/


## Installation

1. install lua
2. move `lsqlite3.dll` to `/kolibrios/lib/lua`
3. rename(or copy) `/kolibrios/lib/sqlite.dll` to `/kolibrios/lib/libsqlite.dll` 


## Build

```
git clone https://github.com/Egor00f/lua-kolibrios.git
git clone https://github.com/KolibriOS/kolibrios.git
git clone https://github.com/Egor00f/luasqlite3-kolibrios.git

cd luasqlite3-kolibrios
make all
```

## Tests

move repo to kolibrios filesystem and run `test/test.sh`.

Some tests need lunit. move luinit.lua to `/kolibrios/shard/lua`.
