// ignore_for_file: public_member_api_docs, sort_constructors_first
class UserModel {
  final String name;
  final String email;
  final String bio;
  final String ProfilePic;
  final String createdAt;
  final String phoneNumber;
  final String uid;
  final int AccountBalance;

  UserModel({
    required this.name,
    required this.email,
    required this.bio,
    required this.ProfilePic,
    required this.createdAt,
    required this.phoneNumber,
    required this.uid,
    required this.AccountBalance,
  });

// from Map
  factory UserModel.fromMap(Map<String, dynamic> map){
    return UserModel(
      name: map['name'] ?? '', 
      email: map['email']  ?? '', 
      bio: map['bio']  ?? '', 
      ProfilePic: map['ProfilePic']  ?? '', 
      createdAt: map['createdAt']  ?? '', 
      phoneNumber: map['phoneNumber']  ?? '', 
      uid: map['uid']  ?? '', 
      AccountBalance: map['AccountBalance']  ?? 0);
  }

// To Map
Map<String, dynamic> toMap(){
  return {
      "name": name, 
      "email": email , 
      "bio": bio , 
      "ProfilePic" : ProfilePic , 
      "createdAt" : createdAt, 
      "phoneNumber" : phoneNumber , 
      "uid": uid, 
      "AccountBalance": AccountBalance
  };
}



}
