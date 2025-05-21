#!/usr/bin/env python
# -*- coding: utf-8 -*-

"""
Test script to verify Oracle database connection using oracledb
"""

import oracledb
import sys

def test_connection(username, password, host, port, service_name):
    """Test connection to Oracle database"""
    print(f"oracledb version: {oracledb.__version__}")
    
    # Construct the DSN (Data Source Name)
    dsn = f"{host}:{port}/{service_name}"
    print(f"Attempting to connect to Oracle database: {dsn}")
    
    try:
        # Attempt to establish a connection
        connection = oracledb.connect(user=username, password=password, dsn=dsn)
        
        # Get database version
        cursor = connection.cursor()
        cursor.execute("SELECT BANNER FROM V$VERSION WHERE ROWNUM = 1")
        version = cursor.fetchone()
        
        print(f"Successfully connected to Oracle Database!")
        if version:
            print(f"Database version: {version[0]}")
        
        # Close the connection
        cursor.close()
        connection.close()
        
        return True
    except Exception as e:
        print(f"Error connecting to Oracle database: {e}")
        return False

if __name__ == "__main__":
    if len(sys.argv) != 6:
        print("Usage: python test_oracledb_connection.py <username> <password> <host> <port> <service_name>")
        sys.exit(1)
    
    username = sys.argv[1]
    password = sys.argv[2]
    host = sys.argv[3]
    port = sys.argv[4]
    service_name = sys.argv[5]
    
    success = test_connection(username, password, host, port, service_name)
    sys.exit(0 if success else 1)
