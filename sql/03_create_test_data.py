import mysql.connector
import random
import uuid
import os
from datetime import date

def lastnames():
    return [
        'Doe',
        'Tucker',
        'Colon',
        'Rios',
        'Snow',
        'Smith',
        'Price',
        'Burton',
        'Hayes',
        'Franco',
        'Carr',
        'Malone',
        'Howe'
    ]

def firstnames(): 
    return [
        'Kye',
        'Boris',
        'Alina',
        'Heather',
        'Sam',
        'Emmie',
        'Tina',
        'Christian',
        'Darcie',
        'Florian',
        'Rhonda',
        'Lana'
    ]

def get_phone_number():
    return f"{random.randrange(1000,9999)}-{random.randrange(1000,9999)}-{random.randrange(1000,9999)}"

def get_products():
    return [
        {
            'product_id': 10,
            'product_name': 'gas',
            'product_abo': 0
        },
        {
            'product_id': 20,
            'product_name': 'power',
            'product_abo': 1
        },
        {
            'product_id': 30,
            'product_name': 'super gas',
            'product_abo': 1
        },
        {
            'product_id': 40,
            'product_name': 'super power',
            'product_abo': 1
        }
    ]

def get_payment():
    return [
        {
            'payment_id': 1,
            'payment_name': 'direct debit'
        },
        {
            'payment_id': 2,
            'payment_name': 'credit card'
        },
        {
            'payment_id': 3,
            'payment_name': 'paypal'
        },
        {
            'payment_id': 4,
            'payment_name': 'credit card'
        }
    ]

def create_payment(connection):
    with connection.cursor() as cursor:
        for p in get_payment():
            payment = ('INSERT INTO PAYMENT '
                    '(PAYMENT_ID, PAYMENT_NAME) '
                    'VALUES (%(payment_id)s, %(payment_name)s)')

            cursor.execute(payment, p)
            connection.commit()

def create_product(connection):
    with connection.cursor() as cursor:

        for p in get_products():
            product = ('INSERT INTO PRODUCTS '
                    '(PRODUCT_ID, PRODUCT_NAME, PRODUCT_ABO) '
                    'VALUES (%(product_id)s, %(product_name)s, %(product_abo)s)')

            cursor.execute(product, p)
            connection.commit()

def create_transaction(connection, customer_transaction_code):
    with connection.cursor() as cursor:
        for _ in range(25):
            try:
                transaction = ('INSERT INTO TRANSACTIONS '
                            '(TRANSACTION_ID, BALANCE, STATUS, BOOKING_DATE, CUSTOMER_TRANSACTION_CODE, CURRENCY) '
                            'VALUES (%(transaction_id)s, %(balance)s, %(status)s, %(booking_date)s, %(customer_transaction_code)s,%(currency)s)')
                
                transaction_data = {
                    'transaction_id': random.randrange(1,1000000),
                    'balance': random.uniform(1.0,10000.00),
                    'status': random.choice(['approved','rejected']),
                    'booking_date': date.today(),
                    'customer_transaction_code': str(customer_transaction_code),
                    'currency': random.choice(['$','€','£'])
                }

                cursor.execute(transaction, transaction_data)
                connection.commit()
                return True

            except Exception as e:
                print(e)
                return False

def create_customer(connection):
    with connection.cursor() as cursor:

        customer = ('INSERT INTO CUSTOMERS '
                '(SAP_ID, ICE_ID, PAYMENT_TYPE, LASTNAME, FIRSTNAME, CUSTOMER_SINCE, PRODUCT_ID, PHONE, AGE, TRANSACTIONS) '
                'VALUES (%(sap_id)s, %(ice_id)s, %(payment_type)s, %(lastname)s, %(firstname)s, %(customer_since)s, %(product_id)s, %(phone)s, %(age)s, %(transactions)s)')
        customer_records = []

        for _ in range(100):
           
            customer_transaction_code = uuid.uuid4()

            if create_transaction(connection, customer_transaction_code) == True:
                customer_data = {
                    "sap_id": str(uuid.uuid4()),
                    "ice_id": str(uuid.uuid4()),
                    "payment_type": random.randrange(1,5),
                    "lastname": random.choice(lastnames()),
                    "firstname": random.choice(firstnames()),
                    "customer_since": date.today(),
                    "product_id": random.choice([10,20,30,40]),
                    "phone": get_phone_number(),
                    "age": random.randrange(18,100),
                    "transactions": str(customer_transaction_code)
                }

                customer_records.append(customer_data)
            else:
                print("skip due error in creating transaction")

        cursor.executemany(customer, customer_records)
        connection.commit()        

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
                # create_payment(connection)
                # create_product(connection)
                create_customer(connection)
            

    except Exception as err:
        print(err)
