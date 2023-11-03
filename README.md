# asy_FIFO
Asynchronous FIFO implementation

# Architecture
![asy_FIFO_architecture](https://github.com/Kai-Dun/asy_FIFO/assets/93189715/db89d3ce-dfd7-4559-b1cc-8fe71f9b537b)


# Empty and Full definition
![ptr](https://github.com/Kai-Dun/asy_FIFO/assets/93189715/d436493a-07e6-4327-acba-94011b421f6f)

Add more 1 bit for ptr  

Binary to Gray code  
0010(2) -> 0011(g)  
1010(2) -> 1111(g)  

So, the way to determine whether it is empty or full in gray code is that the highest two bits are reversed and the remaining bits are the same.
