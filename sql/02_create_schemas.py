import mysql.connector
import os

customer_scheme = """
CREATE TABLE `CUSTOMERS` (
  `CUSTOMER_ID` int unsigned NOT NULL AUTO_INCREMENT,
  `SAP_ID` varchar(45) NOT NULL,
  `ICE_ID` varchar(45) NOT NULL,
  `PAYMENT_TYPE` int DEFAULT NULL,
  `LASTNAME` varchar(150) NOT NULL,
  `FIRSTNAME` varchar(150) NOT NULL,
  `CUSTOMER_SINCE` datetime NOT NULL,
  `PRODUCT_ID` int unsigned NOT NULL,
  `PHONE` varchar(45) NOT NULL,
  `AGE` int unsigned NOT NULL,
  `TRANSACTIONS` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`CUSTOMER_ID`),
  UNIQUE KEY `CUSTOMER_ID_UNIQUE` (`CUSTOMER_ID`),
  UNIQUE KEY `SAP_ID_UNIQUE` (`SAP_ID`),
  UNIQUE KEY `ICE_ID_UNIQUE` (`ICE_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci
"""

payment_scheme = """
CREATE TABLE `PAYMENT` (
  `PAYMENT_ID` int NOT NULL,
  `PAYMENT_NAME` varchar(45) NOT NULL,
  PRIMARY KEY (`PAYMENT_ID`),
  UNIQUE KEY `PAYMENT_ID_UNIQUE` (`PAYMENT_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci
"""

product_scheme = """
CREATE TABLE `PRODUCTS` (
  `PRODUCT_ID` int unsigned NOT NULL,
  `PRODUCT_NAME` varchar(45) NOT NULL,
  `PRODUCT_ABO` int NOT NULL,
  PRIMARY KEY (`PRODUCT_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci
"""

transaction_scheme = """
CREATE TABLE `TRANSACTIONS` (
  `TRANSACTION_ID` int NOT NULL,
  `BALANCE` decimal(10,2) NOT NULL,
  `STATUS` varchar(45) NOT NULL,
  `BOOKING_DATE` datetime NOT NULL,
  `CUSTOMER_TRANSACTION_CODE` varchar(100) NOT NULL,
  `CURRENCY` varchar(10) NOT NULL,
  PRIMARY KEY (`TRANSACTION_ID`),
  UNIQUE KEY `TRANSACTION_ID_UNIQUE` (`TRANSACTION_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci
"""


def create_scheme(scheme, connection):
    try:
        cursor = connection.cursor()
        cursor.execute(scheme)
        connection.commit()
        cursor.close()
    except Exception as e:
        print(e)

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
                create_scheme(transaction_scheme, connection)
                create_scheme(product_scheme, connection)
                create_scheme(payment_scheme, connection)
                create_scheme(customer_scheme, connection)

    except Exception as err:
        print(err)
