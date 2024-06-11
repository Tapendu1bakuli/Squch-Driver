import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizing/sizing.dart';
import 'package:squch_driver/features/user_auth_feature/presentation/controller/registration_controller.dart';
import '../../../core/common/common_button.dart';
import '../../../core/service/page_route_service/routes.dart';
import '../../../core/utils/app_strings.dart';
import '../../../core/utils/utils.dart';
import '../../../core/widgets/common_app_bar.dart';
import 'controller/auth_controller.dart';
import 'widget/type_selection_card_widget.dart';

class TypeSelectionPage extends GetView<RegistrationController> {
  const TypeSelectionPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
          preferredSize:
              Size.fromHeight(MediaQuery.of(context).size.height / 12),
          child: CommonAppbar(
            title: AppStrings.typeSelectionTitle.tr,
            isIconShow: true,
            onPressed: () {
              Get.back();
            },
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: CommonButton(
          padding: EdgeInsets.symmetric(horizontal: 20.ss, vertical: 20.ss),
          label: AppStrings.continueText.tr,
          onClicked: () {
            if(controller.selectedType == null){
              showFailureSnackbar(AppStrings.oops.tr,"Please select driver type");
            }else {
              Get.toNamed(Routes.REGISTER);
            }
            },
        ),
        body: Obx(()=>ListView.builder(
            shrinkWrap: true,
            padding: EdgeInsets.symmetric(horizontal: 20.ss),
            physics: const ClampingScrollPhysics(),
            itemCount: controller.typeSelectionList.length,
            itemBuilder: (context, i) {
              return TypeSelectionCardWidget(
                  authController: controller,
                    onSelected: (selected) {
                    if(selected){
                      controller.selectedType = controller.typeSelectionList[i];
                    }
                    else{
                      controller.selectedType = null;
                    }
                        for (var j = 0; j < controller.typeSelectionList.length; j++) {
                          controller.typeSelectionList[j].isSelected = (i == j) ? selected : false;
                       }
                        controller.typeSelectionList.refresh();
                    },
                    isSelected: controller.typeSelectionList[i].isSelected ?? false,
                    title: controller.typeSelectionList[i].typeSelectionTitle,
                    subtitle: controller.typeSelectionList[i].typeSelectionSubTitle,
                    topContainerText: controller.typeSelectionList[i].typeSelectionTopContainerText,
                    cardImages: controller.typeSelectionList[i].typeSelectionContainerIcons,
                );
            },
          ),
        ));
  }
}
