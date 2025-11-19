unit uOcUserEntity;

interface

uses
  System.SysUtils,
  uBaseEntity,
  System.Generics.Collections,
  MVCFramework,
  MVCFramework.Swagger.Commons,
  MVCFramework.ActiveRecord,
  MVCFramework.Nullables,       // NullableString, NullableInteger, NullableTDateTime
  MVCFramework.Serializer.Commons
  //, uConst.Security
  ;

type
  TUserType = (utStudent, utAuthor, utSuper, utInstructor); // USER_TYPE field

  [MVCTable('OC_USERS')]
  TOcUserBase = class(TEntityBase)
  private
    [MVCTableField('USER_ID', [foPrimaryKey])]
    FUserId: String;                 // NOT NULL
    [MVCTableField('USER_NAME')]
    FUserName: NullableString;
    [MVCTableField('FULL_NAME')]
    FFullName: NullableString;
    [MVCTableField('USER_TYPE')]
    FUserType: NullableInt32;
  public
    procedure Clear; virtual;
    [MVCSwagJSONSchemaField('UserId','Primary key for user', True, False)]
    property UserId: string read FUserId write FUserId;
    [MVCSwagJSONSchemaField('UserName','Login or handle for the user', False, True)]
    property UserName: NullableString read FUserName write FUserName;
    [MVCSwagJSONSchemaField('FullName','User''s full display name', False, True)]
    property FullName: NullableString read FFullName write FFullName;
    [MVCSwagJSONSchemaField('UserType','User type / role code', False, True)]
    property UserType: NullableInt32 read FUserType write FUserType;
  end;


  /// <summary>Model class for OC_USERS (PK: USER_ID)</summary>
  [MVCTable('OC_USERS')]
  TOcUser = class(TOcUserBase)
  private
    [MVCTableField('LAST_LOGIN_DATE')]
    FLastLoginDate: NullableTDateTime;
    [MVCTableField('LAST_LOGIN_IP')]
    FLastLoginIP: NullableString;
    [MVCTableField('LAST_LOGIN_COMPUTER_NAME')]
    FLastLoginComputerName: NullableString;
    [MVCTableField('LAST_LOGIN_COMPUTER_USER')]
    FLastLoginComputerUser: NullableString;
    [MVCTableField('PASSWORD_LIFESPAN')]
    FPasswordLifespan: NullableInt32;
    [MVCTableField('DATE_PASSWORD_CHANGED')]
    FDatePasswordChanged: NullableTDateTime;
    [MVCTableField('FORCE_PASSWORD_CHANGE')]
    FForcePasswordChange: NullableInt16; // SMALLINT -> Integer
    [MVCTableField('DISABLED')]
    FDisabled: NullableInt16;            // SMALLINT -> Integer
    [MVCTableField('FAILED_ATTEMPTS')]
    FFailedAttempts: NullableInt16;      // SMALLINT -> Integer
    [MVCTableField('USER_PRIVILEGES')]
    FUserPrivileges: NullableInt32;
    [MVCTableField('EMAIL_ADDRESS')]
    FEmailAddress: NullableString;
    [MVCTableField('MOBILE_TEL')]
    FMobileTel: NullableString;
    [MVCTableField('ORGANISATION_ID')]
    FOrganisationId: NullableString;
  public
    procedure Clear; override;
    // Booleany helpers (NULL treated as False)
    function IsDisabledOrFalse: Boolean;
    function MustChangePassword: Boolean;
    [MVCSwagJSONSchemaField('LastLoginDate','Last login date/time', False, True)]
    property LastLoginDate: NullableTDateTime read FLastLoginDate write FLastLoginDate;
    [MVCSwagJSONSchemaField('LastLoginIP','Last login client IP address', False, True)]
    property LastLoginIP: NullableString read FLastLoginIP write FLastLoginIP;
    [MVCSwagJSONSchemaField('LastLoginComputerName','Last login computer name', False, True)]
    property LastLoginComputerName: NullableString read FLastLoginComputerName write FLastLoginComputerName;
    [MVCSwagJSONSchemaField('LastLoginComputerUser','Last login OS user name', False, True)]
    property LastLoginComputerUser: NullableString read FLastLoginComputerUser write FLastLoginComputerUser;
    [MVCSwagJSONSchemaField('PasswordLifespan','Password lifespan in days', False, True)]
    property PasswordLifespan: NullableInt32 read FPasswordLifespan write FPasswordLifespan;
    [MVCSwagJSONSchemaField('DatePasswordChanged','Date/time password was last changed', False, True)]
    property DatePasswordChanged: NullableTDateTime read FDatePasswordChanged write FDatePasswordChanged;
    [MVCSwagJSONSchemaField('ForcePasswordChange','Flag to force password change at login', False, True)]
    property ForcePasswordChange: NullableInt16 read FForcePasswordChange write FForcePasswordChange;
    [MVCSwagJSONSchemaField('Disabled','Flag indicating whether the account is disabled', False, True)]
    property Disabled: NullableInt16 read FDisabled write FDisabled;
    [MVCSwagJSONSchemaField('FailedAttempts','Number of failed login attempts', False, True)]
    property FailedAttempts: NullableInt16 read FFailedAttempts write FFailedAttempts;
    [MVCSwagJSONSchemaField('UserPrivileges','User privilege bitmask or code', False, True)]
    property UserPrivileges: NullableInt32 read FUserPrivileges write FUserPrivileges;
    [MVCSwagJSONSchemaField('EmailAddress','User email address', False, True)]
    property EmailAddress: NullableString read FEmailAddress write FEmailAddress;
    [MVCSwagJSONSchemaField('MobileTel','User mobile telephone number', False, True)]
    property MobileTel: NullableString read FMobileTel write FMobileTel;
    [MVCSwagJSONSchemaField('OrganisationId','Owning organisation identifier', False, True)]
    property OrganisationId: NullableString read FOrganisationId write FOrganisationId;
  end;


  [MVCTable('OC_USERS')]
  TOcUserWithPassword = class(TOcUser)
  private
    [MVCTableField('PASSWORD_HASH')]
    FPasswordHash: NullableString;
  public
    procedure Clear; override;
    [MVCSwagJSONSchemaField('PasswordHash', 'Hash of the users password', TRUE, FALSE)]
    property PasswordHash: NullableString read FPasswordHash write FPasswordHash;
  end;

