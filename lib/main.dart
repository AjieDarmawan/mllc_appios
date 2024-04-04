// import 'package:agconnect_core/agconnect_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_branch_sdk/flutter_branch_sdk.dart';
import 'package:mlcc_app_ios/Bloc/timer/timer_bloc.dart';
import 'package:mlcc_app_ios/models/ticker.dart';
import 'package:mlcc_app_ios/screens/main_view.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mlcc_app_ios/Bloc/adv/adv_bloc.dart';
import 'package:mlcc_app_ios/Bloc/auth/auth_bloc.dart';
import 'package:mlcc_app_ios/Bloc/dashboard/dashboard_bloc.dart';
import 'package:mlcc_app_ios/Bloc/entrepreneurs/entrepreneurs_bloc.dart';
import 'package:mlcc_app_ios/Bloc/events/events_bloc.dart';
import 'package:mlcc_app_ios/Bloc/trainings/trainings_bloc.dart';
import 'package:mlcc_app_ios/Bloc/xproject/xproject_bloc.dart';

import 'package:mlcc_app_ios/provider/http_provider.dart';
import 'package:mlcc_app_ios/screens/page/account/account_company.dart';
import 'package:mlcc_app_ios/screens/page/account/account_education_view.dart';
import 'package:mlcc_app_ios/screens/page/account/account_professional_cert_view.dart';
import 'package:mlcc_app_ios/screens/page/account/account_social_media_view.dart';
import 'package:mlcc_app_ios/screens/page/account/account_societies_view.dart';
import 'package:mlcc_app_ios/screens/page/account/account_work_experienced_view.dart';
import 'package:mlcc_app_ios/screens/page/account/contact_us.dart';
import 'package:mlcc_app_ios/screens/page/adv/product_detail_view.dart';
import 'package:mlcc_app_ios/screens/page/adv/reward_detail_view.dart';
import 'package:mlcc_app_ios/screens/page/adv/reward_detail_view.dart';
import 'package:mlcc_app_ios/screens/page/adv/sponsored_detail_view.dart';
import 'package:mlcc_app_ios/screens/page/adv/voucher_detail_view.dart';
import 'package:mlcc_app_ios/screens/page/auth/forgot_password_page.dart';
import 'package:mlcc_app_ios/screens/page/auth/login_page.dart';
import 'package:mlcc_app_ios/screens/page/auth/register_company_page.dart';
import 'package:mlcc_app_ios/screens/page/auth/register_personal_basic_info_page.dart';
import 'package:mlcc_app_ios/screens/page/entrepreneurs/entrepreneur_details_view.dart';
import 'package:mlcc_app_ios/screens/page/entrepreneurs/entrepreneurs_view.dart';
import 'package:mlcc_app_ios/screens/page/events/event_details_view.dart';
import 'package:mlcc_app_ios/screens/page/events/events_view.dart';
import 'package:mlcc_app_ios/screens/page/favorite/favorite_view.dart';
import 'package:mlcc_app_ios/screens/page/home/home_page.dart';
import 'package:mlcc_app_ios/screens/page/account/account_view.dart';
import 'package:mlcc_app_ios/screens/page/account/account_personal_basic_info_view.dart';
import 'package:mlcc_app_ios/screens/page/training/trainer_details_view.dart';
import 'package:mlcc_app_ios/screens/page/training/trainers_view.dart';
import 'package:mlcc_app_ios/screens/page/training/training_details_view.dart';
import 'package:mlcc_app_ios/screens/page/training/trainings_view.dart';
import 'package:mlcc_app_ios/screens/page/webview/payment_webview_page.dart';
import 'package:mlcc_app_ios/screens/page/webview/webview_container_photo.dart';
import 'package:mlcc_app_ios/screens/splash_screen.dart';
import 'package:mlcc_app_ios/theme.dart';
import 'screens/page/auth/register_successful_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

void main() {
  runApp(MyApp());
}

