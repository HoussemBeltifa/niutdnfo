import 'package:flutter/material.dart';
import 'package:meeting/chatlist.dart';
import 'package:meeting/chatlistusers.dart';
import 'package:meeting/chatscreen.dart';
import 'package:meeting/home.dart';
import 'package:meeting/login.dart';
import 'package:flutter/services.dart';
import 'package:meeting/userlistScreen.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Import rootBundle
import 'package:meeting/route_generator.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await loadFonts();
  await SharedPreferences.getInstance();

  runApp(const MyApp());
}

Future<void> loadFonts() async {
  await Future.wait<ByteData>([
    rootBundle.load('assets/fonts/Poppins-Regular.ttf'),
    rootBundle.load('assets/fonts/Poppins-Bold.ttf'),
  ]);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        textTheme: TextTheme(
            titleLarge: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 25,
              fontWeight: FontWeight.normal,
            ),
            titleSmall: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 16,
              fontWeight: FontWeight.normal,
            )),
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: Home(), //ChatListUsers(),
      onGenerateRoute: (settings) => RouteGenerator.generateRoute(settings),
      initialRoute: '/',
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
