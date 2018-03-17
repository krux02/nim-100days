import asyncdispatch, httpclient

{.reorder: on.}

const pagesToVisit = [
   "http://www.arstecica.com",
   "http://planet.gnome.org",
   "http://www.popsci.com"
]

proc scrape() =
   var tasks = newSeq[Future[void]](pagesToVisit.len)
   for i in 0 .. high(pagesToVisit):
      tasks[i] = visitPage(pagesToVisit[i])
   waitFor all(tasks)

proc visitPage(url: string) {.async.} =
   let client = newAsyncHttpClient()
   echo("Visiting page ", url)
   var content: string
   try:
      content = await client.getContent(url)
   except:
      echo("Error while visting ", url)
   client.close()


when isMainModule:
   scrape()
