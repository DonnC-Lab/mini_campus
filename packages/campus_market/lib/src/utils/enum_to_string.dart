import 'package:campus_market/src/constants/market_enums.dart';
import 'package:campus_market/src/extensions/ad_type_ext.dart';
import 'package:campus_market/src/extensions/market_category_ext.dart';

String enumToStringItem(MarketCategory enumVar) => enumVar.name;

String adTypeToStringItem(AdType enumVar) => enumVar.name;

MarketCategory categoryStringToEnum(String mc) => mc.category;

AdType adTypeStringToEnum(String at) => at.adType;
