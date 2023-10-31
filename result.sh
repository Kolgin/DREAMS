#!/bin/bash
# Масив
<<<<<<< HEAD
packages=("apache")
=======
packages=("apache" "mariadb" "firewall" "docker")
>>>>>>> feature-2
# Додаємо до масиву пакети, які передані як аргументи при запуску скрипта
packages+=("$@")
# Функція для установки пакетів на вибраному дистрибутиві
install_packages() {
# Визначаємо дистрибутив
distro=$(grep -w ID /etc/os-release | cut -d '=' -f 2 | tr -d '"')
# Через кейс присвоюємо значення, що запускати в залежності від дістробутива
case $distro in
ubuntu)
pkg_manager="apt-get"
#Створюємо пустий масив, куди будемо записувати, які і як встановити пакети
ubuntu_packages=()
#Цикл коли ми вже в системі і знайшли в якій ми системі, ми проходимо for-ом щоб звірити кожен пакет, який передали до скрипту,
# та записати як його встановлювати, бо просто передати змінні і на їх основі встановити пакети неможливо, бо вони не співпадають по назві і між системами
for package in ${packages[@]}; do
#Якщо ми в убунту і вибрали встановити апач
if [ "$pkg_manager" == "apt-get" ] && [ "$package" == "apache" ]; then
#То спершу ми перевіряємо, а чи встановлений апач, в убунту він називається apache2
  local row=$(apt list --installed apache2 -a | grep -w installed | wc -l)
#Якщо ні, то встановлюємо, і в кінці показуємо чи встановився він, а потім вмикаємо (це для завдання "налаштування конфігів")
  if [ $row == 0  ]; then
      ubuntu_packages+=("sudo apt-get install -y apache2 && apt list --installed apache2 -a | grep -w installed")
      ubuntu_packages+=("sudo systemctl enable apache2")
  else
#Якщо так, то оновлюємо, і показуємо що апач оновлений і інфу по кількості актуальних апдейтів якщо є
      ubuntu_packages+=("sudo apt-get upgrade -y apache2 | grep -E 'apache2|upgraded'")
  fi
#Якщо ми в убунту і вибрали встановити mariaDB
elif [ "$pkg_manager" == "apt-get" ] && [ "$package" == "mariaDB" ]; then
#То спершу ми перевіряємо, а чи встановлена mariaDB, в убунту вона називається mariadb-server
  local row=$(apt list --installed mariadb-server -a | grep -w installed | wc -l)
#Якщо ні, то Додаємо джеркало звідки маріадб може встановитися, бо без цього костиля ніяк. Потім встановлюємо, і в кінці показуємо чи встановилася вона, а потім вмикаємо (це для завдання "налаштування конфігів")
  if [ $row == 0  ]; then
      ubuntu_packages+=("sudo add-apt-repository -r 'deb [arch=amd64,arm64,ppc64el] <a href="http://mirror.realcompute.io/mariadb/repo/10.4/ubuntu">http://mirror.realcompute.io/mariadb/repo/10.4/ubuntu</a> bionic main' && sudo apt-get install -y mariadb-server && apt list --installed mariadb-server -a | grep -w installed")
      ubuntu_packages+=("sudo systemctl enable mariadb")
#Якщо так, то оновлюємо, і показуємо що mariaDB оновлена і інфу по кількості актуальних апдейтів якщо є
  else
      ubuntu_packages+=("sudo apt-get upgrade -y mariadb-server | grep -E 'mariadb-server|upgraded'")
  fi
elif [  "$pkg_manager" == "apt-get" ] && [ "$package" == "firewall"  ]; then
  local row=$(apt list --installed ufw -a | grep -w installed | wc -l)
  if [ $row == 0  ]; then
      ubuntu_packages+=("sudo apt-get install -y ufw && apt list --installed ufw -a | grep -w installed")
      ubuntu_packages+=("sudo systemctl enable ufw")
  else
      ubuntu_packages+=("sudo apt-get upgrade -y ufw | grep -E 'ufw|upgraded'")
  fi
elif [  "$pkg_manager" == "apt-get" ] && [ "$package" == "docker"  ]; then
  local row=$(apt list --installed docker -a | grep -w installed | wc -l)
  if [ $row == 0  ]; then
      ubuntu_packages+=("sudo apt-get install -y docker && apt list --installed docker -a | grep -w installed")
      ubuntu_packages+=("sudo systemctl enable docker")
  else
      ubuntu_packages+=("sudo apt-get upgrade -y docker | grep -E 'docker|upgraded'")
  fi
fi
done
#Цикл пробігається по всьому що ми додали попередньо і виконує це, розділюючи кожне виконання рядка розмеженням <---------------------------------------------------->
for sh in "${ubuntu_packages[@]}"; do
eval "$sh"
echo "<---------------------------------------------------->"
done
;;
# Тут теж саме як і в убунту просто є приколи в назвах пакетів, наприклад не apach,  а httpd. І коли докер перевіряєш, то він не докер, а moby-engine.
# Якщо помилитися, то він не проапдейтиться, тільки встановитися може по докеру, і видалитися, апдейтиться по moby-engine і апдейтить все взаєпов'язане оточення.
# Ну і апдейт тут апгрейд, якщо переплутати не запуститься.
fedora)
pkg_manager="dnf"
fedora_packages=()
for package in ${packages[@]}; do
if [ "$pkg_manager" == "dnf" ] && [ "$package" == "apache" ]; then
  local row=$(rpm -q httpd | grep -w 'is not installed'  | wc -l)
    if [ $row == 1  ]; then
        fedora_packages+=("sudo dnf install -y httpd && rpm -q httpd")
        fedora_packages+=("sudo systemctl enable httpd")
    else
        fedora_packages+=("sudo dnf update -y httpd && echo 'httpd'")
    fi
