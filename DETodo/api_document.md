## DETodo API Document

### リクエスト

POSTとPUT時はヘッダーに以下を追加して、BodyにJSONのデータを入れる or フォームエンコード

    Content-Type: application/json

### ステータスコード

* 200, 201 -> 成功
* 400 -> パラメータが正しくない, POST時のBodyとContent-Typeが正しくない
* 403 -> セッションで認証されていない (要ログイン)
* 404 -> APIのパスが正しくない
* 500 -> サーバーエラー
* 503 -> サーバーメンテナンス中

### 認証

URI
    
    http://<<Server>>/auth/<<API>>
    
ログイン

    POST /login {user_id:"NEW USER ID or EXIST USER ID"}
    
    -> {_id:"98765efef", user_id:"USER ID"} (create new user if not exist)


### リソース (要ログイン)

URI

    http://<<Server>>/api/<<API>>
    
Todoリスト一覧

    GET /list
    
    -> {lists:[{_id:"123ab", title:"LIST TITLE"}, …]}
    
Todoリスト作成

    POST /list {title:"NEW LIST TITLE"}
    
    -> {_id:"456de", "title:"NEW LIST TITLE"}
    
Todoリスト削除
    
    DELETE /list/<<_id, e.g. 456de>>
    
    -> {} (リスト内のアイテムはすべて削除される)
    
Todoアイテム一覧

    GET /list/<<LIST _id>>/item
    
    -> {items:[{_id:"123ab", title:"TODO ITEM TITLE is HERE", done:true}, …]}
    
Todoアイテム作成

    POST /list/<<LIST _id>>/item {title:"NEW ITEM TITLE", done:false}
    
    -> {_id:"456de", title:"NEW ITEM TITLE", done:false}
    
Todoアイテムアップデート

    PUT /list/<<LIST _id>>/item/<<ITEM _id>> {done: true}
    
    -> {_id:"456de", title:"ITEM TITLE", done:true}
    
Todoアイテム削除

    DELETE /list/<<LIST _id>>/item/<<ITEM _id>>
    
    -> {}
    
    