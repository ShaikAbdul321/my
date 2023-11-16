color="\e[32m"
noclor="\e[0m"
logfile="/tmp/roboshop.log"
app_path="/app"

echo -e "$color Installing maven server$nocolor"
yum install maven -y &>>${logfile}
echo -e "$color Adding user and location$nocolor"
useradd roboshop &>>${logfile}
mkdir ${app_path} &>>${logfile}
cd ${app_path}
echo -e "$color Downloading new app content to shipping server$nocolor"
curl -O https://roboshop-artifacts.s3.amazonaws.com/shipping.zip &>>${logfile}
unzip shipping.zip &>>${logfile}
echo -e "$color Downloading dependencies and builiding application to shipping server$nocolor"
mvn clean package &>>${logfile}
mv target/shipping-1.0.jar shipping.jar &>>${logfile}
echo -e "$color creating shipping service file$nocolor"
cp /root/practice-shell/shipping.service /etc/systemd/system/shipping.service
echo -e "$color Downloading and installing the mysql schema$nocolor"
yum install mysql -y &>>${logfile}
mysql -h mysql-dev.nasreen.cloud -uroot -pRoboShop@1 < ${app_path}/schema/shipping.sql &>>${logfile}
echo -e "$color Enabling and starting the shipping service$nocolor"
systemctl daemon-reload
systemctl enable shipping &>>${logfile}
systemctl restart shipping
