# Changelog

All notable user-visible changes to the Threadfin TOS application package.

## 1.2.37-4 — 2026-11-19

Remediation of the 2026-11-15 review of `1.2.37-2` (11 items).

### Added
- **Front-end bundle `webui.bz2`** (F22/F07/F02): a one-page bundle that redirects the App
  Center's internal page to the application on port 8066. The package now satisfies the
  “`path` declared → ship `webui.bz2`” rule; the official self-test accepts it with the
  expected `D20` extra-entry warning.
- **Privacy policy** (`PRIVACY.md`) written for Threadfin: what is stored in the
  configuration folder, retention, user rights, security measures, the deletion channel and
  every endpoint the app contacts (IPTV playlist, stream proxy, XMLTV, channel logos, the
  public CDNs of the web UI, GitHub update check, Docker Hub).
- **Licence notice** (`NOTICE.md`): upstream MIT, the Docker Hub image and its digest, the
  bundled ffmpeg/VLC, and the MIT licence of this packaging.
- README sections for privacy, third-party services, licence and support.

### Fixed
- The Simplified and Traditional Chinese descriptions described a **different application**
  (a habit tracker, `beaverhabitsdocker`); they now describe Threadfin.
- The `important` text said `http://<NAS-IP>:port/web/` (a literal `port`) and described a
  first start that does not exist; it now says the first visit creates the administrator and
  points at `http://<NAS-IP>:8066/web/`.
- The package `help` field now opens the privacy policy instead of the issue tracker
  (C3/C5).
- Removed stale build metadata from `tosapp.json` (a probe block for another application and
  an `entrypoint_file` that does not exist).

## 1.2.37-3 — 2026-11-17

- Added a first privacy policy / licence notice / README compliance sections. This version
  was submitted but withdrawn before review; it is superseded by `1.2.37-4`, which also
  corrects the package texts and adds `webui.bz2`.

## 1.2.37-2 — 2026-11-12

### Changed
- Icon: replaced the letter monogram with a functional vector mark that describes what the
  app does (the upstream project does not publish a compliant SVG).

## 1.2.37-1 — 2026-11-11

### Added
- First release. Threadfin (`fyb3roptik/threadfin:1.2.37`, Docker Hub official image,
  unmodified) packaged as a TOS 7 Docker application, published on port 8066 and running as
  a non-root user (1000:1000).
- Persistent data is kept under `/Volume1/DockerAppData/threadfindocker/`.
