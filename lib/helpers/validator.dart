class FieldValidator{
  static String validateLength(value){
    if (value.trim().isEmpty) return "Task must have a name.";
    return null;
  }
}