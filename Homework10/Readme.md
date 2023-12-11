Опис проведення роботи

1. Створюю EC2, встановлює докер, пулемо з гіта докер файли з 9 домашки, запускаю контейнер з pgadmin4 в фоне,
sudo yum install docker
sudo systemctl start docker
sudo yum install git
git clone https://github.com/Kolgin/DREAMS.git
cd DREAMS
sudo docker-compose up --build -d
Перевіряємо, що відкритий 3000 порт і pgadmin4 працює.

2. Створюємо собі репозіторій і в Elastic Container Registry
![image](https://github.com/Kolgin/DREAMS/assets/12258966/cf7c981a-5737-409a-abdf-e5032d1b2e3a)

3. Закидуємо наш локально робочий образ на сховище контейнерів AWS:
aws ecr-public get-login-password --region us-east-1 | docker login --username AWS --password-stdin public.ecr.aws/s8c9n4n6
Просить авторизуватися в AWS, вводимо aws-ключ і aws-секрет ключ, зону, інше пропускаємо.
aws ecr-public get-login-password --region us-east-1 | docker login --username AWS --password-stdin public.ecr.aws/s8c9n4n6  --авторизація
docker build -t dreams .  --Збираємо білд
docker tag dreams-pgadmin4:latest public.ecr.aws/s8c9n4n6/dreams:latest  --відчеплюємо тег зі зібраного білда
docker push public.ecr.aws/s8c9n4n6/dreams:latest  --пушемо відчеплений тег зібраного білда
![image](https://github.com/Kolgin/DREAMS/assets/12258966/5dc5898c-e4b2-4cdf-9ae0-87e45f5ed88c)

4.Створюємо VPC і оточення
![image](https://github.com/Kolgin/DREAMS/assets/12258966/474ec8c3-880c-4f91-94a8-ec684e12444a)

5. Створюємо кластер->architecture->Desire capacity->Network->Auto-assign public Ip-> done
![image](https://github.com/Kolgin/DREAMS/assets/12258966/0630f3b9-3f82-4bb3-998c-743233afdce1)
![image](https://github.com/Kolgin/DREAMS/assets/12258966/4a0910b4-1433-4fe7-a0a1-35b1f22569f2)
![image](https://github.com/Kolgin/DREAMS/assets/12258966/40d8ae2e-d1b6-474b-a234-c080c289bad4)

6. Створюємо new task definition ->my-app-0 -> done
![image](https://github.com/Kolgin/DREAMS/assets/12258966/96085a25-fe13-45de-914d-986aeb8a8498)
![image](https://github.com/Kolgin/DREAMS/assets/12258966/b274233f-e194-4729-aa7a-72d86b0b7b4d)

7. Створюємо сервіс -> Auto scaling -> done
![image](https://github.com/Kolgin/DREAMS/assets/12258966/3468269c-554c-494f-9471-a09ff3e420d7)
![image](https://github.com/Kolgin/DREAMS/assets/12258966/dca3cdaf-351e-472b-8a1c-37b475ce0aaa)
![image](https://github.com/Kolgin/DREAMS/assets/12258966/dd7b7f24-2438-4bb8-83a6-082f9cad7761)

8. Створюємо TASK -> done 
![image](https://github.com/Kolgin/DREAMS/assets/12258966/a6d46dbc-44d1-42c1-b284-72da62732587)
![image](https://github.com/Kolgin/DREAMS/assets/12258966/029cc20b-37a2-4491-bc61-58c18084810d)

9. Тепер в security groups інстансів, які підняв кластер відкриємо 80 порт і бачимо що контейнер працює:
![image](https://github.com/Kolgin/DREAMS/assets/12258966/85bce3b1-0811-4ad7-be87-c6e74de87d73)
![image](https://github.com/Kolgin/DREAMS/assets/12258966/dcd07dda-4875-4855-8568-eaa0822e0d8c)
![image](https://github.com/Kolgin/DREAMS/assets/12258966/da613200-60ab-4d4d-b31d-17da62c26601)

10. Створюємо LOAD BALANCER. Почнемо з того що створимо новий task definition і  кластер:
![image](https://github.com/Kolgin/DREAMS/assets/12258966/6e2d03ac-e2bc-455e-9dcb-61c55b14cda1)
![image](https://github.com/Kolgin/DREAMS/assets/12258966/5233ac51-4c8f-4405-acd6-2813500ef0cf)

11. Тепер створимо сервіс з load balance -> Deployment configuration -> Network:
Але перед цим треба створити лоад балансер. Для цього відправляємось на EC2. І Створимо TARGET GROPS.
![image](https://github.com/Kolgin/DREAMS/assets/12258966/c018e320-98a1-4bbb-81e4-43265e9ee000)
![image](https://github.com/Kolgin/DREAMS/assets/12258966/a0b923d2-2772-48e1-ab8f-16ad3e22c932)
![image](https://github.com/Kolgin/DREAMS/assets/12258966/cc47539f-9fa5-49e9-a2a1-2b4a82655efd)
Ось тут зупиняємося і йдемо створювати load balance
![image](https://github.com/Kolgin/DREAMS/assets/12258966/51baf35f-1797-4c59-b38f-4be4a0b5e787)
TARGET GROPS
![image](https://github.com/Kolgin/DREAMS/assets/12258966/ccea332b-6977-4deb-a9c3-5dd7f24e22ac)

11.2 Ідемо І створюємо Load Balance. Вибираємо в нетворк паблік сабнети. 
![image](https://github.com/Kolgin/DREAMS/assets/12258966/f447adf3-f037-4345-8978-9066c3f37220)
![image](https://github.com/Kolgin/DREAMS/assets/12258966/5db0fa64-127b-4d3c-85bd-b83e20f8a701)
![image](https://github.com/Kolgin/DREAMS/assets/12258966/333873bc-2874-49a7-8f62-4cf13d2c05f7)

11.3 Тепер можемо достворити сервіс кластера balancer і перевірити як сервіс запустив таску:
тут зупинилися
![image](https://github.com/Kolgin/DREAMS/assets/12258966/72cbd128-97a0-4aea-9f91-c28b38f523b5)
і пішли далі
![image](https://github.com/Kolgin/DREAMS/assets/12258966/1de043e5-6b3c-4de3-8dad-f60651d32ef5)
![image](https://github.com/Kolgin/DREAMS/assets/12258966/b0483061-49f6-400a-a093-cff298792340)
![image](https://github.com/Kolgin/DREAMS/assets/12258966/c0c4ae84-57a5-4fee-8918-d8e666e2f6be)
переходимо TASK -> Configuration -> Network bindings -> посилання сокет з 80 портом
![image](https://github.com/Kolgin/DREAMS/assets/12258966/01182611-c802-4ce4-b8a4-8b4868f978cf)
і бачимо що контейнер з застосунком доступний
![image](https://github.com/Kolgin/DREAMS/assets/12258966/2e5553de-d615-4483-b81b-578f256e3e29)




















