import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:linkable/linkable.dart';
import 'package:mini_campus/src/shared/index.dart';
import 'package:relative_scale/relative_scale.dart';

import '../../../models/ad_service.dart';
import '../../../services/market_rtdb_service.dart';

class AdDetailsView extends ConsumerWidget {
  const AdDetailsView({Key? key, required this.ad}) : super(key: key);

  final AdService ad;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final student = ref.watch(studentProvider);
    final _dialog = ref.read(dialogProvider);
    final adApi = ref.read(marketDbProvider);

    return Scaffold(
      appBar: AppBar(centerTitle: true, title: const Text('Ad Details')),
      body: ref.watch(studentProfileProvider(ad.student!)).when(
            data: (advertiser) {
              return advertiser == null
                  ? const Center(child: Text('Failed to display Ad'))
                  : Scaffold(
                      bottomNavigationBar: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 8),
                        child: SizedBox(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  primary: bluishColor,
                                  elevation: 8,
                                  // fixedSize: Size(width, sy(30)),
                                ),
                                onPressed: advertiser.whatsappNumber.isEmpty
                                    ? null
                                    : () {
                                        customUrlLauncher(whatsappLink(
                                          advertiser.whatsappNumber,
                                          'Hie, I\'m ${student?.alias ?? student?.name} and im interested on your Ad about ${ad.name} on MiniCampus Market.',
                                        ));
                                      },
                                icon: const Icon(Ionicons.logo_whatsapp),
                                label: const Text('Chat'),
                              ),
                              ref
                                  .watch(studentLikeStatusStreamProvider(ad))
                                  .when(
                                      data: (status) {
                                        return IconButton(
                                          tooltip: 'add to my favorite list',
                                          onPressed: status.snapshot.exists
                                              ? () async {
                                                  await adApi
                                                      .dislikeAdService(ad);
                                                  _dialog
                                                      .showToast('Ad disliked');
                                                }
                                              : () async {
                                                  await adApi.likeAdService(ad);
                                                  _dialog.showToast('Ad liked');
                                                },
                                          iconSize: 30,
                                          color: bluishColor,
                                          icon: status.snapshot.exists
                                              ? const Icon(Ionicons.heart)
                                              : const Icon(
                                                  Ionicons.heart_outline),
                                        );
                                      },
                                      loading: () =>
                                          const CircularProgressIndicator(),
                                      error: (e, st) {
                                        debugLogger(e,
                                            error: e, stackTrace: st);
                                        return const SizedBox.shrink();
                                      }),
                              RichText(
                                text: TextSpan(
                                    text: 'USD',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyText1
                                        ?.copyWith(
                                          fontWeight: FontWeight.w500,
                                          color: greyTextShade,
                                          fontSize: 12,
                                        ),
                                    children: <TextSpan>[
                                      TextSpan(
                                        text:
                                            ' \$${ad.price.toStringAsFixed(2)}',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText1
                                            ?.copyWith(
                                              fontSize: 27,
                                              fontWeight: FontWeight.bold,
                                            ),
                                      )
                                    ]),
                              ),
                            ],
                          ),
                        ),
                      ),
                      body: SingleChildScrollView(
                        child: RelativeBuilder(
                            builder: (context, height, width, sy, sx) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // const SizedBox(height: 40),
                              // Align(
                              //   alignment: Alignment.topCenter,
                              //   child: Row(
                              //     children: [
                              //       IconButton(
                              //         onPressed: () {
                              //           routeBack(context);
                              //         },
                              //         icon: const Icon(Icons.arrow_back_ios),
                              //       ),
                              //       const SizedBox(width: 8),
                              //       Text('Ad Details',
                              //           style: Theme.of(context)
                              //               .textTheme
                              //               .headline1
                              //               ?.copyWith(fontSize: 23)),
                              //     ],
                              //   ),
                              // ),
                              const SizedBox(height: 10),
                              SizedBox(
                                height: height * 0.45,
                                width: double.infinity,
                                child: Card(
                                  child: ad.images.isEmpty
                                      ? Image.asset(campusMarketPlaceholder)
                                      : FittedBox(
                                          // TODO: use carousel slider if imgs are many
                                          child: FancyShimmerImage(
                                              imageUrl: ad.images.first),
                                          fit: BoxFit.fill,
                                        ),
                                ),
                              ),
                              const SizedBox(height: 10),
                              Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(ad.name,
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline2),
                                    const SizedBox(height: 10),
                                    Row(
                                      children: [
                                        const Icon(
                                          Entypo.location,
                                          color: greyTextShade,
                                          size: 20,
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          advertiser.campusLocation.isEmpty
                                              ? 'no location'
                                              : advertiser.campusLocation,
                                          style: Theme.of(context)
                                              .textTheme
                                              .subtitle2
                                              ?.copyWith(
                                                fontSize: 13,
                                                color: greyTextShade,
                                              ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 20),
                                    Linkable(
                                      text: ad.description,
                                      linkColor: Colors.blueAccent,
                                      textColor: greyTextShade,
                                      style: Theme.of(context)
                                          .textTheme
                                          .subtitle2
                                          ?.copyWith(
                                              fontSize: 13,
                                              color: greyTextShade),
                                    ),
                                    const SizedBox(height: 20),
                                    const Divider(),
                                    CustomProfileAvatar(
                                        studentId: advertiser.id),
                                  ],
                                ),
                              ),
                            ],
                          );
                        }),
                      ),
                    );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, st) {
              return const Center(child: Text('Failed to display Ad'));
            },
          ),
    );
  }
}