[MVCTable('OC_USERS')]
TUserPasswordChecker = class(TocUser)
  private
    [MVCTableField('PASSWORD_HASH')]
    fHashedPwd: NullableString;
    [MVCTableField('USER_ID')]
    fSalt: NullableString;
    [MVCTableField('FAILED_ATTEMPTS')]
    fFailedAttempts: Integer;
    [MVCTableField('USER_PRIVILEGES')]
    fUserPrivileges: Integer;
  public
    function getRoles: TArray<string>;
    function IsValid(const aPassword: string): boolean;
    [MVCSwagJSONSchemaField('Hashed_Pwd','Hashed password value', False, True)]
    property Hashed_Pwd : nullableString read fHashedPwd write fHashedPwd;
    [MVCSwagJSONSchemaField('Salt','Salt used for password hashing', False, True)]
    property Salt : nullableString read fSalt write fSalt;
    [MVCSwagJSONSchemaField('FailedAttempts','Current failed login attempt count', False, True)]
    property FailedAttempts : Integer read fFailedAttempts write fFailedAttempts;
    [MVCSwagJSONSchemaField('UserPrivileges','Effective user privilege flags', False, True)]
    property UserPrivileges : Integer read fUserPrivileges write fUserPrivileges;
    function ChangePassword(const oldPassword, newPassword : string; const Force : boolean) : boolean;
    function generateNewPassword : string;
  end;


  TOcUserList = TObjectList<TOcUser>;
  TOcUserPasswordList = TObjectList<TUserPasswordChecker>;

  [MVCTable('OC_USER_LOG')]
  [MVCNameCase(ncCamelCase)]
  TOCUserLog = class(TMVCActiveRecord)
  private
    [MVCTableField('ID', [foAutoGenerated, foPrimaryKey])]
    FID: Int64;
    [MVCTableField('USER_ID')]
    FUserID: NullableString;               // varchar(23)
    [MVCTableField('USER_NAME')]
    FUserName: NullableString;             // varchar(35)
    [MVCTableField('USER_ACTION')]
    FUserAction: NullableInt32;            // int
    [MVCTableField('ACTION_SUCCESS')]
    FActionSuccess: NullableInt32;         // int (0/1 or code)
    [MVCTableField('APPLICATION_ID')]
    FApplicationID: NullableString;        // varchar(38)
    [MVCTableField('LOG_TIME')]
    FLogTime: NullableTDateTime;           // datetime
    [MVCTableField('LOG_IP_ADDRESS')]
    FLogIPAddress: NullableString;         // varchar(20)
    [MVCTableField('LOG_LOCAL_IP_ADDRESS')]
    FLogLocalIPAddress: NullableString;    // varchar(20)
    [MVCTableField('LOG_COMPUTER_NAME')]
    FLogComputerName: NullableString;      // varchar(255)
    [MVCTableField('LOG_COMPUTER_USER')]
    FLogComputerUser: NullableString;      // varchar(35)
  public
    // Primary key (AUTO_INCREMENT in MySQL)
    [MVCSwagJSONSchemaField('ID','Primary key for log entry', True, False)]
    property ID: Int64 read FID write FID;
    [MVCSwagJSONSchemaField('UserID','User identifier', False, True)]
    property UserID: NullableString read FUserID write FUserID;
    [MVCSwagJSONSchemaField('UserName','User name at time of log entry', False, True)]
    property UserName: NullableString read FUserName write FUserName;
    [MVCSwagJSONSchemaField('UserAction','Code representing the user action', False, True)]
    property UserAction: NullableInt32 read FUserAction write FUserAction;
    [MVCSwagJSONSchemaField('ActionSuccess','Indicates whether the action succeeded', False, True)]
    property ActionSuccess: NullableInt32 read FActionSuccess write FActionSuccess;
    [MVCSwagJSONSchemaField('ApplicationID','Application identifier', False, True)]
    property ApplicationID: NullableString read FApplicationID write FApplicationID;
    [MVCSwagJSONSchemaField('LogTime','Time of the logged event', False, True)]
    property LogTime: NullableTDateTime read FLogTime write FLogTime;
    [MVCSwagJSONSchemaField('LogIPAddress','Client IP address', False, True)]
    property LogIPAddress: NullableString read FLogIPAddress write FLogIPAddress;
    [MVCSwagJSONSchemaField('LogLocalIPAddress','Local IP address as seen by server', False, True)]
    property LogLocalIPAddress: NullableString read FLogLocalIPAddress write FLogLocalIPAddress;
    [MVCSwagJSONSchemaField('LogComputerName','Client computer name', False, True)]
    property LogComputerName: NullableString read FLogComputerName write FLogComputerName;
    [MVCSwagJSONSchemaField('LogComputerUser','Client OS user name', False, True)]
    property LogComputerUser: NullableString read FLogComputerUser write FLogComputerUser;
  end;

