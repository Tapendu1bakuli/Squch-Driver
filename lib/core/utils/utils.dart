
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sizing/sizing.dart';
import 'package:squch_driver/core/utils/fonts.dart';
import 'package:squch_driver/core/widgets/gap.dart';
//import 'package:squch_driver/features/user_auth_feature/presentation/login_page.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';


import '../shared_pref/shared_pref.dart';

import 'app_colors.dart';
import 'app_strings.dart';


/*
Future<String> openDatePicker(
    BuildContext context, String startDate, String enddate) async {
  String formattedDate = "";
  DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate:
      // (startDate.isEmpty) ?
           DateTime.now(),
          // : DateFormat("yyyy-MM-dd").parse(startDate),
      firstDate: */
/*(enddate.isEmpty)
          ?*//*
 DateTime(1900),
          // : DateFormat("yyyy-MM-dd").parse(enddate),
      //DateTime.now() - not to allow to choose before today.
      lastDate: DateTime(DateTime.now().year + 100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColors.colorDeepPrimary, // <-- SEE HERE
              onPrimary: AppColors.colorAssent, // <-- SEE HERE
              onSurface: AppColors.colorDeepPrimary, // <-- SEE HERE
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                primary: AppColors.colorPrimary, // button text color
              ),
            ),
          ),
          child: child!,
        );
      });

  if (pickedDate != null) {
    print(pickedDate); //pickedDate output format => 2021-03-10 00:00:00.000
    formattedDate = DateFormat('MM/dd/yy').format(pickedDate);
  }
  return formattedDate;
}
*/

bool isGraterDate(String startDate, String endDate) {
  bool isGrater = false;
  try {
    DateTime dt1 = DateTime.parse(startDate);
    DateTime dt2 = DateTime.parse(endDate);

    if (dt1.compareTo(dt2) == 0) {
      debugPrint("Both date time are at same moment.");
      return false;
    }

    if (dt1.compareTo(dt2) < 0) {
      debugPrint("DT1 is before DT2");
      return false;
    }

    if (dt1.compareTo(dt2) > 0) {
      debugPrint("DT1 is after DT2");
      return true;
    }
  } catch (e) {}
  return isGrater;
}

/*String convertDate(String inputdate, String format) {
  String date ="";
  try {
    print(inputdate);
    DateTime dt1 = DateTime.parse(inputdate);
    String formattedDate = DateFormat(format).format(dt1);
    print(formattedDate);
    date =  formattedDate;
  } catch (e) {}
  return date;
}

Future downloadFile(String path,String name) async {
  final taskId = await FlutterDownloader.enqueue(
    url: path,
    savedDir: 'the path of directory where you want to save downloaded files',
    showNotification: true,
    // show download progress in status bar (for Android)
    openFileFromNotification: true, // click on notification to open downloaded file (for Android)
  );
}*/
void showLogoutDialog(Function()? onYesTapped) {
  Get.defaultDialog(title: "Warning",content: Text("Do you want to logout?",style: CustomTextStyle(),),onCancel: (){
    Get.back();
  },onConfirm: onYesTapped,buttonColor: AppColors.buttonColor,textConfirm: "Yes",textCancel: "No",cancelTextColor: AppColors.buttonColor
  );
}
Future logoutUser()async {
  SharedPref sharedPref = Get.find();
  await sharedPref.setLoggedin(false);
  await sharedPref.setLogindata("");
  // sharedPref.clearData();
   //Get.offAll(LoginPage());

}

void showFailureSnackbar( String? title,String msg){
  Get.snackbar(title??AppStrings.oops.tr,msg,snackPosition: SnackPosition.TOP,
      backgroundColor: AppColors.colorgrey,
      colorText: Colors.red,
      padding: EdgeInsets.all(20),
      margin: EdgeInsets.all(20)
  );
}

void showSuccessSnackbar( String? title,String msg) {
  Get.snackbar(title ?? AppStrings.oops.tr, msg, snackPosition: SnackPosition.TOP,
      backgroundColor: AppColors.colorgrey,
      colorText: AppColors.buttonColor,
      padding: EdgeInsets.all(20),
      margin: EdgeInsets.all(20)
  );
}

void showNotificationSnackbar({required String title, required String msg, Function(String?)? onNotificationTap}) {
     Get.snackbar(title, msg, snackPosition: SnackPosition.TOP,
      backgroundColor: AppColors.colorWhite,
      colorText: AppColors.buttonColor,
      padding: EdgeInsets.all(20),
      margin: EdgeInsets.all(20),
      onTap:(value)=> onNotificationTap
  );
}

