# TLI Tracker on Linux (Omarchy / Arch)

Unofficial Linux repack of [Giboork/TLI-tracker-translated](https://github.com/Giboork/TLI-tracker-translated)
(YiHuo ETor, English). No upstream code is stored here: `PKGBUILD` downloads the
upstream release, applies `patch-app.js`, and repacks it for Linux Electron.

## Install

```sh
git clone -b linux-build https://github.com/ramongtx/TLI-tracker-translated
cd TLI-tracker-translated/linux
makepkg -si
```

Needs network at build time (`npx` fetches `@electron/asar`). Installs the
`electron` package as a dependency.

## Run

Launch **TLI Tracker** from the app launcher (`Super+Space`), or run `tli-tracker`.

1. Start Torchlight: Infinite (Steam/Proton).
2. In the tracker, select the game log manually (auto-detect is Windows-only):

   ```
   ~/.local/share/Steam/steamapps/common/Torchlight Infinite/UE_game/TorchLight/Saved/Logs/UE_game.log
   ```

   Path may differ by install; search with
   `find ~/.local/share/Steam -name UE_game.log`.
3. Use windowed/borderless mode in-game for the overlay to be visible.

App data lives in `~/.config/etor`.

## What the patch changes

- Windows updater disabled (it downloads `.exe` files and needs elevation).
- `run-shell-command` IPC stubbed. The UI is loaded from the upstream author's
  server, so a remote page must not get shell access.

The UI still loads from `https://etor-beta.710421059.xyz`, so network is required.

## Update to a new upstream release

```sh
cd TLI-tracker-translated/linux
./update.sh          # bumps pkgver + sha256 in PKGBUILD to the latest release
makepkg -si          # rebuild and reinstall
```

If `makepkg` fails in `prepare()` with `expected 1 match, found 0`, upstream
changed `build/obf-app/main.js`. Edit `patch-app.js` to match, then rebuild.

### Publish the update to the fork

```sh
git checkout linux-build
./linux/update.sh
git commit -am "chore(linux): bump to <version>"
git push origin linux-build
```

Keep the fork's `main` in sync with upstream (README/licenses only):

```sh
gh repo sync ramongtx/TLI-tracker-translated --source Giboork/TLI-tracker-translated
git checkout linux-build && git merge origin/main
```

## Notes

- Not tested against every Electron version; if the app fails to start, check
  `electron --version` and `tli-tracker` output in a terminal.
- No license is declared upstream for the translation. Don't redistribute built packages.
