How to test the response time:
- Connect to the default database in Postgress and run `create database perf_base;`
- Run `./mvnw clean quarkus:dev -pl :0-base` from the repository folder
- Connect to the `perf_base` database in Postgres and run `call initData();`
- Call http://localhost:8000/test?accountId=account-2 and look at the response
- Call http://localhost:8000/test?accountId=account-50 and look at the response
