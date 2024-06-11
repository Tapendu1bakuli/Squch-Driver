
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizing/sizing.dart';
import '../utils/app_colors.dart';
import '../utils/app_strings.dart';
import '../utils/fonts.dart';


class CommonTextFormField extends StatefulWidget {
  late double?  height;
  late double?  width;
  late double?  margin;
  late double?  padding;
  late TextEditingController? controller;
  final Widget? suffixIcon;
  final TextInputAction textInputAction;
  final String? hintText;
  final String? labelText;
  final TextInputType textInputType;
  final TextAlign ? textAlign;
  final Function(String)? onValueChanged;
  final Function(String?)? onValidator;
  final Function()? onSuffixClick;
  final Function? onSuffixClickWithValue;
  final bool? isProgressSuffix;
  final bool? obscureText;
  final bool readOnly;
  final bool? isEnable;
  final bool? expanded;
  final TextAlignVertical? textAlignVertical;
  List<TextInputFormatter>? inputFormatters;
  final Function(String? value)? onSave;
  final String? initialValue;
  //final readOnly;
  final InputDecoration? decoration;
  final TextStyle? fontTextStyle;
  final int? maxLine;
  final int? maxLength;
  final FocusNode? focusNode;
  final bool? isDense;
  final Function()? onTap;
  final Function()? onEditingComplete;
  final Color? fillColor;
  CommonTextFormField(
      {this.controller,
      Key? key,
      this.labelText,
      this.height,
      this.width,
      this.margin,
      this.padding,
      this.hintText,
      this.readOnly = false,
      this.textInputAction = TextInputAction.next,
      this.textInputType = TextInputType.text,
      this.obscureText,
      this.suffixIcon,
      this.textAlign = TextAlign.start,
      this.onValueChanged,
      this.onValidator,
      this.decoration,
      this.maxLine,
      this.isProgressSuffix,
      this.onSuffixClick,
      this.onSave,
      this.isEnable,
      this.initialValue,
      this.focusNode,
      this.maxLength,
      this.inputFormatters,
      this.onSuffixClickWithValue,
      this.fontTextStyle,
      this.onTap,
      this.onEditingComplete,
      this.expanded,
      this.textAlignVertical,
        this.fillColor,
        this.isDense})
      : super(key: key);

  @override
  State<CommonTextFormField> createState() => _CommonTextFormFieldState();
}

class _CommonTextFormFieldState extends State<CommonTextFormField> {
  String? textValue;


  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height??null,
      width:  widget.width??MediaQuery.of(context).size.width,
      margin: EdgeInsets.symmetric(horizontal: widget.margin??8.ss),
      padding: EdgeInsets.symmetric(horizontal: widget.padding?? 10.ss,vertical: 0),
      decoration: BoxDecoration(
         // color: widget.fillColor??Colors.blueGrey.withOpacity(0.0),
           border: Border.all(color: AppColors.colorlightgrey1,width: 0.1),
           borderRadius: BorderRadius.all(Radius.circular(10.ss))

      ),
      //color: Colors.lightGreen,
      child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(10.ss)),
        child: TextFormField(
          expands: widget.expanded??false,
          onTap:widget.onTap ,
          onEditingComplete: widget.onEditingComplete??(){},
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: (value)=>widget.onValidator != null? widget.onValidator!(value):null,
          textAlignVertical: widget.textAlignVertical??TextAlignVertical.center,
          obscureText: widget.obscureText??false,
          readOnly: widget.readOnly,
          enabled: widget.isEnable,
          maxLength: widget.maxLength,
          controller: widget.controller,
          textAlign: widget.textAlign ?? TextAlign.start,
          maxLines: widget.expanded == true? null :  widget.maxLine??1,
          style: widget.fontTextStyle ??  CustomTextStyle(fontSize: 16.fss,fontWeight: FontWeight.w400,color: AppColors.titleColor),
          // focusNode: widget.focusNode,
          inputFormatters: widget.inputFormatters,
          textCapitalization: TextCapitalization.sentences,
          cursorColor: AppColors.titleColor,
          minLines: 1,
          decoration: widget.decoration??
              InputDecoration(
            // isDense:false,
                filled: widget.fillColor!=null,
            fillColor: widget.fillColor??Colors.blueGrey.withOpacity(0.0),
            hintText: widget.hintText??"",
            suffixIcon: widget.suffixIcon,
            hintTextDirection: TextDirection.ltr,
              contentPadding: EdgeInsets.symmetric(horizontal: 10.ss,vertical: 10.ss),
            hintStyle: CustomTextStyle(
                color:Theme.of(context).brightness != Brightness.dark   ? AppColors.textSubBlack : Colors.white,fontSize: 14.fss),
            focusColor: AppColors.titleColor,
            border: OutlineInputBorder(
              borderRadius: new BorderRadius.circular(10.0),
              borderSide: new BorderSide(width: 0.2),
            ),
           focusedBorder: OutlineInputBorder(
             borderRadius: new BorderRadius.circular(10.0),
             borderSide: new BorderSide(width: 1,color: Colors.black),
           )
          ),
          textInputAction: widget.textInputAction,
          keyboardType: widget.textInputType,
          onChanged: (value) {
            textValue = value;
            widget.onValueChanged != null ? widget.onValueChanged!(value) : null;
          },
        ),
      ),
    );
  }
}
class LowerCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    return TextEditingValue(
      text: newValue.text.toLowerCase(),
      selection: newValue.selection,
    );
  }
}