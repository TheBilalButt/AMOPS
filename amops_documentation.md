# AMOPS: Autonomous Military Operations Platform System
### HIT & MHIL Command & Control Platform Documentation

This document provides a comprehensive overview of the technical architecture, implemented concepts, and functional modules of the **AMOPS** mobile/web application developed for **Heavy Industries Taxila (HIT)** and **Margalla Heavy Industries Limited (MHIL)**.

---

## 🛠️ Technology Stack & Class Core Concepts Used

The application is built strictly using the standard, robust Flutter framework concepts taught in class, with advanced features integrated in an elegant, structured, and easy-to-understand structure.

### 1. State Management: Riverpod
*   **Purpose:** Act as the single source of truth for the application's state, decoupling UI from business logic.
*   **Providers Implemented:**
    *   `authProvider` (`AuthNotifier`): Manages user login, signup, current session state, and Role-Based access rights.
    *   `vehicleProvider` (`VehicleNotifier`): Manages state streams for the military armored vehicles.
    *   `droneProvider` (`DroneNotifier`): Manages drone operations (launch, return to base, signal status, battery metrics).
    *   `supabaseProvider` (`SupabaseNotifier`): Streams secure operations data and synchronizes logs between databases.
    *   `alertProvider`: Real-time operational alert logs.
    *   `threatProvider`: Monitors AI threat levels (Low, Medium, High, Critical).

### 2. Dual Database Synchronization (Firebase & Supabase)
*   **Firebase Authentication:** Handles secure user authentication state.
*   **Firebase Cloud Firestore:** Main cloud database storing vehicle, drone, and threat telemetry in real-time.
*   **Supabase:** Serves as the backup and audit replication backend. The *Supabase Sync Hub* demonstrates synchronization logs and directly inserts threat activity details to the Supabase Cloud.
*   **SQLite Caching:** Offline cache module designed to cache critical assets (`vehicles_cache`, `drones_cache`) to ensure uninterrupted operation when internet connectivity is lost.
*   **Shared Preferences:** Saves user role sessions locally so users don't have to select a role on every app launch.

### 3. Animations & Lotties
*   **Lottie Animations:** Fully local vector Lottie animations loaded securely via `Lottie.asset` (bypassing browser CORS issues on Flutter web). It provides a military-grade security loader scanning logo on the login and synchronization screens.
*   **Implicit UI Animations:** Clean animated buttons, state changes, transitions, and loading bars that elevate the visual feedback of the application.

---

## 📂 Project Structure & Module Directory

The app is organized cleanly using a modular feature-first layout:

```
lib/
│
├── app/                  # App initialization & Shell layout (AppDrawer, BottomNavigationBar)
├── core/
│   ├── constants/        # Application styling colors, strings, and theme details
│   ├── database/         # SQLite offline database configuration (DatabaseHelper)
│   └── services/         # Supabase connection & live audit service initialization
│
├── models/               # Strongly-typed data models (User, Vehicle, Drone, AuditLog)
│
├── providers/            # Riverpod State Notifiers and database streams
│
├── widgets/              # Reusable class-taught standard components (StatCard, LottieLoader)
│
└── screens/
    ├── auth/             # Login Screen (featuring Role Selection Cards) & Signup Screen
    ├── dashboard/        # Command Center Dashboard with telemetry graphs (fl_chart)
    ├── fleet/            # Fleet Management with separate Drones & Armored Vehicles tabs
    ├── maintenance/      # Fleet repair logging and request logs
    ├── manufacturing/    # HIT & MHIL assembly pipeline logs
    ├── sales/            # Export records and international defense sales DataTable
    ├── ai_assistant/     # AI assistant screen for operational tactical queries
    └── supabase_sync/    # Supabase operations stream & live synchronized audit hub
```

---

## ⚡ Key Working Modules of the App

### 🔑 1. Role-Based Login & Security (Bypassed Credentials)
*   **The Problem solved:** Manually entering emails/passwords slows down presentations.
*   **How it works:** The login page features beautiful military role selection cards: **Base Commander**, **Logistics Officer**, and **Fleet Operator**.
*   **Security Access:**
    *   **Base Commander:** Full control. Can see every single screen (Dashboard, Fleet, Maintenance, Manufacturing, Sales, and Supabase).
    *   **Logistics Officer:** Restricted access. Can only access general parameters. Sensitive operational areas (Manufacturing, Sales, and Supabase Hub) are **hidden** from their drawer menu.
    *   **Fleet Operator:** Tailored view focused on drone controls and vehicle deployments.

### 🚜 2. HIT & MHIL Armored Fleet Management
*   **Telemetry tracking:** Live display of fuel levels, ammunition capacities, readiness percentages, and engine operating hours.
*   **Authentic Pakistan Assets Displayed:**
    *   *Al-Khalid MBT*
    *   *Al-Zarrar MBT*
    *   *Haider MBT*
    *   *Talha APC*
    *   *Saad APC*
    *   *Maaz ATGM Carrier*
*   **Interactive Controls:** Users can tap "Deploy" or "Send to Maintenance" to instantly trigger database status updates, modifying the UI parameters in real-time.

### 🛸 3. Unmanned Combat Aerial Vehicles (UCAV) & Drones
*   **State indicators:** Monitors flight battery life, signal bandwidth, operational camera status, and active altitudes.
*   **Authentic Drones Included:**
    *   *Burraq UCAV*
    *   *Shahpar-II UCAV*
    *   *GIDS Uqab*
    *   *GIDS Shahpar*
*   **Interactive Drone Missions:** Trigger "Launch Mission", "Abort Mission", or "Return to Base" to witness instant Riverpod state modifications and visual feedback indicators change colors accordingly.

### 📊 4. Interactive Telemetry Charts & Datatables
*   Uses `fl_chart` to render a 7-day visual operation history chart.
*   Uses `DataTable` on the Sales Screen to display chronological export transactions and financial figures in a clear, formatted layout.

---

## ⚙️ How to Compile and Run
1. Navigate to the project root: `cd d:\AMOPS\AMOPS`
2. Get packages: `flutter pub get`
3. Launch on Chrome (Release mode for maximum performance):
   ```bash
   flutter run -d chrome --release --web-port 8083
   ```
