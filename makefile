CC = gcc
CFLAGS = -Wall -g
.PHONY: loops recursives recursived loopd all clean

BASIC =  basicClassification
ACL = advancedClassificationLoop
ACR = advancedClassificationRecursion
NC = NumClass


all: loops recursives loopd recursived mains maindloop maindrec


basicClassification.o: $(BASIC).c $(NC).h
	$(CC) $(CFLAGS) -c $<

advancedClassificationLoop.o: $(ACL).c $(NC).h
	$(CC) $(CFLAGS) -c $<

advancedClassificationRecursion.o: $(ACR).c $(NC).h
	$(CC) $(CFLAGS) -c $<

main.o: main.c $(NC).h
	$(CC) $(CFLAGS) -c $<


loops: libclassloops.a
libclassloops.a: $(BASIC).o $(ACL).o
	ar -rcu libclassloops.a $^

recursives: libclassrec.a
libclassrec.a: $(BASIC).o $(ACR).o
	ar -rc libclassrec.a $^
	
recursived: $(BASIC).o $(ACR).o
	$(CC) $(CFLAGS) -fPIC -shared -o libclassrec.so $^

loopd:libclassloops.so	
libclassloops.so: $(BASIC).o $(ACL).o
	$(CC) $(CFLAGS) -fPIC -shared -o libclassloops.so $^
	
mains: main.o libclassrec.a
	$(CC) $(CFLAGS) -o mains main.o -L. -libclassloops -lm
	
maindloop: main.o libclassloops.so
	$(CC) $(CFLAGS) -o maindloop main.o -L. -libclassloops -lm
	export LD_LIBRARY_PATH=.:$$LD_LIBRARY_PATH
	
maindrec: main.o libclassrec.so
	$(CC) $(CFLAGS) -o maindrec main.o -L. -libclassloops -lm
	export LD_LIBRARY_PATH=.:$$LD_LIBRARY_PATH
	
clean:
	rm -f *.o *.so *.a mains maindloop maindrec
