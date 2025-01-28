import pandas as pd
from sqlalchemy import create_engine
import os


def ingest_into_db(**arg):
    
    engine = create_engine(f'''postgresql://{arg['DB_USER']}:{arg['DB_PASSWORD']}@{arg['DB_HOST']}:{arg['DB_PORT']}/{arg['DB_NAME']}''')

    

    df_iter = pd.read_csv('./csv_data_files/green_tripdata_2019-10.csv', iterator=True, chunksize=100000)


    for chunk in df_iter:
        # datetime type
        chunk.lpep_pickup_datetime = pd.to_datetime(chunk.lpep_pickup_datetime)
        chunk.lpep_dropoff_datetime = pd.to_datetime(chunk.lpep_dropoff_datetime)

        chunk.to_sql(name='green_taxi_data', con=engine, if_exists="append")

        print("a chunk of green taxi inserted...")
    

    df2_iter = pd.read_csv('./csv_data_files/taxi_zone_lookup.csv', iterator=True, chunksize=100000)


    for chunk in df2_iter:

        chunk.to_sql(name='taxi_zone_lookup', con=engine, if_exists="append")

        print("a chunk of taxi zone inserted...")


if __name__ == "__main__":
    # parameters
    DB_USER = os.getenv("DB_USER")
    DB_PASSWORD = os.getenv("DB_PASSWORD")
    DB_HOST = os.getenv("DB_HOST")
    DB_PORT = os.getenv("DB_PORT")
    DB_NAME = os.getenv("DB_NAME")

    
    
    arguments = {
        'DB_USER': DB_USER,
        'DB_PASSWORD': DB_PASSWORD,
        'DB_HOST': DB_HOST,
        'DB_PORT': DB_PORT,
        'DB_NAME': DB_NAME
    }

    ingest_into_db(**arguments)