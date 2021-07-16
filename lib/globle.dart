class Globle {
  //One instance, needs factory
  static Globle _instance;

  static bool isRembemerMe=false;

  factory Globle() => _instance ??= new Globle._();
  Globle._();
  //

  static String serverUrl ='http://iotsolution.unifiedtnc.com/api/';
  static String login =serverUrl+'get_login.php';
  static String signUp =serverUrl+'get_user_signup.php';
  static String getGraph =serverUrl+'get_graph_url.php';
  static String getCategory =serverUrl+'get_category.php';
  static String resetPassword =serverUrl+'forgot_password.php';
  static String driver ='driver';
  static String vehicle ='vehicle';
  static String temp ='temp';
  static String fuel ='fuel';
  /*-------------------------------*/
  static String terms ='https://iotsolutions.ie/terms-conditions';
  static String contact ='https://iotsolutions.ie/home/contact';
  static String privacy ='https://iotsolutions.ie/privacy-policy/';
  /*-------------------------------*/
  static String name ='';
  static String email ='';
  static String userId ='';
  static String password ='';

  static List<dynamic> data;
}