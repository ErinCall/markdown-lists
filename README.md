# Markdown Lists

This Snapplication demonstrates a problem with lists rendered from Markdown into a splice and then into the page.

### To see the problem:

* Make sure you have [cabal](https://www.haskell.org/cabal/download.html) installed.
* Clone this repo
* `cabal install --only-dependencies -fdevelopment`
* `cabal configure -fdevelopment`
* `cabal build`
* `cabal run`
* browse to [localhost:8000](http://localhost:8000)
* Notice that [the markdown defined in Site.hs](../blob/master/src/Site.hs#L30-47) is rendered as HTML, except the <ul> and <ol> tags, which have their angle-brackets HTML-escaped.

