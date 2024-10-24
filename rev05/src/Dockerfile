FROM python:3.12

RUN apt-get update && apt-get install -y \
	yosys \
	iverilog

RUN pip install --no-cache-dir z3-solver