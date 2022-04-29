# Mini Campus

MiniCampus - A virtual campus app for students

## About
MiniCampus, **MC** - thrives to be the go to student app for both freshers and existing students on campus. It comes equipped with the tools and services to make life easy for a student.
- It comprises of `modules` that each act as a standalone application serving a single purpose

## Modules

Follow unfollow - students can follow and unfollow each other*
- send notification to each other when a follow is made
- send notification when followed student ads something on the platform

### 1. Campus Market
### 2. Learning
### 3. Lost & Found
### 4. Report

### 5. Notifications
Don't miss campus notifications, get notified of campus notifications
#### 5.1 General push notifications
These are sent per channel, general channel are based on | include:
1. all - for all push notifications
2. gender - based on student gender males | females
3. department - based on student department, using dept-code
4. faculty - based per faculty
5. year - based on enrollment year e.g part 1, part 4

 
<br>

## Microservices*
### 0. Student Profile
- `profile` - firestore
- `tokens` - firestore
- `profile pictures` - cloud storage

### 1. Campus Market
- `products` - rtdb
- `images` - cloud storage | deta drive

### 2. Learning
- `data` - deta base
- `papers` - deta drive

### 3. L&F
- `data` - deta base
- `files` - deta drive

### 4. Report
- `data` - rtdb

### 5. Notifications
- `data` - rtdb


## Getting Started

terminal model build command
```bash
$ flutter clean
$ flutter pub get
$ flutter pub run build_runner build --delete-conflicting-outputs
```

* flutter_notification_channel

### Test User
- n0173320w@students.nust.ac.zw
- donald@123