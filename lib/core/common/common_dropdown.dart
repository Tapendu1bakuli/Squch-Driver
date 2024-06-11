import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sizing/sizing.dart';
import 'package:squch_driver/core/utils/image_utils.dart';

import '../model/dropdown_model.dart';
import '../utils/app_colors.dart';
import '../utils/fonts.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

class CommonDropdown extends StatefulWidget {
  late double? height;
  late double? width;
  late double? margin;
  late List<DropdownModel> options;
  late DropdownModel selectedValue;
  final Color? borderColor;
  final double? borderRadius;
  final bool? isDisable;
  final Function(DropdownModel) onChange;

  CommonDropdown({
    this.width,
    this.height = 50,
    this.margin,
    required this.selectedValue,
    required this.options,
    required this.onChange,
    this.borderColor,
    this.borderRadius,
    Key? key,
    this.isDisable = false,
  }) : super(key: key);

  @override
  State<CommonDropdown> createState() => _CommonCommonDropdownState();
}

class _CommonCommonDropdownState extends State<CommonDropdown> {
  String? textValue;

  @override
  Widget build(BuildContext context) {
    print(widget.isDisable);
    // print("Selected ==>>>" + widget.selectedValue.label.toString());
    // for (int i = 0; i < widget.options.length; i++) {
    //   print(widget.options[i].label);
    // }
    return Container(
        height: widget.height,
        width: widget.width ?? MediaQuery.of(context).size.width,
        margin: EdgeInsets.symmetric(horizontal: widget.margin??20.ss),
        decoration: BoxDecoration(
            // color: Colors.blueGrey.withOpacity(0.03),
            border: Border.all(color: widget.borderColor ??  Colors.black,width: 0.5),
            borderRadius:
                BorderRadius.all(Radius.circular(widget.borderRadius ?? 10))),
        //color: Colors.lightGreen,
        child: DropdownButtonHideUnderline(
          child: DropdownButton2(
              dropdownStyleData: const DropdownStyleData(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(15),
                    bottomLeft: Radius.circular(15),
                  ),

                ),
              ),
              iconStyleData: IconStyleData(
                icon:
                    Padding(
                      padding:  EdgeInsets.symmetric(horizontal: 10.0.ss),
                      child: SvgPicture.asset(ImageUtils.downArrow),
                    ),
              ),
              isExpanded: true,
              hint: Text(
                'Select Item',
                style: CustomTextStyle(
                  fontSize: 14.fss,
                  fontWeight: FontWeight.w200,
                  color: Theme.of(context).hintColor,
                ),
              ),
              items:
                  [
                for (var data in widget.options)
                  DropdownMenuItem(
                    value: data.id,
                    child:  Text(
                      data.label,
                      style: TextStyle(
                        color: widget.selectedValue == data ? AppColors.buttonColor : Colors.black,
                      ),
                    ),
                  )
              ],

              value: widget.selectedValue.id,
              onChanged: widget.isDisable!
                  ? null
                  : (value) {
                      for (var item in widget.options) {
                        if (item.id == value) {
                          widget.onChange(item);
                          break;
                        }
                      }
                    },
            selectedItemBuilder: (BuildContext ctxt) {
              return widget.options.map<Widget>((item) {
                return DropdownMenuItem(
                    child: Text("${item.label}",
                        style: const TextStyle(color: Colors.black)),
                    value: item);
              }).toList();
            },
              // buttonHeight: 40,
              //  buttonWidth: 140,
              //  itemHeight: 40,
              ),
        ));
  }
}
