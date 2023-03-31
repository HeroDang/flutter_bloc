import 'dart:async';

import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'remote_event.dart';
import 'remote_state.dart';

const String KEY_VOLUME = 'volume';
const String KEY_CHANNEL = 'channel';

class RemoteBloc {
  var state = RemoteState(volume: 70, channel: 1); // init giá trị khởi tạo của RemoteState. Giả sử TV ban đầu có âm lượng 70

  // tạo 2 controller
  // 1 cái quản lý event, đảm nhận nhiệm vụ nhận event từ UI
  final eventController = StreamController<RemoteEvent>();

  // 1 cái quản lý state, đảm nhận nhiệm vụ truyền state đến UI
  final stateController = BehaviorSubject<RemoteState>();

  getCurrentState() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    state.volume = (prefs.getInt(KEY_VOLUME) ?? 70);
    state.channel = (prefs.getInt(KEY_CHANNEL) ?? 1);

    stateController.sink.add(state);
  }

  saveCurrentState(RemoteState state) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.setInt(KEY_CHANNEL, state.channel!);
    prefs.setInt(KEY_VOLUME, state.volume!);
  }

  RemoteBloc() {
    // lắng nghe khi eventController push event mới
    eventController.stream.listen((RemoteEvent event) {
      // người ta thường tách hàm này ra 1 hàm riêng và đặt tên là: mapEventToState
      // đúng như cái tên, hàm này nhận event xử lý và cho ra output là state

      if (event is IncrementEvent) {
        // nếu eventController vừa add vào 1 IncrementEvent thì chúng ta xử lý tăng âm lượng
        state.volume = state.volume! + event.increment;
      } else if (event is DecrementEvent) {
        // xử lý giảm âm lượng
        state.volume = (state.volume! - event.decrement);
      } else if(event is MuteEvent) {
        // xử lý mute
        state.volume = 0;
      }else if(event is IncrementChanelEvent){
        state.channel = state.channel! + event.incrementChanel;
      }else if(event is DecrementChanelEvent){
        state.channel = state.channel! + event.decrementChanel;
      }

      saveCurrentState(state);

      // add state mới vào stateController để bên UI nhận được
      stateController.sink.add(state);
    });
  }

  // khi không cần thiết thì close tất cả controller
  void dispose() {
    stateController.close();
    eventController.close();
  }
}
