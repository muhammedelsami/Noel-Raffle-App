# Noel Raffle App

A Flutter app for running raffles with friends, family or colleagues. It needs no
server: every raffle is drawn on the phone. Firebase's free Spark plan is optional
and adds online result codes.

# Screenshots

![Noel Raffle: splash, home, participants, secret reveal and gift results](screenshots/screen.png)

## Features

### Raffles

- **New Year raffle (Secret Santa):** everyone is assigned one person to buy a gift for.
  The draw forms a single circle, so nobody draws themselves and no two people just swap.
- **Gift raffle:** list the gifts (with quantities) and they are handed out to random
  participants, with at most one gift per person. The app warns right away when there are
  more gifts than participants.
- **Step-by-step setup:** name the raffle, add a note for everyone (such as the gift budget
  or the exchange date), then add the participants and gifts. A progress bar shows each
  step, and the same name can't be added twice.

### Results

- **Secret results on one phone:** results stay hidden. Pass the phone around; each person
  taps their own name and sees only their own result. A progress bar shows how many people
  have already looked.
- **Share results** one by one through WhatsApp, SMS or any app, or by email from your
  own mail app (participant emails are optional). Gift raffle winners can be shared as one
  list.
- **Online codes (optional, Firebase):** every participant gets a personal code and sees
  only their own result under "View my result" in the app, on their own phone.

### App

- **Works offline, no account:** the draw runs on the phone, and history and statistics
  are kept on the device. With Firebase you also get totals across all users.
- **Modern design:** Material 3 with light, dark or system theme, WCAG AA contrast in both
  themes, the Alexandria font and an adaptive app icon.
- **Three languages:** Turkish, English and Arabic, with a full right-to-left layout.
  Theme and language are changed in the Settings screen.

## Getting Started

### Prerequisites

- Flutter SDK (recent stable; Dart `>=3.2.3 <4.0.0`)
- Android Studio or VS Code

### Installation

```bash
flutter pub get
flutter run
```

The app runs fully offline as is. The online features stay hidden until Firebase
is configured.

## Firebase setup (optional)

Everything below fits in Firebase's free **Spark** plan. No Cloud Functions or
billing account is needed.

1. Create a project in the [Firebase console](https://console.firebase.google.com/).
2. **Authentication → Sign-in method:** enable **Anonymous**.
3. **Firestore Database:** create a database (production mode).
4. Connect the app. This overwrites the placeholder `lib/firebase_options.dart` and adds
   the platform config files:
   ```bash
   dart pub global activate flutterfire_cli
   flutterfire configure
   ```
5. Deploy the security rules from `firebase/firestore.rules`:
   ```bash
   npm install -g firebase-tools
   firebase login
   firebase use --add            # pick your project
   firebase deploy --only firestore:rules
   ```
   You can also paste the file into **Firestore → Rules** in the console.

### What is stored

| Path | Content | Access |
| --- | --- | --- |
| `results/{code}` | One participant's result: raffle title, note, their name and their match | Read by code only (no listing); only the publishing device can delete |
| `stats/global` | Global counters (raffles, participants, gifts) | Anyone can read; each write may only add one raffle |

Emails and other participants' results are never uploaded. The full history stays on
the device.

## Development

```bash
flutter analyze
flutter test
```

The Google Play listing (texts, icon, feature graphic and screenshots in English,
Turkish and Arabic) lives in [`Production/`](Production/README.md). Its images, and the
screenshot at the top of this README, are rendered from the real app:

```bash
flutter test Production/tool/store_assets.dart
```

## Contributing

Contributions are what make the open-source community such an amazing place to learn, inspire, and create. Any contributions you make are greatly appreciated.

1. Fork the Project
2. Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3. Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the Branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## License

Distributed under the MIT License. See `LICENSE` for more information.

## Contact

Eda Barutçu - edabarutcu@protonmail.com 

Muhammed Elşami - muhammed97r@hotmail.com

Project Link: [https://github.com/muhammedelsami/Noel-Raffle-App](https://github.com/muhammedelsami/Noel-Raffle-App)
