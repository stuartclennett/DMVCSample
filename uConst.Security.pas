unit uConst.Security;

interface

uses
  system.SysUtils;

type
  TUserType = (utStudent, utAuthor, utSuper, utInstructor); // USER_TYPE field

//  EBaseSecurityException = class(Exception);
//  EBasePasswordChangeException = class(EBaseSecurityException);
//  EIncorrectOldPassword = class(EBasePasswordChangeException);
//  ENewPasswordMismatch = class(EBasePasswordChangeException);
//  EInvalidNewPassword = class(EBasePasswordChangeException);
//  EUserAlreadyExists = class(EBaseSecurityException);
//  EInvalidUserName = class(EBaseSecurityException);

const
  // Roles for RolesAllowed attribute
  cRoleSTUDENT = 'Student';
  cRoleINSTRUCTOR = 'Instructor';
  cRoleAUTHOR  = 'Author';
  cRoleSUPER   = 'SuperAdmin';
  cAllRoles = cRoleSTUDENT + ',' + cRoleINSTRUCTOR + ',' + cRoleAUTHOR + ',' + cRoleSUPER;

  // Security Actions
  ACTION_LOGIN : integer = 1;
  ACTION_LOGOUT : integer = 2;
  ACTION_CHANGE_PASS : integer = 3;
  APP_ID = 'ocAPI';  // for user log

  cActionLogin : integer = 1;
  cActionLogout : integer = 2;
  cActionChangePwd : integer = 3;

  cUnauthorised = 'Unauthorised';

  cMinLengthUsername : integer = 3;
  cMinLengthPassword : integer = 8;

  cResetPasswordPin = 'A4D6ABE0-5E6E-46B7-8B86-B424F489BA36'; // `-` --> `#` @ runtime

implementation

end.
