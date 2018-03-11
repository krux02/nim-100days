import asyncdispatch, parseopt, strutils, os

proc writeHelp() =
  echo """
Usage:  jest [<dir>] [<port>] [--host:<addr>]
addr: the address to serve to, default: 'localhost'
port: the port to serve to, default: '8000'
dir: the directory to serve, default: local dir '.'. Needs to exist.
"""

var 
  prt = 8000
  dir = "."
  adr = "localhost"

proc serve() =
  let httpServer = newAsyncHttpServer()
  let page = fakeMangaPage().render()
  proc cb(req: Request) {.async.} =
    await onRequest(req, page)
  requestCount = 0
  waitFor httpServer.serve(Port(8080), cb)

proc main =
  for kind, key, val in getopt():
    case kind:
    of cmdArgument:
      if key.isDigit: prt = key.parseint
      elif existsdir(key): dir = key
      else:
        writeHelp()
        quit()
    of cmdShortOption:
      echo usage()
      quit()
    of cmdLongOption, cmdShortOption:
      case key:
      of "host": adr = val
      else: 
        writeHelp()
        quit()
    of cmdEnd: assert(false)

settings:
  staticDir = dir
  port = Port(prt)
  bindAddr = adr

routes:
  get "/":
    redirect(uri("index.html"))



