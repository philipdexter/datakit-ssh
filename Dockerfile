FROM ocaml/opam:alpine

RUN sudo apk add ncurses-dev libev-dev
RUN opam depext lwt && opam install lwt alcotest conf-libev

# cache opam install of dependencies
COPY full_src/opam /home/opam/src/datakit/opam
RUN opam pin add datakit.dev /home/opam/src/datakit -n
RUN opam depext datakit && opam install datakit --deps

COPY full_src /home/opam/src/datakit

RUN opam install datakit.dev -vv

RUN sudo apk add openssh

EXPOSE 5640
EXPOSE 22

RUN sudo mkdir /data && sudo chown opam.nogroup /data && chmod 700 /data && \
    sudo cp $(opam config exec -- which datakit) /usr/bin/datakit && \
    sudo cp $(opam config exec -- which datakit-mount) /usr/bin/datakit-mount

RUN opam config exec -- ocaml /home/opam/src/datakit/check-libev.ml

COPY sshd_config /.sshd_config
COPY entry.sh /.entry.sh

RUN sudo apk add openssl

ENTRYPOINT ["sudo", "sh", "/.entry.sh"]

# ENTRYPOINT ["/usr/bin/datakit"]
# CMD ["--url=tcp://0.0.0.0:5640", "--git=/data", "-vv"]
