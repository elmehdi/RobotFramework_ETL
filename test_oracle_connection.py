#!/usr/bin/env python
# -*- coding: utf-8 -*-

"""
Test script to verify Oracle database connection using oracledb
"""

import oracledb
import sys

def test_connection(username, password, dsn):
    """Test connection to Oracle database"""
    print(f"oracledb version: {oracledb.__version__}")
    print(f"Attempting to connect to Oracle database: {dsn}")
    
    try:
        # Attempt to establish a connection
        connection = oracledb.connect(user=username, password=password, dsn=dsn)
        
        # Get database version
        cursor = connection.cursor()
        cursor.execute("SELECT BANNER FROM V$VERSION")
        version = cursor.fetchone()
        
        print(f"Successfully connected to Oracle Database!")
        print(f"Database version: {version[0]}")
        
        # Close the connection
        cursor.close()
        connection.close()
        
        return True
    except Exception as e:
        print(f"Error connecting to Oracle database: {e}")
        return False

if __name__ == "__main__":
    if len(sys.argv) != 4:
        print("Usage: python test_oracle_connection.py <username> <password> <host:port/service_name>")
        sys.exit(1)
    
    username = sys.argv[1]
    password = sys.argv[2]
    dsn = sys.argv[3]
    
    success = test_connection(username, password, dsn)
    sys.exit(0 if success else 1)
