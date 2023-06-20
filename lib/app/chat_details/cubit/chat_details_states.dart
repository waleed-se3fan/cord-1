
abstract class ChatDetailsStates {}

class ChatDetailsInitial implements ChatDetailsStates {}
class ChatDetailsSendingMessage implements ChatDetailsStates {}
class ChatDetailsSendingRecord implements ChatDetailsStates {}
class ChatDetailsIsSent implements ChatDetailsStates {}
class ChatDetailsSendingError implements ChatDetailsStates {}

class ChatDetailsRecordIsDownloading implements ChatDetailsStates {}
class ChatDetailsRecordIsDownloaded implements ChatDetailsStates {}



