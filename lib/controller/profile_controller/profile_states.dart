abstract class ProfileStates {}

class InitProfileState extends ProfileStates {}



class InitUploadProfileImage extends ProfileStates {}
class SuccessUploadProfileImage extends ProfileStates {}
class ErrorUploadProfileImage extends ProfileStates {}



class InitUpdateProfile extends ProfileStates {}
class SuccessUpdateProfile extends ProfileStates {}
class ErrorUpdateProfile extends ProfileStates {}


class SuccessGetProfileImage extends ProfileStates {}
class ErrorGetProfileImage extends ProfileStates {}