    1 curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64 --завнтажуємо мінікуб
    2  sudo install minikube-linux-amd64 /usr/local/bin/minikube -- розпаковуємо мінікуб
    3  rm minikube-linux-amd64 --чистимо за собою
    4  minikube start --driver=docker --запускаємо, але докера нема
    5  sudo apt-get install -y apt-transport-https gnupg curl  
    6  curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key --keyring /usr/share/keyrings/kubernetes-archive-keyring.gpg add -
    7  echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list > /dev/null
    12  sudo apt-get update
    13  sudo apt-get install -y kubectl
    15  kubectl create namespace niglocker-prod
    16  kubectl create secret generic mysql-secret   --namespace=niglocker-prod   --from-literal=root_password=tree   --from-literal=password=PAssport   --from-literal=mysql_user=admin
    17  nano nginx-pod.yaml
![image](https://github.com/Kolgin/DREAMS/assets/12258966/cf5a304b-c71d-45d4-8b2d-4c7b743b1f3c)
    18  nano mysql-pod.yaml
![image](https://github.com/Kolgin/DREAMS/assets/12258966/fa8b34d8-1ffa-401f-bf04-5731fed65fac)
    22  kubectl apply -f nginx-pod.yaml
    23  kubectl apply -f mysql-pod.yaml 
    24  kubectl get pods -n niglocker-prod
    25  kubectl exec -it mysql-pod -n niglocker-prod -- /bin/bash
    mysql -u admin -p
![image](https://github.com/Kolgin/DREAMS/assets/12258966/8ce4dbda-dfee-4fde-9172-28c69df97eee)
    show databases;
![image](https://github.com/Kolgin/DREAMS/assets/12258966/6832afe9-d765-46f1-9844-acead546a4a2)
