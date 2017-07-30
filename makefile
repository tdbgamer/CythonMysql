all: compile test

compile:
	python3 setup.py build_ext --inplace

test:
	PYTHONPATH=${PWD} py.test --verbose --color=yes -s

docker-up:
	(cd mysql_server && docker-compose up -d)
