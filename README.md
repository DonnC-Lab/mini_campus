# MiniCampus 🎓

MiniCampus  - A virtual campus app, with 💙 for students 👨‍🎓👩‍🎓

## About
MiniCampus, **MC** - thrives to be the go to student app for both freshers and existing students on campus. It comes equipped with the tools and services to make life easy for a student.
- It comprises of [modules](docs/modules/README.md) that each act as a standalone application serving a single purpose

## Showcase
Checkout the development progress under [releases](https://github.com/DonnC-Lab/mini_campus/releases) for demo builds


*coming soon*

## Getting Started
This project is built using Flutter, for a getting started, checkout [flutter.dev](https://flutter.dev/)

After successful setup of your local flutter environment, fork this repository and run the following commands in the root folder (project uses `freezed`)

```bash
$ flutter clean
$ flutter pub get
$ flutter pub run build_runner build --delete-conflicting-outputs

# generate flavors
$ flutter pub run flutter_flavor:main

# run dev mode with flavor
$ flutter run --flavor dev -t lib/main-dev.dart
```

For local development, it is recommended to use `dev` [flavor](https://docs.flutter.dev/deployment/flavors) mode and [firebase local emulator](https://fireship.io/snippets/firestore-emulator-flutter/)

### Firebase Setup
To setup firebase services with flavors using FlutterFire CLI [more](https://sebastien-arbogast.com/2022/05/02/multi-environment-flutter-projects-with-flavors/#Integrating_Firebase)
```bash
# for dev flavor
$ flutterfire configure -i com.dcl.mc.dev \
-a com.dcl.mc.dev \
-o lib/firebase/dev/firebase_options.dart \
--no-apply-gradle-plugins \
--no-app-id-json
```

Please note the app id is per the one setup in `pubspec` following `flutter_flavor` convention

### Running with Flavor
Flavors have been configured for `vscode` but for `Android Studio` check [here](https://www.chwe.at/2020/10/flutter-flavors/#add-a-flutter-build-configuration-for-each-flavor-in-android-studio)

> Currently MC is tested against Android devices only. It might work on iOS but this has not been tested yet, help us archive this goal 🙏


For interactive long conversations around issues, new developments, announcements and progress etc, make use of our [discussions 💡 here](https://github.com/DonnC-Lab/mini_campus/discussions)

## Modules
MC is broken down into modules (packages), each, which serve a single purpose, they act as single mini apps within the MC framework.

It comes with the following **core** modules and counting 😎
1. Campus Market
2. Learning
3. Lost & Found
4. Feedback
5. Notifications

### 5.1 General push notifications
MC comes with default fcm push notifications, each student on successful register automatically subscribe to the following topics:
1. all - for all push notifications
2. gender - based on student gender males | females
3. department - based on student department, using dept-code
4. faculty - based per faculty
5. year - based on enrollment year e.g part 1, part 4

These aim to tackle communication issues on campus to enhance announcement delivery e.g
> When we want to notify all students about the opening of Payment Plans on Campus Admin

> Important message from the clinic about counselling services

> Broadcast announcement to all girl child about Women in Engineering event

 
<br>

## Built With
MC strives to take advantage the available open source & free* tools

This is because MC is made by students for students

1. Flutter Dart
2. Firebase services
3. Deta services [here](https://docs.deta.sh/) - for persistence free storage and nosql db
4. Python, Fast Api [server](https://github.com/DonnC-Lab/mc_py_server) - for interfacing with deta

## Contributing
We love contributions, no contribution is small or big, every bit of it is welcome here be it technical or non-technical including suggestions, documentations and typos etc

To learn more about the different ways you can contribute to MC, see the [CONTRIBUTING guide](CONTRIBUTING.md)

## Authors

* **DonnC Lab** - *Initial work* - [DonnC](https://github.com/DonnC)
* **Traders Incubator** - *Initial work* - [Dont Delete](https://github.com/DontDelete)

See also the list of awesome [contributors](https://github.com/DonnC-Lab/mini_campus/contributors) who participated in this project.

## License

This project is licensed under the Apache License - see the [LICENSE](LICENSE) file for details

## Acknowledgements

* StackOverflow - what can we do without it
* Dont Delete - for providing early feedback on technical tests and module ideation
* Brighton Tanda for bringing the ideation to live
* FlutterDevZW community
* a lot more 

## Onboarding attributes
> Place the attribution on the app's credits page and on the description page on the app store. 
- learning - <a href="https://storyset.com/people">People illustrations by Storyset</a>
- students - <a href="https://storyset.com/education">Education illustrations by Storyset</a>
- market - <a href="https://storyset.com/online">Online illustrations by Storyset</a>
- survey - <a href="https://storyset.com/marketing">Marketing illustrations by Storyset</a>

## Community
*coming soon*