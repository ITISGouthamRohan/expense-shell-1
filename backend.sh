#!/bin/bash


 source ./common.sh

 check_root

 echo "Please enter DB password:"
 read -s mysql_root_password
 

 dnf module disable nodejs -y &>>$LOGFILE


 dnf module enable nodejs:20 -y &>>$LOGFILE
 

 dnf install nodejs -y &>>$LOGFILE


 #useradd expense 
 #VALIDATE $? "Creating expense user"

 id expense  &>>$LOGFILE
 if [ $? -ne 0 ]
 then
    useradd expense &>>$LOGFILE
    
 else
     echo -e "Expense user already created...$Y SKIPPING $N"
 fi    

 mkdir -p /app &>>$LOGFILE # Here p will check for directory present or not. if it is present it will ignore else will create one.
 

 curl -o /tmp/backend.zip https://expense-builds.s3.us-east-1.amazonaws.com/expense-backend-v2.zip &>>$LOGFILE


 cd /app 
 rm -rf /app/*
 unzip /tmp/backend.zip &>>$LOGFILE
 

 npm install &>>$LOGFILE


 # checl your repo and path
 cp /home/ec2-user/expense-shell-1/backend.service /etc/systemd/system/backend.service &>>$LOGFILE


 systemctl daemon-reload &>>$LOGFILE


 systemctl start backend &>>$LOGFILE
 

 systemctl enable backend &>>$LOGFILE
 

 dnf install mysql -y &>>$LOGFILE
 

 # mysql -h <MYSQL-SERVER-IPADDRESS> -uroot -pExpenseApp@1 < /app/schema/backend.sql

 mysql -h db.itsgouthamrohan.site -uroot -p${mysql_root_password} < /app/schema/backend.sql &>>$LOGFILE
 

 systemctl restart backend &>>$LOGFILE
 

 #sudo cat /app/schema/backend.sql