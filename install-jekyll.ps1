
function RefreshEnvPath
{
    $env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") `
        + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")
}

#
# Choco
#

Write-Output "Installing Choco"

if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator"))
{
    Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs; exit
}

Invoke-WebRequest https://chocolatey.org/install.ps1 -UseBasicParsing | iex

RefreshEnvPath

#
# Ruby
#

Write-Output "Installing Ruby"

choco install ruby --yes
choco install ruby2.devkit --yes

RefreshEnvPath

#
# Jekyll
#

Write-Output "Installing Jekyll"

gem sources --remove https://rubygems.org/
gem sources -a http://rubygems.org/
gem install jekyll

#
# Jekyll requirements
#

Write-Output "Installing standard jekyll libs/plugins"
gem install bundler
gem install minima
gem install jekyll-feed

RefreshEnvPath

#
# Get --watch to work
#

Write-Output "Installing WDM"

gem install wdm
bundle update

#
# Install S3_Website https://github.com/laurilehmijoki/s3_website
#

Write-Output "Installing s3_website"

gem install s3_website

#
# Run it!
#

Write-Output "Done! Use `jekyll serve` to view your website"

RefreshEnvPath