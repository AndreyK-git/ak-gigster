# MediaWiki on Kubernetes

1) Clone repo and access directory with kubernetes files
```
git clone https://github.com/AndreyK-git/k8-mediawiki.git
cd k8-mediawiki/kubernetes
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
### Optional - install cluster monitoring

6) Install visibility and monitoring using heapster, grafana, and influxdb
```
kubectl create -f monitor/
```
7) Verify services are up and running
```
kubectl get pods --namespace=kube-system
kubectl get services --namespace=kube-system
```
8) Login to grafana by pointing browser to kubernetes node, followed by port listed from the services output in previous step.
9) At the top left left-click on the grafana icon and left-click "Sign In"
```
Username: admin
Password: admin
```
10) Left-click on the grafana icon again and left-click on "Data Sources". In the middle there should be an influxdb datasource box, left-click on it
11) A pre-populated form will pop up, scroll down and select "Save & Test" (it may take a few minutes after creating the deployments before influxdb is ready to be paired with grafana)
12) Return to the grafana dashboards and select "Cluster" or "Pods" to see the metrics as pods get created or destroyed
