# health_connector

Health connector.ai is health and fitness app powered by Livvinyl progressive media marketing.

# TODO-Sikander Find out the sizes and enter below (Android + iOS)
### App Size
#### Android:
    FAT APK                             ???? MB
    app-arm64-v8a-release.apk           ???? MB
    app-armeabi-v7a-release.apk         ???? MB
    app-x86_64-release.apk              ???? MB

#### IOS:
    ???? MB (Final Size will be determined by AppStore)

# TODO-Sikander Test code and report below
## Tested Devices:
    Model			    OS			Screen Size		Tested by	Tested on
	=====			    ==			===========		=========	=========
	Samsung A750		Android 10  Medium			Skandar		????????????
    iPad 10             IOS 14.8    Large           Skandar     10/22/2021

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

- [ ] Make exercie widget for Exercise screen for reuse in list in exercises screen.
- [ ] Make class to hold data for lost of exercises form json Map.
- [ ] verify Login screen.
- [ ] confirm login methods from team.
- [ ] get videos from team for exercises and store tham in firebase storage.
- [ ] Store exercises data in firebase rtdb.
- [ ] make play video page.
- [ ] make result page and use widget based model.
- [ ] Share result of exercise.
- [ ] Remove camera skewness.
- [ ] Improve Skelton design.
- [ ] make generic function to detect pose from remote config. (find a solution)