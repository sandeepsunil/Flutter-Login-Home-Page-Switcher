import 'package:flutter/material.dart';
import 'package:flutter_tests/locator.dart';
import 'package:flutter_tests/storage.dart';
import 'package:provider/provider.dart';

class AuthController with ChangeNotifier {
  // bool _isAuthenticated = false;
  //
  // bool get isAuthenticated => _isAuthenticated;
  //
  // set isAuthenticated(bool isAuth) {
  //   this._isAuthenticated = isAuth;
  //   this.notifyListeners();
  // }

  Future<bool> checkAuth() async {
    print('checking auth');
    if (await getIt<SecureStorageHelper>().getAuthToken() != null) {
      return true;
    } else {
      return false;
    }
  }

  Future<void> loginUser(String token) async {
    await getIt<SecureStorageHelper>().setAuthToken(token);
    notifyListeners();
    // if (await getIt<SecureStorageHelper>().setAuthToken(token))
    //   this.isAuthenticated = true;
    // else
    //   this.isAuthenticated = true;
  }

  Future<void> logoutUser() async {
    await getIt<SecureStorageHelper>().deleteAll();
    notifyListeners();
    // this.isAuthenticated = false;
  }
}

void main() {
  setupLocator();
  return runApp(
    ChangeNotifierProvider<AuthController>(
      create: (BuildContext context) => AuthController(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(final BuildContext context) {
    return Consumer<AuthController>(
      builder:
          (BuildContext context, AuthController authController, Widget child) {
        authController.checkAuth();
        return MaterialApp(
          title: 'Flutter Login Logout Test',
          theme: ThemeData(primarySwatch: Colors.blue),
          // home: authController.isAuthenticated ? HomePage() : LoginPage(),
          home: FutureBuilder(
            future: authController.checkAuth(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              print(snapshot.connectionState);
              if (snapshot.hasData) {
                return snapshot.data ? HomePage() : LoginPage();
              } else
                return HomePage();
            },
          ),
        );
      },
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(final BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Home logged in")),
      body: Center(
        child: RaisedButton(
          child: const Text("Logout"),
          onPressed: () {
            Provider.of<AuthController>(context, listen: false).logoutUser();
          },
        ),
      ),
    );
  }
}

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login"),
        backgroundColor: Colors.red,
      ),
      body: Center(
        child: RaisedButton(
          child: const Text("Login"),
          onPressed: () {
            Provider.of<AuthController>(context, listen: false)
                .loginUser('login_token');
          },
        ),
      ),
    );
  }
}
