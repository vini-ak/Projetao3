import 'package:Projetao3/workersList.dart';
import 'package:flutter/material.dart';
import 'package:splashscreen/splashscreen.dart';
import 'src/login.dart';
import 'src/register.dart';
import 'src/registerPhoto.dart';
//import 'src/perfilShift.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: _buildRoutes(context),
      initialRoute: '/login',
      debugShowCheckedModeBanner: false,
    );
  }

  _buildRoutes(context) {
    return {
      '/login': (context) => Login(),
      '/register': (context) => RegisterPage(),
      '/registerPhoto': (context) => RegisterPhotoPage(),
      '/workers': (context) => WorkersPage(),
      //'/perfilShift': (context)=> PerfiShift(),
    };
  }
}

class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  // TODO: Importar o Firebase App no Material App
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Stack(
        children: [
          SplashScreen(
            seconds: 4,
            navigateAfterSeconds: _loadNextPage(),
            loaderColor: Colors.transparent,
          ),
          Container(
            color: Colors.yellow,
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Text("Splash"),
          ),
        ],
      ),
    );
  }

  _loadNextPage() {
    // TODO: Criar a página inicial que Felipe sugeriu
    // por enquanto:
    return LoginPage();
  }
}
