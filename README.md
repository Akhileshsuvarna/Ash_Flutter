# health_connector

Health connector.ai is health and fitness app powered by Livvinyl progressive media marketing.

### App Size
#### Android:
    FAT APK                             ???? MB
    app-arm64-v8a-release.apk           ???? MB
    app-armeabi-v7a-release.apk         ???? MB
    app-x86_64-release.apk              ???? MB

#### IOS:
    ???? MB (Final Size will be determined by AppStore)

## Tested Devices:
    Model               OS              Screen Size     Tested by       Tested on
    =====               ==              ===========     =========       =========
    Samsung A750        Android 10      Medium          Skandar         21/12/2021
    iPad 10             IOS 14.8        Large           Skandar         21/12/2021
    TODO(Ash)           Android 12      Medium           Ash            21/12/2021

# TODO-Sikander verify percentage based coordinate system
## Percent Based Coordinate System:

    Screen width (px): 1977		height: 1080
    Screen width (lp): 720		height: 394
     Image width (px): 320		height: 240

    x=10%	y=10%	w=50%	h=50% (provided configuration)
    x=198	y=108	w=989	h=540 (on screen in px)
    x=72	y=39.4	w=360	h=197 (on screen in lp)
    x=32	y=24	w=160	h=120 (in image in px)

    ? / (720 / 320) = ? px
    465x180 = 2.58 (ratio)
    320x123 = 2.60 (ratio)drawRect

    10 / (465/320) = 6.88 = 7


## TODOs:

- [x] Make exercie widget for Exercise screen for reuse in list in exercises screen.
- [x] Make class to hold data for list of exercises form json Map.
- [ ] Save last frame of detected pose in user Gallery with Overlay. (When done capture frame and goto temporay screen and perform pose detection on static image instead of frame from stream and do custom paint on it. Now it won't be a paltformview at this stage screenshot can be taken using screenshot plugin) -> https://pub.dev/packages/screenshot
- [ ] verify Login screen.(Anthony)
- [ ] confirm login methods from team. (Ash)
- [ ] get videos from team for exercises and store tham in firebase storage.(Anthony)
- [ ] Store exercises data in firebase rtdb.(Sikander)
- [ ] make play video page.(Sikander)
- [ ] make result page and use widget based model.(Sikander)
- [ ] Share result of exercise.(Sikander)
- [ ] Remove camera skewness. (Team) -> Re-Test required.
- [ ] Improve Skelton design. 
- [ ] make generic function to detect pose from remote config. (find a solution)
- [ ] Scoring How good is user doing exercise VS the refference.
- [ ] Save results in Firebase (For reporting / history) purpose.
- [ ] Fix Frot Camera (Sikander)
- [ ] Make sketon paint smooth (jittery)
- [ ] Start Timer on Initial pose Detection and stop timer when pose is not detected for 1 to 2 seconds(threshold should be configurable from backend remotely)
- [ ] Make a function to capture exercise So Admin can capture exercise Poses and Add Aexercise.
- [ ] Make a Generic function to detect if live pose is smilar / same pose from required exercise.