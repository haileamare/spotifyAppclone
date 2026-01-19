class CreateUserReq{
  final String email;
  final String userName;
  final String password;
  const CreateUserReq({
    required this.email,
    required this.userName,
    required this.password
  });
}