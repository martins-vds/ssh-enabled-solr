FROM solr

USER root

RUN apt-get update \
    && apt-get -y install openssh-server \
    && echo "root:Docker!" | chpasswd \
    && rm -rf /etc/ssh

COPY sshd_config /etc/ssh/

COPY ./init_container.sh /opt/solr

RUN chmod +x /opt/solr/init_container.sh \
    && ssh-keygen -t dsa -q -f /etc/ssh/ssh_host_dsa_key -N "" \
    && ssh-keygen -t rsa -q -f /etc/ssh/ssh_host_rsa_key -N "" \
    && ssh-keygen -t ecdsa -q -f /etc/ssh/ssh_host_ecdsa_key -N "" \
    && ssh-keygen -t ed25519 -q -f /etc/ssh/ssh_host_ed25519_key -N ""

EXPOSE 2222

WORKDIR /opt/solr

USER solr

ENTRYPOINT [ "bash", "init_container.sh" ]

CMD ["solr-foreground"]