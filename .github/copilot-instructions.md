# Copilot / AI Assistant Instructions for TOKOKITA

This contains concise, codebase-specific guidance to help AI coding agents work productively on TOKOKITA (a Flutter mobile app).

Quick architecture summary
- Flutter app (mobile, multi-platform) with main entry: `lib/main.dart`.
- UI pages sit under `lib/ui/` and are standard `StatefulWidget`/`StatelessWidget` pages.
- Business-logic layer uses very small `bloc` classes under `lib/bloc/` with static `Future` methods (not the official flutter_bloc package):
  - Example: `LoginBloc.login(email, password)` returns a `Login` model.
- Networking: central wrapper in `lib/helpers/api.dart` which handles GET/POST/PUT/DELETE and token injection via a `UserInfo` helper.
- API endpoints: single source in `lib/helpers/api_url.dart` — modify `baseUrl` and endpoints there (local backend: `http://10.99.4.18:8080/`).
- Models live in `lib/model/` and are plain Dart POJOs used by the UI and blocs.
- Local storage: `SharedPreferences` via `lib/helpers/user_info.dart` for token and user ID.

Key file locations & patterns
- `lib/main.dart` — entry, chooses `LoginPage` or `ProdukPage` from saved token.
- `lib/helpers/api.dart` — do not call `http` directly in UI; use `Api().get/post/put/delete(...)` to ensure consistent header/auth handling and error mapping.
- `lib/helpers/api_url.dart` — add endpoints here and use them from bloc methods.
- `lib/bloc/*_bloc.dart` — small static methods that call `Api()` and `json.decode(response.body)`, returning models or status flags.
- `lib/widget/*` — shared widgets (success/warning dialogs).

Patterns and conventions that matter
- “BLoC” is implemented as a collection of static functions — add new operations by adding a new method in the appropriate `bloc` file.
  - Avoid introducing long-lived bloc objects or streams unless necessary — follow the current single-call style.
- Always use `ApiUrl` values for endpoints; avoid hardcoding strings outside `api_url.dart`.
- API token/ID management should go through `UserInfo` to ensure consistent storage and retrieval.
- JSON decoding occurs within `bloc` methods; prefer returning model classes from these methods (see `ProdukBloc.getProduks`).
- Error handling: `Api` maps HTTP response codes to custom exceptions (see `lib/helpers/app_exception.dart`) — UI should handle `.onError` when calling bloc methods and surface friendly dialogs using `WarningDialog`.
- UI navigation: use `Navigator.pushReplacement` for login flows and `Navigator.push/MaterialPageRoute` for normal navigation.

Developer workflow & commands (Windows / PowerShell)
- Set up dependencies and check SDK:
  ```powershell
  flutter doctor
  flutter pub get
  flutter analyze
  flutter format .
  flutter test
  ```
- Run app on device/emulator: `flutter devices` then `flutter run -d <deviceId>`.
- Common build tasks:
  - `flutter clean` (clear build artifacts)
  - `flutter build apk` | `flutter build ios` (CI / release builds)
- When backend is required: ensure local backend is running and `ApiUrl.baseUrl` points to a reachable address.

