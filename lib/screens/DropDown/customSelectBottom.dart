import 'package:biit_social/Controllers/DropDowncontroler.dart';
import 'package:biit_social/Controllers/PostController.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';

class CustomDropDown extends StatefulWidget {
  //final ScrollController scrollController;

  const CustomDropDown({
    super.key,
  });

  @override
  State<CustomDropDown> createState() => _CustomDropDownState();
}

class _CustomDropDownState extends State<CustomDropDown> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // dropDownController ??= context.read<DropDownController>();
    // dropDownController!.getData(context.read<SettingController>());
  }

  bool readOnly = true;
  DropDownController? dropDownController;
  TextEditingController controller = TextEditingController();

  //late SelectDataController selectDataController;
  late PostController postController;
  @override
  Widget build(BuildContext context) {
    //dropDownController ??= context.read<DropDownController>();
    postController = context.read<PostController>();
    return Container(
      child: Row(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
            alignment: Alignment.centerRight,
            margin:
                const EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
            decoration: boxDecorationDefault(),
            width: readOnly ? context.width() * 0.3 : context.width() * 0.8,
            height: context.height() * 0.06,
            child: TextFormField(
              readOnly: readOnly,
              controller: controller,
              decoration: InputDecoration(
                  suffixIcon: IconButton(
                      onPressed: () {
                        filter(false);
                      },
                      icon: const Icon(Icons.search)),
                  border: const OutlineInputBorder(),
                  hintText: readOnly ? 'All' : 'Enter course to filter'),
              onTapOutside: (event) => filter(false),
              onFieldSubmitted: (value) {
                filter(false);
              },
              onSaved: (newValue) {},
            ),
          ),
          IconButton(
              onPressed: () {
                setState(() {
                  readOnly = !readOnly;
                });
                filter(true);
              },
              icon: Icon(!readOnly ? Icons.filter_alt_off : Icons.filter_alt))
        ],
      ),
    );
  }

  filter(bool toDo) {
    if (toDo) {
      controller.text = '';
    }
    postController.classWallFilter = controller.text.trim();
    postController.notifyListeners();

    FocusScope.of(context).requestFocus(FocusNode());
  }
}
