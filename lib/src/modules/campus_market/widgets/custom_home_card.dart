import 'package:flutter/material.dart';
import 'package:mini_campus/src/shared/index.dart';

import '../constants/market_enums.dart';
import '../models/ad_service.dart';
import 'custom_inner_card.dart';

class CustomHomeCard extends StatelessWidget {
  const CustomHomeCard({
    Key? key,
    required this.ad,
    this.chipRadius = 10.0,
  }) : super(key: key);

  final double chipRadius;
  final AdService ad;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // todo go to details page
      },
      child: ClipRRect(
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(chipRadius),
          ),
          child: ad.type == AdType.Service
              ? CustomInnerCard(ad: ad, chipRadius: chipRadius)
              : ad.isRequest
                  ? Banner(
                      location: BannerLocation.topEnd,
                      message: 'request',
                      color: bluishColorShade,
                      child: CustomInnerCard(ad: ad, chipRadius: chipRadius),
                    )
                  : ad.isNegotiable
                      ? Banner(
                          location: BannerLocation.topEnd,
                          message: 'negotiable',
                          color: bluishColorShade,
                          child:
                              CustomInnerCard(ad: ad, chipRadius: chipRadius),
                        )
                      : CustomInnerCard(ad: ad, chipRadius: chipRadius),
        ),
      ),
    );
  }
}
