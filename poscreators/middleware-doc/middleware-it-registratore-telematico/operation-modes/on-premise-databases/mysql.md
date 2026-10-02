---
slug: /poscreators/middleware-doc/italy/databases/mysql
title: MySQL
description: MySQL storage provider for running the Italian Middleware with an external MySQL database, and its connection string parameter.
tags: [mysql, queue, configuration, operation-modes, italy]
---

# MySQL Storage

## Support

**from version:** 1.3.45

The use of the MySQL storage provider enables the middleware to be operated with an external MySQL database system. The middleware stores all the data processed during the operation of the queue and all configuration data directly in the database.

This storage provider is particularly suitable for setting up fail-safe systems or for integrating middleware into existing system architectures.

## Parameters

| Name               | Description                                    | **Default Value**<br />**Mandatory Field** |
|--------------------|------------------------------------------------|--------------------------------------------|
| _connectionstring_ | MySQL connection string to the database system | mandatory                                  |

*Table 1. MySQL storage provider parameters.*
