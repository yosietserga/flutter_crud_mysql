import 'package:flutter/material.dart';
import 'package:fire_crud_mysql/themes/app_theme.dart';

class AuthBackground extends StatelessWidget {
  final Widget child;

  const AuthBackground({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: Stack(children: [const _ColorBox(), const _HeaderIcon(), child]),
    );
  }
}

class _HeaderIcon extends StatelessWidget {
  const _HeaderIcon({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Container(
            width: double.infinity,
            margin: const EdgeInsets.only(top: 30),
            child: const Image(image: AssetImage('assets/images/logoSF.png'))));
  }
}

class _ColorBox extends StatelessWidget {
  const _ColorBox({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Container(
        width: double.infinity,
        height: size.height * 0.4,
        decoration: _gradientBackground(AppTheme.primary, AppTheme.secundary),
        child: Stack(children: const [
          Positioned(top: 90, left: 30, child: _Bubble()),
          Positioned(top: -40, left: -30, child: _Bubble()),
          Positioned(top: -50, right: -20, child: _Bubble()),
          Positioned(top: -50, left: 10, child: _Bubble()),
          Positioned(top: 120, right: 20, child: _Bubble())
        ]));
  }

  BoxDecoration _gradientBackground(Color color1, Color color2) =>
      BoxDecoration(gradient: LinearGradient(colors: [color1, color2]));
}

class _Bubble extends StatelessWidget {
  const _Bubble({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        width: 100,
        height: 100,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100),
            color: const Color.fromRGBO(255, 255, 255, 0.05)));
  }
}