elif [ "$pkg_manager" == "dnf" ] && [ "$package" == "mariaDB" ]; then
  local row=$(rpm -q mariadb-server | grep -w 'is not installed'  | wc -l)
    if [ $row == 1  ]; then
        fedora_packages+=("sudo dnf install -y mariadb-server && rpm -q mariadb-server")
        fedora_packages+=("sudo systemctl enable mariadb")
    else
        fedora_packages+=("sudo dnf update -y mariadb-server && echo 'mariadb-server'")
    fi
elif [  "$pkg_manager" == "dnf" ] && [ "$package" == "firewall"  ]; then
  local row=$(rpm -q firewalld | grep -w 'is not installed'  | wc -l)
    if [ $row == 1  ]; then
        fedora_packages+=("sudo dnf install -y firewalld && rpm -q firewalld")
        fedora_packages+=("sudo systemctl enable firewalld")
    else
        fedora_packages+=("sudo dnf update -y firewalld && echo 'firewall'")
    fi
elif [  "$pkg_manager" == "dnf" ] && [ "$package" == "docker"  ]; then
local row=$(rpm -q docker | grep -w 'is not installed'  | wc -l)
    if [ $row == 1  ]; then
        fedora_packages+=("sudo dnf install -y docker && rpm -q moby-engine")
        fedora_packages+=("sudo systemctl enable docker")
    else
        fedora_packages+=("sudo dnf update -y docker")
    fi
fi
done
for sh in "${fedora_packages[@]}"; do
eval "$sh"
echo "<---------------------------------------------------->"
done
;;
#Тут теж саме, що й fedora, але docker норм інсталиться, видаляється, апдейтиться по слову docker. І апдейт нормальний (не апгрейд)
centos)
pkg_manager="yum"
centos_packages=()
for package in ${packages[@]}; do
if [ "$pkg_manager" == "yum" ] && [ "$package" == "apache" ]; then
  local row=$(rpm -q httpd | grep -w 'is not installed'  | wc -l)
    if [ $row == 1  ]; then
        centos_packages+=("sudo yum install -y httpd && rpm -q httpd")
        centos_packages+=("sudo systemctl enable httpd")
    else
        centos_packages+=("sudo yum update -y httpd && echo 'httpd'")
    fi
elif [ "$pkg_manager" == "yum" ] && [ "$package" == "mariaDB" ]; then
  local row=$(rpm -q mariadb-server | grep -w 'is not installed'  | wc -l)
    if [ $row == 1  ]; then
        centos_packages+=("sudo yum install -y mariadb-server && rpm -q mariadb-server")
        centos_packages+=("sudo systemctl enable mariadb")
    else
        centos_packages+=("sudo yum update -y mariadb-server && echo 'mariadb-server'")
    fi
elif [  "$pkg_manager" == "yum" ] && [ "$package" == "firewall"  ]; then
  local row=$(rpm -q firewalld | grep -w 'is not installed'  | wc -l)
    if [ $row == 1  ]; then
        centos_packages+=("sudo yum install -y firewalld && rpm -q firewalld")
        centos_packages+=("sudo systemctl enable firewalld")
    else
        centos_packages+=("sudo yum update -y firewalld && echo 'firewalld'")
    fi
elif [  "$pkg_manager" == "yum" ] && [ "$package" == "docker"  ]; then
  local row=$(rpm -q docker | grep -w 'is not installed'  | wc -l)
    if [ $row == 1  ]; then
        centos_packages+=("sudo yum install -y docker && rpm -q docker")
        centos_packages+=("sudo systemctl enable docker")
    else
        centos_packages+=("sudo yum update -y docker && echo 'docker'")
    fi
fi
done
for sh in "${centos_packages[@]}"; do
eval "$sh"
echo "<---------------------------------------------------->"
done
;;
*)
echo "Невідомий дистрибутив"
exit 1
;;
esac

}

# Викликаємо функцію для установки пакетів
install_packages
# Пам'ятка для Келеберди Віктора
if [ "$distro" == "ubuntu" ]; then
echo "Перевірка і видалення для ubuntu"
echo "apt list --installed apache2 mariadb-server ufw docker  -a"
echo "sudo apt-get remove apache2 mariadb-server ufw docker  -y"
fi
if [ "$distro" == "fedora" ]; then
echo "Перевірка і видалення для fedora"
echo "sudo rpm -q moby-engine firewalld mariadb-server httpd"
echo "sudo dnf remove httpd mariadb-server firewalld docker  -y"
fi
if [ "$distro" == "centos" ]; then
echo "Перевірка і видалення для centos"
echo "sudo rpm -q docker firewalld mariadb-server httpd"
echo "sudo yum remove httpd mariadb-server firewalld docker  -y"
fi

