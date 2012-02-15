OBJS = dpflib.o rawusb.o

all: libdpf.a fwload

fwload: fwload.o libdpf.a
	$(CC) -o $@ fwload.o $(LDFLAGS) -ldpf -lusb 

libdpf.a: $(OBJS)
	$(AR) ruv $@ $(OBJS)

clean:
	rm -f fwload libdpf.a *.o
