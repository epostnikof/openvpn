#! /bin/bash
#ВНИМАНИЕ!!! Работать будет при настроенном сервере. Запускать только через sudo. 
# Спрашиваем имя пользователя 
echo "Введите имя пользователя"
read username
#Создадим сертификат клиента
cd /etc/openvpn/easy-rsa
sudo ./easyrsa build-client-full $username nopass
mkdir /etc/openvpn/clients 2>/dev/null #в этом месте создаётся папка для клиента
cd /etc/openvpn/clients # переходим в эту папку
#Создаём папку клиента в домашней директории
mkdir ./$username
#Копируем сертификаты
sudo cp /etc/openvpn/easy-rsa/pki/ca.crt ./$username/
sudo cp /etc/openvpn/easy-rsa/pki/issued/$username.crt ./$username/
sudo cp /etc/openvpn/easy-rsa/pki/private/$username.key ./$username/
#Создаём конфигурационный файл для учётной записи
touch ./$username/$username.conf
#Здесь просто печисляются и добавляются параметры в том парядке, в котором они будут добавлены в файл
echo "client" >> ./$username/$username.conf
echo "dev tun" >> ./$username/$username.conf
echo "proto udp" >> ./$username/$username.conf
echo "remote 18.196.4.122 1194" >> ./$username/$username.conf # при изменении адреса vpn сервера этот параметр нужно изменить
echo "resolv-retry infinite" >> ./$username/$username.conf
echo "persist-key" >> ./$username/$username.conf
echo "persist-tun" >> ./$username/$username.conf
echo "<ca>" >> ./$username/$username.conf
cat ./$username/ca.crt >> ./$username/$username.conf
echo "</ca>" >> ./$username/$username.conf
echo "<cert>" >> ./$username/$username.conf
cat ./$username/$username.crt >> ./$username/$username.conf
echo "</cert>" >> ./$username/$username.conf
echo "<key>" >> ./$username/$username.conf
cat ./$username/$username.key >> ./$username/$username.conf
echo "</key>" >> ./$username/$username.conf
echo "cipher AES-256-CBC" >> ./$username/$username.conf
echo "verb 3" >> ./$username/$username.conf
#Удаляем вставленные сертификаты, оставляя готовый файл
rm ./$username/ca.crt
rm ./$username/$username.crt
rm ./$username/$username.key
