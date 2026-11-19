# Privacy Policy — Threadfin for TerraMaster TOS (`threadfindocker`)

**Last updated:** 19 November 2026
**Data controller / contact:** Moechz — moechz@163.com

This policy covers the TOS application `threadfindocker` (the “app”) and its packaging. The
app runs the official `fyb3roptik/threadfin:1.2.37` container image, unmodified, on your own
NAS.

## 1. Summary

- The app runs **entirely on your NAS**. The developer does not receive, collect or have
  access to your data, and operates no server that the app talks to.
- No telemetry, no analytics, no advertising and no account with the developer.
- The app contacts **only** the IPTV playlist / EPG / logo addresses **you configure**, plus
  GitHub (update check) and the Docker image registry at install time. The web UI loads its
  Bootstrap / Font Awesome / clipboard.js assets from public CDNs. Your media servers on the
  LAN connect **to** the app; it does not call them.
- Every endpoint, the data sent and its destination are listed in §6.

## 2. What data is processed

| Container path | Stored on the NAS at |
|---|---|
| `/home/threadfin/conf` | `/Volume1/DockerAppData/threadfindocker/conf` |

That folder holds the application's own state, written by Threadfin:

- `settings.json` — the web UI settings, including the IPTV playlist URL, the XMLTV guide
  URL, the tuner count and the web UI login;
- `authentication.json` — the web UI account you create on the first visit (salted password
  hash, session data);
- `data/` — the imported channel list, guide data and the channel mappings (`m3u.json`,
  `xml.json`, `xepg.json`, `pms.json`);
- `cache/images/` — channel logos and images downloaded from the URLs in your playlist;
- `backup/` — the configuration backups you create in the UI.

**No video is stored.** Threadfin proxies the live streams between your IPTV provider and
your player; nothing is recorded to disk by the app. The playlist and EPG URLs may contain
provider credentials — they are kept in the configuration folder on your NAS and are not
sent to the developer.

Logs go to the container's stdout/stderr (`docker logs threadfindocker`); the package sets
no log file path and writes no log file on the NAS.

## 3. Retention period

- **Configuration, channel list and mappings:** kept until **you** delete them. There is no
  automatic expiry and no upload. Uninstalling the app keeps the folder unless you tick
  “delete data”.
- **Playlist / EPG data:** refreshed from the provider you configured on the schedule you set
  in the UI; the previous copy is replaced.
- **Logo cache:** downloaded on demand and kept until you clear it or delete the folder.
- **Logs:** live in the container's stdout/stderr; Docker rotates them according to the log
  driver configured on your NAS.

## 4. Your rights and the deletion channel

| Right | How |
|---|---|
| Access / export | Copy the folder `/Volume1/DockerAppData/threadfindocker/` — the configuration and data are plain JSON files; the UI also has a backup function. |
| Correct | Change the settings, playlist, guide or mappings in the app's own web UI. |
| Delete | Delete the entries in the web UI, uninstall the app with “delete data”, or stop the container and remove `/Volume1/DockerAppData/threadfindocker/`. |
| Assistance | Email **moechz@163.com** with the subject “Threadfin data request”; a reply follows within 30 days. |

The developer holds no copy of your data, so deletion is normally completed by removing the
folder on your own NAS. The e-mail channel exists for questions and for requests about the
website or the publishing records.

## 5. Security measures

- The container runs as **uid 1000**, never root; no `privileged`, no `cap_add`, no host
  network, no Docker socket, no volumes beyond its own configuration folder.
- Only one port is published (`8066` on the NAS → `34400` in the container).
- The image tag is **pinned** (`fyb3roptik/threadfin:1.2.37`, the latest upstream release);
  the package is rebuilt when upstream ships fixes.
- The configuration folder is owned by the application user and not world-readable.
- The web UI has its own login. The first visit asks you to create the administrator account;
  no default account or password is shipped.
- The app's built-in self-update cannot replace the installed binary because the container
  user does not own it — updates come from the package, through the App Center.
- The web UI is served over **plain HTTP on your LAN**. Put it behind a TLS reverse proxy
  before exposing it to the internet.

## 6. Third-party sharing and API disclosure

The developer shares nothing and receives nothing. The app contacts only the endpoints below.

| Service | Endpoint | Data sent | Destination / region |
|---|---|---|---|
| IPTV playlist | the M3U URL you enter in Settings | a playlist request; the URL may contain the provider credentials you stored | your IPTV provider's server |
| IPTV streams (proxy) | the stream URLs contained in the playlist | your player's stream request is proxied to the provider; the provider sees your NAS's IP address and the requested stream | your IPTV provider's server |
| XMLTV guide | the guide URL you enter in Settings | a guide request; the URL may contain credentials | your EPG provider's server |
| Channel logos | the image URLs listed in your playlist | an image request | whichever host the provider lists |
| Web UI assets (every page) | `cdn.jsdelivr.net` (Bootstrap) and `cdnjs.cloudflare.com` (Font Awesome, clipboard.js) | your browser's IP address and user agent, the asset requested — no account, playlist or stream data | Cloudflare, US/EU |
| GitHub update check | `api.github.com/repos/Threadfin/Threadfin` | a release-metadata request; no account or user data | GitHub, US |
| GitHub update download (only if the automatic update finds a new release) | `github.com/Threadfin/Threadfin/releases` | a binary download; in this package the container user cannot replace the binary, so the update does not modify the installed app | GitHub, US |
| Media servers / players on your LAN | the address of this app that you give them | their tuner and guide requests; the data stays on your LAN | your LAN |
| HDHomeRun discovery (SSDP) | multicast on the local network | discovery messages; no data leaves your LAN | your LAN |
| Image pull at install | `registry-1.docker.io` or your registry mirror | anonymous pull | Docker Hub, US / your mirror |

There is **no telemetry**, no analytics SDK, no advertising and no update service other than
GitHub. No data is sold or shared.

## 7. Children

The app is a self-hosted utility and is not directed at children.

## 8. Changes

Material changes are published in this file and reflected in the “Last updated” date.

## 9. Contact

- Moechz — **moechz@163.com**
- Package repository and issues: <https://github.com/Moechz/threadfin>
- Website privacy page: <https://www.moechz.com/privacy.html>
