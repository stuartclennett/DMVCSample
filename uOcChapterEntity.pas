unit uOcChapterEntity;

interface

uses
  System.SysUtils,
  System.Classes,
  uBaseEntity,
  MVCFramework.Swagger.Commons,
  MVCFramework.ActiveRecord,
  MVCFramework.Nullables,          // NullableString, NullableInteger, NullableTDateTime
  MVCFramework.Serializer.Commons;

type
  // Optional helper for raw SQL; delete if not needed.
  TOcChapterCols = record
  public const
    TableName        = 'OC_CHAPTER';
    CHAPTER_ID       = 'CHAPTER_ID';
    COURSE_ID        = 'COURSE_ID';
    TITLE            = 'TITLE';
    INTRO_TEXT       = 'INTRO_TEXT';
    TARGET_LEVELS    = 'TARGET_LEVELS';
    AUTHOR_NAME      = 'AUTHOR_NAME';
    AUTHOR_ID        = 'AUTHOR_ID';
    CREATE_DATE      = 'CREATE_DATE';
    MODIFIED_DATE    = 'MODIFIED_DATE';
    DISPLAY_ORDER    = 'Display_Order';   // note exact DB casing
    INTRO_TEXT_TXT   = 'INTRO_TEXT_TXT';
  end;

  /// <summary>
  ///   Model class for OC_CHAPTER (PK: CHAPTER_ID)
  /// </summary>
  [MVCTable('OC_CHAPTER')]
  TOcChapter = class(TEntityBase)
  private
    [MVCTableField('CHAPTER_ID')]
    FChapterId: string;
    [MVCTableField('COURSE_ID')]
    FCourseId: NullableString;
    [MVCTableField('TITLE')]
    FTitle: NullableString;
    [MVCTableField('INTRO_TEXT')]
    FIntroText: NullableString; // LongBLOB -> it's text though
    [MVCTableField('TARGET_LEVELS')]
    FTargetLevels: NullableInteger;
    [MVCTableField('AUTHOR_NAME')]
    FAuthorName: NullableString;
    [MVCTableField('AUTHOR_ID')]
    FAuthorId: NullableString;
    [MVCTableField('CREATE_DATE')]
    FCreateDate: NullableTDateTime;
    [MVCTableField('MODIFIED_DATE')]
    FModifiedDate: NullableTDateTime;
    [MVCTableField('DISPLAY_ORDER')]
    FDisplayOrder: NullableInteger;  // "Display_Order" column
    [MVCTableField('INTRO_TEXT_TXT')]
    FIntroTextTxt: NullableString;   // LongText
  public
    class function TableName: string; static;
    procedure Clear;
    [MVCSwagJSONSchemaField('ChapterId','Primary key for chapter', True, False)]
    property ChapterId: string read FChapterId write FChapterId;
    [MVCSwagJSONSchemaField('CourseId','Owning course identifier (FK)', False, True)]
    property CourseId: NullableString read FCourseId write FCourseId;
    [MVCSwagJSONSchemaField('Title','Chapter title', False, True)]
    property Title: NullableString read FTitle write FTitle;
    [MVCSwagJSONSchemaField('IntroText','Intro text (stored as BLOB in DB but textual)', False, True)]
    property IntroText: NullableString read FIntroText write FIntroText;
    [MVCSwagJSONSchemaField('TargetLevels','Target audience levels', False, True)]
    property TargetLevels: NullableInteger read FTargetLevels write FTargetLevels;
    [MVCSwagJSONSchemaField('AuthorName','Author display name', False, True)]
    property AuthorName: NullableString read FAuthorName write FAuthorName;
    [MVCSwagJSONSchemaField('AuthorId','Author identifier', False, True)]
    property AuthorId: NullableString read FAuthorId write FAuthorId;
    [MVCSwagJSONSchemaField('CreateDate','Creation date/time', False, True)]
    property CreateDate: NullableTDateTime read FCreateDate write FCreateDate;
    [MVCSwagJSONSchemaField('ModifiedDate','Last modified date/time', False, True)]
    property ModifiedDate: NullableTDateTime read FModifiedDate write FModifiedDate;
    [MVCSwagJSONSchemaField('DisplayOrder','Display order within course (mixed case as per DDL)', False, True)]
    property DisplayOrder: NullableInteger read FDisplayOrder write FDisplayOrder;
    [MVCSwagJSONSchemaField('IntroTextTxt','Intro text (plain text)', False, True)]
    property IntroTextTxt: NullableString read FIntroTextTxt write FIntroTextTxt;
  end;


implementation

{ TOcChapter }

procedure TOcChapter.Clear;
begin
  FChapterId := '';

  FCourseId.Clear;
  FTitle.Clear;
  FIntroText.Clear;
  FTargetLevels.Clear;
  FAuthorName.Clear;
  FAuthorId.Clear;
  FCreateDate.Clear;
  FModifiedDate.Clear;
  FDisplayOrder.Clear;
  FIntroTextTxt.Clear;
end;

class function TOcChapter.TableName: string;
begin
  Result := TOcChapterCols.TableName;
end;

end.

