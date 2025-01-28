FROM docker.io/python:3.11-slim



WORKDIR /application
COPY data_ingest.py data_ingest.py
ADD csv_data_files ./csv_data_files
ADD requirements.txt .

RUN pip install -r requirements.txt

# ENTRYPOINT [ "bash" ]
ENTRYPOINT [ "python", "data_ingest.py" ]