Known pitfalls and troubleshooting
- Local backend URL: `lib/helpers/api_url.dart` uses IP `10.99.4.18`; update to your host IP or emulator equivalent if backend is remote or different.
- Snapshot mismatch / wrong full snapshot version error (when running Flutter):
  - Common cause: stale engine snapshot or mismatched Flutter SDK vs built artifacts. Fix steps:
    ```powershell
    flutter clean
    flutter pub get
    flutter pub cache repair
    Remove the `build/` directory if needed (git clean -xfd will remove more — use with caution)
    flutter run -v
    ```
  - If the error persists: ensure the Flutter SDK version matches the one used previously and reinstall/update Flutter: `flutter upgrade` or `flutter downgrade <version>`.
  - On Windows, also check `windows/flutter/ephemeral` and `build/windows` artifacts if building for desktop; delete ephemeral directories and re-run.
  - Example Windows troubleshooting (PowerShell):
    ```powershell
    flutter clean
    flutter pub get
    flutter pub cache repair
    # Remove local build artifacts (be cautious, this deletes build/)
    Remove-Item -Recurse -Force .\build\
    Remove-Item -Recurse -Force .\windows\flutter\ephemeral\
    flutter precache
    flutter doctor
    flutter run -v
    ```
  - If the flutter tool itself is failing before `doctor` runs (wrong snapshot version on `flutter --version`), it means the local Flutter SDK tools are corrupted or mismatched. Try the following in PowerShell from the SDK folder or project root:
    ```powershell
    # Show which flutter binary is used and where
    Get-Command flutter | Select-Object -ExpandProperty Source

    # Remove cached engine artifacts and compiled snapshots that may be out of sync
    # Replace the path below if your Flutter SDK is in a different location
    Remove-Item -Recurse -Force D:\Flutter\flutter\bin\cache

    # Then run flutter again so it can re-create the cache
    # Use the SDK's explicit path to avoid PATH confusion
    D:\Flutter\flutter\bin\flutter.bat doctor -v
    D:\Flutter\flutter\bin\flutter.bat precache
    D:\Flutter\flutter\bin\flutter.bat run -v
    ```
  - If the problem persists, re-download or re-clone the Flutter SDK and reinstall it (or use FVM to pin an SDK version to the project). Example using a fresh install (Windows):
    1) Move the current Flutter SDK folder aside (or delete it after backup):
       ```powershell
       # If you want to move (safe):
       Move-Item -Path D:\Flutter\flutter -Destination D:\Flutter\flutter_backup_$(Get-Date -Format yyyyMMdd_HHmmss)
       ```
    2) Download and unzip the SDK again (manual or via `git`):
       - Git approach (recommended for future upgrades):
         ```powershell
         git clone https://github.com/flutter/flutter.git -b stable D:\Flutter\flutter
         ```
    3) Add the SDK to PATH and run `flutter doctor`.
  - Debugging tips:
    - If `Get-Command flutter` shows another flutter in PATH, remove or reorder PATH to use the correct SDK.
    - If the SDK is under version control (git) and modified, run `git clean -xfd` and `git pull` inside the SDK to restore a clean state.

- Token issues: `UserInfo` stores token as a String — ensure `setToken` and `getToken` follow that contract, and use `UserInfo()` consistently.
- IDs are sometimes stored as `int` but used as `String` in UI — double-check type conversions (e.g., `int.parse(produk.id!)` in `ProdukBloc`).

Minor code smells to watch
- `ApiUrl.baseUrl` currently contains a trailing slash (`http://10.99.4.18:8080/`). Combined with endpoint concatenation (`baseUrl + '/login'`) this creates double-slashes in some URLs (e.g. `http://10.99.4.18:8080//login`). Not fatal, but consider removing the trailing slash to avoid confusion.

When adding changes or features
- Add backend endpoints to `api_url.dart` and call through `Api()` from a new bloc method.
- Return typed model classes from bloc methods; if returning raw JSON, document it in the method comment.
- For UI changes, follow `lib/ui/*` patterns (small Stateless/Stateful widgets and `MaterialPageRoute` navigation).
- Add consistent messaging and handle errors using `WarningDialog` / `SuccessDialog` widgets for user-facing messages.

Good examples from the repo
- Login & persistence: `lib/ui/login_page.dart` + `lib/bloc/login_bloc.dart` + `lib/helpers/user_info.dart`.
- CRUD for products: `lib/bloc/produk_bloc.dart` + `lib/ui/produk_page.dart` + `lib/helpers/api_url.dart`

What to ask the maintainers (if unclear)
- Is there a canonical Flutter SDK version or channel to use (stable/dev) for reproduction and CI?
- Is the backend always local at `10.99.4.18` or should we use a configuration/secrets file for endpoint switching?
- Any additional styling or UI libraries expected when adding new UI pages?

If you need more details or a different format (shorter/longer or checklists for PR review), let me know and I will iterate.
