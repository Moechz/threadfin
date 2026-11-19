# threadfin-for-tos

> TerraMaster TOS 7 App Center — **Docker application** package for
> [Threadfin](https://github.com/Threadfin/Threadfin).

## What this is

A TOS Docker application archive that installs Threadfin on TOS 7 through the App Center
(one archive per architecture: `threadfindocker_x86_64.tar.gz`,
`threadfindocker_aarch64.tar.gz`). Each archive contains the four core files:

- `config.ini` — TOS application metadata (`application_type: docker`, id `threadfindocker`)
- `threadfindocker.lang` — 23-language superset (TOS requires 14)
- `threadfindocker.svg` — application icon (SVG, 73.4% glyph)
- `docker-compose.yml` — one service, image `fyb3roptik/threadfin:1.2.37`

plus `webui.bz2` — the small front-end bundle the review asks for when `config.ini` declares
a `path` (F22/F07). It contains one `index.html` that redirects the App Center's internal
page to the application on port 8066; all real UI work is served by Threadfin itself.

## How it works

| | |
|---|---|
| Container image | `fyb3roptik/threadfin:1.2.37` (Docker Hub, upstream image used unmodified) |
| Open | `http://<NAS-IP>:8066/web/` (container port 34400) |
| First run | the web UI asks you to create the administrator account |
| Runs as | non-root, `user: "1000:1000"` |
| Persistent data | `/home/threadfin/conf` → `/Volume1/DockerAppData/threadfindocker/conf` |
| Logs | `docker logs threadfindocker` (stdout/stderr) |
| Health check | `curl -fsS http://<container-host>/` on port 34400 |

Threadfin is an IPTV proxy: it merges the M3U playlists and XMLTV guide data you configure
and exposes them to Plex, Emby, Jellyfin or an HDHomeRun client as a single tuner on your
LAN. It proxies the live streams; it does not record them.

## Privacy

This application runs entirely on your NAS. **The developer does not collect, receive or
have access to any data processed by the application.** There is no telemetry, no analytics
and no account with the developer.

| Topic | Detail |
|---|---|
| Data processed | Settings (IPTV/EPG URLs, tuner count), the web UI account, the imported channel list, guide data, channel mappings and the logo cache. |
| Where it is stored | `/Volume1/DockerAppData/threadfindocker/conf` on your NAS. Nothing is uploaded to the developer. |
| Retention period | Until **you** delete it. The playlist/guide is refreshed on your schedule; the logo cache is rebuilt on demand; uninstalling keeps the data unless you tick “delete data”. |
| Your rights | **Access / export**: copy the data folder (plain JSON) or use the UI backup. **Correct**: change the settings in the UI. **Delete**: delete in the UI, uninstall with “delete data”, or remove the folder. |
| Deletion channel | The data folder, or email **moechz@163.com** (answered within 30 days). |
| Security measures | uid 1000 (never root), no `privileged`, no host network, no `cap_add`, no Docker socket, one published port, pinned image tag; the built-in self-update cannot replace the installed binary. |

**Full privacy policy:** [PRIVACY.md](PRIVACY.md) —
<https://github.com/Moechz/threadfin/blob/main/PRIVACY.md> — and the website version at
<https://www.moechz.com/privacy.html>. The package `help` field opens it directly.

## Third-party services (API disclosure)

The developer operates no server in this path. The application contacts only the endpoints
below: the IPTV / EPG / logo addresses you configure, GitHub for the update check, public
CDNs for the web UI assets, and Docker Hub for the image pull. Your media servers connect
**to** the app on the LAN.

| Service | Endpoint | Data sent | Destination / region |
|---|---|---|---|
| IPTV playlist | the M3U URL you enter in Settings | a playlist request; the URL may contain the provider credentials you stored | your IPTV provider's server |
| IPTV streams (proxy) | the stream URLs in that playlist | your player's stream request, proxied; the provider sees your NAS's IP and the requested stream | your IPTV provider's server |
| XMLTV guide | the guide URL you enter in Settings | a guide request (credentials if in the URL) | your EPG provider's server |
| Channel logos | the image URLs in the playlist | an image request | whichever host the provider lists |
| Web UI assets (every page) | `cdn.jsdelivr.net` (Bootstrap), `cdnjs.cloudflare.com` (Font Awesome, clipboard.js) | your browser's IP address and user agent, the asset requested — no playlist or stream data | Cloudflare, US/EU |
| Update check | `api.github.com/repos/Threadfin/Threadfin` (and `github.com/.../releases` only if an update is found) | release metadata; no user data | GitHub, US |
| Media servers / players | the address of this app that you give them | tuner and guide requests | your LAN |
| HDHomeRun discovery (SSDP) | multicast on the local network | discovery messages | your LAN |
| Image pull at install | `registry-1.docker.io` or your registry mirror | anonymous pull | Docker Hub, US / your mirror |

See `PRIVACY.md` §6 for the same table with more detail. There is no telemetry and no
advertising SDK.

## Licence and attributions

| Component | Licence | Notes |
|---|---|---|
| Threadfin | MIT | <https://github.com/Threadfin/Threadfin> — upstream application, used unmodified inside the image |
| `fyb3roptik/threadfin:1.2.37` image | MIT (application); bundled ffmpeg/VLC under their own licences | Docker Hub image of the upstream release, pulled at install time |
| This packaging (compose file, metadata, translations, icon, webui.bz2) | MIT | see `LICENSE` |

“Threadfin”, “TerraMaster” and “TOS” are trademarks of their respective owners. This is an
independent community package by Moechz; it is not affiliated with or endorsed by the
Threadfin project or TerraMaster. The icon is a generic “play” mark, not the upstream logo.
Full details: [NOTICE.md](NOTICE.md).

## Design highlights

- **Non-root.** `user: "1000:1000"`; verified on real hardware (the container reports uid 1000).
- **Fixed image tag, never `:latest`**, Docker Hub only, no `privileged`, no `network_mode: host`, no Docker socket, no `cap_add`.
- **Health check** with the image's own `curl` against the app on container port 34400.
- **Deterministic build**: GNU tar with uid/gid 0 and zeroed timestamps, gzip without a timestamp.
- **Front-end bundle** `webui.bz2` (a redirect page) so the package satisfies the review's
  `path` + front-end-bundle rule while keeping the four Docker core files untouched.

## Runtime file manifest

Everything the application writes on the NAS lives inside its own configuration directory;
the container-internal `/tmp/threadfin` is discarded with the container.

| Path | Purpose | Created when | Growth bound | Lifecycle |
|---|---|---|---|---|
| `/Volume1/DockerAppData/threadfindocker/conf` | settings, account, channel list, guide data, mappings, logo cache, backups | on first start / on demand | bounded by your playlist and guide | persistent; kept on uninstall unless you ask to delete it |

The application logs to stdout/stderr only (`docker logs threadfindocker`); it does not
write a log file on the NAS.

## Build

```bash
scripts/build-dual.sh 1.2.37-4      # both architectures
scripts/add-webui.sh                # add the webui.bz2 front-end bundle + refresh hashes
```

`scripts/build.sh` stages the four files, substitutes the version/platform placeholders,
removes CRLF/BOM/AppleDouble, then runs `tools/verify.py`, a review-standards self-check
(archive layout, JSON validity, required fields, 14+ language coverage, version consistency,
Docker-Hub-only images, fixed tag, reserved/recommended host ports, non-root user,
per-service healthcheck/TZ/restart, data path below the application data root, never the
`/Volume*` wildcard, comment-free sequence blocks, `x-app-meta` position, no literal
secrets, and the SVG size/element limits). `scripts/add-webui.sh` then adds the bundle and
rewrites the `.sha256` sidecars.

## Local verification

```bash
./TOSAppSelfTestingTool -c out/threadfindocker_x86_64.tar.gz    # official spec check
./TOSAppSelfTestingTool -c out/threadfindocker_aarch64.tar.gz
bash test/install-and-verify.sh                  # on-device E2E (needs root)
```

The official tool reports the extra `webui.bz2` as a `D20` warning (four core files plus the
bundle); the check still passes, which is the same result the review's F22 fix expects.

> Docker applications cannot be side-loaded through the App Center's manual install page
> (it accepts `.deb` only); the official self-testing tool's `-i` mode or `docker compose`
> are the only ways to install one for testing.

## Store submission checklist

1. Public GitHub repo (code + README only).
2. Release **tag `v1.2.37-4`** with four assets:
   `threadfindocker_x86_64.tar.gz` + `.sha256`,
   `threadfindocker_aarch64.tar.gz` + `.sha256`.
3. Developer platform: two App records with the same ID `threadfindocker`, package type
   Docker, architectures `x86_64` and `aarch64`.
4. Version Management → Add Version `1.2.37-4` for each architecture → automated validation
   → review.

## Limitations

- The application runs inside a container; data lives in the configuration folder under
  `/Volume1/DockerAppData/threadfindocker/`.
- Only x86_64 and aarch64 are packaged; the image also ships an arm/v7 build, but TOS only
  accepts the two declared architectures.
- The image is the latest upstream release (1.2.37, 2025-09-11); no newer upstream image
  exists at the time of writing. The package is rebuilt when upstream ships one.
- The web UI is plain HTTP on the LAN; put it behind a TLS reverse proxy before exposing it
  to the internet.
- Docker applications cannot be updated in place by the App Center; uninstall and reinstall
  to upgrade — the data folder is kept by default.

## Support

- Issues and questions: <https://github.com/Moechz/threadfin/issues>
- Email: moechz@163.com
- Privacy: [PRIVACY.md](PRIVACY.md) · Licence: [NOTICE.md](NOTICE.md)

---

Packaged for TOS 7 by Moechz. Upstream image used unmodified from Docker Hub.
