# This Docker uses the multi-stage build feature of Docker.
# It kicks of the installation of Nix in a temporary alpine container,
# after which we copy the installation to an empty image that only contains Nix.

FROM alpine as FETCHER

# Enable HTTPS support in wget.
RUN apk add --update openssl

# Download Nix and install it into the system.
RUN wget -O- https://nixos.org/releases/nix/nix-1.11.14/nix-1.11.14-x86_64-linux.tar.bz2 | bzcat - | tar xf - \
  && addgroup -g 30000 -S nixbld \
  && for i in $(seq 1 30); do adduser -S -D -h /var/empty -g "Nix build user $i" -u $((30000 + i)) -G nixbld nixbld$i ; done \
  && mkdir -m 0755 /nix && USER=root sh nix-*-x86_64-linux/install

# The target image don't have coreutils installed, so we just copy over an empty directory to create a /tmp
RUN mkdir /emptydir

# Create symlink that will become /bin/sh in the Nix image
RUN mkdir /nixbin  \
  && . /root/.nix-profile/etc/profile.d/nix.sh \
  && export NIX_PATH=/nix/var/nix/profiles/per-user/root/channels \
  && ln -s "$(nix-build '<nixpkgs>' -A bash)/bin/sh" /nixbin/sh

# Remove garbage
RUN . /root/.nix-profile/etc/profile.d/nix.sh && nix-store --gc

# Now create the actual image
FROM scratch
COPY --from=FETCHER /nix /nix
COPY --from=FETCHER /etc/passwd /etc/passwd
COPY --from=FETCHER /etc/shadow /etc/shadow
COPY --from=FETCHER /etc/group /etc/group
COPY --from=FETCHER /root /root
COPY --from=FETCHER /emptydir /tmp
COPY --from=FETCHER /nixbin /bin

ONBUILD ENV \
    ENV=/nix/var/nix/profiles/default/etc/profile.d/nix.sh \
    PATH=/nix/var/nix/profiles/default/bin:/nix/var/nix/profiles/default/sbin:/bin:/sbin:/usr/bin:/usr/sbin \
    GIT_SSL_CAINFO=/nix/var/nix/profiles/default/etc/ssl/certs/ca-bundle.crt \
    NIX_SSL_CERT_FILE=/nix/var/nix/profiles/default/etc/ssl/certs/ca-bundle.crt

ENV \
    ENV=/nix/var/nix/profiles/default/etc/profile.d/nix.sh \
    PATH=/nix/var/nix/profiles/default/bin:/nix/var/nix/profiles/default/sbin:/bin:/sbin:/usr/bin:/usr/sbin \
    GIT_SSL_CAINFO=/nix/var/nix/profiles/default/etc/ssl/certs/ca-bundle.crt \
    NIX_SSL_CERT_FILE=/nix/var/nix/profiles/default/etc/ssl/certs/ca-bundle.crt \
    NIX_PATH=/nix/var/nix/profiles/per-user/root/channels
