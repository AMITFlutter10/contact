class UserModel{
 String? name;
 String? email;
 String? password;
 String? id ;
 String? pic ;

 UserModel({
     this.name,
     this.email,
     this.password,
     this.id,
     this.pic,
  });

 Map<String, dynamic> toMap() {
    return {
      'name': this.name,
      'email': this.email,
      'password': this.password,
      'id': this.id,
      'pic': this.pic,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      name: map['name'] as String,
      email: map['email'] as String,
      password: map['password'] as String,
      id: map['id'] as String,
      pic: map['pic'] as String,
    );
  }
}