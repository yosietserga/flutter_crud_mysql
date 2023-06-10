import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:fire_crud_mysql/providers/providers.dart';
import 'package:fire_crud_mysql/screens/screens.dart';
import 'package:fire_crud_mysql/services/services.dart';
import 'package:fire_crud_mysql/themes/app_theme.dart';
import 'package:fire_crud_mysql/ui/input_decorations.dart';
import 'package:fire_crud_mysql/widgets/widgets.dart';

class RegisterScreen extends StatelessWidget {
  static const String routerName = "RegisterScreen";
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: AuthBackground(
            child: SingleChildScrollView(
                child: Column(
      children: [
        const SizedBox(height: 200),
        CardContainer(
            child: Column(children: [
          const SizedBox(height: 10),
          Text('Registrar', style: Theme.of(context).textTheme.headline4),
          const SizedBox(height: 30),
          ChangeNotifierProvider(
              create: (_) => LoginFormProvider(), child: const _LoginForm())
        ])),
        const SizedBox(height: 30),
        TextButton(
            onPressed: () =>
                Navigator.pushReplacementNamed(context, LoginScreen.routerName),
            style: ButtonStyle(
              overlayColor:
                  MaterialStateProperty.all(Colors.indigo.withOpacity(0.1)),
              shape: MaterialStateProperty.all(const StadiumBorder()),
            ),
            child: const Text('¿Ya tienes una cuenta?',
                style: TextStyle(fontSize: 18, color: Colors.black87))),
        const SizedBox(height: 30),
      ],
    ))));
  }
}

class _LoginForm extends StatelessWidget {
  const _LoginForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final loginForm = Provider.of<LoginFormProvider>(context);

    return Form(
        key: loginForm.formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(children: [
          TextFormField(
            autocorrect: false,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecorations.authInputDecoration(
                hintText: 'john.doe@gmail.com',
                labelText: 'Email',
                prefixIcon: Icons.alternate_email_sharp),
            onChanged: (value) => loginForm.email = value,
            validator: (value) {
              String pattern =
                  r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
              RegExp regExp = new RegExp(pattern);
              return regExp.hasMatch(value ?? '')
                  ? null
                  : 'El correo no tiene un formato valido';
            },
          ),
          const SizedBox(height: 25),
          TextFormField(
              autocorrect: false,
              obscureText: true,
              decoration: InputDecorations.authInputDecoration(
                  hintText: 'Password',
                  labelText: 'Password',
                  prefixIcon: Icons.lock_outline),
              onChanged: (value) => loginForm.password = value,
              validator: (value) {
                return (value != null && value.length >= 6)
                    ? null
                    : 'La contraseña debe tener mas de 6 caracteres';
              }),
          const SizedBox(height: 25),
          MaterialButton(
              onPressed: loginForm.isLoading
                  ? null
                  : () async {
                      //Quitamos el teclado al pulsar el boton
                      FocusScope.of(context).unfocus();

                      final authService =
                          Provider.of<UserService>(context, listen: false);

                      //Al pulsar el boton se comprueba si el form es valido a traves del provider
                      if (!loginForm.isValidForm()) return;
                      loginForm.isLoading = true;

                      final Map? u = await authService.emailRegister(
                          loginForm.email, loginForm.password);
                      loginForm.isLoading = (u != null && u.isNotEmpty);
                      if (u != null && u.isNotEmpty)
                        Navigator.pushReplacementNamed(
                            context, HomeScreen.routerName);
                      else // Mostrar error en pantalla
                        NotificationsService.showSnackBar(
                            "Ha ocurrido un error, intenta de nuevo");
                      // print(errorMsg);

                      loginForm.isLoading = false;
                    },
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              elevation: 0,
              color: AppTheme.primary,
              child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 60, vertical: 15),
                  child: Text(
                    loginForm.isLoading ? 'Espere' : 'Registrarse',
                    style: TextStyle(color: Colors.white),
                  ))),
          const SizedBox(height: 25)
        ]));
  }
}
