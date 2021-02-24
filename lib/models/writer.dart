import 'dart:ffi';

class Writer {
  String id;
  String firstName;
  String lastName;
  String email;

  Writer({this.id, this.firstName, this.lastName, this.email});
  factory Writer.fromJson(Map<String, dynamic> json) {
    return Writer(
        id: json['_id'],
        firstName: json['firstName'],
        lastName: json['lastName'],
        email: json['email']);
  }
}
