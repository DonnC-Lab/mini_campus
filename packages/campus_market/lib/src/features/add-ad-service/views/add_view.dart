import 'package:animate_do/animate_do.dart';
import 'package:campus_market/src/constants/market_enums.dart';
import 'package:campus_market/src/features/add-ad-service/views/add_product.dart';
import 'package:campus_market/src/features/add-ad-service/views/add_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:mini_campus_components/mini_campus_components.dart';
import 'package:mini_campus_constants/mini_campus_constants.dart';
import 'package:relative_scale/relative_scale.dart';

class AddView extends StatefulWidget {
  const AddView({super.key});

  @override
  State<StatefulWidget> createState() => _AddViewState();
}

class _AddViewState extends State<AddView> {
  AdType _adType = AdType.ad;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(centerTitle: true, title: const Text('Add Your Ad')),
      body: RelativeBuilder(
        builder: (context, height, width, sy, sx) {
          return SingleChildScrollView(
            padding: EdgeInsets.all(sx(20)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'What would you like to add?',
                  style: titleTextStyle(context),
                ),
                SizedBox(height: sy(10)),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _adType == AdType.ad
                              ? AppColors.kPrimaryColor
                              : Colors.grey,
                          elevation: 8,
                          fixedSize: Size(width, sy(30)),
                        ),
                        onPressed: () {
                          setState(() {
                            _adType = AdType.ad;
                          });
                        },
                        icon: const Icon(Ionicons.add_outline),
                        label: const Text('Product'),
                      ),
                    ),
                    SizedBox(width: sx(50)),
                    Expanded(
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _adType == AdType.service
                              ? AppColors.kPrimaryColor
                              : Colors.grey,
                          elevation: 8,
                          fixedSize: Size(width, sy(30)),
                        ),
                        onPressed: () {
                          setState(() {
                            _adType = AdType.service;
                          });
                        },
                        icon: const Icon(Ionicons.cog_outline),
                        label: const Text('Service'),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: sy(15)),
                if (_adType == AdType.ad)
                  SlideInLeft(child: const AddProduct())
                else
                  SlideInRight(child: const AddService()),
              ],
            ),
          );
        },
      ),
    );
  }
}
