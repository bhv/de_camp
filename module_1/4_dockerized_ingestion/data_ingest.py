import pandas as pd
from sqlalchemy import create_engine
import os


def ingest_into_db(**arg):
    
    engine = create_engine(f'''postgresql://{arg['DB_USER']}:{arg['DB_PASSWORD']}@{arg['DB_HOST']}:{arg['DB_PORT']}/{arg['DB_NAME']}''')

    

    df_iter = pd.read_csv(arg['DATA_FILE_PATH'], iterator=True, chunksize=100000)


    for chunk in df_iter:
        # datetime type
        chunk.tpep_pickup_datetime = pd.to_datetime(chunk.tpep_pickup_datetime)
        chunk.tpep_dropoff_datetime = pd.to_datetime(chunk.tpep_dropoff_datetime)

        chunk.to_sql(name=arg['TABLE_NAME'], con=engine, if_exists="append")

        print("a chunk inserted...")


if __name__ == "__main__":
    # parameters
    DB_USER = os.getenv("DB_USER")
    DB_PASSWORD = os.getenv("DB_PASSWORD")
    DB_HOST = os.getenv("DB_HOST")
    DB_PORT = os.getenv("DB_PORT")
    DB_NAME = os.getenv("DB_NAME")
    TABLE_NAME = os.getenv("TABLE_NAME")
    DATA_FILE_PATH = os.getenv("DATA_FILE_PATH")

    arguments = {
        'DB_USER': DB_USER,
        'DB_PASSWORD': DB_PASSWORD,
        'DB_HOST': DB_HOST,
        'DB_PORT': DB_PORT,
        'DB_NAME': DB_NAME,
        'TABLE_NAME': TABLE_NAME,
        'DATA_FILE_PATH': DATA_FILE_PATH
    }

    ingest_into_db(**arguments)