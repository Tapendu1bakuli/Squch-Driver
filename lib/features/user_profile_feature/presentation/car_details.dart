import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:squch_driver/features/user_profile_feature/presentation/controller/profile_controller.dart';
import '../../../core/common/common_button.dart';
import '../../../core/common/common_dropdown.dart';
import '../../../core/common/common_text_form_field.dart';
import '../../../core/model/dropdown_model.dart';
import '../../../core/utils/app_colors.dart';
import '../../../core/utils/app_strings.dart';
import '../../../core/utils/fonts.dart';
import '../../../core/utils/image_utils.dart';
import '../../../core/utils/utils.dart';
import '../../../core/widgets/common_app_bar.dart';
import '../../../core/widgets/gap.dart';
import '../../../core/widgets/title_text.dart';
import 'package:sizing/sizing.dart';

class CarDetailsPage extends GetView<ProfileController> {
  const CarDetailsPage({super.key});
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: CommonAppbar(title:AppStrings.carDetails.tr,isIconShow: true,onPressed: (){Get.back();},
      ),
      body:  Obx(()=>SafeArea(
        child:
        controller.isInitialLoading.value?
        const Center(child: CircularProgressIndicator())
            :
        SingleChildScrollView(
            child: Stack(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20.ss),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Gap(10.ss),
                      Text(AppStrings.selectVehicleTypeTitle.tr,
                        style: CustomTextStyle(fontSize: 20.fss,fontWeight: FontWeight.w700),),
                     Gap(30.ss),
                     Form(
                       key: controller.userCarDetailsFormKey,
                         child: Column(
                           crossAxisAlignment: CrossAxisAlignment.start,
                           children: [
                             TitleText(context, AppStrings.vehicleCompany.tr),
                             Gap(10.ss),
                             CommonDropdown(
                                 margin: 0,
                                 selectedValue:  controller.selectedVehicleCompany.value,
                                 options:  controller.vehicleCompanyList,
                                 onChange: (newValue){
                                   controller.selectedVehicleCompany.value = newValue;
                                   controller.getVehicleModelList(newValue.id);
                                   controller.modelList.clear();
                                   controller.modelList.add(DropdownModel(uniqueid: -1,id: "-1",label: "Select",));
                                   controller.selectedModel.value = controller.modelList.first;

                                 }
                             ),
                             Gap(30.ss),

                             TitleText(context, AppStrings.modelName.tr),
                             Gap(10.ss),
                             CommonDropdown(
                                 margin: 0,
                                 selectedValue:  controller.selectedModel.value,
                                 options:  controller.modelList,
                                 onChange: (newValue){
                                   controller.selectedModel.value = newValue;
                                 }
                             ),
                             Gap(30.ss),
                             TitleText(context, AppStrings.vehicleYear.tr),
                             Gap(10.ss),
                             CommonDropdown(
                                 margin: 0,
                                 selectedValue:  controller.selectedManufactureYear.value,
                                 options:  controller.manufactureYearList,
                                 onChange: (newValue){
                                   controller.selectedManufactureYear.value = newValue;
                                   controller.vehicleCompanyList.clear();
                                   controller.vehicleCompanyList.add(DropdownModel(uniqueid: -1,id: "-1",label: "Select",));
                                   controller.selectedVehicleCompany.value = controller.vehicleCompanyList.first;
                                 }
                             ),
                             Gap(30.ss),
                             TitleText(context, AppStrings.vinNo.tr),
                             Gap(10.ss),
                             CommonTextFormField(
                               readOnly: controller.isLoading.value,
                               hintText: AppStrings.enterVinNo.tr,
                               margin: 0,
                               padding: 0,
                               controller:  controller.vinNumberController,
                               onValidator: (value){
                                 if(value == null || value.isEmpty){
                                   return AppStrings.enterVinNo.tr;
                                 }else {
                                   return null;
                                 }
                               },
                             ),
                             Gap(30.ss),
                             TitleText(context, AppStrings.licensePlateNumber.tr),
                             Gap(10.ss),
                             CommonTextFormField(
                               readOnly: controller.isLoading.value,
                               hintText: AppStrings.enterLicensePlateNumber.tr,
                               margin: 0,
                               padding: 0,
                               controller:  controller.licensePlateNumberController,
                               onValidator: (value){
                                 if(value == null || value.isEmpty){
                                   return AppStrings.enterLicensePlateNumber.tr;
                                 }else {
                                   return null;
                                 }
                               },
                             ),
                             Gap(30.ss),
                             Row(
                               mainAxisAlignment:
                               MainAxisAlignment.spaceBetween,
                               children: [
                                 TitleText(context, AppStrings.uploadVehicleImage.tr),
                                 Visibility(
                                   visible: controller.temporaryVehicleImagePath.value.isNotEmpty,
                                   child: InkWell(
                                       onTap: ()async{
                                         await modalBottomSheetMenu(context,
                                                 (XFile? selectedImage) {
                                               controller.temporaryVehicleImageName
                                                   .value = selectedImage!.name;
                                               controller.temporaryVehicleImagePath
                                                   .value = selectedImage.path;
                                             });
                                       },
                                       child: TitleText(context, AppStrings.replace.tr,textColor: AppColors.buttonColor)),
                                 ),
                               ],
                             ),
                             Gap(10.ss),

                       DottedBorder(
                               borderType: BorderType.RRect,
                               radius: Radius.circular(10.ss),
                               color: AppColors.buttonColor,
                               strokeWidth: 1,
                               child: controller.temporaryVehicleImagePath.value.isEmpty?
                               Container(
                                 padding:const EdgeInsets.symmetric(horizontal: 30,vertical: 20),
                                 decoration: BoxDecoration(
                                   borderRadius: BorderRadius.all(Radius.circular(10.ss))
                                 ),
                                 child: Center(
                                   child: GestureDetector(
                                     onTap: ()async{
                                       await modalBottomSheetMenu(context,
                                           (XFile? selectedImage) {
                                         controller.temporaryVehicleImageName
                                             .value = selectedImage!.name;
                                         controller.temporaryVehicleImagePath
                                             .value = selectedImage.path;
                                       });
                                     },
                                     child: Container(
                                       padding: EdgeInsets.symmetric(vertical: 30.ss),
                                       width: MediaQuery.of(context).size.width/3,
                                       child: Column(
                                         children: [
                                           SvgPicture.asset(ImageUtils.upload),
                                           Gap(10.ss),
                                           Text(AppStrings.uploadVehicleImage.tr,style: CustomTextStyle(),
                                           textAlign: TextAlign.center,)
                                         ],
                                       ),
                                     ),
                                   ),
                                 ),
                               )
                                   : Container(
                                 width: MediaQuery.sizeOf(context).width,
                                 height: 189.ss,
                                 padding: EdgeInsets.symmetric(horizontal: 0.ss),
                                 decoration: BoxDecoration(
                                     borderRadius: BorderRadius.all(
                                         Radius.circular(10.ss))),
                                 child: ClipRRect(
                                   borderRadius: BorderRadius.all(
                                       Radius.circular(10.ss)),
                                   child: Image.file(fit: BoxFit.fitWidth,
                                     File(controller
                                         .temporaryVehicleImagePath.value),),
                                 ),
                               )

                             )
                           ,
                             Gap(30.ss),
                             Row(
                               mainAxisAlignment:
                               MainAxisAlignment.spaceBetween,
                               children: [
                                 TitleText(context, AppStrings.uploadRegistrationDocument.tr),
                                 Visibility(
                                   visible: controller.temporaryRegDocImagePath.value.isNotEmpty,
                                   child: InkWell(
                                       onTap: ()async{
                                         await modalBottomSheetMenu(context,
                                                 (XFile? selectedImage) {
                                               controller.temporaryRegDocImageName
                                                   .value = selectedImage!.name;
                                               controller.temporaryRegDocImagePath
                                                   .value = selectedImage.path;
                                             });
                                       },
                                       child: TitleText(context, AppStrings.replace.tr,textColor: AppColors.buttonColor)),
                                 ),
                               ],
                             ),
                             Gap(10.ss),

                       DottedBorder(
                               borderType: BorderType.RRect,
                               radius: Radius.circular(10.ss),
                               color: AppColors.buttonColor,
                               strokeWidth: 1,
                               child:controller.temporaryRegDocImagePath.value.isEmpty?
                               Container(
                                 padding:const EdgeInsets.symmetric(horizontal: 30,vertical: 20),
                                 decoration: BoxDecoration(
                                   borderRadius: BorderRadius.all(Radius.circular(10.ss))
                                 ),
                                 child: Center(
                                   child: GestureDetector(
                                     onTap: ()async{
                                       await modalBottomSheetMenu(context,
                                               (XFile? selectedImage) {
                                             controller.temporaryRegDocImageName
                                                 .value = selectedImage!.name;
                                             controller.temporaryRegDocImagePath
                                                 .value = selectedImage.path;
                                           });
                                     },
                                     child: Container(
                                       padding: EdgeInsets.symmetric(vertical: 30.ss),
                                       width: MediaQuery.of(context).size.width/3,
                                       child: Column(
                                         children: [
                                           SvgPicture.asset(ImageUtils.upload),
                                           Gap(10.ss),
                                           Text(AppStrings.uploadRegistrationDocument.tr,style: CustomTextStyle(),
                                           textAlign: TextAlign.center,)
                                         ],
                                       ),
                                     ),
                                   ),
                                 ),
                               )
                                   : Container(
                                 width: MediaQuery.sizeOf(context).width,
                                 height: 189.ss,
                                 padding: EdgeInsets.symmetric(horizontal: 0.ss),
                                 decoration: BoxDecoration(
                                     borderRadius: BorderRadius.all(
                                         Radius.circular(10.ss))),
                                 child: ClipRRect(
                                   borderRadius: BorderRadius.all(
                                       Radius.circular(10.ss)),
                                   child: Image.file(fit: BoxFit.fitWidth,
                                     File(controller
                                         .temporaryRegDocImagePath.value),),
                                 ),
                               ),
                             ),
                             Gap(20.ss),
                             controller.isLoading.value?
                             const Row(
                               mainAxisAlignment: MainAxisAlignment.center,
                               children: [
                                 CircularProgressIndicator(),
                               ],
                             )
                                 : Padding(
                               padding: EdgeInsets.symmetric(horizontal: 0.0.ss,vertical: 10.ss),
                               child: CommonButton(label:AppStrings.submit.tr,onClicked: (){
                                 controller.updateCarDetails();
                               },),
                             ),
                             Gap(20.ss),
                           ],
                         )
                     )
                    ],
                  ),
                ),
                controller.isLoading.value?
                SizedBox(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    child: const Center(child: CircularProgressIndicator())):
                const Offstage()
              ],
            )),
      )),


    );
  }
}
