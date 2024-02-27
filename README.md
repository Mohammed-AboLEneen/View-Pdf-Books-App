# View-Pdf-Books-App

## Description

This Flutter app empowers users with an engaging and interactive reading experience, offering:

* **Secure Google Sign-in:** Seamlessly authenticate users using their existing Google accounts.
* **Extensive Book Library:** Explore and browse a diverse collection of books across various genres.
* **Offline Reading:** Download books directly within the app for reading enjoyment anywhere, anytime.
* **Enhanced Comprehension:** Highlight key passages and add personalized comments to enrich learning.
* **Persistent Annotation Storage:** Save highlights and comments locally or to a remote storage service (e.g., Cloud Firestore) for consistency across app sessions.

## Key Technologies

* **Flutter:** [https://flutter.dev/] (Cross-platform development framework)
* **Firebase:** [https://firebase.google.com/] (Backend services for authentication, storage, etc.)

## Getting Started

Before you begin, ensure you have:

* **Flutter SDK installed:** [https://docs.flutter.dev/get-started/install]
* **Firebase project set up:** [https://firebase.google.com/docs/projects/api/workflow_set-up-and-manage-project]

**Steps:**

1. **Clone the repository:**

   ```bash
   git clone https://github.com/Mohammed-AboLEneen/View-Pdf-Books-App/.git

2. **Configure Firebase:**
   * Follow Firebase documentation to integrate it into your Flutter project: https://firebase.google.com/docs/flutter/setup.
   * Enable necessary services like Authentication, Storage (for book downloads), and Cloud Firestore (optional, for storing annotations).
   * Replace placeholders in lib/services/firebase_service.dart with your actual Firebase project configuration (API key, etc.).

4. **install dependencies:**

   ```bash
   flutter pub get

5. **Run app:**

   ```bash
   flutter run

   
