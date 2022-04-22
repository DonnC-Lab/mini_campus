import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:mini_campus/src/shared/index.dart';

import '../data/models/lost_found_filter.dart';
import '../data/models/lost_found_item.dart';
import '../services/data_service.dart';
import 'add_lf_item.dart';
import 'item_details.dart';
import 'item_image.dart';

class LostFoundView extends ConsumerStatefulWidget {
  const LostFoundView({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LostFoundViewState();
}

class _LostFoundViewState extends ConsumerState<LostFoundView> {
  String? _selectedMonth;

  /// true - lost | false - found
  bool isLostItems = true;

  late LostFoundFilter _lostFoundFilter;

  void setInitialFilter() {
    String type = isLostItems ? 'lost' : 'found';

    var month = _selectedMonth ?? DateFormat.MMM().format(DateTime.now());

    setState(() {
      _lostFoundFilter = LostFoundFilter(type: type, month: month);
    });
  }

  @override
  void initState() {
    setInitialFilter();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _style = Theme.of(context).textTheme.subtitle2?.copyWith(
          fontSize: 12,
          color: greyTextShade,
          fontWeight: FontWeight.w400,
          fontStyle: FontStyle.italic,
        );

    const double itemHeight = 40;

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: bluishColor,
        tooltip: 'upload new L&F item',
        onPressed: () {
          routeTo(context, const AddLFItemView());
        },
        child: const Icon(Icons.add),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Lost &\nFound',
                  style: Theme.of(context)
                      .textTheme
                      .headline1
                      ?.copyWith(fontSize: 28),
                ),
              ),
              Container(
                margin: const EdgeInsets.fromLTRB(16, 16, 0, 16),
                padding: const EdgeInsets.all(3),
                decoration: const BoxDecoration(
                  color: bluishColor,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(25),
                      bottomLeft: Radius.circular(25)),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: DropdownButton<String?>(
                    value: _selectedMonth,
                    iconEnabledColor: greyTextShade,
                    underline: const SizedBox(),
                    hint: Text('-month-',
                        style: Theme.of(context)
                            .textTheme
                            .bodyText2
                            ?.copyWith(fontSize: 12)),
                    style: Theme.of(context)
                        .textTheme
                        .subtitle2
                        ?.copyWith(fontSize: 12),
                    items: months
                        .map((e) => DropdownMenuItem(
                              child: Text(e),
                              value: e,
                            ))
                        .toList(),
                    onChanged: (val) {
                      setState(() {
                        _selectedMonth = val;
                      });
                      setInitialFilter();
                    },
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              height: itemHeight,
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(25),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          isLostItems = true;
                        });
                        setInitialFilter();
                      },
                      child: Container(
                        height: itemHeight,
                        decoration: BoxDecoration(
                          color: isLostItems
                              ? Theme.of(context).appBarTheme.backgroundColor
                              : Theme.of(context).cardColor,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Center(
                          child: Text(
                            'Lost Items',
                            style: Theme.of(context)
                                .textTheme
                                .bodyText1
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color:
                                      isLostItems ? mainWhite : greyTextShade,
                                ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          isLostItems = false;
                        });
                        setInitialFilter();
                      },
                      child: Container(
                        height: itemHeight,
                        decoration: BoxDecoration(
                          color: !isLostItems
                              ? Theme.of(context).appBarTheme.backgroundColor
                              : Theme.of(context).cardColor,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Center(
                          child: Text(
                            'Found Items',
                            style: Theme.of(context)
                                .textTheme
                                .bodyText1
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color:
                                      !isLostItems ? mainWhite : greyTextShade,
                                ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: ref.watch(lfFilterProvider(_lostFoundFilter)).when(
                  data: (items) {
                    return items == null
                        ? Center(
                            child: Padding(
                            padding: const EdgeInsets.all(30.0),
                            child: Text('🙁 failed to fetch Lost & Found Items',
                                style: _style),
                          ))
                        : items.isEmpty
                            ? Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(30.0),
                                  child: Text(
                                      'no ${_lostFoundFilter.type} Items in ${_lostFoundFilter.month} found at the moment, check again later!',
                                      style: _style),
                                ),
                              )
                            : ListView.separated(
                                padding: const EdgeInsets.all(8),
                                itemBuilder: (context, index) {
                                  final LostFoundItem lfi = items[index];

                                  return GestureDetector(
                                    onTap: () {
                                      ItemDetails(context, lfi);
                                    },
                                    child: Row(
                                      children: [
                                        ItemImage(img: lfi.image),
                                        const SizedBox(width: 20),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              lfi.name,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .headline1
                                                  ?.copyWith(
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                            ),
                                            const SizedBox(height: 8),
                                            Text(
                                              DateFormat.yMMMMd()
                                                  .format(lfi.date),
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .subtitle2
                                                  ?.copyWith(
                                                    fontSize: 11,
                                                    color: greyTextShade,
                                                  ),
                                            ),
                                          ],
                                        ),
                                        const Spacer(),
                                        Text(
                                          lfi.location,
                                          style: Theme.of(context)
                                              .textTheme
                                              .subtitle2
                                              ?.copyWith(
                                                fontSize: 11,
                                              ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                                separatorBuilder: (context, index) =>
                                    const SizedBox(height: 30),
                                itemCount: items.length,
                              );
                  },
                  error: (e, st) => Center(
                      child: Text('🙁 failed to fetch Lost & Found Items',
                          style: _style)),
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                ),
          ),
        ],
      ),
    );
  }
}

/*
 Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6),
                          color: index.isEven
                              ? orangishColor.withOpacity(0.4)
                              : greenishColor.withOpacity(0.4)),
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(6.0),
                          child: Text(
                            index.isEven ? 'active' : 'sorted',
                            style:
                                Theme.of(context).textTheme.bodyText1?.copyWith(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: index.isEven
                                          ? orangishColor
                                          : greenishColor,
                                    ),
                          ),
                        ),
                      ),
                    ),
*/
