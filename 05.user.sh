color="\e[32m"
noclor="\e[0m"
logfile="/tmp/roboshop.log"
app_path="/app"

echo -e "$color Downloading Nodejs repo file$nocolor"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>${logfile}
echo -e "$color Installing Nodejs server$nocolor"
yum install nodejs -y &>>${logfile}
echo -e "$color Adding user and location$nocolor"
useradd roboshop  &>>${logfile}
mkdir ${app_path} &>>${logfile}
cd ${app_path}
echo -e "$color Downloading new app content and dependencies to user server$nocolor"
curl -O https://roboshop-artifacts.s3.amazonaws.com/user.zip  &>>${logfile}
unzip user.zip &>>${logfile}
rm -rf user.zip
npm install  &>>${logfile}
echo -e "$color creating user service file$nocolor"
cp /root/practice-shell/user.service /etc/systemd/system/user.service
echo -e "$color Downloading and installing the mongodb schema$nocolor"
cp /root/practice-shell/mongodb.repo /etc/yum.repos.d/mongodb.repo
yum install mongodb-org-shell -y  &>>${logfile}
mongo --host mongodb-dev.nasreen.cloud <${app_path}/schema/user.js  &>>${logfile}
echo -e "$color Enabling and starting the user service$nocolor"
systemctl daemon-reload
systemctl enable user &>>${logfile}
systemctl restart user
