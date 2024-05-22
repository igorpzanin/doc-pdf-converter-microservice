FROM python

WORKDIR /app
COPY . .
RUN mkdir -p /app/pdf
RUN apt-get update && \
    apt-get -y install cron unoconv awscli
RUN pip install boto3
RUN sed -i 's|#!/usr/bin/env python3|#!/usr/bin/python3|' /usr/bin/unoconv


CMD ["python3", "./script.py"] 
