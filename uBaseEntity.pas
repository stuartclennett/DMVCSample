unit uBaseEntity;

interface

uses
  System.SysUtils,
  System.Classes,
  MVCFramework.ActiveRecord,
  MVCFramework.Nullables,          // NullableString, NullableInteger, NullableTDateTime
  MVCFramework.Serializer.Commons;

type
  TEntityBase = class(TMVCActiveRecord);

implementation

end.
