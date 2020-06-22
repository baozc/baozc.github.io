# Cannot retrieve speedtest configuration ERROR: <urlopen error [SSL: CERTIFICATE_VERIFY_FAILED] **certificate verify failed** (_ssl.c:726)>

固定

TL; DR：
运行：
export PYTHONHTTPSVERIFY=0

说明：
即使您使用HTTP，LB也将重定向到HTTPS：
... Location: https://www.speedtest.net/speedtest-config.php [following] Spider mode enabled. Check if remote file exists. --2019-01-22 19:11:45-- https://www.speedtest.net/speedtest-config.php Connecting to www.speedtest.net|151.101.2.219|:443... connected. ERROR: cannot verify www.speedtest.net's certificate, issued by 'CN=GlobalSign CloudSSL CA - SHA256 - G3,O=GlobalSign nv-sa,C=BE': Unable to locally verify the issuer's authority. To connect to www.speedtest.net insecurely, use --no-check-certificate'. ...

您可以通过运行以下命令来关闭证书验证：
export PYTHONHTTPSVERIFY=0

问题可以解决

30 270 135
