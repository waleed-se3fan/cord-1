
abstract class AudioStates {}

class AudioInitialingState extends AudioStates {}
class AudioIsInitialedState extends AudioStates {}
class AudioIsDisposed extends AudioStates {}

class AudioRecordStarted extends AudioStates {}
class AudioRecordStopped extends AudioStates {}
class AudioRecordPaused extends AudioStates {}

class AudioPlayerStarted extends AudioStates {}
class AudioPlayerPaused extends AudioStates {}
class AudioPlayerStopped extends AudioStates {}