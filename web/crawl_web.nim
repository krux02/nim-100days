import httpclient, sets, strutils, parseutils

{.reorder: on.}

const
   startUrl = "http://www.tovima.gr/"
   searchWord = "stemming"
   maxPagesToVisit = 40

var
   client = newHttpClient(userAgent = "")
   pagesVisited = initSet[string]()
   numPagesVisited = 0
   pagesToVisit = @[startUrl]

proc crawl() =
   while pagesToVisit.len > 0:
      if numPagesVisited >= maxPagesToVisit:
         echo("Reached max limit of number of pages to visit.")
         return
      let nextPage = pagesToVisit.pop()
      if nextPage in pagesVisited:
         # We've already visited this page, so repeat the crawl
         crawl()
      else:
         # New page we haven't visited
         visitPage(nextPage, crawl)

proc visitPage(url: string; cb: proc ()) =
   # Add page to our set
   pagesVisited.incl(url)
   numPagesVisited.inc

   # Make the request
   echo("Visiting page ", url)
   var content: string
   try:
      content = client.getContent(url)
      if searchWord in content:
         echo("Word ", searchWord, " found at page ", url)
      for u in content.getUrls:
         pagesToVisit.add(u)
   except:
      echo("Error while visting ", url)
   finally:
      cb()

proc skipUntil(s: string; until: string; unless = '\0'; start: int): int =
   # Skips all characters until the string `until` is found. Returns 0
   # if the char `unless` is found first or the end is reached.
   var i = start
   var u = 0
   while true:
      if s[i] == '\0' or s[i] == unless:
         return 0
      elif s[i] == until[0]:
         u = 1
         while i + u < s.len and u < until.len and s[i + u] == until[u]:
            inc u
         if u >= until.len: break
      inc(i)
   result = i + u - start

iterator getUrls(s: string): string =
   const quotes = {'\'', '\"'}
   var i = 0
   var b = 0
   while i < len(s):
      var found = false
      let n = skip(s, "<a", i)
      if n != 0:
         inc(i, n)
         let f = skipUntil(s, "href=", '>', i)
         if f != 0:
            inc(i, f)
            if s[i] in quotes:
               inc(i, 1)
               b = i
               while s[i] notin quotes:
                  inc(i, 1)
               found = true
      if found:
         yield substr(s, b, i)
      i = i + n + 1
      b = 0

when isMainModule:
   crawl()
