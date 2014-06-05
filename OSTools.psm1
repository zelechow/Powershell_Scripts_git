

function Get-SystemDetails
{
    [CmdletBinding()]

    Param(
        [Parameter(Mandatory=$true,
                   ValueFromPipeline=$true,
                   ValueFromPipelineByPropertyName=$true)]
        [alias("Name")] 
        [string[]]$ComputerName

            
            
            
    )

BEGIN{}

PROCESS{
       
        foreach($comp in $ComputerName){
                $os = Get-WmiObject -Class win32_OperatingSystem -ComputerName $comp |
                          select VERSION,ServicePackMajorVersion,BuildNumber

                $system = Get-WmiObject -Class Win32_ComputerSystem -ComputerName $comp|
                            select Manufacturer,Model,__SERVER
    
                $bios = Get-WmiObject -Class win32_bios -computername $comp|
                            select SerialNumber


                $params = [ordered]@{
                                     ComputerName=$comp;
                                     OSVersion=$os.VERSION;
                                     OSBuild=$os.BuildNumber;
                                     Manufacturer=$system.Manufacturer
                                     Model=$system.Model
                                     BIOSSerial=$bios.SerialNumber
                                     }

                $CompObj = New-Object -TypeName psobject -Property $params

                Write-Output $CompObj
                            

        }
}

END{}


}