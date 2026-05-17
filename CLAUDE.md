# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project overview

NJTech campus network auto-login scripts. No build system, package manager, or test suite — this is a pair of standalone scripts deployed directly on target devices.

## Scripts

- **`login_openwrt.sh`** — Bash script for OpenWrt routers. Cron-triggered to check connectivity (`curl -IsS baidu.com`) and re-login when needed.
- **`login_windows.bat`** — Windows batch equivalent. Same check-then-login pattern via `ping` + `curl`.

## Login portal

Both scripts POST credentials to the campus portal at `http://10.50.255.11`. The portal API endpoints differ between the two scripts:

- OpenWrt uses: `/eportal/portal/login?callback=dr1003&login_method=1&...`
- Windows uses: `/eportal/?c=ACSetting&a=Login&protocol=http:&...` with additional headers and `--data-raw`

## WAN IP detection

- OpenWrt: reversed — pulls from `http://10.50.255.11/a79.htm` via `sed` extraction (preferred). Commented-out alternative uses `ifconfig eth0`.
- Windows: scrapes `ipconfig` output for `IPv4`.

## Configuration

Credentials are defined in two places, with **script values taking priority**:

1. `.env` (lower priority) — sourced by both scripts at runtime if present. Not tracked by git.
2. Script-inline variables (higher priority) — `USERID`, `PASSWORD`, `CHANNEL` at the top of each script. Comment these out to delegate entirely to `.env`.

Copy `.env.example` to `.env` and edit with real credentials. The `.env` file is gitignored.
