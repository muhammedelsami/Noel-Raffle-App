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
| Full description | 1669 | 1708 | 1475 | 4000 |
| What's new | 383 | 394 | 316 | 500 |

All images are 24-bit PNGs without an alpha channel, as Play requires for screenshots and the
feature graphic. The screenshots show the real app with language-specific sample data:

1. Home: the two raffle types
2. Participants: adding people, with the step indicator
3. Secret reveal: the pass-the-phone result dialog (dark theme)
4. Reveal progress: who has already looked
5. Gift raffle results (dark theme)
6. Settings (light) and history (dark) side by side

## Uploading

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
`<versionCode>.txt`. The version in `pubspec.yaml` (currently `1.0.0+8`) must be raised before
the redesigned build can be uploaded.

## Regenerating the images

After UI or copy changes, run from the project root:

```bash
flutter test Production/tool/store_assets.dart
```

It drives the real screens with the sample data in `tool/src/store_locale.dart`, frames them and
writes every image for all three languages. Captions and sample data live in the same file.

## Notes

- The listing does not mention online result codes: `lib/firebase_options.dart` is still the
  placeholder, so that feature is hidden in this build. Add it to the descriptions once Firebase
  is configured.
- Claims in the texts match the app: the draw runs offline on the device, no account is needed,
  nobody draws their own name, and each person wins at most one gift.
