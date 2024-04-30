# Get Route Generator.

We can generate code like:
```dart
import 'package:get/get.dart';
import 'package:xxxx/pages/welcome_page/welcome_view.dart';
import 'package:xxxx/pages/welcome_page/welcome_binding.dart';
import 'package:xxxx/pages/login/login_view.dart';
import 'package:xxxx/pages/login/login_binding.dart';

class AppRouterName {
  static const String welcomePage = '/welcomePage';
  static const String loginPage = '/loginPage';
}

class AppRouter {
  static List<GetPage> pages = [
    GetPage(name: AppRouterName.welcomePage, page: () => const WelcomePage(), binding: WelcomeBinding()),
    GetPage(name: AppRouterName.loginPage, page: () => const LoginPage(), binding: LoginBinding()),
  ];
}
```

Only `@GetGeneratePage()` like:
```dart
@GetGeneratePage()
class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final logic = Get.find<WelcomeLogic>();
    final state = Get.find<WelcomeLogic>().state;

    return Container();
  }
}
```
When project file structure like:
```
[welcome_page](..%2F..%2Fflutter_pro%2Fpair_up%2Flib%2Fpages%2Fwelcome_page)
[welcome_binding.dart](..%2F..%2Fflutter_pro%2Fpair_up%2Flib%2Fpages%2Fwelcome_page%2Fwelcome_binding.dart)
[welcome_logic.dart](..%2F..%2Fflutter_pro%2Fpair_up%2Flib%2Fpages%2Fwelcome_page%2Fwelcome_logic.dart)
[welcome_state.dart](..%2F..%2Fflutter_pro%2Fpair_up%2Flib%2Fpages%2Fwelcome_page%2Fwelcome_state.dart)
[welcome_view.dart](..%2F..%2Fflutter_pro%2Fpair_up%2Flib%2Fpages%2Fwelcome_page%2Fwelcome_view.dart)
```