# jenkins-runner
Dockerfile for jenkins docker runner.
Usage: write jenkins public key to ./ssh/autorized_keys， after that, run docker build.
Use to build buffalo project.
go version: 1.19
node version:18.8.0
yarn version upgrade to stable.
base image: ubuntu:jammy
