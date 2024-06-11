import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:get/get.dart';

import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:squch_driver/core/utils/image_utils.dart';
import 'package:squch_driver/features/user_profile_feature/data/models/vehicle_model_list_master_response.dart';
import '../../../../core/model/dropdown_model.dart';
import '../../../../core/network_checker/common_network_checker_controller.dart';
import '../../../../core/service/page_route_service/routes.dart';
import '../../../../core/shared_pref/shared_pref.dart';
import '../../../../core/utils/Resource.dart';
import '../../../../core/utils/Status.dart';
import '../../../../core/utils/app_strings.dart';
import '../../../../core/utils/utils.dart';
import '../../../user_auth_feature/data/models/driver_details_item.dart';
import '../../../user_auth_feature/data/models/login_response.dart';
import '../../data/models/bank_list_master_response.dart';
import '../../data/models/vehicle_company_list_master_response.dart';
import '../../domain/repositories/profile_repository.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';

class ProfileController extends GetxController{
  final SharedPref sharedPref;
  final ProfileRepository profileRepository;
  RxBool isLoading = false.obs;
  RxBool rememberMe = false.obs;
  RxBool isInitialLoading = false.obs;
  String token ="";

  ProfileController({required this.sharedPref,required this.profileRepository});
  final userIdProofFormKey = GlobalKey<FormState>();
  final userInsuranceFormKey = GlobalKey<FormState>();
  final userCarDetailsFormKey = GlobalKey<FormState>();
  final userDrivingLicenseFormKey = GlobalKey<FormState>();
  final userBankDetailsFormKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  TextEditingController idNumberController = TextEditingController();
  TextEditingController dobController = TextEditingController();

  TextEditingController vinNumberController = TextEditingController();
  TextEditingController licensePlateNumberController = TextEditingController();
  TextEditingController licenseNumberController = TextEditingController();
  TextEditingController insuranceNumberController = TextEditingController();
  TextEditingController branchNameController = TextEditingController();
  TextEditingController accountNumberController = TextEditingController();
  TextEditingController mWalletNumberController = TextEditingController();
  TextEditingController ifscCodeController = TextEditingController();
  TextEditingController ibanNumberController = TextEditingController();

  RxList<DriverDetailsItem> driverDetailsList = [
    DriverDetailsItem(title:AppStrings.personalDetails,image: ImageUtils.personal_details,status: "approved"),
    DriverDetailsItem(title: AppStrings.idProofDetails,image: ImageUtils.idProof, status: "pending"),
    DriverDetailsItem(title: AppStrings.addCarDetails,image: ImageUtils.carDetails, status: "pending"),
    DriverDetailsItem(title: AppStrings.addDrivingLicenseDetails,image: ImageUtils.idProof, status: "pending"),
    DriverDetailsItem(title: AppStrings.addSelfie,image: ImageUtils.selfie, status: "pending"),
    DriverDetailsItem(title: AppStrings.addInsuranceDetails,image: ImageUtils.insuranceDetails, status: "pending"),
    DriverDetailsItem(title: AppStrings.addPayoutBankDetails,image: ImageUtils.bankDetails, status: "pending"),
  ].obs;
  LoginData? logedinData;
  RxList<DropdownModel> vehicleCompanyList = [
    DropdownModel(uniqueid: -1,id: "-1",label: "Select",)
  ].obs;

  Rx<DropdownModel> selectedVehicleCompany =  DropdownModel(uniqueid: -1,id: "-1",label: "Select",).obs;

  RxList<DropdownModel> modelList = [
    DropdownModel(uniqueid: -1,id: "-1",label: "Select",)
  ].obs;

  Rx<DropdownModel> selectedModel =  DropdownModel(uniqueid: -1,id: "-1",label: "Select",).obs;

  RxList<DropdownModel> manufactureYearList = [
    DropdownModel(uniqueid: -1,id: "-1",label: "Select",)
  ].obs;

  Rx<DropdownModel> selectedManufactureYear =  DropdownModel(uniqueid: -1,id: "-1",label: "Select",).obs;