emailValidator(String? email){
  Pattern pattern = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
  RegExp regex = new RegExp(pattern.toString());
  if(email == null || email.isEmpty){
    return 'Email is empty';
  } if (!(regex.hasMatch(email))) {
    return "Please enter a valid email";
  }
  return null;
}

mobileValidator(String? mobile){

  if(mobile == null || mobile.isEmpty){
    return 'Mobile no is empty';
  } if (mobile.length<10) {
    return "Please enter a valid mobile no";
  }
  return null;
}

Future modalBottomSheetMenu(BuildContext context, Function onImageSelected,{bool? isFront = false}) async {
  XFile? choosedImage;
  await showModalBottomSheet(
      backgroundColor: Get.theme.colorScheme.onPrimary,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(25.0),
        ),
      ),
      context: context,
      builder: (builder) {
        return Container(
          height: 187.0.ss,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(25.0),
            ),
          ),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28.0),
              child: Column(
                children: [
                  Gap(10),
                  Container(
                    width: 54,
                    height: 3,
                    decoration: ShapeDecoration(
                      color: AppColors.colorLightGrey,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(100),
                      ),
                    ),
                  ),
                  Gap(30),
                  ElevatedButton(
                    style: ButtonStyle(
                        fixedSize: MaterialStateProperty.all<Size>(
                          Size(335.0.ss, 48.0.ss), // Set the desired width and height
                        ),
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0), // Adjust the value as needed
                          ),
                        ),
                        backgroundColor: MaterialStateProperty.all<Color>(AppColors.iconColor)),
                    onPressed: () async {
                      Get.back();
                      debugPrint("Camera button pressed");
                      choosedImage = await  openCamera(context,isFront: isFront);
                      onImageSelected(choosedImage);
                    },
                    child: Text(AppStrings.takePhoto.tr,style: CustomTextStyle(fontWeight: FontWeight.w700,fontSize: 15,color: AppColors.colorWhite),),
                  ),
                  Gap(14),
                  ElevatedButton(
                    style: ButtonStyle(
                        fixedSize: MaterialStateProperty.all<Size>(
                          Size(335.0.ss, 48.0.ss), // Set the desired width and height
                        ),
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0), // Adjust the value as needed
                          ),
                        ),
                        backgroundColor: MaterialStateProperty.all<Color>(
                            AppColors.colorGrey)),
                    onPressed: () async {
                      Get.back();
                      debugPrint("Gallery button pressed");
                       choosedImage = await _getFromGallery();
                      onImageSelected(choosedImage);
                    },
                    child: Text(AppStrings.addFromPhotoLibrary.tr,style: CustomTextStyle(color: AppColors.titleColor,fontWeight: FontWeight.w700,fontSize: 15),),
                  ),
                ],
              ),
            ),
          ),
        );
      });
 // return choosedImage;
}

Future<XFile?> openGallery(context) async {
  // Check if the storage permission is already granted
  PermissionStatus status = await Permission.storage.status;
  if (status.isGranted) {
    // Permission is already granted, open the gallery
   return _getFromGallery();
  } else if (status.isDenied) {
    // Permission is denied, show a dialog to request permission again
    showPermissionDialog(context);
  } else {
    // Permission is not determined, request the storage permission
    PermissionStatus requestedStatus = await Permission.storage.request();
    if (requestedStatus.isGranted) {
      // Permission granted, open the gallery
    return _getFromGallery();
    } else if (requestedStatus.isPermanentlyDenied) {
      // Permission denied permanently, show a dialog to redirect to app settings
      showSettingsDialog(context);
    } else {
      // Permission denied, handle accordingly
      print('Gallery permission denied');
    }
  }
}

Future<XFile?> openCamera(context,{bool? isFront = false}) async {
  // Check if the camera permission is already granted
  PermissionStatus status = await Permission.camera.status;
  if (status.isGranted) {
    // Permission is already granted, open the camera
   return _getFromCamera(isFront: isFront);
  } else if (status.isDenied) {
    // Permission is denied, show a dialog to request permission again
    showPermissionDialog(context);
  } else {
    // Permission is not determined, request the camera permission
    PermissionStatus requestedStatus = await Permission.camera.request();
    if (requestedStatus.isGranted) {
      // Permission granted, open the camera
    return _getFromCamera(isFront: isFront);
    } else if (requestedStatus.isPermanentlyDenied) {
      // Permission denied permanently, show a dialog to redirect to app settings
      showSettingsDialog(context);
    } else {
      // Permission denied, handle accordingly
      print('Camera permission denied');
    }
  }
}

