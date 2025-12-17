

import '../../db/service/login/login_local_service.dart';

Future<void> totalDataClean() async {
  await LoginLocalService().deleteTokens();
}
