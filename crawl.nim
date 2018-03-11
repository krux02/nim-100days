import httpclient, sets

{.reorder: on.}

const
   start_url = "http://www.ethnos.gr/"
   search_word = "stemming"
   max_pages_to_visit = 40

var
   client = newHttpClient(userAgent = "")
   pagesVisited = initSet[string]()
   numPagesVisited = 0
   pagesToVisit = @[start_url]

proc crawl() =
   while pagesToVisit.len > 0:
      if numPagesVisited >= max_pages_to_visit:
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
   except:
      echo("Error while visting ", url, getCurrentExceptionMsg())
      return
   finally:
      cb()


crawl()
