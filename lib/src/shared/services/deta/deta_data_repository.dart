// import 'dart:io';

// import 'package:dio/dio.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:http_parser/http_parser.dart';
// import 'package:path/path.dart' as path;

// import 'index.dart';

// final dataRepoProvider = Provider((ref) => DataRepository(ref.read));

// class DataRepository {
//   // ignore: prefer_final_fields
//   late Dio _dioClient;

//   final Reader _reader;

//   DataRepository(this._reader) : _dioClient = _reader(dioProvider).state;

//   // ads/create-view/
//   Future updateUserAdView(String adId) async {
//     try {
//       var resp =
//           await _dioClient.post('ads/create-view/', data: {'ad_id': adId});

//       log(resp);

//       if (resp.statusCode == 200) {
//         return true;
//       }
//     }

//     //
//     catch (e) {
//       log('[updateUserAdView] $e', 'e');
//       return exceptionHandler(e, 'update Ad view');
//     }
//   }

//   /// get viewed ads
//   Future getViewedAds() async {
//     try {
//       // make request
//       var resp = await _dioClient.get('ads/watched/');

//       if (resp.statusCode == 200) {
//         final List res = List.from(resp.data);

//         return res.map((e) => ViewedAd.fromJson(e)).toList();
//       }
//     }

//     //
//     catch (e) {
//       log('[getViewedAds] $e', 'e');

//       throw exceptionHandler(e, 'get viewed ads history');
//     }
//   }

//   /// get locations
//   Future<List<City>?> getLocations() async {
//     try {
//       var resp = await _dioClient.get('profiles/locations/');

//       if (resp.statusCode == 200) {
//         final cities = CityResponse.fromMap(resp.data);

//         return cities.results ?? const [];
//       }
//     }

//     //
//     catch (e) {
//       log('[getLocations] $e', 'e');

//       throw exceptionHandler(e, 'get available locations');
//     }
//     return null;
//   }

//   /// get user current ads balance
//   Future getUserCurrentBalance() async {
//     try {
//       // make request
//       var resp = await _dioClient.get('profiles/check-balance/');

//       if (resp.statusCode == 200) {
//         return resp.data['balance'];
//       }
//     }

//     //
//     catch (e) {
//       log('[getUserCurrentBalance] $e', 'e');

//       throw exceptionHandler(e, 'get account balance');
//     }
//   }

//   /// get econet bundles
//   Future getEconetBundles() async {
//     try {
//       // make request
//       var resp = await _dioClient.get('payouts/recharge-econet-bundles/');

//       log('[getEconetBundles] $resp');

//       if (resp.statusCode == 200) {
//         return EconetBundle.fromJson(resp.data);
//       }
//     }

//     //
//     catch (e) {
//       log('[getEconetBundles] $e', 'e');

//       throw exceptionHandler(e, 'get data bundles');
//     }
//   }

//   /// redeem bundle
//   Future redeemBundle(String phone, String productCode) async {
//     try {
//       // make request
//       var resp =
//           await _dioClient.post('payouts/recharge-econet-bundles/', data: {
//         'phone_number': phone,
//         'product_code': productCode,
//       });

//       if (resp.statusCode == 200) {
//         return true;
//       }
//     }

//     //
//     catch (e) {
//       log('[redeemBundle] $e', 'e');

//       return exceptionHandler(e, 'redeem via data bundle');
//     }
//   }

//   /// redeem airtime
//   Future redeemAirtime(String phone, double amount) async {
//     try {
//       // make request
//       var resp = await _dioClient.post('payouts/recharge-airtime/', data: {
//         'phone_number': phone,
//         'amount': amount,
//       });

//       if (resp.statusCode == 200) {
//         return true;
//       }
//     }

//     //
//     catch (e) {
//       log('[redeemAirtime] $e', 'e');

//       return exceptionHandler(e, 'redeem via airtime');
//     }
//   }

//   /// get ads
//   Future getAvailableAds() async {
//     try {
//       var resp = await _dioClient.get('ads/ranked-ad-list/');

//       if (resp.statusCode == 200) {
//         log(resp.data);

//         // successful
//         // final re = AdResult.fromJson(resp.data);

//         var adsL = resp.data as List;

//         var ads = adsL.map((e) => Ad.fromJson(e)).toList();

//         return AdResult(results: ads);
//       }

//       // var resp = await _dioClient.get('ads/advertisments/');

//       // if (resp.statusCode == 200) {
//       //   log(resp.data);

//       //   final re = AdResult.fromJson(resp.data);

//       //   return re;
//       // }
//     }

//     //
//     catch (e) {
//       log('[getAvailableAds] $e', 'e');
//       throw exceptionHandler(e, 'get available ads');
//     }
//   }

//   /// get interests
//   Future getAvailableInterests() async {
//     try {
//       // make request
//       var resp = await _dioClient.get('profiles/interests/');

//       if (resp.statusCode == 200) {
//         // successful
//         List res = resp.data['results'];

//         var innt = res.map((e) => Interest.fromJson(e)).toList();

//         // compare already liked user lists

//         var ss = innt.map((e) => SelectedInterest(interest: e)).toList();

//         _reader(selectedInterestsProvider).state = ss;

//         return ss;
//       }
//     }

//     //
//     catch (e) {
//       log('[getAvailableInterests] $e', 'e');
//       throw exceptionHandler(e, 'get available interests');
//     }
//   }

//   /// upload user profile pic to server
//   ///
//   /// this automatically update user profile with the image uploaded, no need to re-use fileUrl
//   ///
//   /// to manually update again the user profile
//   Future uploadProfilePic(String profilePath) async {
//     final userProfile = _reader(profileProvider).state!;

//     try {
//       final file = File(profilePath);

//       String fileName = path.basename(file.path);

//       var ext = path.extension(file.path).replaceAll('.', '').trim();

//       FormData formData = FormData.fromMap({
//         "file": await MultipartFile.fromFile(
//           file.path,
//           filename: fileName,
//           contentType: MediaType('application', ext),
//         ),
//       });

//       var resp = await _dioClient.post('profiles/regulars-upload-image/',
//           data: formData);

//       if (resp.statusCode == 201) {
//         // successful
//         var fileUrl = resp.data['file']['full_size'];

//         final _copy = userProfile.copyWith(profileImage: fileUrl);

//         final _prof = await _reader(authRepoProvider).updateProfile(_copy);

//         if (_prof is UserProfile) {
//           _reader(profileProvider).state = _prof;
//         }

//         return fileUrl;
//       }
//     }

//     //
//     catch (e) {
//       log('[uploadProfilePic] $e', 'e');
//       return exceptionHandler(e, 'upload profile image');
//     }
//   }
// }