  RxList<DropdownModel> bankNameList = [
    DropdownModel(uniqueid: -1,id: "-1",label: "Select",)
  ].obs;
  RxList<DropdownModel> payoutAccTypeList = [
    DropdownModel(uniqueid: 2,id: "2",label: "mWallet",),
    DropdownModel(uniqueid: 1,id: "1",label: "Bank",)

  ].obs;

  Rx<DropdownModel> selectedBankName =  DropdownModel(uniqueid: -1,id: "-1",label: "Select",).obs;
  Rx<DropdownModel> selectedPayoutAccType =  DropdownModel(uniqueid: 2,id: "2",label: "mWallet",).obs;


  final CommonNetWorkStatusCheckerController _netWorkStatusChecker = Get.put(CommonNetWorkStatusCheckerController());

  RxString temporaryIdImageName = "".obs;
  RxString temporaryIdImagePath = "".obs;

  RxString temporaryInsuranceImageName = "".obs;
  RxString temporaryInsuranceImagePath = "".obs;

  RxString temporaryLicenseImageName = "".obs;
  RxString temporaryLicenseImagePath = "".obs;

  RxString temporarySelfieImageName = "".obs;
  RxString temporarySelfieImagePath = "".obs;

  RxString temporaryVehicleImageName = "".obs;
  RxString temporaryVehicleImagePath = "".obs;

  RxString temporaryRegDocImageName = "".obs;
  RxString temporaryRegDocImagePath = "".obs;

  @override
  void onInit(){
    _netWorkStatusChecker.updateConnectionStatus();
    getProfile();
    getRememberData();
    setYearData();
    // Get called when controller is created
    super.onInit();
  }

  @override
  void onReady(){
    // Get called after widget is rendered on the screen
    super.onReady();
  }

  @override
  void onClose(){
    //Get called when controller is removed from memory
    super.onClose();
  }


  void getRememberData() async{

    if(await sharedPref.isRememberMe() == true){
      rememberMe.value = true;
      emailController.text = await sharedPref.getLoginId()??"";
      passwordController.text =  await sharedPref.getLoginPassword()??"";
    }else{
      rememberMe.value = false;
      emailController.text = "";
      passwordController.text = "";
    }
  }

  Future getBankNames()async{
    bankNameList.clear();
    bankNameList.add(DropdownModel(uniqueid: -1,id: "-1",label: "Select",));
    logedinData = await sharedPref.getLogindata();
    if (await _netWorkStatusChecker.isInternetAvailable()) {

      isInitialLoading.value = true;
      var header ={
        "x-access-token": logedinData!.token??""
      };
      Resource profileResource = await profileRepository.getBankList(header: header);
      if (profileResource.status == STATUS.SUCCESS) {
        isInitialLoading.value = false;
        List<Banks>? banks = profileResource.data;
        if(banks!=null && banks.isNotEmpty){
          for(var bank in banks){
            bankNameList.add(DropdownModel(uniqueid: bank.id!,id: bank.id.toString(),label: bank.name??"",));
          }
        }

      } else {
        isInitialLoading.value = false;
        showFailureSnackbar(
            "Failed", profileResource.message ?? "Failed");
      }
    }
    else{
      showFailureSnackbar("No Internet", "Your device is not connected with internet.");
    }
  }
  Future getProfile()async{

    logedinData = await sharedPref.getLogindata();
    token = await sharedPref.getToken();
    if (await _netWorkStatusChecker.isInternetAvailable()) {

      isInitialLoading.value = true;
     // debugPrint(logedinData.toString());
      var header ={
        "x-access-token": logedinData!.token??""
      };
      Resource profileResource = await profileRepository.getProfile(header: header);
      if (profileResource.status == STATUS.SUCCESS) {
        isInitialLoading.value = false;
        logedinData = profileResource.data;
        logedinData!.token = token;
        sharedPref.setLogindata(jsonEncode(logedinData!.toJson()));
        logedinData = await sharedPref.getLogindata();
        setStatus();
        if(logedinData!.user!.driverDocument!.documentStatus == "pending" || logedinData!.user!.driverDocument!.documentStatus == "rejected" ) {
        }
        else{
          Get.offNamed(Routes.DASHBOARD);
        }
      } else {
        isLoading.value = false;
        showFailureSnackbar(
            "Failed", profileResource.message ?? "Failed");
      }
    }
    else{
      showFailureSnackbar("No Internet", "Your device is not connected with internet.");
    }
  }

