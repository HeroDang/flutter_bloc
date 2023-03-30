abstract class RemoteEvent {}

// event tăng âm lượng, user muốn tăng lên bao nhiêu thì truyền vào biến increment
class IncrementEvent extends RemoteEvent {
  IncrementEvent(this.increment);

  final int increment;
}

// event giảm âm lượng, user muốn giảm bao nhiêu thì truyền vào biến decrement
class DecrementEvent extends RemoteEvent {
  DecrementEvent(this.decrement);

  final int decrement;
}

// event mute
class MuteEvent extends RemoteEvent {}

class IncrementChanelEvent extends RemoteEvent{
  IncrementChanelEvent(this.incrementChanel);
  final int incrementChanel;
}

class DecrementChanelEvent extends RemoteEvent{
  DecrementChanelEvent(this.decrementChanel);
  final int decrementChanel;
}
