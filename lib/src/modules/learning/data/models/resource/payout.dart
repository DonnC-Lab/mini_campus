import 'package:freezed_annotation/freezed_annotation.dart';

part 'payout.freezed.dart';
part 'payout.g.dart';

@freezed
 class Payout with _$Payout {
    factory  Payout({
        bool? hasStudentApproved,
        String? status,
        double? amount,
        /// account to credit e.g ecocash or innbucks or deriv etc
        String? account,
        /// payment method e.g ecocash or innbucks or deriv etc
        String? method,
        /// transaction ref if any
        String? ref,
    }) = _Payout;

    factory Payout.fromJson(Map<String, dynamic> json) => _$PayoutFromJson(json);
}