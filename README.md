# nextcloud

專為臺北市教育局校園單一身份驗證設計的 nextcloud，並且解決了官方容器無法重啟的問題！

若要讓系統實際上線服務，請務必修改環境變數，在 docker-compose.yml 檔案中，與網域和密碼相關的所有參數。

* __ORG: xxps__ 務必修改為貴校在 ldap.tp.edu.tw 上的組織代號，例如：meps。
