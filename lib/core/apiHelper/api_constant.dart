const int TIMEOUT_DURATION = 5;

const String BASE_URL = 'api.squch.com';

//Auth Section
const String LOGIN = '/api/v1/auth/driver/login';
const String REGISTRATION_MASTER = '/api/v1/auth/user/register/master';
const String REGISTRATION_SUBMIT = '/api/v1/auth/driver/register';
const String REGISTRATION_VERIFY_EMAIL = '/api/v1/auth/otp/verify/driver-register/email';
const String REGISTRATION_VERIFY_MOBILE = '/api/v1/auth/otp/verify/driver-register/mobile';
const String RESEND_EMAIL_OTP = '/api/v1/auth/otp/resend/driver-register/email';
const String RESEND_MOBILE_OTP = '/api/v1/auth/otp/resend/driver-register/mobile';
const String FORGOT_PASSWORD = '/api/v1/auth/driver/reset-password';
const String FORGOT_PASSWORD_RESEND_OTP = '/api/v1/auth/otp/resend/user-resetpassword/mobile';
const String FORGOT_PASSWORD_VERIFY_OTP = '/api/v1/auth/otp/verify/user-resetpassword/mobile';
const String SET_NEW_PASSWORD = '/api/v1/auth/driver/reset-password/change';

const String GET_PROFILE = '/api/v1/driver/profile/get';
const String GET_BANK_LIST = '/api/v1/driver/profile/banks/master';
const String GET_VEHICLE_COMPANY_LIST = '/api/v1/driver/profile/vehicle-companies/master';
const String GET_VEHICLE_MODEL_LIST = '/api/v1/driver/profile/vehicle-models/master';
const String UPDATE_ID_PROOF = '/api/v1/driver/profile/idproof-details/update';
const String UPDATE_INSURANCE_DETAILS = '/api/v1/driver/profile/insurance-details/update';
const String UPDATE_LICENSE_DETAILS = '/api/v1/driver/profile/license-details/update';
const String UPDATE_BANK_DETAILS = '/api/v1/driver/profile/bank-details/update';
const String UPDATE_SELFIE = '/api/v1/driver/profile/profile-picture/update';
const String UPDATE_CAR_DETAILS = '/api/v1/driver/profile/vehicle-details/update';


// Logout
const String LOGOUT = '/api/v1/driver/logout';
//Change Online Status
const String CHANGE_ONLINE_STATUS = '/api/v1/driver/profile/online-status/update';

const String UPDATE_LOCATION = '/api/v1/driver/profile/location/update';

//Ride Section
const String INIT_RIDE = '/api/v1/driver/ride/init';
const String INTRO_SCREEN = '/api/v1/common/cms-content/get';
const String GET_CANCEL_RIDE_REASON = '/api/v1/driver/ride/cancel/master';


//Socket Ports
const String driverRideSearch = "driverRideSearch";
const String driverSearchRideIn = "driverSearchRideIn";
const String driverRideAccept = "driverRideAccept";
const String rideStatusUpdate = "rideStatusUpdate";
const String driverRideBidRejected = "driverRideBidRejected";
const String driverSearchRideOut = "driverSearchRideOut";
const String driverRideStatusUpdate = "driverRideStatusUpdate";
const String rideSendMessage = "rideSendMessage";
const String rideNewMessage = "rideNewMessage";
const String rideFetchMessage = "rideFetchMessage";



 //Socket Config
//ws://api.squch.com:3000?x-access-token=[Driver Access Token]
const String SOCKET_URL = "http://api.squch.com";
const String SOCKET_PATH = '/socket.io';
const String SOCKET_TRANSPORTERS = 'websocket';
