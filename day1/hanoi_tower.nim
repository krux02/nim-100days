
proc echoMove(fr, to: string) {.inline.} =
   echo "move from ", fr, " to ", to

proc hanoi(n: int, fr, to, spare: string) =
   if n > 0:
      hanoi(n - 1, fr, spare, to)
      echoMove(fr, to)
      hanoi(n - 1, spare, to, fr)

hanoi(3, "left", "right", "middle")
