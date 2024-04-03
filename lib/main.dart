import 'package:flutter/material.dart';
import 'package:my_gallery/core/providers/user_provider.dart';
import 'package:my_gallery/core/services/injection_container.dart';
import 'package:my_gallery/src/auth/presntation/bloc/auth_bloc.dart';
import 'package:my_gallery/src/auth/presntation/view/auth_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_gallery/src/gallery/presenation/bloc/gallery_bloc.dart';
import 'package:my_gallery/src/gallery/presenation/view/gallery_sceen.dart';
import 'package:provider/provider.dart';

import 'package:sizer/sizer.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await init();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => UserProvider(),
        ),
        BlocProvider(
          create: (context) => sl<GalleryBloc>(),
        ),
      ],
      child: Consumer<UserProvider>(
        builder: (context, value, child) => Sizer(
          builder: (context, orientation, deviceType) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              theme: ThemeData.light(),
              home: value.user != null
                  ? const GalleryScreen()
                  : BlocProvider(
                      create: (_) => sl<AuthBloc>(),
                      child: const AuthScreen(),
                    ),
              routes: {
                GalleryScreen.routeName: (context) => const GalleryScreen(),
              },
            );
          },
        ),
      ),
    );
  }
}
