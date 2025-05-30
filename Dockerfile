FROM ubuntu:latest
LABEL authors="wr201"

ENTRYPOINT ["top", "-b"]