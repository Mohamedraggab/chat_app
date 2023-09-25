class UserModel
{
  late String username;
  late String email;
  late String phone;
  late String uId;
  late String image;

  UserModel({
    required this.username,
    required this.email,
    required this.phone,
    required this.uId,
    required this.image,
});


  UserModel.fromJson(Map<String , dynamic>?json)
  {
    username = json!['username'];
    email = json['email'];
    uId = json['uid'];
    image = json['image'];
    phone = json['phone'];
  }

  Map<String , dynamic> toMap()
  {
    return {
      'username':username,
      'email':email,
      'phone':phone,
      'uid':uId,
      'image':image,
    };
  }


}