  void setStatus() async{
debugPrint(jsonEncode(logedinData!.toJson()));
    for(int i =0; i< driverDetailsList.length;i++){
   if(i ==1){
     driverDetailsList[i].status =logedinData!.user!.driverDocument!.idCardDetails!.idStatus??"rejected";
   } else if(i ==2){
     driverDetailsList[i].status =logedinData!.user!.driverDocument!.vehicleDetails!.vehicleStatus??"rejected";
   } else if(i ==3){
     driverDetailsList[i].status =logedinData!.user!.driverDocument!.licenseDetails!.licenseStatus??"rejected";
   } else if(i ==4){
     driverDetailsList[i].status =logedinData!.user!.driverDocument!.profilePicDetails!.profilePicStatus??"rejected";
   } else if(i ==5){
     driverDetailsList[i].status =logedinData!.user!.driverDocument!.insuranceDetails!.insuranceStatus??"rejected";
   } else if(i ==6){
     driverDetailsList[i].status =logedinData!.user!.driverDocument!.bankDetails!.bankStatus??"rejected";
   }
    }
    driverDetailsList.refresh();

    if(logedinData!.user!.driverDocument!.documentStatus == "pending" || logedinData!.user!.driverDocument!.documentStatus == "rejected" ) {
      Get.back();
    }
    else{
      if(await sharedPref.isLoggedin()){
        Get.offAllNamed(Routes.DASHBOARD);
      }
      //await sharedPref.setLoggedin(true);
     else {
        Get.offAllNamed(Routes.LOGIN);
      }
    }
  }

  Future saveIdProof()async{
    // dob:2000-01-01
    // idCardNumber:TEST000001,
    // idCardPhoto:
    List<String> path = [];
    List<String> keys = [];
    if(!userIdProofFormKey.currentState!.validate()){
      return;
    }
    else if(temporaryIdImagePath.isEmpty){
      showFailureSnackbar(
          "Oops", AppStrings.takeIdImage.tr);
      return;
    }
    else {
      if (await _netWorkStatusChecker.isInternetAvailable()) {
        isLoading.value = true;
        var header = {
          "x-access-token": logedinData!.token ?? ""
        };
        DateTime parseDate =
        new DateFormat("dd-MM-yyyy").parse(dobController.text);
        var inputDate = DateTime.parse(parseDate.toString());
        var outputFormat = DateFormat('yyyy-MM-dd');
        var outputDate = outputFormat.format(inputDate);
        var body = {
          "dob": outputDate,
          "idCardNumber": idNumberController.text
        };
        XFile compressedFile = await compressFile(
            filePath: temporaryIdImagePath.value);
        path.add(compressedFile.path);
        keys.add("idCardPhoto");
        Resource profileResource = await profileRepository.updateIdProof(
            body: body, headers: header, key: keys, path: path
        );
        if (profileResource.status == STATUS.SUCCESS) {
          isLoading.value = false;
          logedinData = profileResource.data;
          logedinData!.token = token;
          sharedPref.setLogindata(jsonEncode(logedinData!.toJson()));
          logedinData = await sharedPref.getLogindata();
          setStatus();

        } else {
          isLoading.value = false;
          showFailureSnackbar(
              "Failed", profileResource.message ?? "Failed");
        }
      }
      else {
        showFailureSnackbar(
            "No Internet", "Your device is not connected with internet.");
      }
    }


  }
  Future saveInsuranceDetails()async{
    // dob:2000-01-01
    // idCardNumber:TEST000001,
    // idCardPhoto:
    List<String> path = [];
    List<String> keys = [];
    if(!userInsuranceFormKey.currentState!.validate()){
      return;
    }else {
      if(temporaryInsuranceImagePath.isEmpty){
        showFailureSnackbar(
            "Oops", AppStrings.pleaseTakeInsuranceImage.tr);
        return;
      }
      if (await _netWorkStatusChecker.isInternetAvailable()) {
        isLoading.value = true;
        var header = {
          "x-access-token": logedinData!.token ?? ""
        };
        var body = {
          "insuranceNumber": insuranceNumberController.text
        };
        XFile compressedFile = await compressFile(
            filePath: temporaryInsuranceImagePath.value);
        path.add(compressedFile.path);
        keys.add("insuranceImage");
        Resource profileResource = await profileRepository
            .updateInsuranceDetails(
            body: body, headers: header, key: keys, path: path
        );
        if (profileResource.status == STATUS.SUCCESS) {
          isLoading.value = false;
          logedinData = profileResource.data;
          logedinData!.token = token;
          sharedPref.setLogindata(jsonEncode(logedinData!.toJson()));
          logedinData = await sharedPref.getLogindata();
          setStatus();

        } else {
          isLoading.value = false;
          showFailureSnackbar(
              "Failed", profileResource.message ?? "Failed");
        }
      }
      else {
        showFailureSnackbar(
            "No Internet", "Your device is not connected with internet.");
      }
    }


  }

