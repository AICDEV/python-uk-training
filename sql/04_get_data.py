import mysql.connector
import os

def get_customers(connection):
    with connection.cursor() as cursor:

        customer = ('SELECT * FROM CUSTOMERS')
        cursor.execute(customer)

        for c in cursor.fetchall():
            print(c)     

if __name__ == '__main__':
    try:
        with mysql.connector.connect(
            user='root',
            password=os.environ.get('PYTHON_WS_SQL_ROOT_PW'),
            host='18.194.156.120',
            port='9001',
            database="trainer"
        ) as db_connection:

            with db_connection as connection:
                get_customers(connection)
            

    except Exception as err:
        print(err)
