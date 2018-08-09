build:
	docker build -t dlang .
	docker run -it -v `pwd`:/home/webapp -wd /home/webapp dlang
