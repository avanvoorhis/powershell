param(
    [parameter(Mandatory=$true)]
    [string[]]$computerName # This parameter will allow a series of computers named on the command line
    )

function get-nvidia ($computerName = $env:COMPUTERNAME)
{
<#
  .Synopsis
	Simple module to run NVIDIA-SMI.exe on the host(s) named on the command line.	 
   .Description
    	This module should only be run on hosts where NVIDIA has been installed.
   .Example
      get-nvidia computer_name
	{noformat}
	COMPUTER_NAME: Thu Jul 21 15:30:49 2016
	+------------------------------------------------------+
	| NVIDIA-SMI 353.30     Driver Version: 353.30         |
	|-------------------------------+----------------------+----------------------+
	| GPU  Name            TCC/WDDM | Bus-Id        Disp.A | Volatile Uncorr. ECC |
	| Fan  Temp  Perf  Pwr:Usage/Cap|         Memory-Usage | GPU-Util  Compute M. |
	|===============================+======================+======================|
	|   0  Quadro K5000       WDDM  | 0000:05:00.0      On |                  Off |
	| 30%   35C    P8    16W / 137W |     76MiB /  4096MiB |      0%      Default |
	+-------------------------------+----------------------+----------------------+
	
	+-----------------------------------------------------------------------------+
	| Processes:                                                       GPU Memory |
	|  GPU       PID  Type  Process name                               Usage      |
	|=============================================================================|
	|    0       564  C+G   C:\WINDOWS\system32\csrss.exe                N/A      |
	+-----------------------------------------------------------------------------+
	{noformat}

   .Parameter computerName
    	This parameter can be one host or a list of comma-separated hosts.
   .Inputs
    [string]
   .OutPuts
    [string]
   .Notes
    NAME    : get-nvidia
    AUTHOR  : Andrew VanVoorhis
    LASTEDIT: 3/07/2018
    KEYWORDS: NVIDIA, graphics, quadro, Windows, system, information
#>
    foreach ($pc in $computerName)
    {
        try
        {
            $pc = $pc.Trim() # This is important because Powershell will include spaces and error out
            $nvidiaRept = Invoke-Command -computername $pc { & "C:\Program Files\NVIDIA Corporation\NVSMI\nvidia-smi.exe"} -ErrorAction Stop
            "{noformat}"
            write-host $pc.ToString().ToUpper()"`b: " -NoNewline
            $nvidiaRept # print NVIDIA-SMI output to shell
            "{noformat}`n"
        } catch {
            Write-Host "*** NVIDIA-SMI not available on $pc ***" -ForegroundColor Red
        }
    }
}
