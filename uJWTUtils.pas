unit uJWTUtils;

interface

uses
  MVCFramework, MVCFramework.Commons,
  System.SysUtils, System.Classes, System.NetEncoding, System.JSON;

type
  TJWTUtils = class
  private
    class function Base64UrlDecodeToString(const ABase64Url: string): string; static;
    class function TryGetPayloadJSON(const AToken: string; out APayload: TJSONObject): Boolean; static;
  public
    class function ExtractBearerToken(const AContext: TWebContext): string;
    class function TryGetJtiFromJWT(const AToken: string; out AJti: string): Boolean;
    class function TryGetJtiAndExpFromJWT(const AToken: string; out AJti: string; out AExp: TDateTime): Boolean;
  end;

implementation

class function TJWTUtils.ExtractBearerToken(const AContext: TWebContext): string;
var
  LAuth: string;
const
  BEARER = 'BEARER ';
begin
  Result := '';
  LAuth := AContext.Request.Headers['Authorization'];

  if LAuth = '' then
    Exit;

  // Case-insensitive "Bearer "
  if SameText(Copy(LAuth, 1, Length(BEARER)), BEARER) then
    Result := Trim(Copy(LAuth, Length(BEARER) + 1, MaxInt))
  else
    Result := '';
end;

class function TJWTUtils.Base64UrlDecodeToString(const ABase64Url: string): string;
var
  S: string;
begin
  // Convert from base64url to base64 (replace chars + pad)
  S := ABase64Url;
  S := StringReplace(S, '-', '+', [rfReplaceAll]);
  S := StringReplace(S, '_', '/', [rfReplaceAll]);
  while (Length(S) mod 4) <> 0 do
    S := S + '=';
  Result := TNetEncoding.Base64.Decode(S);
end;

class function TJWTUtils.TryGetPayloadJSON(const AToken: string; out APayload: TJSONObject): Boolean;
var
  Parts: TArray<string>;
  JSONStr: string;
  JSONVal: TJSONValue;
begin
  Result := False;
  APayload := nil;

  Parts := AToken.Split(['.']);
  if Length(Parts) <> 3 then
    Exit;

  try
    JSONStr := TJWTUtils.Base64UrlDecodeToString(Parts[1]);
    JSONVal := TJSONObject.ParseJSONValue(JSONStr);
    if (JSONVal <> nil) and (JSONVal is TJSONObject) then
    begin
      APayload := TJSONObject(JSONVal);
      Result := True;
    end
    else
      JSONVal.Free;
  except
    // swallow; Result stays False
  end;
end;

class function TJWTUtils.TryGetJtiFromJWT(const AToken: string; out AJti: string): Boolean;
var
  Payload: TJSONObject;
  Val: TJSONValue;
begin
  Result := False;
  AJti := '';

  if not TJWTUtils.TryGetPayloadJSON(AToken, Payload) then
    Exit;
  try
    Val := Payload.Values['jti'];
    if (Val <> nil) and (Val.Value <> '') then
    begin
      AJti := Val.Value;
      Result := True;
    end;
  finally
    Payload.Free;
  end;
end;

class function TJWTUtils.TryGetJtiAndExpFromJWT(const AToken: string; out AJti: string; out AExp: TDateTime): Boolean;
var
  Payload: TJSONObject;
  ValJti, ValExp: TJSONValue;
  UnixExp: Int64;
begin
  Result := False;
  AJti := '';
  AExp := 0;

  if not TJWTUtils.TryGetPayloadJSON(AToken, Payload) then
    Exit;
  try
    ValJti := Payload.Values['jti'];
    ValExp := Payload.Values['exp']; // standard JWT claim: seconds since epoch (UTC)

    if (ValJti = nil) or (ValJti.Value = '') or (ValExp = nil) then
      Exit;

    if not TryStrToInt64(ValExp.Value, UnixExp) then
      Exit;

    AJti := ValJti.Value;
    // 25569 = Delphi TDateTime for Unix epoch (1970-01-01)
    AExp := (UnixExp / 86400) + 25569;
    Result := True;
  finally
    Payload.Free;
  end;
end;

end.
