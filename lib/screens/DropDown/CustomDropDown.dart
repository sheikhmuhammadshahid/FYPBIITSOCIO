import 'package:biit_social/Controllers/DropDowncontroler.dart';
import 'package:flutter/material.dart';
import 'package:biit_social/screens/DropDown/component/custom_select2dot1';
import 'package:provider/provider.dart';

class CustomExample0 extends StatefulWidget {
  final ScrollController scrollController;

  const CustomExample0({super.key, required this.scrollController});

  @override
  State<CustomExample0> createState() => _CustomExample0State();
}

class _CustomExample0State extends State<CustomExample0> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    dropDownController ??= context.read<DropDownController>();
    dropDownController!.getData();
  }

  DropDownController? dropDownController;
  @override
  Widget build(BuildContext context) {
    dropDownController ??= context.read<DropDownController>();
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: CustomSelect2dot1(
        title: 'Select',
        data: context.watch<DropDownController>().items,
        isMultiSelect: true,
        avatarInSingleSelect: false,
        extraInfoInSingleSelect: true,
        extraInfoInDropdown: true,
        scrollController: widget.scrollController,
      ),
    );
  }
}
