# sb_mobile

## Version used for building the latest updated

```shell
Flutter 3.13.0-19.0.pre.99 • channel master •
https://github.com/flutter/flutter.git
Framework • revision 0bc5a2bca4 (10 hours ago) • 2023-08-08 16:24:19 -0700
Engine • revision 82292b8390
Tools • Dart 3.2.0 (build 3.2.0-42.0.dev) • DevTools 2.26.1
```
## Recent Google Maps Crashing on iOS Devices

Due to issues with Google Maps crashing on iOS devices, some adjustments were made in our Flutter configuration:

### Steps Taken:

1. **Switch to the Latest Master Branch in Flutter**: 
    - To address the crash, we switched to the latest master branch in Flutter.
    
2. **Modify `Info.plist`**:
    - An additional line `<key>FLTEnableImpeller</key><false />` was added to `Info.plist`. This disables the impeller engine which was also necessary for the bug fix.

### Note to Future Developers:

Once the Flutter Team integrates these fixes from the master branch into the stable branch:

1. Consider switching back to the stable Flutter branch for building the app.
2. If applicable and the bug has been resolved, enable the impeller engine by removing the `<key>FLTEnableImpeller</key><false />` line from `Info.plist`.
