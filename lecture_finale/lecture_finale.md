# 最終課題

## 目的：CircleCIでterraformを環境構築して、ansibleでアプリをプロビジョニングする
- 前回の課題でterraformで環境を構築するだけでした
- 今回はansibleを入れて、アプリが動けるように設定をしました
- コードをgithubにプッシュして、circleCIがゼロからアプリのページが開けるようにするまで自動的にやってくれるデプロイです

## 今回のはまりポイント
- CircleCIのworkspaceの引き続きがややこしかった
    - job間にpersist_to_workspaceで前のjobが保存したものを次のjobに使われる機能ですが、cdなどでdirが前後する作業があると違うdirを指定してしまうことが発生しかねないので、すべてのdirを absolute path で指定して、一応問題を回避しました

- Ansibleにterraformが作ったもののIPアドレスなどをどうやって自動的に読み込ませるか
    -　EIPを事前に設定するのもあったが、それはひと手間かかると思います、
        - 解決方法：terraformのoutputはjsonにすることができるし、ansibleはjsonをqueryして、hostなどの追加するmoduleもあるので、そこを活用しました。そのついでに、環境変数も一緒に追加できるので、非常に便利です
    > jinja2のsyntaxで、nginxのconfのtemplateにもec2のIPを注入することも可能
- AnsibleはSSHに引っ掛かりました
    - 単純に key pair の知識不足でした、
        - circleCIの設定にssh private key を追加して、fingerprintをlocalhostの.sshフォルダーに入れて、.pubのようなpublic key のファイルが同じフォルダーに生成されるはずなので、sshするとき、public key を指定すれば良いです
    - 初めてsshするサーバに対して、known host を追加しましょうかというユーザープロンプトが出るので、自動化作業が続けられなくなってしまいます。
        - 解決方法：Ansible config に <code>host key checking</code>をFalseにすることで済みます。もしくはshellでそのhostを.ssh/known_hostsに追加する
        - 参考：[How to ignore ansible SSH authenticity checking?](https://stackoverflow.com/questions/32297456/how-to-ignore-ansible-ssh-authenticity-checking)

## 今回やってなかったこと（今後の自分への課題）
- git branch でdev、prod、stage環境を分岐すること
- ACMでssl認証を追加すること

## CircleCI workflow tl;dr
- terraform
    - validate
    - tflint check
    - plan => persist-workspace: plan.out
    - apply => terraform apply plan.out

- terraform read output
    - terraform output -json > terraform_output.json
    - persist workspace => terraform_output.json

- ansible
    - attach workspace => terraform_output.json
    - playbook
        - read terraform_output.json
        - configure app in ec2 using output data from json (ec2 ip, db password, etc...)

- terraform destroy
- END