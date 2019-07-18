<#
.Synopsis
   Update Hosts file on system to add entries needed
.DESCRIPTION
   Update Hosts file on system to add entries needed
.EXAMPLE
   Run script without parameters
.EXAMPLE
   Another example of how to use this cmdlet

    THIS CODE AND ANY ASSOCIATED INFORMATION ARE PROVIDED “AS IS” WITHOUT WARRANTY OF ANY KIND, EITHER EXPRESSED OR 
    IMPLIED, INCLUDING BUT NOT LIMITED TO THE IMPLIED WARRANTIES OF MERCHANTABILITY AND/OR FITNESS FOR A PARTICULAR
    PURPOSE. THE ENTIRE RISK OF USE, INABILITY TO USE, OR RESULTS FROM THE USE OF THIS CODE REMAINS WITH THE USER.
#>



$file = "$env:windir\System32\drivers\etc\hosts"
"erone.cable.comcast.com  147.191.117.131" | Add-Content -PassThru $file
"erone-web.cable.comcast.com  10.146.81.247" | Add-Content -PassThru $file
"eronerpt.cable.comcast.com  147.191.117.132" | Add-Content -PassThru $file