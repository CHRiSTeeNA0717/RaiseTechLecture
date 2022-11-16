# lecture12課題

## terraform と CI/CD(CircleCI) の運用

### terraform
- 前の課題で構築した環境をterraformで再現
- 今回は簡単に作りたかったため、moduleではなく、<code>main.tf</code>ファイル一つだけのterraform環境になります
- 過程としてはほとんどcloudformationのコピーだけ
- ただSGの設定は2、3種類くらいあるみたいで、少しじかんかかりましたが、何とかなりました。
> SGの設定はどうしたほうが正解なのかはまだ不明ですが、これからもやりながらって感じです

### circleCI
- <code>config.yml</code>を<code>.circleci</code>のフォルダーの中に作って、編集すれば、[CircleCIのUI](app.circleci.com)のUIで読み込まれて、pipelineを作られます
- はまりポイント：
    - <code>working_directory</code>の設定があいまい
    - <code>checkout</code>をする前にしかできないようで、repoのdirectoryにworking_directoryとして設定できないため、jobごとにcdしないといけない状態です
    > 例：root_dir/terraformをデフォルトにできないので、<code>terraform init</code>する前にcdしないといけない 
    - 解決方法はまだ不明で、今のところはすべてのjobのcommandに先にcdして、実行したいコマンドを行うという感じです