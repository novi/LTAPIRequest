## DETodo Server

`detodo-server` がAPIサーバーで、`test-server-node` がiOS側アプリテスト用のモックAPIサーバーです。
Node.js と MongoDB が必要となりますので、実行するには先にインストールして起動しておいてください。
OS X 環境へは、それぞれ、Homebrew または MacPorts で簡単にインストールできます。

実行するには

    $ cd detodo-server or test-server-node
    $ npm install
    $ node app

とします。

デフォルトではどちらも localhost:3000 を使うので同時には立ち上げられません。セッションストレージはオンメモリなので、Nodeを再起動するとクリアされます。
(要再ログイン)

また、サーバサイドのテストを実行するには

    $ npm install -g mocha
    
で、 Mocha.js をインストールして、

    $ cd detodo-server
    $ npm install should
    $ mocha

とします。(`detodo-server` をあらかじめ立ち上げておいてください)

モックサーバーである `test-server-node` は app.js のみで構成されています。今回必要なAPIを実装して、
固定のJSONを返すようになっています。
また、UIのデバッグ用にHTTPレスポンスを返すのを数秒遅らせています。

少しいじって、タイムアウトさせる(レスポンスを返さない)シミュレーションをしてもいいかもしれません。

