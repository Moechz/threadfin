# NOTICE — third-party components and attributions

This package (`threadfindocker`, TOS 7 Docker application, version `1.2.37-4`) is an
independent packaging by Moechz of the upstream **Threadfin** project.

## 1. Upstream application — Threadfin

- Project: <https://github.com/Threadfin/Threadfin>
- Version: **1.2.37** (released 2025-09-11; the latest upstream release at the time of this
  package)
- Licence: **MIT** — <https://github.com/Threadfin/Threadfin/blob/main/LICENSE>
- Relationship: the upstream application is used **unmodified**, inside the container image.
  No upstream source code is redistributed in this package.

## 2. Container image — `fyb3roptik/threadfin:1.2.37`

- Registry: Docker Hub — `docker.io/fyb3roptik/threadfin:1.2.37`
- Multi-arch manifest (linux/amd64 digest:
  `sha256:bfec764f7f313bcacc626ae6bb44c1398f209b46772bb7c479317257802e34c7`;
  linux/arm64 and linux/arm/v7 are in the same tag)
- Maintainer: fyb3roptik
- The image is pulled from Docker Hub at install time and is not redistributed here.

## 3. Components inside the image

The image is built by its maintainer on `ubuntu:24.04` and bundles ffmpeg, VLC
(`vlc-bin`/`jellyfin-ffmpeg7` from the Jellyfin repository), CA certificates and the
Threadfin Go binary. Their licences are documented in the image's own package metadata; they
are shipped inside the image only and are not redistributed as separate files by this
package. The web UI additionally loads Bootstrap, Font Awesome and clipboard.js from public
CDNs at runtime (see `PRIVACY.md` §6).

## 4. This packaging

The files authored for this package — `docker-compose.yml`, `config.ini`,
`threadfindocker.lang`, `threadfindocker.svg`, `webui.bz2`, build scripts and this
documentation — are released under **MIT** (see `LICENSE`).

## 5. Trademarks

“Threadfin”, “TerraMaster” and “TOS” are trademarks or registered trademarks of their
respective owners. Their use here is descriptive only. This package is **not affiliated with,
sponsored or endorsed by** the upstream project or TerraMaster.

## 6. Icon

The application icon in `src/threadfindocker.svg` is a generic “play” mark drawn for this
package; it does not reproduce the upstream Threadfin logo.

## 7. Contact

Moechz — moechz@163.com — <https://www.moechz.com/>
