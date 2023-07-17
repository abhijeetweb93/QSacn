import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qscan/base/base_bloc.dart';
import 'package:qscan/splash/view/splash_page.dart';
import 'package:qscan/view_records/bloc/view_records_bloc.dart';
import 'package:qscan/view_records/bloc/view_records_events.dart';

import 'home/bloc/home_bloc.dart';
import 'home/bloc/home_state.dart';
import 'home/view/home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.hhhh
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider<ViewRecordsBloc>.value(value: ViewRecordsBloc(StateContentLoading())),
          BlocProvider<HomeBloc>.value(value: HomeBloc(const HomeInit()))
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Flutter Demo',
          theme: ThemeData(
            // This is the theme of your application.
            //
            // Try running your application with "flutter run". You'll see the
            // application has a blue toolbar. Then, without quitting the app, try
            // changing the primarySwatch below to Colors.green and then invoke
            // "hot reload" (press "r" in the console where you ran "flutter run",
            // or simply save your changes to "hot reload" in a Flutter IDE).
            // Notice that the counter didn't reset back to zero; the application
            // is not restarted.
            primarySwatch: Colors.pink,
          ),
          home: const SplashPage(),
        ));
  }
}
