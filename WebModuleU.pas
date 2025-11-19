unit WebModuleU;

interface

uses
  System.SysUtils,
  System.Classes,
  Web.HTTPApp,
  MVCFramework;

type
  TSCDemoWebMod = class(TWebModule)
    procedure WebModuleCreate(Sender: TObject);
    procedure WebModuleDestroy(Sender: TObject);
  private
    fMVC: TMVCEngine;
  end;

var
  WebModuleClass: TComponentClass = TSCDemoWebMod;

implementation

{$R *.dfm}

uses
  ControllerU,
  uChaptersControllers,
  System.IOUtils,
  MVCFramework.Commons,
  MVCFramework.Swagger.Commons,
  MVCFramework.Middleware.ActiveRecord,
  MVCFramework.Middleware.Session,
  MVCFramework.Middleware.Redirect,
  MVCFramework.Middleware.StaticFiles,
  MVCFramework.Middleware.Analytics,
  MVCFramework.Middleware.Trace,
  MVCFramework.Middleware.CORS,
  MVCFramework.Middleware.ETag,
  MVCFramework.Middleware.Swagger,
  MVCFramework.Middleware.Compression;

procedure TSCDemoWebMod.WebModuleCreate(Sender: TObject);
var
  lSwagInfo: TMVCSwaggerInfo;
begin
  fMVC := TMVCEngine.Create(Self,
    procedure(Config: TMVCConfig)
    begin
      //default content-type
      Config[TMVCConfigKey.DefaultContentType] := dotEnv.Env('dmvc.default.content_type', TMVCConstants.DEFAULT_CONTENT_TYPE);
      //default content charset
      Config[TMVCConfigKey.DefaultContentCharset] := dotEnv.Env('dmvc.default.content_charset', TMVCConstants.DEFAULT_CONTENT_CHARSET);
      //unhandled actions are permitted?
      Config[TMVCConfigKey.AllowUnhandledAction] := dotEnv.Env('dmvc.allow_unhandled_actions', 'false');
      //enables or not system controllers loading (available only from localhost requests)
      Config[TMVCConfigKey.LoadSystemControllers] := dotEnv.Env('dmvc.load_system_controllers', 'true');
      //default view file extension
      Config[TMVCConfigKey.DefaultViewFileExtension] := dotEnv.Env('dmvc.default.view_file_extension', 'html');
      //view path
      Config[TMVCConfigKey.ViewPath] := dotEnv.Env('dmvc.view_path', 'templates');
      //use cache for server side views (use "false" in debug and "true" in production for faster performances
      Config[TMVCConfigKey.ViewCache] := dotEnv.Env('dmvc.view_cache', 'false');
      //Max Record Count for automatic Entities CRUD
      Config[TMVCConfigKey.MaxEntitiesRecordCount] := dotEnv.Env('dmvc.max_entities_record_count', IntToStr(TMVCConstants.MAX_RECORD_COUNT));
      //Enable Server Signature in response
      Config[TMVCConfigKey.ExposeServerSignature] := dotEnv.Env('dmvc.expose_server_signature', 'false');
      //Enable X-Powered-By Header in response
      Config[TMVCConfigKey.ExposeXPoweredBy] := dotEnv.Env('dmvc.expose_x_powered_by', 'true');
      // Max request size in bytes
      Config[TMVCConfigKey.MaxRequestSize] := dotEnv.Env('dmvc.max_request_size', IntToStr(TMVCConstants.DEFAULT_MAX_REQUEST_SIZE));
    end);

  lSwagInfo.Title := 'Omnicourse API';
  lSwagInfo.Version := 'v1';
  lSwagInfo.TermsOfService := '';
  lSwagInfo.Description := 'API for the Omnicourse Online Learning Application';
  lSwagInfo.ContactName := 'Stuart Clennett';
  lSwagInfo.ContactEmail := 'stuart@sblsf.com';
  lSwagInfo.ContactUrl := 'http://www.sbslf.com';
  lSwagInfo.LicenseName := '';
  lSwagInfo.LicenseUrl := '';

  // Controllers
  fMVC.AddController(TSCDemoController);
  fMVC.AddController(TOcChaptersController);

  // Controllers - END

  // Middleware
  // To use memory session uncomment the following line
  // fMVC.AddMiddleware(UseMemorySessionMiddleware);
  //
  // To use file based session uncomment the following line
  // fMVC.AddMiddleware(UseFileSessionMiddleware);
  //
  // To use database based session uncomment the following lines,
  // configure you firedac db connection and create table dmvc_sessions
  // fMVC.AddMiddleware(TMVCActiveRecordMiddleware.Create('firedac_con_def_name'));
  // fMVC.AddMiddleware(UseDatabaseSessionMiddleware);
  fMVC.AddMiddleware(TMVCActiveRecordMiddleware.Create(
    dotEnv.Env('firedac.connection_definition_name', 'ocAPI'),
    dotEnv.Env('firedac.connection_definitions_filename', '')
  ));

  fMVC
      .AddMiddleware(TMVCSwaggerMiddleware.Create(fMVC, lSwagInfo, '/api/swagger.json'))
      .AddMiddleware(TMVCStaticFilesMiddleware.Create('/swagger', TPath.Combine(ExtractFilePath(GetModuleName(HInstance)), '..\..\swagger-ui')))


  // Middleware - END

end;

procedure TSCDemoWebMod.WebModuleDestroy(Sender: TObject);
begin
  fMVC.Free;
end;

end.
