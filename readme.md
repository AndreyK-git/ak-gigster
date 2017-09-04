# MediaWiki on Kubernetes

1) Clone repo and access directory with kubernetes files
```
git clone https://github.com/AndreyK-git/ak-gigster.git
cd ak-gigster/kubernetes
```
2) Using kubectl and the yaml files, create the kubernetes secrets, volumes, services, and deployments
```
kubectl create -f secrets.wiki.yaml
kubectl create -f vol-wiki.yaml
kubectl create -f svc-wiki.yaml
kubectl create -f deploy-wiki-sql.yaml
kubectl create -f deploy-wiki-web.yaml
```
3) Verify everything was created as expected.
```
kubectl describe deployments
```
4) Launch browser and point it to a kubernetes node followed by port ":30010". Go through mediawiki installation wizard and enter the following when prompted
```
Database host: svc-wiki-sql
Database name: wikidb
Database username: wikiuser
Database password: wikiuser
```
5) After wizard is completed, download LocalSettings.php and copy to /var/www/data/ within your wiki-web pod
```
kubectl cp /Users/andrey.kumanov/Downloads/LocalSettings.php [wiki-web_pod_name]:/var/www/data/LocalSettings.php
```
