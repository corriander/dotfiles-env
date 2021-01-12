# Handcranked an intermediate image but could ditch this.
FROM debian:unstable

RUN apt update
RUN apt upgrade --yes
RUN apt install git git-annex --yes
RUN dpkg-reconfigure tzdata