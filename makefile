SHELL := /bin/bash


all:
	source jaspergo && jg do.tcl

clean:
	rm -rf jgproject
