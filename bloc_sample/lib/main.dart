// main.dart
import 'package:flutter/material.dart';
import 'counter_bloc.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: CounterScreen(),
    );
  }
}

class CounterScreen extends StatefulWidget {
  @override
  _CounterScreenState createState() => _CounterScreenState();
}

class _CounterScreenState extends State<CounterScreen> {
  late CounterBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = CounterBloc();
  }

  @override
  void dispose() {
    _bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Bloc Pattern Example"),
      ),
      body: Center(
        child: StreamBuilder<int>(
          stream: _bloc.stateStream,
          initialData: 0,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Text(
                'Counter: ${snapshot.data}',
                style: Theme.of(context).textTheme.headlineMedium,
              );
            } else {
              return CircularProgressIndicator();
            }
          },
        ),
      ),
      persistentFooterButtons: [
        FloatingActionButton(
          onPressed: () {
            _bloc.eventSink.add(ResetEvent());
          },
          tooltip: 'Reset',
          child: const Text('RESET'),
        ),
        FloatingActionButton(
          onPressed: () {
            _bloc.eventSink.add(IncrementEvent(incrementBy: 1));
          },
          tooltip: 'Increment by 1',
          child: const Text('1'),
        ),
        FloatingActionButton(
          onPressed: () {
            _bloc.eventSink.add(IncrementEvent(incrementBy: -1));
          },
          tooltip: 'Decrement by 1',
          child: const Text('-1'),
        ),
        FloatingActionButton(
          onPressed: () {
            _bloc.eventSink.add(IncrementEvent(incrementBy: 10));
          },
          tooltip: 'Increment by 10',
          child: const Text('10'),
        )
      ],
    );
  }
}