const
  // Roles for RolesAllowed attribute
  cRoleSTUDENT = 'Student';
  cRoleINSTRUCTOR = 'Instructor';
  cRoleAUTHOR  = 'Author';
  cRoleSUPER   = 'SuperAdmin';
  cAllRoles = cRoleSTUDENT + ',' + cRoleINSTRUCTOR + ',' + cRoleAUTHOR + ',' + cRoleSUPER;
  cMinLengthPassword : integer = 8;


implementation

uses
  System.Hash;

{ TOcUser }

procedure TOcUser.Clear;
begin
  inherited;
  FLastLoginDate.Clear;
  FLastLoginIP.Clear;
  FLastLoginComputerName.Clear;
  FLastLoginComputerUser.Clear;
  FPasswordLifespan.Clear;
  FDatePasswordChanged.Clear;
  FForcePasswordChange.Clear;
  FDisabled.Clear;
  FFailedAttempts.Clear;
  FUserPrivileges.Clear;
  FFullName.Clear;
  FEmailAddress.Clear;
  FMobileTel.Clear;
  FOrganisationId.Clear;
end;

function TOcUser.IsDisabledOrFalse: Boolean;
begin
  Result := (FDisabled.Value <> 0) ;
end;

function TOcUser.MustChangePassword: Boolean;
begin
  Result := (FForcePasswordChange.Value <> 0);
end;

{ TOcUserWithPassword }

procedure TOcUserWithPassword.Clear;
begin
  inherited;
  FPasswordHash := '';
end;

{ TUserPasswordChecker }

function TUserPasswordChecker.ChangePassword(const OldPassword, newPassword: string; const Force: boolean): boolean;
begin
  var lNewHash := THashSHA1.GetHashString(newPassword);
  var lOldHash := THashSHA1.GetHashString(oldPassword);
  if force or (lNewHash = lOldHash) then
  begin
    Hashed_Pwd := lNewHash;
    result := TRUE;
  end;
end;

function TUserPasswordChecker.generateNewPassword: string;
begin
  if EmailAddress.HasValue then
    result := UserName.value + ':' + EmailAddress.Value
  else
  if MobileTel.HasValue then
    result := UserName.value + ':' + FMobileTel.value
  else
    result := UserName.value + ':57243'; //random
end;

function TUserPasswordChecker.GetRoles: TArray<string>;
begin
  if FUserType = Ord(TUserType.utStudent) then
    result := result + [cRoleSTUDENT];
  if fUserType = Ord(TUserType.utInstructor) then
  begin
    result := result + [cRoleStudent];
    result := Result + [cRoleInstructor];
  end;
  if fUserType = Ord(TUserType.utAuthor) then
  begin
    result := result + [cRoleStudent];
    result := Result + [cRoleInstructor];
    result := Result + [cRoleAUTHOR];
  end;
  if fUserType = Ord(TUserType.utSuper) then
  begin
    result := result + [cRoleStudent];
    result := Result + [cRoleInstructor];
    result := Result + [cRoleAUTHOR];
    result := result + [cRoleSUPER];
  end;
end;

function TUserPasswordChecker.IsValid(const aPassword: string): boolean;
//var
//  lHasHTest : string;
begin
  // SHA256 (I think)... see AquilaServer for implementation!
  result := (aPassword.Length > cMinLengthPassword);
//  if result then
//  begin
//    var lSaltedPassword := FUserId + ':' + aPassword;
//    lHasHTest := THashSHA1.GetHashString(lSaltedPassword);
//    result := SameText(lHashTest, self.fHashedPwd);
//  end;
end;

{ TOcUserBase }

procedure TOcUserBase.Clear;
begin
  FUserId := '';
  FUserName.Clear;
  FUserType.Clear;
end;


end.

