$servers = @("opticor.sytes.net", "opticor.ddns.net")

$ports = @(8080, 8080)
$users = @("prooxy", "prooxy")
$connect = $true

if (Get-Command "ssh" -errorAction SilentlyContinue)
{
    for ($i=0; $i -lt $servers.Length; $i++)
    {
        $server = $servers[$i]
        $port = $ports[$i]
        $user = $users[$i]
        if ((tnc $server -p $port -InformationLevel Quiet) -and ($connect)) {
            echo " "
            echo " "
            echo " "
            echo " "
            echo " "
            echo "[+] Server found, starting proxy"
            Set-ItemProperty -Path "Registry::HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings" ProxyEnable -value 1
            Set-ItemProperty -Path "Registry::HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings" MigrateProxy -value 1
            Set-ItemProperty -Path "Registry::HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings" ProxyHttp1.1 -value 0
            Set-ItemProperty -Path "Registry::HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings" ProxyOverride -value "<local>"
            Set-ItemProperty -Path "Registry::HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings" ProxyServer -value "socks=127.0.0.1:$port"
            Set-ItemProperty -Path "Registry::HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings" ProxyEnable -value 1
            echo "[+] Connecting..."
            echo " "
            echo " "
            ssh -D $port $user@$server -p $port
            break
        }
    }
} else {
    echo "[!] SSH NOT FOUND!"
    sleep -s 2;
}
echo " "
echo " "
echo " "
echo " "
echo " "
echo " "
echo "[*] Server not found, disabling prooxy"
Set-ItemProperty -Path "Registry::HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings" ProxyEnable -value 0
sleep -s 2;
