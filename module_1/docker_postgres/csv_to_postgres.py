import pandas as pd
from sqlalchemy import create_engine
import os



def ingest_into_db(df_iter):

    engine = create_engine('postgresql://sagar:sagar@localhost:5432/ny_taxi')
    db_table_name = 'yellow_taxi_data'
    
    for chunk in df_iter:
        
        # datetime type
        chunk.tpep_pickup_datetime = pd.to_datetime(chunk.tpep_pickup_datetime)
        chunk.tpep_dropoff_datetime = pd.to_datetime(chunk.tpep_dropoff_datetime)

        chunk.to_sql(name='yellow_taxi_data', con=engine, if_exists='append')

        print(f'a chunk inserted...')


if __name__ == '__main__':

    
    # read csv in pandas dataframe
    sample_df = pd.read_csv('module_1/docker_postgres/csv_data_files/yellow_tripdata_2021-01.csv', nrows=100)
    print(sample_df.head())

    # creatign iterator to read data in chunks
    df_iter = pd.read_csv('module_1/docker_postgres/csv_data_files/yellow_tripdata_2021-01.csv', iterator=True, chunksize=100000)

    # ingest
    ingest_into_db(df_iter)