$PHP_VIRTUAL_HOST = "www.$env:BASE_DOMAIN, $env:BASE_DOMAIN"
$PHP_APACHE_ALIAS = "localhost"
if (Test-Path $env:CWD\docker-data\config\container\php\apache2\aliases.txt) {
    $domains = cat docker-data\config\container\php\apache2\aliases.txt
    foreach ($domain in $domains) {
        $domain = $domain.Trim()
        if ($domain -And -Not ($domain.StartsWith('#'))) {
            $PHP_VIRTUAL_HOST = "$PHP_VIRTUAL_HOST, $domain"
            $PHP_APACHE_ALIAS = "$PHP_APACHE_ALIAS $domain"
        }
    }
}

if (-Not (Test-Path $env:CWD\docker-data\config\build\counter.txt)) {
    "0" | Set-Content "$env:CWD\docker-data\config\build\counter.txt"
}

$BUILD_COUNTER = Get-Content "$env:CWD\docker-data\config\build\counter.txt"
$BUILD_COUNTER = [convert]::ToInt32($BUILD_COUNTER, 10)
$BUILD_COUNTER++
$BUILD_COUNTER | Set-Content "$env:CWD\docker-data\config\build\counter.txt"

Write-Host "`nbuilding ..."

cat docker-data\config\build\Dockerfile | `
%{$_ -replace "{{php_version}}", "$env:PHP_VERSION"} | `
%{$_ -replace "{{base_domain}}", "$env:BASE_DOMAIN"} | `
%{$_ -replace "{{php_virtual_host}}", "$PHP_VIRTUAL_HOST"} | `
%{$_ -replace "{{php_apache_alias}}", "$PHP_APACHE_ALIAS"} | `
%{$_ -replace "{{document_root}}", "$env:DOCUMENT_ROOT"} | `
%{$_ -replace "{{environment}}", "$env:ENVIRONMENT"} | `
%{$_ -replace "{{phpmyadmin_restriction}}", "$env:PHPMYADMIN_RESTRICTION"} | `
%{$_ -replace "{{htdocs_folder}}", "$env:HTDOCS_FOLDER"} | Out-File docker-data\config\build\Dockerfile.parsed -Encoding UTF8 -append

Invoke-Expression "& { docker build -t `"$env:PROJECTNAME`:$BUILD_COUNTER`" --squash -f docker-data/config/build/Dockerfile.parsed .} | Out-Null"

Write-Host "`ncleanup ..."
Invoke-Expression "& { del docker-data/config/build/Dockerfile.parsed }"

Write-Host "`nfinished building image `"$env:PROJECTNAME`:$BUILD_COUNTER`""

Write-Host "`n"

exit
