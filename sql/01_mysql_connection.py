import mysql.connector
import os

try:
    with mysql.connector.connect(
        user='root',
        password=os.environ.get('PYTHON_WS_SQL_ROOT_PW'),
        host='18.194.156.120',
        port='9001'
    ) as db_connection:
        
        with db_connection.cursor() as cursor:
            cursor.execute("SHOW DATABASES")
            for db in cursor:
                print(db)

except Exception as err:
    print(err)

