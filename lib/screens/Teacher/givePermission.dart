import 'package:biit_social/utils/SVCommon.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

class SVGivePermission extends StatefulWidget {
  const SVGivePermission({super.key});

  @override
  State<SVGivePermission> createState() => _SVGivePermissionState();
}

class _SVGivePermissionState extends State<SVGivePermission> {
  List<Items> items = [Items(id: 1, name: 'Nazaid')];
  List<Items> items1 = [
    Items(id: 1, name: 'Full controll'),
    Items(id: 2, name: 'Add posts'),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: SizedBox(
        width: 100,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(shape: const StadiumBorder()),
          onPressed: () {},
          child: Row(
            children: const [
              Icon(Icons.add),
              SizedBox(
                width: 10,
              ),
              Text('Save')
            ],
          ),
        ),
      ),
      appBar: AppBar(
        elevation: 0,
        title: Text(
          'Permissions',
          style: TextStyle(color: context.primaryColor),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 20.0, right: 20, top: 40),
        child: Column(
          children: [
            TextFormField(
              decoration: const InputDecoration(hintText: 'Select Teacher'),
              readOnly: true,
              onTap: () async {
                //  await getSelector(context, 'Select Teacher', items);
              },
            ),
            const SizedBox(
              height: 40,
            ),
            TextFormField(
              decoration: const InputDecoration(hintText: 'Select Students'),
              readOnly: true,
              onTap: () async {
                // await getSelector(context, 'Select permissons', items1);
              },
            ),
            //ElevatedButton(onPressed: () {}, child: const Text('Save'))
          ],
        ),
      ),
    );
  }
}
