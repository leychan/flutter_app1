// ignore_for_file: avoid_print

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

@immutable
class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var text = 'Hello World';
  var index = 0;

  @override
  Widget build(BuildContext context) {
    Widget page;
    switch (index) {
      case 0:
        page = const GeneratorPage();
        break;
      case 1:
        page = const Placeholder();
        break;
      default:
        throw UnimplementedError('no widget for $index');
    }

    return Scaffold(
      body: Row(
        children: [
          SafeArea(
              child: NavigationRail(
            extended: false,
            destinations: const [
              NavigationRailDestination(
                  icon: Icon(Icons.home), label: Text('首页')),
              NavigationRailDestination(
                  icon: Icon(Icons.face), label: Text('第二页')),
            ],
            selectedIndex: index,
            onDestinationSelected: (value) =>
                {print('selected: $value'), setState(() => index = value)},
          )),
          Expanded(
              child: Container(
            color: Theme.of(context).colorScheme.primaryContainer,
            child: page,
          ))
        ],
      ),
    );
  }
}

class GeneratorPage extends StatefulWidget {
  const GeneratorPage({super.key});

  @override
  State<GeneratorPage> createState() => _GeneratorPageState();
}

class _GeneratorPageState extends State<GeneratorPage> {
  final Dio _dio = Dio();

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: FutureBuilder(
        future: _dio.get('https://api.github.com/orgs/flutterchina/repos'),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            Response response = snapshot.data;
            if (snapshot.hasError) {
              return Text(snapshot.error.toString());
            }
            // print(response);
            return ListView(
              children: response.data
                  .map<Widget>((e) => ListTile(
                        title: Text(e['full_name']),
                        subtitle: Text(e['url']),
                      ))
                  .toList(),
            );
          }
          return const CircularProgressIndicator();
        },
      ),
    );
  }
}

class Placeholder extends StatelessWidget {
  const Placeholder({super.key});
  
  @override
  Widget build(BuildContext context) {
    return const Center(child: RotateImg());
  }

}


class RotateImg extends StatefulWidget {
  const RotateImg({super.key});

  @override
  State<RotateImg> createState() => _RotateImgState();
  
}

class _RotateImgState extends State<RotateImg> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(  
      duration: const Duration(seconds: 5),  
      vsync: this,  
    )..repeat(); 
  }
  
  @override
  Widget build(BuildContext context) {
    return RotationTransition(
      turns: Tween<double>(begin: 1.0, end: 0.0).animate(_controller),
      child: Padding(padding: const EdgeInsets.all(16.0), child: Image.network('https://img3.tuwandata.com//uploads/chatroom/20230516/1571001684232867.gif'),),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}