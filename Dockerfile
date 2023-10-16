FROM ghcr.io/dbt-labs/dbt-postgres:1.6.3

WORKDIR /dbt

CMD ["dbt", "run"]