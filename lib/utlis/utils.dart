import 'package:image_picker/image_picker.dart';

class Utils{
  pickImage(ImageSource imageSource)async{
    final ImagePicker imagePicker = ImagePicker();

    XFile? file = await imagePicker.pickImage(source: imageSource, imageQuality: 70);

    if(file != null){
      return await file.readAsBytes();
    }else{
      print('no image picked');
    }

  }
}