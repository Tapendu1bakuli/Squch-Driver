import 'package:get/get.dart' show GetPage, Transition;
import 'package:squch_driver/features/chat_screen_features/presentation/chat_screen.dart';
import 'package:squch_driver/features/map_page_feature/presentation/bindings/map_binding.dart';
import 'package:squch_driver/features/user_auth_feature/presentation/ChooseCountryView.dart';
import 'package:squch_driver/features/user_profile_feature/presentation/bindings/profile_binding.dart';
import 'package:squch_driver/features/user_profile_feature/presentation/car_details.dart';
import 'package:squch_driver/features/user_auth_feature/presentation/controller/auth_controller.dart';
import 'package:squch_driver/features/user_profile_feature/presentation/driver_details_listing.dart';
import 'package:squch_driver/features/user_profile_feature/presentation/selfie_page.dart';
import 'package:squch_driver/features/welcome_page_feature/landing_screen.dart';

import 'package:squch_driver/features/welcome_page_feature/presentation/bindings/welcome_binding.dart';

//import 'package:squch_driver/features/welcome_page_feature/presenation/introduction_page.dart';
import 'package:squch_driver/features/welcome_page_feature/presentation/splash_screen.dart';
import '../../../features/chat_screen_features/presentation/binding/chat_binding.dart';
import '../../../features/dashboard_feature/presentation/bindings/dashboard_binding.dart';
import '../../../features/dashboard_feature/presentation/dash_board_page.dart';
import '../../../features/map_page_feature/presentation/map_page.dart';
import '../../../features/rate_ride_feature/presentation/rate_ride_page.dart';
import '../../../features/user_auth_feature/presentation/bindings/auth_binding.dart';
import '../../../features/user_auth_feature/presentation/verify_registration_otp.dart';
import '../../../features/user_profile_feature/presentation/driving_licence_details.dart';
import '../../../features/user_profile_feature/presentation/id_proof_details.dart';
import '../../../features/user_profile_feature/presentation/insurance_details.dart';
import '../../../features/user_auth_feature/presentation/login_page.dart';
import '../../../features/user_profile_feature/presentation/payout_bank_details.dart';
import '../../../features/user_auth_feature/presentation/signup_page.dart';
import '../../../features/user_auth_feature/presentation/type_selection.dart';
import '../../../features/welcome_page_feature/presentation/introduction_page.dart';
import 'auth_middleware.dart';
import 'routes.dart';

class AppPages {
  static const INITIAL = Routes.ROOT;

