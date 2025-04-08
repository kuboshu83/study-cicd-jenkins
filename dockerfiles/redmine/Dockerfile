FROM redmine:5.1.7

COPY ./resources/init.sh /usr/src/redmine/init.sh
RUN chmod +x /usr/src/redmine/init.sh

ENTRYPOINT ["/usr/src/redmine/init.sh"]