  Future saveLicenseDetails()async{
    // dob:2000-01-01
    // idCardNumber:TEST000001,
    // idCardPhoto:
    List<String> path = [];
    List<String> keys = [];

      if (!userDrivingLicenseFormKey.currentState!.validate()) {
        return;
      }else {
        if(temporaryLicenseImagePath.isEmpty){
          showFailureSnackbar(
              "Oops", AppStrings.pleaseTakeDrivingLicenseImage.tr);
          return;
        }
        if (await _netWorkStatusChecker.isInternetAvailable()) {
          isLoading.value = true;
          var header = {
            "x-access-token": logedinData!.token ?? ""
          };
          var body = {
            "licenseNumber": licenseNumberController.text
          };
          XFile compressedFile = await compressFile(
              filePath: temporaryLicenseImagePath.value);
          path.add(compressedFile.path);
          keys.add("licensePhoto");
          Resource profileResource = await profileRepository
              .updateLicenseDetails(
              body: body, headers: header, key: keys, path: path
          );
          if (profileResource.status == STATUS.SUCCESS) {
            isLoading.value = false;
            logedinData = profileResource.data;
            logedinData!.token = token;
            sharedPref.setLogindata(jsonEncode(logedinData!.toJson()));
            logedinData = await sharedPref.getLogindata();
            setStatus();

          } else {
            isLoading.value = false;
            showFailureSnackbar(
                "Failed", profileResource.message ?? "Failed");
          }
        }
        else {
          showFailureSnackbar(
              "No Internet", "Your device is not connected with internet.");
        }

    }


  }

  Future getVehicleCompanyList()async{
    // dob:2000-01-01
    // idCardNumber:TEST000001,
    // idCardPhoto:
    if (await _netWorkStatusChecker.isInternetAvailable()) {

      isLoading.value = true;
      var header ={
        "x-access-token": logedinData!.token??""
      };
      Resource profileResource = await profileRepository.getVehicleCompanyList(header: header);
      if (profileResource.status == STATUS.SUCCESS) {
        isLoading.value = false;
        List<VehicleCompanies> vehicleCompanies = profileResource.data;
        vehicleCompanyList.clear();
        vehicleCompanyList.add(
          DropdownModel(uniqueid: -1,id: "-1",label: "Select",)
        );
        for(var item in vehicleCompanies){
          vehicleCompanyList.add(DropdownModel(uniqueid: item.id!,id: item.id!.toString(),label: item.name??"",));
        }

      } else {
        isLoading.value = false;
        showFailureSnackbar(
            "Failed", profileResource.message ?? "Failed");
      }
    }
    else{
      showFailureSnackbar("No Internet", "Your device is not connected with internet.");
    }


  }

  Future getVehicleModelList(String companyId)async{
    // dob:2000-01-01
    // idCardNumber:TEST000001,
    // idCardPhoto:
    if (await _netWorkStatusChecker.isInternetAvailable()) {

      isLoading.value = true;
      var header ={
        "x-access-token": logedinData!.token??""
      };
      var body ={
        "vehicleCompanyId": companyId
      };

      Resource profileResource = await profileRepository.getVehicleModelList(header: header,body: body);
      if (profileResource.status == STATUS.SUCCESS) {
        isLoading.value = false;
        List<VehicleModels> vehicleCompanies = profileResource.data;
        modelList.clear();
        modelList.add(
          DropdownModel(uniqueid: -1,id: "-1",label: "Select",)
        );
        for(var item in vehicleCompanies){
          modelList.add(DropdownModel(uniqueid: item.id!,id: item.id!.toString(),label: item.name??"",));
        }

      } else {
        isLoading.value = false;
        showFailureSnackbar(
            "Failed", profileResource.message ?? "Failed");
      }
    }
    else{
      showFailureSnackbar("No Internet", "Your device is not connected with internet.");
    }


  }

