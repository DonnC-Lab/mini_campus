import 'package:campus_market/src/constants/market_enums.dart';
import 'package:campus_market/src/features/home/views/ad_details.dart';
import 'package:campus_market/src/models/ad_service.dart';
import 'package:campus_market/src/widgets/custom_inner_card.dart';
import 'package:flutter/material.dart';
import 'package:mini_campus_constants/mini_campus_constants.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';

class CustomHomeCard extends StatelessWidget {
  const CustomHomeCard({
    super.key,
    required this.ad,
    this.chipRadius = 10.0,
    this.isEven = false,
  });

  final double chipRadius;
  final bool isEven;
  final AdService ad;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        pushNewScreen<void>(
          context,
          screen: AdDetailsView(ad: ad),
          withNavBar: false,
        );
      },
      child: ClipRRect(
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(chipRadius),
          ),
          child: ad.type == AdType.service
              ? CustomInnerCard(ad: ad, chipRadius: chipRadius, isEven: isEven)
              : ad.isRequest
                  ? Banner(
                      location: BannerLocation.topEnd,
                      message: 'request',
                      color: AppColors.kLightShadeColor,
                      child: CustomInnerCard(
                        ad: ad,
                        chipRadius: chipRadius,
                        isEven: isEven,
                      ),
                    )
                  : ad.isNegotiable
                      ? Banner(
                          location: BannerLocation.topEnd,
                          message: 'negotiable',
                          color: AppColors.kLightShadeColor,
                          child: CustomInnerCard(
                            ad: ad,
                            chipRadius: chipRadius,
                            isEven: isEven,
                          ),
                        )
                      : CustomInnerCard(
                          ad: ad,
                          chipRadius: chipRadius,
                          isEven: isEven,
                        ),
        ),
      ),
    );
  }
}
