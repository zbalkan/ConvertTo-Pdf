<#
.SYNOPSIS
Reads a file as plain text and writes the content to a new PDF file.
.DESCRIPTION
The script uses PdfSharp library to manage PDF documents. It creates an empty PSD, copies the content inside and saves it to the defined path. 
If the path is not defined, the output will be created on the input path.
.EXAMPLE
ConvertTo-Pdf -Path "test.txt"
.EXAMPLE
ConvertTo-Pdf -Path "test.txt" -OutputPath "D:\\"
.INPUTS
Plain text file
.OUTPUTS
PDF File
#>
function ConvertTo-Pdf {
    [CmdletBinding(SupportsShouldProcess=$true,
    PositionalBinding=$false,
    ConfirmImpact='Medium')]
    [Alias()]
    Param (
    # Plain Text file path 
    [Parameter(Mandatory=$true,
    Position=0,
    ValueFromPipeline=$true,
    ValueFromPipelineByPropertyName=$true,
    ValueFromRemainingArguments=$false)]
    [ValidateNotNull()]
    [ValidateNotNullOrEmpty()]
    [String]
    $FilePath,
    
    
    # Output Path. By default it's the parent directory of input file
    [Parameter(Mandatory=$false,
    Position=1,
    ValueFromPipeline=$false,
    ValueFromPipelineByPropertyName=$false,
    ValueFromRemainingArguments=$false)]
    [String]
    $OutputPath
    )
    
    begin {
        try {
            [void][System.Reflection.Assembly]::LoadFrom(".\PdfSharp.dll")        
        }
        catch {
            Write-Error "PdfSharp.dll canot be found. Please download using Install-Package PdfSharp and copy the DLL file into the script path."
        }
        
        Add-Type -Path ".\PdfSharp.dll"
    }
    
    process {
        if ($pscmdlet.ShouldProcess("text file defined in FilePath", "Convert to PDF")) { 
            if( (Test-Path $FilePath) -eq $false ) { Write-Error "File not found."; break; }
            $textFile = Get-Item $FilePath
            if($null -eq $OutputPath -or $OutputPath.Length -eq 0) { $OutputPath = $textfile.DirectoryName }
                        
            $doc = New-Object PdfSharp.Pdf.PdfDocument
            $doc.Info.Title = $textFile.Name.Replace($textFile.Extension,"")
            $page = $doc.AddPage()
            $gfx = [PdfSharp.Drawing.XGraphics]::FromPdfPage($page)
            $font = New-Object PdfSharp.Drawing.XFont("Arial", 12, [PdfSharp.Drawing.XFontStyle]::Regular)
            $msg = Get-Content $FilePath
            $rect = New-Object PdfSharp.Drawing.XRect(40, 20, $page.Width, $page.Height)
            $gfx.DrawString($msg, $font, [PdfSharp.Drawing.XBrushes]::Black, $rect, [PdfSharp.Drawing.XStringFormats]::TopLeft)
            
            if($null -eq $OutputPath -or $OutputPath.Length -eq 0) { $OutputPath = $textfile.Parent }
            $OutFile = Join-Path -Path $OutputPath -ChildPath ($textFile.Name.Replace($textFile.Extension,"") + ".pdf")
            $doc.Save( $OutFile )
        }
    }
    
    end {
    }
}
