FROM docker:stable
COPY start-tgserver.sh /start-tgserver.sh
RUN chmod +x /start-tgserver.sh
ENTRYPOINT ["/start-tgserver.sh"]