  Future updateBankDetails()async{
    if(selectedPayoutAccType.value.id == "1" && selectedBankName.value.id =="-1"){
      showFailureSnackbar(
          AppStrings.oops.tr, AppStrings.selectBankName.tr);
    }
    if (!userBankDetailsFormKey.currentState!.validate()) {
      return;
    }
    else{
      if (await _netWorkStatusChecker.isInternetAvailable()) {

        isLoading.value = true;
        var header ={
          "x-access-token": logedinData!.token??""
        };
        var body ={
          "payoutAccType":selectedPayoutAccType.value.id=="1"?"bank":selectedPayoutAccType.value.label,
          "bankId":selectedPayoutAccType.value.id =="1"? selectedBankName.value.id: "",
          "bankBranch":selectedPayoutAccType.value.id =="1"? branchNameController.text:"",
          "bankAccNo":selectedPayoutAccType.value.id =="1"? accountNumberController.text:"",
          "bankIfscCode":selectedPayoutAccType.value.id =="1"? ifscCodeController.text:"",
          "mWalletNumber":selectedPayoutAccType.value.id =="2"? mWalletNumberController.text:""
        };

        Resource profileResource = await profileRepository.updateBankDetails(headers: header,body: body);
        if (profileResource.status == STATUS.SUCCESS) {
          isLoading.value = false;
          logedinData = profileResource.data;
          logedinData!.token = token;
          sharedPref.setLogindata(jsonEncode(logedinData!.toJson()));

          logedinData = await sharedPref.getLogindata();
          setStatus();
        } else {
          isLoading.value = false;
          showFailureSnackbar(
              "Failed", profileResource.message ?? "Failed");
        }
      }else{
        showFailureSnackbar("No Internet", "Your device is not connected with internet.");
      }
  }
  }

  Future updateSelfie()async{
    // dob:2000-01-01
    // idCardNumber:TEST000001,
    // idCardPhoto:
    List<String> path = [];
    List<String> keys = [];
    if(temporarySelfieImagePath.isEmpty){
      showFailureSnackbar(
          "Oops","Please capture selfie");
      return;
    }
    if (await _netWorkStatusChecker.isInternetAvailable()) {

      isLoading.value = true;
      var header ={
        "x-access-token": logedinData!.token??""
      };
      var body ={
      };
      XFile compressedFile = await compressFile(filePath: temporarySelfieImagePath.value);
      path.add(compressedFile.path);
      keys.add("profilePic");
      Resource profileResource = await profileRepository.updateProfilePicture(body: body,headers: header,key:keys,path:path
      );
      if (profileResource.status == STATUS.SUCCESS) {
        isLoading.value = false;
        logedinData = profileResource.data;
        logedinData!.token = token;
        sharedPref.setLogindata(jsonEncode(logedinData!.toJson()));
        logedinData = await sharedPref.getLogindata();
        setStatus();


      } else {
        isLoading.value = false;
        showFailureSnackbar(
            "Failed", profileResource.message ?? "Failed");
      }
    }
    else{
      showFailureSnackbar("No Internet", "Your device is not connected with internet.");
    }


  }

