function JsonDB-Init()
{
  Set-Variable -name "kJsonCompilationDbPath" -value ("$(Get-Location)\compile_commands.json") -option Constant -scope Global
  Set-Variable -name "kJsonCompilationDbCount" -value 0 -scope Global
  
  "[" | Out-File $kJsonCompilationDbPath -Encoding "UTF8"
}

function JsonDB-Append($text)
{
  $text | Out-File $kJsonCompilationDbPath -append -Encoding "UTF8"
}

function JsonDB-Finalize()
{
  JsonDB-Append "]"
  Write-Output "Exported JSON Compilation Database to $kJsonCompilationDbPath"
}

function JsonDB-Push($directory, $file, $command)
{
  if ($kJsonCompilationDbCount -ge 1)
  {
    JsonDB-Append "  ,"
  }
  
  # use only slashes
  $command = $command.Replace('\', '/')
  $file = $file.Replace('\', '/')
  $directory = $directory.Replace('\', '/')
  
  # escape double quotes
  $command = $command.Replace('"', '\"')
  
  # make paths relative to directory
  $command = $command.Replace("$directory/", "")
  $file = $file.Replace("$directory/", "")
  
  JsonDB-Append "  {`n    ""directory"": ""$directory"",`n    ""command"": ""$command"",`n    ""file"": ""$file""`n  }"
   
  Set-Variable -name "kJsonCompilationDbCount" -value ($kJsonCompilationDbCount + 1) -scope Global
}
