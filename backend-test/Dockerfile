FROM python:alpine
COPY dist/ /usr/src/
WORKDIR /usr/src
RUN python3 -m venv env
RUN source env/bin/activate
RUN pip3 install -r requirements.txt