  Future updateCarDetails()async{
    // dob:2000-01-01
    // idCardNumber:TEST000001,
    // idCardPhoto:
    List<String> path = [];
    List<String> keys = [];
    if (!userCarDetailsFormKey.currentState!.validate()) {
      return;
    }
    else {
      /*if(selectedManufactureYear.value.id =="-1"){
      showFailureSnackbar("Oops", AppStrings.pleaseChooseVehicleYear.tr);
      return;
    }
    else if(selectedVehicleCompany.value.id =="-1"){
      showFailureSnackbar("Oops", "Please choose vehicle company");
      return;
    }*/
      if(temporaryVehicleImagePath.isEmpty){
        showFailureSnackbar(
            "Oops", AppStrings.takeVehicleImage.tr);
        return;
      }
      else if(temporaryRegDocImagePath.isEmpty){
        showFailureSnackbar(
            "Oops", AppStrings.takeRegDoc.tr);
        return;
      }
      if (await _netWorkStatusChecker.isInternetAvailable()) {
        isLoading.value = true;
        var header = {
          "x-access-token": logedinData!.token ?? ""
        };

        var body = {
          "vehicleCompanyId": selectedVehicleCompany.value.id == "-1"
              ? ""
              : selectedVehicleCompany.value.id,
          "vehicleModelId": selectedModel.value.id == "-1" ? "" : selectedModel
              .value.id,
          "vehicleRegYear": selectedManufactureYear.value.id,
          "vehicleVinNo": vinNumberController.text,
          "vehicleRegNo": licensePlateNumberController.text,
        };

        XFile compressedFile = await compressFile(filePath: temporaryVehicleImagePath.value);
        XFile compressedFile2 = await compressFile(filePath: temporaryRegDocImagePath.value);
        path.add(compressedFile.path);
        path.add(compressedFile2.path);
        keys.add("vehicleImage");
        keys.add("vehicleRegDoc");
        Resource profileResource = await profileRepository.updateCarDetails(
            body: body, headers: header, key: keys, path: path
        );
        if (profileResource.status == STATUS.SUCCESS) {
          isLoading.value = false;
          logedinData = profileResource.data;
          logedinData!.token = token;
          sharedPref.setLogindata(jsonEncode(logedinData!.toJson()));
          logedinData = await sharedPref.getLogindata();
          setStatus();

        } else {
          isLoading.value = false;
          showFailureSnackbar(
              "Failed", profileResource.message ?? "Failed");
        }
      }
      else {
        showFailureSnackbar(
            "No Internet", "Your device is not connected with internet.");
      }
    }


  }
  Future<XFile> compressFile({required String  filePath}) async {


    // Create output file path
    // eg:- "Volume/VM/abcd_out.jpeg"
    final lastIndex = filePath.lastIndexOf(RegExp(r'.jp'));
    final splitted = filePath.substring(0, (lastIndex));
    final outPath = '${splitted}_out${filePath.substring(lastIndex)}';
    var result = await FlutterImageCompress.compressAndGetFile(
      filePath,
      outPath,
      quality: 50,
    );
    return result!;
  }

  void setYearData() {

    int year = DateTime.now()!.year;
    int startingYear = year-50;
    for(int i = year; i>=startingYear; i-- ){
      manufactureYearList.add(DropdownModel(uniqueid: i,id: i.toString(),label: i.toString(),));
    }
  }

  void clearForm(){
     emailController.text ="";
     passwordController.text ="";
     idNumberController.text ="";
     dobController.text ="";
     vinNumberController.text ="";
     licensePlateNumberController.text ="";
     licenseNumberController.text ="";
     insuranceNumberController.text ="";
     branchNameController.text ="";
     accountNumberController.text ="";
     mWalletNumberController.text ="";
     ifscCodeController.text ="";
     ibanNumberController.text ="";

      temporaryIdImageName.value = "";
      temporaryIdImagePath.value = "";

      temporaryInsuranceImageName.value = "";
      temporaryInsuranceImagePath.value = "";

      temporaryLicenseImageName.value = "";
      temporaryLicenseImagePath.value = "";

      temporarySelfieImageName.value = "";
      temporarySelfieImagePath.value = "";

      temporaryVehicleImageName.value = "";
      temporaryVehicleImagePath.value = "";

      temporaryRegDocImageName.value = "";
      temporaryRegDocImagePath.value = "";

      selectedBankName.value =  DropdownModel(uniqueid: -1,id: "-1",label: "Select",);
      selectedPayoutAccType.value =  DropdownModel(uniqueid: 2,id: "2",label: "mWallet",);

      selectedManufactureYear.value =  DropdownModel(uniqueid: -1,id: "-1",label: "Select",);
      selectedModel.value =  DropdownModel(uniqueid: -1,id: "-1",label: "Select",);
      selectedVehicleCompany.value =  DropdownModel(uniqueid: -1,id: "-1",label: "Select",);
  }
}