import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

Future<PickerItem?> showNumberPickerSheet({
  required BuildContext context,
  required String title,
  required List<PickerItem> values,
  required int initialIndex,
}) {
  return showModalBottomSheet<PickerItem>(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (_) => _NumberPickerSheet(
      title: title,
      values: values,
      initialIndex: initialIndex,
    ),
  );
}

class PickerItem {
  final double numericValue;
  final String label;
  const PickerItem({required this.numericValue, required this.label});
}

List<PickerItem> ageItems() => List.generate(
      90,
      (i) => PickerItem(
          numericValue: (i + 10).toDouble(), label: '${i + 10}  años'),
    );

List<PickerItem> weightKgItems() => List.generate(
      171,
      (i) => PickerItem(
          numericValue: (i + 30).toDouble(), label: '${i + 30}  kg'),
    );

List<PickerItem> weightLbItems() => List.generate(
      375,
      (i) => PickerItem(
          numericValue: (i + 66) * 0.453592, label: '${i + 66}  lb'),
    );

List<PickerItem> heightCmItems() => List.generate(
      151,
      (i) => PickerItem(
          numericValue: (i + 100).toDouble(), label: '${i + 100}  cm'),
    );

List<PickerItem> heightFtItems() {
  final items = <PickerItem>[];
  for (int ft = 4; ft <= 7; ft++) {
    for (int inch = 0; inch <= 11; inch++) {
      final totalInches = ft * 12 + inch;
      final cm = totalInches * 2.54;
      items.add(PickerItem(
        numericValue: cm,
        label: "$ft'${inch.toString().padLeft(2, '0')}\"",
      ));
    }
  }
  return items;
}

class _NumberPickerSheet extends StatefulWidget {
  final String title;
  final List<PickerItem> values;
  final int initialIndex;

  const _NumberPickerSheet({
    required this.title,
    required this.values,
    required this.initialIndex,
  });

  @override
  State<_NumberPickerSheet> createState() => _NumberPickerSheetState();
}

class _NumberPickerSheetState extends State<_NumberPickerSheet> {
  late final FixedExtentScrollController _controller;
  late int _selectedIndex;

  static const double _itemExtent = 56.0;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
    _controller =
        FixedExtentScrollController(initialItem: widget.initialIndex);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.55,
      decoration: const BoxDecoration(
        color: kWhite,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [

          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: kLightGrey,
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Text(
              widget.title,
              style: const TextStyle(
                color: kDark,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          Expanded(
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  height: _itemExtent,
                  margin: const EdgeInsets.symmetric(horizontal: 24),
                  decoration: BoxDecoration(
                    color: kLightGrey,
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),

                ListWheelScrollView.useDelegate(
                  controller: _controller,
                  itemExtent: _itemExtent,
                  physics: const FixedExtentScrollPhysics(),
                  perspective: 0.003,
                  diameterRatio: 2.5,
                  onSelectedItemChanged: (i) =>
                      setState(() => _selectedIndex = i),
                  childDelegate: ListWheelChildBuilderDelegate(
                    childCount: widget.values.length,
                    builder: (context, index) {
                      final isSelected = index == _selectedIndex;
                      return Center(
                        child: Text(
                          widget.values[index].label,
                          style: TextStyle(
                            color: isSelected ? kDark : kGrey,
                            fontSize: isSelected ? 28 : 20,
                            fontWeight: isSelected
                                ? FontWeight.w600
                                : FontWeight.normal,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.fromLTRB(24, 12, 24, 32),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () =>
                    Navigator.pop(context, widget.values[_selectedIndex]),
                style: ElevatedButton.styleFrom(
                  backgroundColor: kOrange,
                  foregroundColor: kWhite,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'OK',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}