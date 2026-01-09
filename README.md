README.md
# Flutter Task App

A **Flutter task management app** that uses **MockAPI** as a backend and **Hive** for local offline storage.  
Supports **CRUD operations**, **offline caching**, and **internet connectivity checks**.

---

## **1. How to Run the App**

### Prerequisites

- Flutter SDK installed ([Flutter installation guide](https://flutter.dev/docs/get-started/install))  
- Node.js (optional, if you want local mock server instead of MockAPI)  
- Internet connection for API calls

### Steps

1. Clone the repository:

Install dependencies:
flutter pub get

Generate Hive adapters:
flutter packages pub run build_runner build

Run the app:
flutter run

For Android emulator, Hive is fully supported.

2. Summary of Fixes / Improvements
Mutable state issue fixed:
Tasks are now updated immutably in Bloc when toggling completed status.
Previously, mutating the list directly caused the UI not to rebuild.
Offline support implemented with Hive:
API responses are saved to Hive box.
If the user has no internet, cached tasks are loaded automatically.
Internet check before API calls:
Uses real connection check (InternetAddress.lookup('example.com')).
Prevents unnecessary API calls when offline.
Hive errors fixed:
Using put(task.id, task) instead of add(task) prevents the HiveError: The same instance of a HiveObject cannot be stored with two different keys.
Error handling improved:
If API fails, the app tries to load cached tasks.
User-friendly messages shown when both API and cache fail.

3. Explanation of Offline Indicator
The app detects internet connectivity before making API calls.
If there is no internet:
The app loads tasks from Hive cache.



4. Features
Fetch tasks from MockAPI
Toggle completed status
Offline caching with Hive
Real internet connectivity checks

5. Folder Structure (Recommended)
lib/
├── main.dart
├──app/
│   └── page
	views
├──data/
│   └── model
	network
├── repositories/
│   └── task_repository.dart


6. Dependencies
flutter
http
hive
Hive_flutter
path_provider
internet_connection_checker_plus

Dev dependencies:
hive_generator
build_runner

7. Notes
Hive stores tasks locally, so offline operations are fast.
Make sure to run build_runner after changing the Task model.
UI rebuilds properly after immutable state updates in Bloc.

8. Contact / Support
For issues or improvements, please contact: mdrahamt0505@gmail.com

This `README.md` covers **all your questions**:  

1. **How to run the app**  
2. **Summary of fixes** (mutable state, Hive errors, offline handling)  
3. **Offline indicator explanation**  



