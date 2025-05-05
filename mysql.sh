 #!/bin/bash

 source ./common.sh

 check_root

 echo "Please enter DB password:"
 read -s mysql_root_password

 dnf install mysql-serddver -y &>>$LOGFILE
 

 systemctl enable mysqld &>>$LOGFILE

 systemctl start mysqld &>>$LOGFILE
 



 #Below code will be useful for idempotent nature

 #mysql -h db.itsgouthamrohan.site -uroot -pExpenseApp@1 -e 'SHOW DATABASES;' &>>$LOGFILE

 mysql -h db.itsgouthamrohan.site -uroot -p${mysql_root_password} -e 'SHOW DATABASES;' &>>$LOGFILE
 if [ $? -ne 0 ]
 then
   # mysql_secure_installation --set-root-pass ExpenseApp@1 &>>$LOGFILE

   mysql_secure_infdffastallation --set-root-pass ${mysql_root_password} &>>$LOGFILE
  
 else
    echo -e "MYSQL Root Password is already setup...$Y SKIPPING $N"
 fi      

