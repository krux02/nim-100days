
proc echoMove(fr, to: string) {.inline.} =
   echo "move from ", fr, " to ", to

proc hanoi(n: int, fr, to, spare: string) =
   if n == 1:
      echoMove(fr, to)
   else:
      hanoi(n - 1, fr, spare, to)
      hanoi(1, fr, to, spare)
      hanoi(n - 1, spare, to, fr)

hanoi(3, "left", "right", "middle")
