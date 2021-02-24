import 'dart:ffi';

class Blog {
  String id;
  String title;
  String description;
  String location;
  String image;
  String owner;
  String category;
  String createdDate;
  String phoneNumber;
  Blog(
      {this.id,
      this.title,
      this.description,
      this.location,
      this.image,
      this.owner,
      this.category,
      this.createdDate,
      this.phoneNumber});
  factory Blog.fromJson(Map<String, dynamic> json) {
    return Blog(
        id: json['id'],
        title: json['title'],
        description: json['description'],
        location: json['location'],
        owner: json['owner'],
        phoneNumber: json['phoneNumber'],
        category: json['category'],
        createdDate: json['createdDate'],
        image: json.containsKey('image')
            ? json['image']
            : 'https://www.retailwire.com/wp-content/uploads/2017/04/sams-club-tastetips-bag-666x333.jpg');
  }
}
