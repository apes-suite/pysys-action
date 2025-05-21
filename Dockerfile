FROM ghcr.io/apes-suite/seeder:1.6.2

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
