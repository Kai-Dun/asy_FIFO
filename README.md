# asy_FIFO

Architecture

![image](https://github.com/Kai-Dun/asy_FIFO/assets/93189715/681dfbc0-4196-46bb-ab2d-f9c1d373700c)


Empty and Full definition
Add more 1 bit for ptr

![ptr](https://github.com/Kai-Dun/asy_FIFO/assets/93189715/d5a0e2f8-3fc7-4c37-b77b-05c83f5f3077)

Binary to Gray code
0010(2) -> 0011(g)
1010(2) -> 1111(g)

So, The way to determine whether it is empty or full in gray code is that the highest two bits are reversed and the remaining bits are the same.
