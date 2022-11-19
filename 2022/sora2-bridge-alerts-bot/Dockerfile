FROM python:3.8-slim-buster

RUN apt update && apt -y install gcc

RUN adduser --disabled-password bot --shell /bin/bash --home /app --quiet
USER bot

WORKDIR /app

ENV PYTHONUNBUFFERED 1

COPY requirements.txt requirements.txt
RUN pip3 install -r requirements.txt

COPY . .
CMD ["python3", "main.py"]