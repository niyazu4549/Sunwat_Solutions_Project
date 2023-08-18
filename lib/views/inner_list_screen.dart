import 'package:flutter/material.dart';
import 'package:lite_rolling_switch/lite_rolling_switch.dart';
import 'package:sunwat_solutions/colors.dart';
import 'package:sunwat_solutions/constants.dart';
import 'package:sunwat_solutions/models/service_lists_model.dart';
import 'package:sunwat_solutions/views/provider_class.dart';

class InnerListScreen extends StatefulWidget {
  niyazModel element;
  MyProvider? provider;

  InnerListScreen({super.key, required this.element, required this.provider});

  @override
  State<InnerListScreen> createState() => _InnerListScreenState();
}

class _InnerListScreenState extends State<InnerListScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 10, right: 10, top: 5),
      child: Center(
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                widget.element.text,
                maxLines: 1,
                style: TextStyle(
                  color: black,
                  fontFamily: ubuntu,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(bottom: 5),
              height: 32,
              child: LiteRollingSwitch(
                width: 70,
                value: true,
                colorOn: Colors.green,
                colorOff: Colors.red,
                textSize: 12,
                onDoubleTap: () {},
                onSwipe: () {},
                onTap: () {},
                onChanged: (bool state) {
                  print('turned ${(state) ? 'Yes' : 'No'}');
                  widget.element.status = !widget.element.status;
                  widget.provider!.refreshWidget();
                },
                animationDuration: const Duration(milliseconds: 100),
                iconOff: Icons.close,
                textOn: "Yes",
                textOff: "No",
              ),
            ),
          ],
        ),
      ),
    );
  }
}
