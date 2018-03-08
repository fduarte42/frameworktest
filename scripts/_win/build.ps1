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

Write-Host "`nbuilding Dockerfile ..."
(Get-Content docker-data\config\build\Dockerfile.tpl | `
%{$_ -replace "{{php_version}}", "$env:PHP_VERSION"} | `
%{$_ -replace "{{base_domain}}", "$env:BASE_DOMAIN"} | `
%{$_ -replace "{{php_virtual_host}}", "$PHP_VIRTUAL_HOST"} | `
%{$_ -replace "{{php_apache_alias}}", "$PHP_APACHE_ALIAS"} | `
%{$_ -replace "{{document_root}}", "$env:DOCUMENT_ROOT"} | `
%{$_ -replace "{{environment}}", "$env:ENVIRONMENT"} | `
%{$_ -replace "{{phpmyadmin_restriction}}", "$env:PHPMYADMIN_RESTRICTION"} | `
%{$_ -replace "{{htdocs_folder}}", "$env:HTDOCS_FOLDER"}) -join "`n" | Out-File Dockerfile -Encoding UTF8

Write-Host "`nfinished"

Write-Host "`n"

exit
