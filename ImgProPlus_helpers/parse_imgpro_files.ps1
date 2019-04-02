# set user gui for selecting folder path
$application = New-Object -ComObject Shell.Application
$path = ($application.BrowseForFolder(0, 'Select location where ImgPro output text files are stored', 0)).Self.Path

# gather all text files in the path
$files = Join-Path $path "\*.txt"

# for each file in the path append the relevant data to its own text file
echo "Creating combined data files..."

foreach ($file in $files) {
Get-Content $file | Select-String -Pattern 'Densitometry' -CaseSensitive -Context 0,11 | Out-File -Encoding ASCII D:\Desktop\densitometry.txt -Append
Get-Content $file | Select-String -Pattern 'Alveolar' -CaseSensitive -Context 0,11 | Out-File -Encoding ASCII D:\Desktop\alveolar.txt -Append
}

# run python script to parse and create output xlsx file
echo "Creating 'lung_data.xlsx' file..."
echo "Saving 'lung_data.xlsx' to Desktop..." 
python D:\python_scripts\parse_imgpro.py D:\Desktop\densitometry.txt D:\Desktop\alveolar.txt

# remove the text data files so they don't accumulate on the next run
echo "Cleaning up..."
Remove-Item -Path D:\Desktop\densitometry.txt
Remove-Item -Path D:\Desktop\alveolar.txt

echo "All done!"
