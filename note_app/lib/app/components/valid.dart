// Assume this function is in the file where it's needed
String? validInput(String val, int min, int max, {bool isEmail = false}) {
  if (val.isEmpty) {
    return "This field is required";
  }
  if (val.length < min) {
    return "Must be at least $min characters";
  }
  if (val.length > max) {
    return "Must be less than $max characters";
  }
  if (isEmail) {
    // Basic regex for email validation
    String pattern =
        r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$';
    RegExp regex = RegExp(pattern);
    if (!regex.hasMatch(val)) {
      return "Enter a valid email address";
    }
  }
  return null;
}
