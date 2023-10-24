import 'package:app2/popular_movies.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:local_auth/local_auth.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: FormPage(),
    );
  }
}

class FormPage extends StatefulWidget {
  const FormPage({Key? key}) : super(key: key);

  @override
  _FormPageState createState() => _FormPageState();
}

class _FormPageState extends State<FormPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  bool isButtonEnabled = true;
  final LocalAuthentication localAuth = LocalAuthentication();
  Future<bool> authenticateUser(String email, String password) async {
    if (email == "arami@gmail.com" && password == "zzz123") {
      return true; // exito.
    } else {
      return false; // fail.
    }
  }

  Future<void> saveAuthenticationState(bool isAuthenticated) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isAuthenticated', isAuthenticated);
  }

  void showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Builder(builder: (context) {
        return Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(labelText: "Ingresa el email"),
              ),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: "Ingresa la contraseña",
                ),
                obscureText: true,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  String email = _emailController.text;
                  String password = _passwordController.text;

                  bool isAuthenticated =
                      await authenticateUser(email, password);

                  if (isAuthenticated) {
                    await saveAuthenticationState(true);
                    showSnackBar("Autenticación exitosa");
                    // Abre la pantalla de películas populares
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => PopularMoviesScreen()),
                    );
                  } else {
                    showSnackBar("Autenticación fallida");
                  }
                },
                child: Text("Iniciar Sesión"),
              ),
              SizedBox(height: 10), // Agrega un espacio en blanco
              Text("O autentícate con huella digital:"),
              ElevatedButton(
                onPressed: () async {
                  final bool authenticated = await localAuth.authenticate(
                    localizedReason:
                        'Coloca tu dedo en el sensor de huella digital para autenticarte.',
                    useErrorDialogs: true,
                  );

                  if (authenticated) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => PopularMoviesScreen()),
                    );
                  } else {
                    // La autenticación con huella digital falló.
                    showSnackBar("Autenticación con huella digital fallida");
                  }
                },
                child: Text("Autenticar con Huella Digital"),
              ),
            ],
          ),
        );
      }),
    );
  }
}
