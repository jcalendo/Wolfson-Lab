if WScript.Arguments.Count < 2 Then
    WScript.Echo "Please specify the source and the destination files. Usage: xml2xlsx <xls/xml source file> <xlsx destination file>"
    Wscript.Quit
End If

xml_format = 51

Set objFSO = CreateObject("Scripting.FileSystemObject")

src_file = objFSO.GetAbsolutePathName(Wscript.Arguments.Item(0))
dest_file = objFSO.GetAbsolutePathName(WScript.Arguments.Item(1))

Dim oExcel
Set oExcel = CreateObject("Excel.Application")

Dim oBook
Set oBook = oExcel.Workbooks.Open(src_file)

oBook.SaveAs dest_file, xml_format

oBook.Close False
oExcel.Quit