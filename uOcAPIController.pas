unit uOcAPIController;

interface

uses
  MVCFramework, MVCFramework.Commons, MVCFramework.Nullables, PersonEntityU, PersonServiceU, MVCFramework.Serializer.Commons,
  System.Generics.Collections, FireDAC.Comp.Client;

type
  TControllerBase = class(TMVCController)
  protected
    procedure OnBeforeAction(AContext: TWebContext; const AActionName: string; var AHandled: Boolean); override;
    procedure OnAfterAction(AContext: TWebContext; const AActionName: string); override;
  end;

  [MVCPath('/api/test')]
  TocAPIController = class(TControllerBase)
  public
    [MVCPath]
    [MVCHTTPMethod([httpGET])]
    [MVCProduces(TMVCMediaType.TEXT_HTML)]
    function Index: String;

    [MVCPath('/reversedstrings/($Value)')]
    [MVCHTTPMethod([httpGET])]
    [MVCProduces(TMVCMediaType.TEXT_PLAIN)]
    function GetReversedString(const Value: String): String;

    //Sample CRUD Actions for a "People" entity
    [MVCPath('/people')]
    [MVCHTTPMethod([httpGET])]
    function GetPeople([MVCInject] PeopleService: IPeopleService): IMVCResponse;

    [MVCPath('/people/($ID)')]
    [MVCHTTPMethod([httpGET])]
    function GetPerson(ID: Integer): TPerson;

    [MVCPath('/people')]
    [MVCHTTPMethod([httpPOST])]
    function CreatePerson([MVCFromBody] Person: TPerson): IMVCResponse;

    [MVCPath('/people/($ID)')]
    [MVCHTTPMethod([httpPUT])]
    function UpdatePerson(ID: Integer; [MVCFromBody] Person: TPerson): IMVCResponse;

    [MVCPath('/people/($ID)')]
    [MVCHTTPMethod([httpDELETE])]
    function DeletePerson(ID: Integer): IMVCResponse;
  end;

  // path not found?
  [MVCPath('/api/v1/auth')]
  TocAuthController = class(TcontrollerBase)
  public
    [MVCPath('/logout')]
    [MVCHTTPMethod([httpDELETE])]
    function Logout : IMVCResponse;
  end;

const
  cSBLSF_ID = 'SBLSF';

  AUTHOR_APP_ID = '{31EBD1FA-8E86-4A5E-8EA4-51C10F96D9B8}';
  STUDENT_APP_ID = '{4C3BE796-EFC4-4EB1-B0B2-6319D35B6215}';
  API_ID = '{F7D9DA96-8932-4D99-9119-18997CDBC9A8}';

implementation

uses
  System.StrUtils, System.SysUtils,
  uJWTUtils,
  MVCFramework.Logger,
  uOCConstants,
  MVCFramework.ActiveRecord
  , uOcUserEntity
  ;

{ TControllerBase }

procedure TControllerBase.OnBeforeAction(AContext: TWebContext;
  const AActionName: string; var AHandled: Boolean);
var
  lConn: TFDConnection;
begin
  inherited;
  lConn := TFDConnection.Create(Nil);
  lConn.ConnectionDefName := cOCConnectionName;
  ActiveRecordConnectionsRegistry.AddDefaultConnection(lConn);
end;

procedure TControllerBase.OnAfterAction(AContext: TWebContext;
  const AActionName: string);
begin
  inherited;
  ActiveRecordConnectionsRegistry.RemoveDefaultConnection();
end;

{ TocAPIController }

function TocAPIController.Index: String;
begin
  //use Context property to access to the HTTP request and response
  Result := '<p>Hello <strong>DelphiMVCFramework</strong> World</p>' + 
            '<p><small>dmvcframework-' + DMVCFRAMEWORK_VERSION + '</small></p>';
end;

function TocAPIController.GetReversedString(const Value: String): String;
begin
  Result := System.StrUtils.ReverseString(Value.Trim);
end;

//Sample CRUD Actions for a "People" entity (with service injection)
function TocAPIController.GetPeople(PeopleService: IPeopleService): IMVCResponse;
begin
  Result := OkResponse(PeopleService.GetAll);
end;

function TocAPIController.GetPerson(ID: Integer): TPerson;
begin
  Result := TPerson.Create(ID, 'Daniele', 'Teti', EncodeDate(1979, 11, 4));
end;

function TocAPIController.CreatePerson([MVCFromBody] Person: TPerson): IMVCResponse;
begin
  LogI('Created ' + Person.FirstName + ' ' + Person.LastName);
  Result := CreatedResponse('', 'Person created');
end;

function TocAPIController.UpdatePerson(ID: Integer; [MVCFromBody] Person: TPerson): IMVCResponse;
begin
  LogI('Updated ' + Person.FirstName + ' ' + Person.LastName);
  Result := NoContentResponse();
end;

function TocAPIController.DeletePerson(ID: Integer): IMVCResponse;
begin
  LogI('Deleted person with id ' + ID.ToString);
  Result := NoContentResponse();
end;

{ TocSecurityController }

function TocAuthController.Logout: IMVCResponse;
var
  UserLog: TOCUserLog;
begin
  // this should also blacklist the JWT (see Webmodule middleware setup)
  UserLog := TOcUserLog.Create(TRUE);
  UserLog.ApplicationID := API_ID;
  UserLog.UserName.value := Context.LoggedUser.UserName;
  UserLog.UserAction.value := 2; //logout
  UserLog.ActionSuccess.Value := 1; // 0=failed, 1=worked
  UserLog.LogTime.Value := Now;
  UserLog.LogIPAddress.Value := Context.Request.ClientIp;
  UserLog.Store;
end;

end.
