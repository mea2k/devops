#!/usr/bin/python
import os

if 'DB_USER' not in os.environ:
	os.environ['DB_USER']='user'
if 'DB_PASSWORD' not in os.environ:
	os.environ['DB_PASSWORD']='userpwd'
if 'DB_HOST' not in os.environ:
	os.environ['DB_HOST']='localhost'
if 'DB_NAME' not in os.environ:
	os.environ['DB_NAME']='virtd'
if 'DB_REQUESTS_TABLE' not in os.environ:
	os.environ['DB_REQUESTS_TABLE']='logs'

#print(os.environ.get('DB_USER'))