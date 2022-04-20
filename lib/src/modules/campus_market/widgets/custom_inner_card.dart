import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:mini_campus/src/modules/campus_market/models/ad_service.dart';
import 'package:mini_campus/src/shared/index.dart';

class CustomInnerCard extends StatelessWidget {
  const CustomInnerCard({
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(chipRadius),
            topRight: Radius.circular(chipRadius),
          ),
          child: SizedBox(
            height: isEven ? 130 : 150,
            width: double.infinity,
            child: ad.images.isEmpty
                ? Image.asset('assets/images/market_ad.png')
                : FittedBox(
                    child: FancyShimmerImage(imageUrl: ad.images.first),
                    fit: BoxFit.fill,
                  ),
          ),
        ),
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            ad.name,
            style: Theme.of(context).textTheme.subtitle2,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            'USD \$${ad.price.toStringAsFixed(2)}',
            style:
                Theme.of(context).textTheme.bodyText2?.copyWith(fontSize: 12),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                Ionicons.time_outline,
                color: bluishColorShade,
                size: 13,
              ),
              const SizedBox(width: 5),
              Text(
                elapsedTimeAgo(ad.createdOn),
                style: Theme.of(context)
                    .textTheme
                    .bodyText2
                    ?.copyWith(fontSize: 11),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
