FROM mcr.microsoft.com/windows/servercore:ltsc2019

LABEL Description="Apache-PHP" Vendor1="Apache Software Foundation" Version1="2.4.55" Vendor2="The PHP Group" Version2="7.4.33"

SHELL ["powershell", "-Command"]

# Download Apache 2.4.55 x86
RUN Invoke-WebRequest -Method Get -Uri https://www.apachehaus.com/downloads/httpd-2.4.55-o111s-x86-vs17.zip -OutFile c:\apache.zip ; \
	Expand-Archive -Path c:\apache.zip -DestinationPath c:\ ; \
	Remove-Item c:\apache.zip -Force

# Download Visual C++ Redist 17
RUN Invoke-WebRequest -Method Get -Uri "https://aka.ms/vs/17/release/vc_redist.x86.exe" -OutFile c:\vc_redist.x64.exe ; \
	start-Process c:\vc_redist.x64.exe -ArgumentList '/quiet' -Wait ; \
	Remove-Item c:\vc_redist.x64.exe -Force

# Download PHP 7.4.33 and rename php.ini-development to php.ini
RUN Invoke-WebRequest -Method Get -Uri https://windows.php.net/downloads/releases/php-7.4.33-Win32-vc15-x86.zip -OutFile c:\php.zip ; \
    Expand-Archive -Path c:\php.zip -DestinationPath c:\php ; \
    Remove-Item c:\php.zip -Force ; \
    Rename-Item -Path "c:\php\php.ini-development" -NewName "php.ini"

# To create C:\www directory
RUN New-Item -Type Directory c:\www -Force ; \
    Add-Content -Value "<?php phpinfo(); ?>" -Path c:\www\index.php

WORKDIR /Apache24/bin

CMD /Apache24/bin/httpd.exe -w