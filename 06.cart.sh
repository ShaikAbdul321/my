color="\e[32m"
noclor="\e[0m"
logfile="/tmp/roboshop.log"
app_path="/app"

echo -e "$color Downloading Nodejs repo file$nocolor"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash  &>>${logfile}
echo -e "$color Installing Nodejs server$nocolor"
yum install nodejs -y &>>${logfile}
echo -e "$color Adding user and location$nocolor"
useradd roboshop &>>${logfile}
mkdir ${app_path} &>>${logfile}
cd ${app_path}
echo -e "$color Downloading new app content and dependencies to cart server$nocolor"
curl -O https://roboshop-artifacts.s3.amazonaws.com/cart.zip &>>${logfile}
unzip cart.zip &>>${logfile}
rm -rf cart.zip
npm install &>>${logfile}
echo -e "$color creating cart service file$nocolor"
cp /root/practice-shell/cart.service /etc/systemd/system/cart.service
echo -e "$color Enabling and starting the cart service$nocolor"
systemctl daemon-reload
systemctl enable cart &>>${logfile}
systemctl restart cart
