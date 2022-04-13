import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:mini_campus/src/shared/index.dart';
import 'package:relative_scale/relative_scale.dart';

import '../../../constants/market_enums.dart';
import 'add_product.dart';
import 'add_service.dart';

class AddView extends ConsumerStatefulWidget {
  const AddView({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AddViewState();
}

class _AddViewState extends ConsumerState<AddView> {
  AdType _adType = AdType.Ad;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Add Your Ad'),
      ),
      body: RelativeBuilder(builder: (context, height, width, sy, sx) {
        return SingleChildScrollView(
          padding: EdgeInsets.all(sx(20)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('What would you like to add?',
                  style: titleTextStyle(context)),
              SizedBox(height: sy(10)),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        primary:
                            _adType == AdType.Ad ? bluishColor : Colors.grey,
                        elevation: 8,
                        fixedSize: Size(width, sy(30)),
                      ),
                      onPressed: () {
                        setState(() {
                          _adType = AdType.Ad;
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
                        primary: _adType == AdType.Service
                            ? bluishColor
                            : Colors.grey,
                        elevation: 8,
                        fixedSize: Size(width, sy(30)),
                      ),
                      onPressed: () {
                        setState(() {
                          _adType = AdType.Service;
                        });
                      },
                      icon: const Icon(Ionicons.cog_outline),
                      label: const Text('Service'),
                    ),
                  ),
                ],
              ),
              SizedBox(height: sy(15)),
              _adType == AdType.Ad
                  ? SlideInLeft(child: const AddProduct())
                  : SlideInRight(child: const AddService()),
            ],
          ),
        );
      }),
    );
  }
}