void showSettingsDialog(context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Permission Required'),
        content: const Text(
            'Camera permission is required. Please enable it in the app settings.'),
        actions: [
          TextButton(
            child: const Text('CANCEL'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: const Text('SETTINGS'),
            onPressed: () {
              Navigator.of(context).pop();
              openAppSettings(); // Open app settings page
            },
          ),
        ],
      );
    },
  );
}

void showPermissionDialog(context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Permission Required'),
        content: const Text('This app requires access to the camera.'),
        actions: [
          TextButton(
            child: const Text('CANCEL'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: const Text('SETTINGS'),
            onPressed: () {
              Navigator.of(context).pop();
              openAppSettings(); // Open app settings page
            },
          ),
        ],
      );
    },
  );
}

Future<XFile?> _getFromGallery() async {
  XFile? selectedImage;
  selectedImage = (await ImagePicker().pickImage(
    source: ImageSource.gallery,
    maxWidth: 1800,
    maxHeight: 1800,
  ));
  if (selectedImage != null) {
    CroppedFile? croppedImage = await ImageCropper().cropImage(
      sourcePath: selectedImage.path,
      aspectRatioPresets: [
        CropAspectRatioPreset.square,
        CropAspectRatioPreset.ratio3x2,
        CropAspectRatioPreset.original,
        CropAspectRatioPreset.ratio4x3,
        CropAspectRatioPreset.ratio16x9,
        CropAspectRatioPreset.ratio7x5,
      ],
      compressQuality: 100, // Set the compression quality
    );

    // Convert the File to XFile
    if (croppedImage != null) {
      return XFile(croppedImage.path);
    }
  }
  return null;
}

Future<XFile?> _getFromCamera({bool? isFront= false}) async {
  print("ISFRONT:$isFront");
  XFile? selectedImage;

  // Pick image from the camera
  selectedImage = await ImagePicker().pickImage(
    source: ImageSource.camera,
    preferredCameraDevice: (isFront ?? false)?CameraDevice.front:CameraDevice.rear,
    maxWidth: 1800,
    maxHeight: 1800,
  );

  // Check if an image was selected
  if (selectedImage != null) {
    // Crop the selected image
    CroppedFile? croppedImage = await ImageCropper().cropImage(
      sourcePath: selectedImage.path,
      aspectRatioPresets: [
        CropAspectRatioPreset.square,
        CropAspectRatioPreset.ratio3x2,
        CropAspectRatioPreset.original,
        CropAspectRatioPreset.ratio4x3,
        CropAspectRatioPreset.ratio16x9,
        CropAspectRatioPreset.ratio7x5,
      ],
      compressQuality: 100, // Set the compression quality
    );

    // Convert the File to XFile
    if (croppedImage != null) {
      return XFile(croppedImage.path);
    }
  }

  // Return null if no image was selected or cropping was canceled
  return null;
}
// String input = DateFormat('yyyy-MM-dd HH:mm:ss').format(dt1);
//     String  formattedDate = DateFormat('EEEE, MMM d, yyyy').format(input);


Future<DateTime?> getDateTimeFromCalender(
    {required BuildContext context, required bool isFutureDateEnable,DateTime? initialDate,DateTime ? firstDate,DateTime ? lastDate}) async {
  DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate??DateTime.now(),
      firstDate:firstDate?? DateTime(1900),
      //DateTime.now() - not to allow to choose before today.
      lastDate: lastDate!=null?lastDate :  isFutureDateEnable? DateTime.now().add(Duration(days: 100000)): DateTime.now());

  if (pickedDate != null) {
    debugPrint(pickedDate.toString()); 
    String formattedDate =
    DateFormat('yyyy-MM-dd').format(pickedDate);
    debugPrint(formattedDate);
  } else {}

  return pickedDate;
}

openDialPad(String phoneNumber) async {
  Uri url = Uri(scheme: "tel", path: phoneNumber);
  if (await canLaunchUrl(url)) {
    await launchUrl(url);
  } else {
    print("Can't open dial pad.");
  }
}