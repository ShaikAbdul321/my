color="\e[32m"
noclor="\e[0m"
logfile="/tmp/roboshop.log"
app_path="/app"

echo -e "$color Installing python server$nocolor"
yum install python36 gcc python3-devel -y &>>${logfile}
echo -e "$color Adding user and location$nocolor"
useradd roboshop &>>${logfile}
mkdir ${app_path} &>>${logfile}
cd ${app_path}
echo -e "$color Downloading new app content and dependencies to payment server$nocolor"
curl -O https://roboshop-artifacts.s3.amazonaws.com/payment.zip &>>${logfile}
unzip payment.zip &>>${logfile}
pip3.6 install -r requirements.txt &>>${logfile}
echo -e "$color creating payment service file$nocolor"
cp /root/practice-shell/payment.service /etc/systemd/system/payment.service
echo -e "$color Enabling and starting the payment service$nocolor"
systemctl daemon-reload
systemctl enable payment &>>${logfile}
systemctl restart payment
