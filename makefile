all: compile test

compile:
	python3 setup.py build_ext --inplace

test:
	PYTHONPATH=~/Documents/python/learncython py.test --verbose --color=yes

docker-up:
	(cd mysql_server && docker-compose up -d)
