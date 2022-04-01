import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mini_campus/src/shared/index.dart';
import 'package:toggle_switch/toggle_switch.dart';

import 'add_lf_item.dart';

class LostFoundView extends ConsumerStatefulWidget {
  const LostFoundView({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LostFoundViewState();
}

class _LostFoundViewState extends ConsumerState<LostFoundView> {
  String? _selectedMonth;

  @override
  Widget build(BuildContext context) {
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
                child: DropdownButton<String?>(
                  value: _selectedMonth,
                  underline: const SizedBox(),
                  hint: Text('-month-',
                      style: Theme.of(context).textTheme.bodyText2?.copyWith(
                            fontSize: 12,
                          )),
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
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          Center(
            child: ToggleSwitch(
              minWidth: double.infinity,
              cornerRadius: 20.0,
              initialLabelIndex: 1,
              totalSwitches: 2,
              radiusStyle: true,
              labels: const ['Lost Items', 'Found Items'],
              // doubleTapDisable: true,
              onToggle: (index) {
                print('switched to: $index');
              },
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.all(8),
              itemBuilder: (context, index) {
                return Row(
                  children: [
                    Container(
                      height: 60,
                      width: 60,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        image: const DecorationImage(
                          image: AssetImage('assets/images/product-1.png'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Student ID Card',
                            style:
                                Theme.of(context).textTheme.headline1?.copyWith(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500,
                                    )),
                        const SizedBox(height: 8),
                        Text(
                          '23 Mar 2022',
                          style:
                              Theme.of(context).textTheme.subtitle2?.copyWith(
                                    fontSize: 11,
                                    //  fontStyle: FontStyle.italic,
                                    color: greyTextShade,
                                  ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    Text(
                      'Chem Building',
                      style: Theme.of(context).textTheme.subtitle2?.copyWith(
                            fontSize: 11,
                          ),
                    ),
                  ],
                );
              },
              separatorBuilder: (context, index) => const SizedBox(height: 30),
              itemCount: 4,
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