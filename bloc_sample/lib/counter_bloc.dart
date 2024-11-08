// カウンターイベントの抽象クラス。
import 'dart:async';

abstract class CounterEvent {}

/// カウンターを指定された値だけ増加させるイベント。
class IncrementEvent extends CounterEvent {
  final int incrementBy;

  /// [incrementBy]で増加量を指定。デフォルトは1。
  IncrementEvent({this.incrementBy = 1});
}

/// カウンターをリセットするイベント。
class ResetEvent extends CounterEvent {}

/// カウンターのビジネスロジックを管理するBlocクラス。
class CounterBloc {
  int _counter = 0;

  // イベントを受け取るためのコントローラ。
  final _eventController = StreamController<CounterEvent>();

  // カウンターの状態を出力するためのコントローラ。
  final _stateController = StreamController<int>();

  /// イベントを追加するためのシンク。
  Sink<CounterEvent> get eventSink => _eventController.sink;

  /// カウンターの状態をストリームとして提供。
  Stream<int> get stateStream => _stateController.stream;

  /// コンストラクタ。イベントストリームのリスナーを設定。
  CounterBloc() {
    _eventController.stream.listen(_mapEventToState);
  }

  /// イベントに応じてカウンターの状態を更新し、状態ストリームに新しい値を追加。
  void _mapEventToState(CounterEvent event) {
    switch (event.runtimeType) {
      case IncrementEvent:
        final incrementEvent = event as IncrementEvent;
        _counter += incrementEvent.incrementBy;
        _stateController.sink.add(_counter);
        break;
      case ResetEvent:
        _counter = 0;
        _stateController.sink.add(_counter);
        break;
      default:
        throw UnimplementedError('未処理のイベントタイプ: ${event.runtimeType}');
    }
  }

  /// リソースを解放し、コントローラを閉じる。
  void dispose() {
    _eventController.close();
    _stateController.close();
  }
}
