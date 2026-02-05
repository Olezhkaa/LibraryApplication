class AuthValidators {

  //Сообщения с ошибками
  static const String emailErrorMassage = "Неверный формат почты. Попробуйте еще раз. ";
  static const String passwordErrorMessage = "Неверный формат пароля. Попробуйте еще раз.";
  
  //Ошибка - поле является обязательным
  static const String isEmptyErrorMessage = "Данное поле является обязательным";

  //Ошибка - поле не должно содержать пробелы
  static const String containtsSpaceErrorMessage = "Данное поле не может содержать пробелы";


  //Проверка почты
  String? emailValidator(String value) {
    final String email = value;


    final emailIndexOf = email.indexOf('@');

    //Недействительна, если длина меньше 3-х
    if(email.length <= 3) return emailErrorMassage;
    //Недействительна, если отсутствует символ "@"
    if(!email.contains('@')) return emailErrorMassage;
    //Недействительна, если количество символа "@" больше или меньше 1
    if(email.length>email.replaceAll('@', '').length+1) return emailErrorMassage;
    //Недействительна, если "@" находится в начале или в конце
    if(emailIndexOf==0 || emailIndexOf == email.length-1) return emailErrorMassage;

    //Если все проверки прошли, возвращает null
    return null;
  }

  String? passwordValidator(String value) {
    final String password = value;
    
    //Если поле пустое 
    if (password.isEmpty) return passwordErrorMessage;
    //Пароль должен быть от 6 до 20 символов
    if (password.length < 6 || password.length > 20) return passwordErrorMessage;

    //Если все проверки пройдены, возвращает null
    return null;
  }

  String? requiredFieldValidator(String value) {
    final String requiredField = value;

    //Проверка пустого значения
    if(requiredField.isEmpty) return isEmptyErrorMessage;

    //Проверка на наличие пробелов
    if(requiredField.contains(" ")) return containtsSpaceErrorMessage;

    //Возвращает null если все верно
    return null;
  }

  String? noRequiredFieldValidator(String value) {
    final String noRequiredField = value;

    //Проверка на наличие пробелов
    if(noRequiredField.contains(' ')) return containtsSpaceErrorMessage;
    
    //Возвращает null если все верно
    return null;
  }


}