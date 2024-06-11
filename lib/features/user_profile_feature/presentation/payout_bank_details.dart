
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizing/sizing.dart';

import '../../../core/common/common_button.dart';
import '../../../core/common/common_dropdown.dart';
import '../../../core/common/common_text_form_field.dart';
import '../../../core/utils/app_strings.dart';
import '../../../core/utils/fonts.dart';
import '../../../core/widgets/common_app_bar.dart';
import '../../../core/widgets/gap.dart';
import '../../../core/widgets/title_text.dart';
import 'controller/profile_controller.dart';

class PayoutBankDetailsPage extends GetView<ProfileController> {
  const PayoutBankDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: CommonAppbar(title:AppStrings.payoutBankDetails.tr,isIconShow: true,onPressed: (){Get.back();},
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
                      Text(AppStrings.payoutBankDetailsTitle.tr,
                        style: CustomTextStyle(fontSize: 20.fss,fontWeight: FontWeight.w700),),
                      Gap(30.ss),
                      Form(
                        key: controller.userBankDetailsFormKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TitleText(context, AppStrings.payoutAccType.tr),
                              Gap(10.ss),
                              CommonDropdown(
                                  margin: 0,
                                  selectedValue:  controller.selectedPayoutAccType.value,
                                  options:  controller.payoutAccTypeList,
                                  onChange: (newValue){
                                    controller.selectedPayoutAccType.value = newValue;
                                  },
                              ),
                              Gap(30.ss),
                              Visibility(
                                  visible: controller.selectedPayoutAccType.value.id == "2",
                                  child:
                              ListView(
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                children: [
                                  TitleText(context, AppStrings.mWalletNumber.tr),
                                  Gap(10.ss),
                                  CommonTextFormField(
                                    readOnly: controller.isLoading.value,
                                    hintText: AppStrings.entermWalletNumber.tr,
                                    margin: 0,
                                    padding: 0,
                                    textInputType: TextInputType.number,
                                    controller: controller.mWalletNumberController,
                                    onValidator: (value){
                                      if(value == null || value.isEmpty){
                                        return AppStrings.entermWalletNumber.tr;
                                      }else {
                                        return null;
                                      }
                                    },
                                  ),
                                ],
                              )
                              ),

                              Visibility(
                                visible: controller.selectedPayoutAccType.value.id == "1",
                                child: ListView(
                                  physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  children: [
                                    TitleText(context, AppStrings.bankName.tr),
                                    Gap(10.ss),
                                    CommonDropdown(
                                      margin: 0,
                                      selectedValue:  controller.selectedBankName.value,
                                      options:  controller.bankNameList,
                                      onChange: (newValue){
                                        controller.selectedBankName.value = newValue;
                                      },
                                    ),
                                    Gap(30.ss),

                                    TitleText(context, AppStrings.branchName.tr),
                                    Gap(10.ss),
                                    CommonTextFormField(
                                      readOnly: controller.isLoading.value,
                                      hintText: AppStrings.enterBranchName.tr,
                                      margin: 0,
                                      padding: 0,
                                      controller:  controller.branchNameController,
                                      onValidator: (value){
                                        if(value == null || value.isEmpty){
                                          return AppStrings.enterBranchName.tr;
                                        }else {
                                          return null;
                                        }
                                      },

                                    ),
                                    Gap(30.ss),
                                    TitleText(context, AppStrings.accountNumber.tr),
                                    Gap(10.ss),
                                    CommonTextFormField(
                                      readOnly: controller.isLoading.value,
                                      hintText: AppStrings.enterAccountNumber.tr,
                                      margin: 0,
                                      padding: 0,
                                      textInputType: TextInputType.number,
                                      controller: controller.accountNumberController,
                                      onValidator: (value){
                                        if(value == null || value.isEmpty){
                                          return AppStrings.enterAccountNumber.tr;
                                        }else {
                                          return null;
                                        }
                                      },
                                    ),
                                    Gap(30.ss),
                                    TitleText(context, AppStrings.ifscCode.tr),
                                    Gap(10.ss),
                                    CommonTextFormField(
                                      readOnly: controller.isLoading.value,
                                      hintText: AppStrings.enterIfscCode.tr,
                                      margin: 0,
                                      padding: 0,
                                      controller:  controller.ifscCodeController,
                                      onValidator: (value){
                                        if(value == null || value.isEmpty){
                                          return AppStrings.enterIfscCode.tr;
                                        }else {
                                          return null;
                                        }
                                      },
                                    ),
                                  ],
                                ),
                              ),


                              Gap(controller.selectedPayoutAccType.value.id == "1"?
                                  MediaQuery.sizeOf(context).height/11 :
                                  MediaQuery.sizeOf(context).height/2.2),
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
                                      controller.updateBankDetails();
                                },),
                              ),
                            ],
                          )
                      )
                    ],
                  ),
                ),
                controller.isInitialLoading.value?
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
