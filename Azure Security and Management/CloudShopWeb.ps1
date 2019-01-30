Configuration CloudShopWeb
{
    Node "WebServer" 
    {
	    # Install the IIS role 
	    WindowsFeature IIS 
	    { 
		    Ensure          = "Present" 
		    Name            = "Web-Server" 
	    } 
	    # Install the ASP .NET 4.5 role 
	    WindowsFeature AspNet45 
	    { 
		    Ensure          = "Present" 
		    Name            = "Web-Asp-Net45" 
	    } 
 
	    Script DeployWebPackage
	    {
		    GetScript = {@{Result = "DeployWebPackage"}}
		    TestScript = {
                if((Test-Path "C:\inetpub\wwwroot\Global.asax") -eq $true)
                {
                    return $true
                }
                else
                {
                    return $false
                }
            }
		    SetScript ={
			    [system.io.directory]:: CreateDirectory("C:\WebApp")
			    $dest = "C:\WebApp\Site.zip" 
                Remove-Item -path "C:\inetpub\wwwroot" -Force -Recurse -ErrorAction SilentlyContinue
			    Invoke-WebRequest "http://opsgilityweb.blob.core.windows.net/20160217course-azure-iaas-arm/cloudshop.zip" -OutFile $dest
			    Add-Type -assembly "system.io.compression.filesystem"
			    [io.compression.zipfile]:: ExtractToDirectory($dest, "C:\inetpub\wwwroot")
		    }
		    DependsOn  = "[WindowsFeature]IIS"
	    }
    }
}