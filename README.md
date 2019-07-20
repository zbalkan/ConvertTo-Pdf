# ConvertTo-Pdf

## SYNOPSIS
Reads a file as plain text and writes the content to a new PDF file.

## DESCRIPTION
The script uses PdfSharp library to manage PDF documents. It creates an empty PSD, copies the content inside and saves it to the defined path. 
If the path is not defined, the output will be created on the input path.

## EXAMPLE
`ConvertTo-Pdf -Path "test.txt"`

`ConvertTo-Pdf -Path "test.txt" -OutputPath "D:\\"`

`ConvertTo-Pdf test.txt d:\\`

## INPUTS
Plain text file

## OUTPUTS
PDF File

## INSTALLATION
Use `Install-Package PdfSharp`to install the Nuget package, then copy the DLL file into the script directory.
