// ignore_for_file: public_member_api_docs, sort_constructors_first
class UserModel {
   String name;
   String email;
   String bio;
   String ProfilePic;
   String createdAt;
   String phoneNumber;
   String uid;
   int AccountBalance;

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
