# Google Play listing

Everything needed for the Noel Raffle store listing in English (`en-US`), Turkish (`tr-TR`) and
Arabic (`ar`). The folder follows the [fastlane supply](https://docs.fastlane.tools/actions/supply/)
layout, so it can be uploaded by hand or with fastlane.

```
Production/
├── metadata/android/<language>/
│   ├── title.txt                 # App name, max 30 characters
│   ├── short_description.txt     # Max 80 characters
│   ├── full_description.txt      # Max 4000 characters
│   ├── changelogs/default.txt    # "What's new", max 500 characters
│   └── images/
│       ├── icon.png              # 512 × 512
│       ├── featureGraphic.png    # 1024 × 500 (the cover banner)
│       └── phoneScreenshots/     # 6 annotated screenshots, 1080 × 1920
└── tool/                         # Generator for all images
```

| Text | en-US | tr-TR | ar | Limit |
| --- | --- | --- | --- | --- |
| Title | 25 | 29 | 27 | 30 |
| Short description | 74 | 79 | 69 | 80 |
| Full description | 2411 | 2501 | 2180 | 4000 |
| What's new | 389 | 401 | 353 | 500 |

All images are 24-bit PNGs without an alpha channel, as Play requires for screenshots and the
feature graphic. The screenshots show the real app with language-specific sample data:

1. Home: the two raffle types
2. Participants: adding people, with the step indicator
3. Secret reveal: the pass-the-phone result dialog (dark theme)
4. Reveal progress: who has already looked
5. Gift raffle results (dark theme)
6. Settings (light) and history (dark) side by side

## Uploading

**Automatically:** the release workflow (`.github/workflows/release.yml`) runs `fastlane supply`
on this folder after each app upload. A push to `dev` validates the listing without publishing
it; a push to `main` publishes the texts and images. Unchanged images are skipped. So editing a
text or regenerating the images and merging to `main` is all it takes.

**By hand:** Play Console → the app → *Grow users → Store presence → Main store listing*. Fill in
the texts and images for the default language, then use *Manage translations* to add Turkish and
Arabic. Paste `changelogs/default.txt` into the release notes of the new release for each
language.

**With fastlane** (needs a Play service account key):

```bash
fastlane supply --metadata_path Production/metadata/android \
  --json_key <service-account.json> --package_name com.muhammed.noel_raffle \
  --skip_upload_apk --skip_upload_aab
```

`changelogs/default.txt` is used for any version. To tie the notes to one build, rename it to
`<versionCode>.txt`. Builds are uploaded by GitHub Actions, which sets the version and uses
`changelogs/default.txt` as release notes (see the main README, "Continuous delivery").

## Regenerating the images

After UI or copy changes, run from the project root:

```bash
flutter test Production/tool/store_assets.dart
```

It drives the real screens with the sample data in `tool/src/store_locale.dart`, frames them and
writes every image for all three languages, plus the project README showcase
(`screenshots/screen.png`). Captions and sample data live in the same file.

## Notes

- The listing mentions online result codes because release builds ship with Firebase: the
  release workflow restores `lib/firebase_options.dart` from its secrets. Builds without it
  hide that feature.
- Claims in the texts match the app: the draw runs offline on the device, no account is needed,
  nobody draws their own name, each person wins at most one gift, only published results and
  anonymous statistics are stored online, and emails are never uploaded.
