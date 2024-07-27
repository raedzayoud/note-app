import 'package:note_app/constant/message.dart';

validInput(String val, int min, int max) {
  
  if(val.isEmpty){
    return messageInputEmpty;
  }

  if (val.length > max) {
    return messageInputMax;
  }

  if (val.length < min) {
    return messageInputMin;
  }


  
}
