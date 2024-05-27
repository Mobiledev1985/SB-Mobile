import 'package:hive/hive.dart';
import 'package:sb_mobile/core/config/server_config.dart';
import 'package:sb_mobile/core/config/user_model.dart';

Authenticator auth = Authenticator();

const String authBoxName = "userBox";
const String authBoxKey = "user";
const String isFirstTimeKey = "isFirstTime";
const String isFirstAnglerJourney = "isFirstAnglerJourney";
const String isFirstHomeScreen = "isFirstHomeScreen";
const String isFirstTimeCatchReport = "isFirstTimeCatchReport";

Future<void> deleteAuthBox() async {
  final authBox = await Hive.openBox<UserCredentials>(authBoxName);
  authBox.deleteFromDisk();
}