final HttpProvider httpProvider = HttpProvider();

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    AuthBloc _authBloc = AuthBloc(httpProvider);
    EntrepreneursBloc _entrepreneursBloc = EntrepreneursBloc(httpProvider);
    TrainingsBloc _trainingsBloc = TrainingsBloc(httpProvider);
    EventsBloc _eventsBloc = EventsBloc(httpProvider);
    DashboardBloc _dashboardBloc = DashboardBloc(httpProvider);
    AdvBloc _advBloc = AdvBloc(httpProvider);
    XprojectBloc _xprojectBloc = XprojectBloc(httpProvider);
    TimerBloc _timerBloc = TimerBloc(ticker: const Ticker());
    getUser();
    // huawei();
    oneSignal(context);
    // branchIO();

    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(create: (context) => _authBloc),
        BlocProvider<EntrepreneursBloc>(
            create: (context) => _entrepreneursBloc),
        BlocProvider<TrainingsBloc>(create: (context) => _trainingsBloc),
        BlocProvider<EventsBloc>(create: (context) => _eventsBloc),
        BlocProvider<DashboardBloc>(create: (context) => _dashboardBloc),
        BlocProvider<AdvBloc>(create: (context) => _advBloc),
        BlocProvider<XprojectBloc>(create: (context) => _xprojectBloc),
        BlocProvider<TimerBloc>(create: (context) => _timerBloc)
      ],
      child: MaterialApp(
          builder: (context, child) {
            return MediaQuery(
              child: child as Widget,
              data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
            );
          },
          //theme: themeData,
          debugShowCheckedModeBanner: false,
          title: 'MLCC',
          initialRoute: '/',
          routes: {
            '/': (context) => const SplashScreen(),
            '/home_page': (context) => const HomePage(),
            '/login_page': (context) => const LoginPage(),
            '/favourite_page': (context) => const FavoritePage(),
            '/forgot_password_page': (context) => const ForgotPasswordPage(),
            '/register_personal_basic_info_page': (context) =>
                const RegisterPersonalBasicInfoPage(),
            '/register_company_page': (context) => RegisterCompanyPage(),
            // '/register_select_plan_page': (context) =>
            //     const RegisterSelectPlanPage(),
            '/register_successful_page': (context) =>
                const RegisterSuccessfulPage(
                  arguments: {},
                ),
            '/account_view_page': (context) => const AccountViewPage(),
            // '/account_personal_basic_info_view_page': (context) =>
            //     const AccountPersonalBasicInfoViewPage(),
            '/account_social_media_view_page': (context) =>
                const AccountSocialMediaViewPage(),
            '/account_company_info_view_page': (context) =>
                const AccountCompanyViewPage(),
            '/account_education_view_page': (context) =>
                const AccountEducationViewPage(),
            '/account_societies_view_page': (context) =>
                const AccountSocietiesViewPage(),
            '/account_professional_cert_view_page': (context) =>
                const AccountProfessionalCertViewPage(),
            '/account_work_experienced_view_page': (context) =>
                const AccountWorkExperiencedViewPage(),
            '/entrepreneurs_view_page': (context) =>
                const EntrepreneursViewPage(),
            // '/entrepreneur_details_view_page': (context) =>
            //     const EntrepreneurDetailsViewPage(),
            '/trainers_view_page': (context) => const TrainersViewPage(),
            // '/trainings_view_page': (context) => const TrainingsViewPage(),
            // '/training_details_view_page': (context) =>
            //     const TrainingDetailsViewPage(),
            '/trainer_details_view_page': (context) =>
                const TrainerDetailsViewPage(),
            '/events_view_page': (context) => const MainScreen(
                  page: EventsViewPage(),
                  index: 2,
                ),
            '/home_main': (context) => const MainScreen(
                  page: HomePage(),
                  index: 0,
                ),
            // '/event_details_view_page': (context) =>
            //     const EventDetailsViewPage(),
          },
          onGenerateRoute: (settings) {
            switch (settings.name) {
              case '/entrepreneur_details_view_page':
                final Map<String, dynamic>? args =
                    settings.arguments as Map<String, dynamic>?;
                return MaterialPageRoute(
                    builder: (contet) => EntrepreneurDetailsViewPage(
                          data: args!['data'],
                        ));
              case '/training_details_view_page':
                final Map<String, dynamic>? args =
                    settings.arguments as Map<String, dynamic>?;
                return MaterialPageRoute(
                    builder: (contet) => TrainingDetailsViewPage(
                        data: args!['data'],
                        trainingList: args['trainingList'],
                        wish: args['wish'],
                        type: args['type']));
              case '/trainings_view_page':
                final Map<String, dynamic>? args =
                    settings.arguments as Map<String, dynamic>?;
                return MaterialPageRoute(
                    builder: (contet) => TrainingsViewPage(
                          data: args!['data'],
                        ));
              case '/event_details_view_page':
                final Map<String, dynamic>? args =
                    settings.arguments as Map<String, dynamic>?;
                return MaterialPageRoute(
                    builder: (contet) => EventDetailsViewPage(
                        data: args!['data'],
                        wish: args['wish'],
                        type: args['type']));
              case '/payment_webview_page':
                final Map<String, dynamic>? args =
                    settings.arguments as Map<String, dynamic>?;
                return MaterialPageRoute(
                    builder: (contet) => PaymentWebViewPage(
                        userId: args!['userId'],
                        training: args['training'],
                        event: args['event'],
                        productID: args['product']));
              case '/account_personal_basic_info_view_page':
                final Map<String, dynamic>? args =
                    settings.arguments as Map<String, dynamic>?;
                return MaterialPageRoute(
                    builder: (contet) => AccountPersonalBasicInfoViewPage(
                        data: args!['data'],
                        first: args['first'],
                        disableEdit: args['disableEdit']));
              case '/reward_details_view_page':
                final Map<String, dynamic>? args =
                    settings.arguments as Map<String, dynamic>?;
                return MaterialPageRoute(
                    builder: (contet) => RewardDetailsViewPage(
                        data: args!['data'], type: args['type']));
              case '/sponsored_details_view_page':
                final Map<String, dynamic>? args =
                    settings.arguments as Map<String, dynamic>?;
                return MaterialPageRoute(
                    builder: (contet) => SponsoredDetailsViewPage(
                        data: args!['data'], type: args['type']));
              case '/voucher_details_view_page':
                final Map<String, dynamic>? args =
                    settings.arguments as Map<String, dynamic>?;
                return MaterialPageRoute(
                    builder: (contet) => VoucherDetailsViewPage(
                        data: args!['data'], type: args['type']));
              // case '/product_details_view_page':
              //   final Map<String, dynamic>? args =
              //       settings.arguments as Map<String, dynamic>?;
              //   return MaterialPageRoute(
              //       builder: (contet) => ProductDetailsViewPage(
              //           data: args!['data'], type: args['type']));
              case '/photo_webview_page':
                final dynamic args = settings.arguments;
                return MaterialPageRoute(
                    builder: (context) => WebviewContainerPhoto(
                        url: args['url'], title: args['title']));
              case '/contact_us_view_page':
                final Map<String, dynamic>? args =
                    settings.arguments as Map<String, dynamic>?;
                print("argumentttt");
                print(args);
                return MaterialPageRoute(
                    builder: (context) => ContactUsViewPage());
            }
            return null;
          }),
    );
  }

  void branchIO() {
    print("branch.io");
    FlutterBranchSdk.validateSDKIntegration();
  }

  // Future<void> huawei() async {
  //   AGCApp.instance.setClientId('798438418035002112');
  //   AGCApp.instance.setClientSecret(
  //       '47563E7E3FB3AB27AA82255EE4F2DEE5904CEE0387109F9DDF04913B0DC95B23');
  //   AGCApp.instance.setApiKey(
  //       'DAEDANS5WIMABfqEf8XUxRskDlvX6rxm7RtPnNQAXjYUqM9K+XXe87pdQ1V7e1RfQa3EfrFRDIWt3CcPbYmXaxyPtEyAYmA0mIgPqw==');
  // }

  int userID = 0;
  dynamic notificationList = [];
  dynamic notificationItem = [];
  int total = 0;
  dynamic notification = [];
  Future<void> oneSignal(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    //Remove this method to stop OneSignal Debugging

    OneSignal.Debug.setLogLevel(OSLogLevel.verbose);

    // last not used

    //OneSignal.Debug.setAppId("6eb7a380-be9b-4040-a062-029c6bd81d82");

    //6eb7a380-be9b-4040-a062-029c6bd81d82

    // tes ajie
    //03376405-145b-4009-bf78-ce4802a6ad42

    OneSignal.initialize("6eb7a380-be9b-4040-a062-029c6bd81d82");

    // OneSignal.Notifications.clearAll();

    OneSignal.User.pushSubscription.addObserver((state) {
      print("tes-1${OneSignal.User.pushSubscription.optedIn}");
      print("tes-2${OneSignal.User.pushSubscription.id}");
      print("tes-3${OneSignal.User.pushSubscription.token}");
      print("tes-4${state.current.jsonRepresentation()}");
    });

    OneSignal.Notifications.addPermissionObserver((state) {
      print("Has permission " + state.toString());
    });
    OneSignal.Debug.setLogLevel(OSLogLevel.error);
    await OneSignal.Notifications.requestPermission(true);
    // The promptForPushNotificationsWithUserResponse function will show the iOS push notification prompt. We recommend removing the following code and instead using an In-App Message to prompt for notification permission
    // OneSignal.Debug.promptUserForPushNotificationPermission().then((accepted) {
    //   print("Accepted permission: $accepted");
    // });

    //final status = await OneSignal.shared.getDeviceState();
    final status = OneSignal.User.pushSubscription.id;
    final String? osUserID = status;

    print("osUserID-1${OneSignal.User.pushSubscription.optedIn}");
    print("osUserID-2${OneSignal.User.pushSubscription.id}");
    print("osUserID-3${OneSignal.User.pushSubscription.token}");

    print("osUserID${osUserID}");
    print("osUserID-status${status}");
    prefs.setString('OneSignalPlayerID', osUserID!);

    if (prefs.getBool("isLoggedIn") == true) {
      updateAccess();
    }
  }

  getUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userID = prefs.getInt("userId")!;
    if (userID != 0) {
      final _formData = {};
      _formData['user_id'] = userID;
      notification =
          await httpProvider.postHttp("notification/listing", _formData);
      if (notification.isNotEmpty) {
        for (var item in notification) {
          if (item['type'] != 'Entrepreneurs') {
            if (item['status'] == 0) {
              notificationItem.add(item);
              // total++;
            }
            notificationList.add(item);
          }
        }
      }
    }
  }

  Future<void> updateAccess() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var updateAccessDataReturn = await httpProvider.postHttp("last_access", {
      'user_id': prefs.getInt("userId"),
      'push_token': prefs.getString("OneSignalPlayerID"),
      'push_token_status': '1'
    });
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
