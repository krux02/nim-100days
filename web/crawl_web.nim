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
   inc(numPagesVisited)
   # Make the request
   echo("Visiting page ", url)
   var content: string
   try:
      content = client.getContent(url)
      if searchWord in content:
         echo("Word ", searchWord, " found at page ", url)
      else:
         for u in content.getUrls:
            pagesToVisit.add(u)
   except:
      echo("Error while visting ", url)
   finally:
      cb()

iterator getUrls(s: string): string =
   const quotes = {'\'', '\"'}
   const sub = "href="
   var a {.noInit.}: SkipTable
   initSkipTable(a, sub)
   var i = 0
   while i < len(s):
      var found = false
      var b = 0
      let n = skip(s, "<a", i)
      if n != 0:
         inc(i, n)
         let f = find(a, s, sub, i)
         if f != -1:
            i = f + sub.len
            if s[i] in quotes:
               inc(i)
               b = i
               while s[i] notin quotes:
                  inc(i)
               found = true
      if found:
         yield substr(s, b, i)
      inc(i)

when isMainModule:
   crawl()
