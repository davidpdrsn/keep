# Keep

A clone of [Boom](http://zachholman.com/boom/) in Haskell.

## Installing

- Clone repo
- Make sure you have [Stack](https://www.stackage.org) installed
- `stack setup`
- `stack install`

That'll put the executable somewhere (it'll tell you where). Now you can move it to somewhere on your `$PATH`.

## Usage

Make a new list

```
$ keep gifs
Will keep a list of "gifs"
```

Add things to a list

```
$ keep gifs melissa http://cl.ly/3pAn/animated.gif
Will keep "melissa" in "gifs" as "http://cl.ly/3pAn/animated.gif"
```

Get everything in a list

```
$ keep gifs
melissa => http://cl.ly/3pAn/animated.gif
```

Get all lists

```
$ keep
gifs
```

Get help

```
$ keep [--help|-h]
```
