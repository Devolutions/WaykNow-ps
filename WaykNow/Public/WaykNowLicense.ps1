function Set-WaykNowLicense
{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory,Position=0)]
        [string] $License
    )

    $licensePattern = '[A-Z0-9]{5}-[A-Z0-9]{5}-[A-Z0-9]{5}-[A-Z0-9]{5}-[A-Z0-9]{5}'
    $WaykNowInfo = Get-WaykNowInfo

    if ($License -CMatch $licensePattern) {
        $json = Get-Content -Path $WaykNowInfo.ConfigFile -Raw -Encoding UTF8 | ConvertFrom-Json
        if ($json.RegistrationSerial)
        {
            $json.RegistrationSerial = $License;
        }
        else
        {
            # If the json is empty
            if (!$json) {
                $json = '{}'
                $json = ConvertFrom-Json $json
            }
            
            $json | Add-Member -Type NoteProperty -Name 'RegistrationSerial' -Value $License -Force
        }

        $fileValue = $json | ConvertTo-Json
        $Utf8NoBomEncoding = New-Object System.Text.UTF8Encoding $False
        [System.IO.File]::WriteAllLines($WaykNowInfo.ConfigFile, $fileValue, $Utf8NoBomEncoding)
    } else {
        Write-Error "Invalid License Format"
    }
}

function Get-WaykNowLicense
{
    [CmdletBinding()]
    param()

    [WaykNowInfo]$WaykInfo = Get-WaykNowInfo
    $json = Get-Content -Path $WaykInfo.ConfigFile -Raw -Encoding UTF8 | ConvertFrom-Json
    return $json.RegistrationSerial
}

function Reset-WaykNowLicense
{
    [CmdletBinding()]
    param()

    [WaykNowInfo]$WaykInfo = Get-WaykNowInfo

    $json = Get-Content -Path $WaykInfo.ConfigFile -Raw -Encoding UTF8 | ConvertFrom-Json

    if ($json.RegistrationSerial) {
        $json.RegistrationSerial = ''
        $fileValue = $json | ConvertTo-Json
        $Utf8NoBomEncoding = New-Object System.Text.UTF8Encoding $False
        [System.IO.File]::WriteAllLines($WaykInfo.ConfigFile, $fileValue, $Utf8NoBomEncoding)
    }
}

Export-ModuleMember -Function Set-WaykNowLicense, Get-WaykNowLicense, Reset-WaykNowLicense
