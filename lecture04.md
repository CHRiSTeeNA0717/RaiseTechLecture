## VPC

## subnet(public & private)

## security group
 - SGはinstanceごとに設定しなきゃいけないようです。

## EC2 (public)
- EC2を作って、connectしてみた
<code>
  PS C:\WINDOWS\system32> ssh -i "C:\Users\roche\OneDrive\桌面\kurisu\RaiseTech_Projects\RaiseTechKP.pem" ec2-user@ec2-18-183-164-179.ap-northeast-1.compute.amazonaws.com
  The authenticity of host 'ec2-18-183-164-179.ap-northeast-1.compute.amazonaws.com (18.183.164.179)' can't be established.
  ECDSA key fingerprint is SHA256:IpQAYNsNB/gq2HGVQU6VZ2IxxgpSoKwgEOac1HWSDSU.
  Are you sure you want to continue connecting (yes/no/[fingerprint])? yes
  Warning: Permanently added 'ec2-18-183-164-179.ap-northeast-1.compute.amazonaws.com,18.183.164.179' (ECDSA) to the list of known hosts.

         __|  __|_  )
         _|  (     /   Amazon Linux 2 AMI
        ___|\___|___|

</code>

- 成功です

## EC2 から MySQL への接続
![image](https://user-images.githubusercontent.com/103508472/182993086-7ca42b62-1595-4c8f-9338-4ed821be235b.png)
