import jstrutils, jdict, jjson

type
   Context {.importc.} = ref object
      caller: cstring
      this_script: cstring
      calling_script: cstring

   Args {.importc.} = ref object
      target {.importc: "target.call".}: proc (loc: JsonNode): cstring

proc crackEz21(c: Context; args: Args) {.exportc.} =
   ## Usage: script {target: #s.some_user.their_loc}
   const attempts = [cstring"open", "release", "unlock"]
   for a in attempts:
      var v = newJObject()
      v["ez_21"] = a
      let res = args.target(v)
      if res.startsWith("LOCK_UNLOCKED"):
         return
