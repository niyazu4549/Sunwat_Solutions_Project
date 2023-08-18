// Images
import 'package:sunwat_solutions/common_functions.dart';

String logo = 'assets/images/logo.png';
String backgroundImage = 'assets/images/sunwat 5-1.png';
String enableImageIcon = 'assets/images/switch_enable.png';
String disableImageIcon = 'assets/images/switch_disable.png';

// Texts
String content1 = "Just one step you can see what's";
String content2 = "happened in the world";
String email = "Email or Phone Number";
String fullName = "Full Name";
String userName = "userName";
String password = "password";
String signUp = 'Sign Up';
String account = 'Have an account?';
String login = 'log In';
String content4 = 'We need permission for the service you use';
String learnMore = 'Learn More';
String ubuntu = 'ubuntu_Medium';
String emailOrPassword = "Phone Number,userName or Email";
String forgetPassword = "Forgot password?";
String donTHaveAccount = "Don't have an account?";
String enterYourEmail = 'Enter your email, phone, or userName';
String text1 = "and we'll send you a link to change a";
String newPassword = "new password";
String forgetPassword1 = 'Forgot password';
String roPlantReport = 'RO Plant Report';
String selectRoPlantName = 'Please Select RO Plant Name';
String plantAddress = "Plant Address";
String sufficientRawWaterAvailable = 'Sufficient Raw Water Available';
String nextButton = 'NEXT';
String rOPlantReport = 'RO Plant Report';
String reportText1 = 'Please Click On RO Plant Report To';
String reportText2 = 'Enter Details';
String rOPlantReportButton = 'RO Plant Report';
String plantReportOnDate = 'Plant Report On Date: ${getCurrentDatetime()}';
String byUser = 'By User: ${ConstantVariables.userName}';
String sNo = 'S.No.';
String rOPlantName = 'RO Plant Name';
String one = '1';
String aPssa = 'APSSA,Visakhapatnam-Viskha...';
String vieWButton = 'View';
String reMarks = 'Remarks';
String plantPhotos = 'Plant Photos';
String textForTextField = 'I/We Hereby Certify That The RO Plant';
String textForTextField1 = 'Report Taken By Sunwat Solutions PVT';
String textForTextField2 = 'on Date ${getCurrentDatetime()}';
String customerSignatureButton = 'Customer Signature';
String clearSignatureButton = 'Clear Signature';
String textForTextField3 = 'I Confirm That The RO Plant Reports';
String textForTextField4 = 'Have Been Taken On Dated ${getCurrentDatetime()}';
String executiveSignatureButton = 'Executive Signature';
String submitButton = 'Submit';
String cancelButton = 'Cancel';
String agreeContent= "Sunwat app collects location data to enable the tracking of the user, to attend the client onsite service calls, even when the app is closed or not in use ";
String disagreeContent= "In order proceed further login into the app we need you to agree the terms of ";
String privacyPolicyUrl= "https://sunwatsolutions.com/privacy-policy/";

// API URLS
String loginUrl = "http://sunwatsolutions.com/api/Home/login";
String logOutUrl = "http://sunwatsolutions.com/api/Home/logout";
String changePasswordUrl = "http://sunwatsolutions.com/api/Home/changepassword";
String forgetPasswordUrl = "http://sunwatsolutions.com/api/Home/forgetPassword";
String searchPlantUrl = "http://sunwatsolutions.com/api/Home/searchplant";
String plantUrl = "http://sunwatsolutions.com/api/Home/plants";
String serviceListModelUrl = "http://sunwatsolutions.com/api/Home/serviceslist";
String savedataUrl = "http://sunwatsolutions.com/api/Home/savedata";
String locationUrl = "http://sunwatsolutions.com/api/Home/userlogmap";
String reportUrl = "http://sunwatsolutions.com/api/Home/plantreportuser?id=";
String uploadUrl = 'http://sunwatsolutions.com/api/Home/reportimagesdata';
String finalReportUrl = 'http://sunwatsolutions.com/api/Home/reportdetails';

Map<String, String>? getHeaders = {
  'Content-Type': 'application/json; charset=UTF-8',
};
String? latitude, longitude;

Map<String, dynamic> requestPayloadMap = {
  "user_id": ConstantVariables.userId,
  "plant_id": ConstantVariables.plantId,
  "plant_name": ConstantVariables.plantName,
  "plant_address": ConstantVariables.plantAddress,
  "serviceListdata": ConstantVariables.serviceListDataArray,
};

class ConstantVariables {
  static String userId = '';
  static String userName = '';
  static String plantId = '';
  static String reportId = '';
  static String plantName = '';
  static String plantAddress = '';
  static String remarks = '';
  static String customerName = '';
  static String executiveName = '';

  static List<String> selectedImages = [];
  static String? customerSignatureImageArray;
  static String? executiveSignatureImageArray;
  static List<Map<String, dynamic>> serviceListDataArray = [];
  static String deviceToken='';
}
