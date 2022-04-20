import 'package:flutter/material.dart';
import 'package:mini_campus/src/shared/index.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';

import '../constants/market_enums.dart';
import '../features/home/views/ad_details.dart';
import '../models/ad_service.dart';
import 'custom_inner_card.dart';

class CustomHomeCard extends StatelessWidget {
  const CustomHomeCard({
    Key? key,
    required this.ad,
    this.chipRadius = 10.0,
    this.isEven = false,
  }) : super(key: key);

  final double chipRadius;
  final bool isEven;
  final AdService ad;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        pushNewScreen(
          context,
          screen: AdDetailsView(ad: ad),
          withNavBar: false,
        );
      },
      child: ClipRRect(
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(chipRadius),
          ),
          child: ad.type == AdType.Service
              ? CustomInnerCard(ad: ad, chipRadius: chipRadius, isEven: isEven)
              : ad.isRequest
                  ? Banner(
                      location: BannerLocation.topEnd,
                      message: 'request',
                      color: bluishColorShade,
                      child: CustomInnerCard(
                          ad: ad, chipRadius: chipRadius, isEven: isEven),
                    )
                  : ad.isNegotiable
                      ? Banner(
                          location: BannerLocation.topEnd,
                          message: 'negotiable',
                          color: bluishColorShade,
                          child: CustomInnerCard(
                              ad: ad, chipRadius: chipRadius, isEven: isEven),
                        )
                      : CustomInnerCard(
                          ad: ad, chipRadius: chipRadius, isEven: isEven),
        ),
      ),
    );
  }
}
