grab: grab.cpp
	g++ grab.cpp -o grab

run: grab
	./grab

install: grab
	cp ./grab /usr/local/bin/grab
