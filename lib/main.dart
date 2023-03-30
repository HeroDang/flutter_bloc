import 'package:flutter/material.dart';
import 'package:flutter18_bloc/page2.dart';
import 'package:flutter18_bloc/remote_bloc.dart';
import 'package:flutter18_bloc/remote_event.dart';
import 'package:flutter18_bloc/remote_state.dart';

final bloc = RemoteBloc(); // khởi tạo bloc  <=== new

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green,
      appBar: AppBar(
        title: Text('Page 1'),
      ),
      body: Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              StreamBuilder<RemoteState>(
                // sử dụng StreamBuilder để lắng nghe Stream <=== new
                stream: bloc.stateController.stream,
                // truyền stream của stateController vào để lắng nghe <=== new
                initialData: bloc.state,
                // giá trị khởi tạo chính là volume 70 hiện tại <=== new
                builder: (BuildContext context,
                    AsyncSnapshot<RemoteState> snapshot) {
                  RemoteState? _newState = snapshot.data;
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text('Kênh hiện tại: ${_newState?.channel}'),
                      Text('Âm lượng hiện tại: ${_newState?.volume}'),
                    ],
                  ); // update UI <=== new
                },
              ),
              ElevatedButton(onPressed: (){
                Navigator.push(context,
                MaterialPageRoute(builder: (BuildContext context){
                  return Page2();
                }));
              }, child: Text('Go to Page 2'))
            ]),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              FloatingActionButton(
                onPressed: () {
                  bloc.eventController.sink.add(IncrementChanelEvent(1));
                }, // add event <=== new
                child: Icon(Icons.plus_one),
              ),
              SizedBox(
                width: 10,
              ),
              FloatingActionButton(
                onPressed: () {
                  bloc.eventController.sink.add(DecrementChanelEvent(1));
                }, // add event <=== new
                child: Icon(Icons.exposure_minus_1),
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              FloatingActionButton(
                onPressed: () =>
                    bloc.eventController.sink.add(IncrementEvent(5)),
                // add event <=== new
                child: Icon(Icons.volume_up),
              ),
              SizedBox(
                width: 10,
              ),
              FloatingActionButton(
                onPressed: () =>
                    bloc.eventController.sink.add(DecrementEvent(10)),
                // add event <=== new
                child: Icon(Icons.volume_down),
              ),
              SizedBox(
                width: 10,
              ),
              FloatingActionButton(
                onPressed: () => bloc.eventController.sink.add(MuteEvent()),
                // add event <=== new
                child: Icon(Icons.volume_mute),
              )
            ],
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    bloc.dispose(); // dispose bloc <=== new
  }
}