  static final AppRoutes = [
    GetPage(
        name: Routes.ROOT,
        page: () => SplashScreen(),
        binding: WelcomeBinding()),
    GetPage(
        name: Routes.LANDING,
        page: () => LandingScreen(),
        binding: WelcomeBinding()),
    GetPage(
        name: Routes.INTRODUCTION,
        page: () => IntroductionPage(),
        binding: WelcomeBinding()),
    GetPage(
        name: Routes.LOGIN,
        page: () => LoginPage(),
        binding: AuthBinding(),
        middlewares: [AuthMiddleware()],
        transitionDuration: Duration(milliseconds: 100)),
    GetPage(
        name: Routes.CHOOSECOUNTRY,
        page: () => ChooseCountryView(),
        binding: AuthBinding(),
        middlewares: [AuthMiddleware()],
        transitionDuration: Duration(milliseconds: 100)),
    GetPage(
        name: Routes.REGISTER,
        page: () => SignUpPage(),
        binding: AuthBinding(),
        middlewares: [AuthMiddleware()],
        transitionDuration: Duration(milliseconds: 100)),
    GetPage(
        name: Routes.TYPESELECTION,
        page: () => TypeSelectionPage(),
        binding: AuthBinding(),
        middlewares: [AuthMiddleware()],
        transitionDuration: Duration(milliseconds: 100)),
    GetPage(
        name: Routes.DRIVER_DETAILS_LISTING,
        page: () => DriverDetailsListingPage(),
        binding: ProfileBinding(),
        middlewares: [AuthMiddleware()],
        transitionDuration: Duration(milliseconds: 100)),
    GetPage(
        name: Routes.DASHBOARD,
        page: () => DashBoardPage(),
        binding: DashboardBinding(),
        middlewares: [AuthMiddleware()],
        transitionDuration: Duration(milliseconds: 100)),
    GetPage(
        name: Routes.ID_PROOF_DETAILS,
        page: () => IdProofDetailsPage(),
        binding: ProfileBinding(),
        middlewares: [AuthMiddleware()],
        transitionDuration: Duration(milliseconds: 100)),
    GetPage(
        name: Routes.CAR_DETAILS,
        page: () => CarDetailsPage(),
        binding: ProfileBinding(),
        middlewares: [AuthMiddleware()],
        transitionDuration: Duration(milliseconds: 100)),
    GetPage(
        name: Routes.DRIVING_LICENCE_DETAILS,
        page: () => DrivingLicenceDetailsPage(),
        binding: ProfileBinding(),
        middlewares: [AuthMiddleware()],
        transitionDuration: Duration(milliseconds: 100)),
    GetPage(
        name: Routes.INSURANCE_DETAILS,
        page: () => InsuranceDetailsPage(),
        binding: ProfileBinding(),
        middlewares: [AuthMiddleware()],
        transitionDuration: Duration(milliseconds: 100)),
    GetPage(
        name: Routes.PAYOUT_BANK_DETAILS,
        page: () => PayoutBankDetailsPage(),
        binding: ProfileBinding(),
        middlewares: [AuthMiddleware()],
        transitionDuration: Duration(milliseconds: 100)),
    GetPage(
        name: Routes.SELFIE_PAGE,
        page: () => SelfiePage(),
        binding: AuthBinding(),
        middlewares: [AuthMiddleware()],
        transitionDuration: Duration(milliseconds: 100)),
    GetPage(
        name: Routes.VERIFY_OTP_PAGE,
        page: () => VerifyRegistrationOtp(),
        binding: AuthBinding(),
        middlewares: [AuthMiddleware()],
        transitionDuration: Duration(milliseconds: 100)),
    GetPage(
        name: Routes.MAP_PAGE,
        page: () => MapPage(),
        binding: MapBinding(),
        middlewares: [AuthMiddleware()],
        transitionDuration: Duration(milliseconds: 100)
    ),
    /*   GetPage(
        name: Routes.LOGIN,
        page: () => LoginPage(),
        binding: AuthBinding(),
        middlewares: [AuthMiddleware()],
      transitionDuration: Duration(milliseconds: 100)
    ),
     GetPage(
        name: Routes.REGISTER_OTP_VERIFICATION,
        page: () => SignUpPage(),
        binding: AuthBinding(),
        middlewares: [AuthMiddleware()],
      transitionDuration: Duration(milliseconds: 100)
    ),
     GetPage(
        name: Routes.REGISTER_OTP_VERIFICATION,
        page: () => SignUpPage(),
        binding: AuthBinding(),
        middlewares: [AuthMiddleware()],
      transitionDuration: Duration(milliseconds: 100)
    ),

     GetPage(
        name: Routes.FORGOT_PASSWORD,
        page: () => ForgotPasswordPage(),
        binding: AuthBinding(),
        middlewares: [AuthMiddleware()],
      transitionDuration: Duration(milliseconds: 100)
    ),
     GetPage(
        name: Routes.FORGOT_PASSWORD_OTP_VERIFICATION,
        page: () => VerifyForgetPasswordOtp(),
        binding: AuthBinding(),
        middlewares: [AuthMiddleware()],
      transitionDuration: Duration(milliseconds: 100)
    ),
     GetPage(
        name: Routes.SETUP_NEW_PASSWORD,
        page: () => SetNewPasswordPage(),
        binding: AuthBinding(),
        middlewares: [AuthMiddleware()],
        transitionDuration: Duration(milliseconds: 100)
    ),

     GetPage(
        name: Routes.HOME,
        page: () => HomePage(),
        binding: AuthBinding(),
        middlewares: [AuthMiddleware()],
        transitionDuration: Duration(milliseconds: 100)
    ),

    GetPage(
        name: Routes.MAP_PAGE,
        page: () => MapPage(),
        binding: MapBinding(),
        middlewares: [AuthMiddleware()],
        transitionDuration: Duration(milliseconds: 100)
    ),
GetPage(
        name: Routes.OTHER_REASON,
        page: () => OterReason(),
        binding: MapBinding(),
        middlewares: [AuthMiddleware()],
        transitionDuration: Duration(milliseconds: 100)
    ),
GetPage(
        name: Routes.PAYMENT_OPTION,
        page: () => PaymentOptionPage(),
        binding: MapBinding(),
        middlewares: [AuthMiddleware()],
        transitionDuration: Duration(milliseconds: 100)
    ),
    */
    GetPage(
        name: Routes.RIDE_SUMMARY,
        page: () => RateRidePage(total: "\$616.80",tripCharge: "\$216.00",subTotal: "\$216.00",rounding: "\$111.00",bookingFee: "\$16.00",ridePromotion: "-\$56.00",date: "1/14/24",paidBy: "paypal",time: "10:34pm",payments: "\$616.80"),
        binding: MapBinding(),
        middlewares: [AuthMiddleware()],
        transitionDuration: Duration(milliseconds: 100)
    ),
    GetPage(
        name: Routes.CHAT_SCREEN,
        page: () => ChatScreen(),
        binding: ChatBinding(),
        middlewares: [AuthMiddleware()],
        transitionDuration: Duration(milliseconds: 100)
    ),
  ];
}
