

class User {
  int id ;
  String name ;
  String type ;
  String phone ;
  String image ;
  String email ;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.image,
    required this.type
});
   factory User.fromJson(Map<String,dynamic> json) => User(
       id: json['id'],
       name: json['name'],
       email: json['email'],
       phone: json['phone'],
       image: json['image'] ?? '',
       type: json['type']);

   Map<String,dynamic> toJson() =>
       {
         'id': id,
         'name': name,
         'email': email,
         'phone': phone,
         'image': image,
         'type': type,
       };
}