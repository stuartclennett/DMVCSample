unit uChaptersControllers;

interface

uses
  MVCFramework, MVCFramework.Commons, MVCFramework.ActiveRecord, MVCFramework.Swagger.Commons,
  System.SysUtils, System.Generics.Collections, Data.DB, uOcAPIController, uOcChapterEntity,
  MVCFramework.Nullables;

type

//  TOcChapter = class
//  private
//    FChapterId: string;
//    FCourseId: NullableString;
//    FTitle: NullableString;
//    FIntroText: NullableString; // LongBLOB -> it's text though
//    FTargetLevels: NullableInteger;
//    FAuthorName: NullableString;
//    FAuthorId: NullableString;
//    FCreateDate: NullableTDateTime;
//    FModifiedDate: NullableTDateTime;
//    FDisplayOrder: NullableInteger;  // "Display_Order" column
//    FIntroTextTxt: NullableString;   // LongText
//  public
//    [MVCSwagJSONSchemaField('ChapterId','Primary key for chapter', True, False)]
//    property ChapterId: string read FChapterId write FChapterId;
//    [MVCSwagJSONSchemaField('CourseId','Owning course identifier (FK)', False, True)]
//    property CourseId: NullableString read FCourseId write FCourseId;
//    [MVCSwagJSONSchemaField('Title','Chapter title', False, True)]
//    property Title: NullableString read FTitle write FTitle;
//    [MVCSwagJSONSchemaField('IntroText','Intro text (stored as BLOB in DB but textual)', False, True)]
//    property IntroText: NullableString read FIntroText write FIntroText;
//    [MVCSwagJSONSchemaField('TargetLevels','Target audience levels', False, True)]
//    property TargetLevels: NullableInteger read FTargetLevels write FTargetLevels;
//    [MVCSwagJSONSchemaField('AuthorName','Author display name', False, True)]
//    property AuthorName: NullableString read FAuthorName write FAuthorName;
//    [MVCSwagJSONSchemaField('AuthorId','Author identifier', False, True)]
//    property AuthorId: NullableString read FAuthorId write FAuthorId;
//    [MVCSwagJSONSchemaField('CreateDate','Creation date/time', False, True)]
//    property CreateDate: NullableTDateTime read FCreateDate write FCreateDate;
//    [MVCSwagJSONSchemaField('ModifiedDate','Last modified date/time', False, True)]
//    property ModifiedDate: NullableTDateTime read FModifiedDate write FModifiedDate;
//    [MVCSwagJSONSchemaField('DisplayOrder','Display order within course (mixed case as per DDL)', False, True)]
//    property DisplayOrder: NullableInteger read FDisplayOrder write FDisplayOrder;
//    [MVCSwagJSONSchemaField('IntroTextTxt','Intro text (plain text)', False, True)]
//    property IntroTextTxt: NullableString read FIntroTextTxt write FIntroTextTxt;
//  end;

  [MVCPath('/api/v1/chapters')]
  [MVCPrimaryKey('CHAPTER_ID')]
  [MVCSWAGDefaultModel(TocChapter, 'Chapter', 'Chapters')] {commenting this line you get an exception}
  [MVCSWAGDefaultSummaryTags('Chapter')] {commenting this line you get an exception}
  TocChaptersController = class(TControllerBase)
  public
    [MVCPath('/($ID)]')]
    [MVCHTTPMethod([httpGET])]
    [MVCSwagSummary(TSwaggerConst.USE_DEFAULT_SUMMARY_TAGS,'Display details for a single Chapter','')]
    (* The Following Line produces Invalid Typecast error on Swagger webpage *)
    [MVCSwagResponses(200, 'OK', TocChapter)]
    [MVCSwagResponses(404, 'Not found')]
    [MVCSwagResponses(500, 'Internal Server Error')]
    [MVCSwagParam(plPath, 'ID', 'The primary key ID of the chapter', ptString)]
    function GetChapter(const id: string) : IMVCResponse;

    [MVCPath('/($id)/slides')]
    [MVCHTTPMethod([httpGET])]
    [MVCSwagSummary(TSwaggerConst.USE_DEFAULT_SUMMARY_TAGS,'Returns a summary list of the slides for the specified course chapter','')]
    [MVCSwagParam(plPath, 'id', 'The primary key ID of the chapter', ptString)]
    (* The Following Line produces Invalid Typecast error on Swagger webpage - if uncommented *)
    //    [MVCSwagResponses(200, 'Success', TOcChapter, FALSE)]
    [MVCSwagResponses(404, 'Not found')]
    [MVCSwagResponses(500, 'Internal Server Error')]
    function GetSlidesForChapter(const id: string): IMVCResponse;
  end;

implementation

uses
  MVCFramework.ActiveRecordController;

function MakePlaceholders(Count: Integer): string;
var
  I: Integer;
begin
  Result := '';
  for I := 1 to Count do
  begin
    if I > 1 then
      Result := Result + ',';
    Result := Result + '?';
  end;
end;

function TocChaptersController.GetChapter(const id: string): IMVCResponse;
var
  Chapter : TOcChapter;
begin
  Chapter := TMVCActiveRecord.GetByPK<TocChapter>(id);
  result := OKResponse(Chapter);

end;

function TocChaptersController.GetSlidesForChapter(const id: string): IMVCResponse;
begin

end;

end.

