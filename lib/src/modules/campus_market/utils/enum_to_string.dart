import '../constants/market_enums.dart';
import '../extensions/ad_type_ext.dart';
import '../extensions/market_category_ext.dart';

String enumToStringItem(MarketCategory enumVar) => enumVar.stringValue;

String adTypeToStringItem(AdType enumVar) => enumVar.stringValue;

MarketCategory categoryStringToEnum(String mc) => mc.category;

AdType adTypeStringToEnum(String at) => at.adType;
