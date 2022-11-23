# 最終課題
- 更新：[ブランチ分岐の実装](#追記ブランチ分岐の実装)

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
    > 実装：[ブランチ分岐の実装](#追記ブランチ分岐の実装)
- ACMでssl認証を追加すること

## 追記：ブランチ分岐の実装
- 初めてgitでbranchを分けて環境を構築するようにしました
- <code>config.yml</code>の中のworkflowをdevとprod二つ書きます、そして条件分岐でdevのworkflowをmainブランチにしか走らない、一方、prodのworkflowをreleaseのブランチにしか走らない、という設定です
```
# 本番環境
deploy_prod:
when:
    equal: [ release, << pipeline.git.branch >> ]
jobs:
    # ........

# 開発環境
deploy_dev:
when: 
    equal: [ main, << pipeline.git.branch >> ]
jobs:
    # ........
```
- 流れ：
    - mainで開発環境を構築、commit、pushして、CircleCIではconfigを走る、目標はオールグリーン、あとは手動で環境破壊をapproveする
    - mainのものをreleaseにpush
    - releaseはCircleCI上で本番configを走ります
    - 本番構築完成
- 注意点：
    - 今回はTerraformで構築しているので、backendは必ず本番環境と開発環境を分けなきゃいけないことを心がけてやっています
    - 分けなかった場合は、開発環境を走る際に、本番環境のstateファイルを読み込んで、すべては開発環境の設定に更新されてしまうからです（EC2が破壊されたり）
    - Terraformは一つの環境に一つのstateをするのが一番良いことだと
    - なので今回はbackendはtfファイルの中ではなく、ブランチごとに設定して、<code>Terraform init</code>の際に<code>-backend-config</code>で環境変数を渡すという形です
- 参考：[Terraform Branching Strategy](https://blog.zhenkai.xyz/the-best-git-branching-strategy-for-terraform-is-no-branching/)
- 結果スクショ：
    - <img width="576" alt="image" src="https://user-images.githubusercontent.com/103508472/203536393-7832347d-a527-46dc-9c5f-ed1bb90006f9.png">
        > 同時にdev環境とprod環境を構築

    - <img width="614" alt="image" src="https://user-images.githubusercontent.com/103508472/203536650-8a251529-9fbd-4e8c-a9e4-3a47db2127e3.png">
        > 二つの環境のALB

    - ![image](https://user-images.githubusercontent.com/103508472/203537483-470c5ef7-affa-42e8-859a-c311d8904dbc.png)
        > 二つのALBからアクセスしたアプリ

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
> dev環境のみ
- END
