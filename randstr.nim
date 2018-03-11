import random

proc randStr(size: int): string =
    result = ""
    # English lower-case letters are 25
    # but random returns in range 0..max-1
    for i in 0 .. size - 1:
        let x = chr(random(26) + 97)
        result.add(x)

let
    size = 1_000_000
    s = randStr(size)

#proc randAddr(): string =
#
#proc randParts(): (string, string) =
#    let length = 254
#    let localLength = random(64) + 1
#    let domainLength = length - localLength
#    for i in 0 .. size - 1:
#
#
#proc makeAddr(local, domain: string): string =
#    result = local & '@' & domain
