#!/bin/bash
mkdir /home/hadoop/spark
mkdir /home/hadoop/bash
sudo aws s3 cp s3://mach-big-data-emr-spot/deploy/shiro.ini /etc/zeppelin/conf/ --sse
sudo aws s3 cp s3://mach-big-data-emr-spot/deploy/notebook-authorization.json /etc/zeppelin/conf/
sudo aws s3 cp s3://mach-big-data-emr-spot/deploy/log4j.properties /etc/zeppelin/conf/
sudo aws s3 cp s3://mach-big-data-emr-spot/deploy/repair_base_tables.sh /home/hadoop/bash/repair_base_tables.sh
sudo aws s3 cp s3://mach-big-data-emr-spot/deploy/restart_zeppelin.sh /home/hadoop/bash/restart_zeppelin.sh
sudo aws s3 cp s3://mach-big-data-emr-spot/deploy/repair_base_tables.py /home/hadoop/spark/repair_base_tables.py
sudo aws s3 cp s3://mach-big-data-emr-spot/deploy/post_boot.sh /tmp
sudo aws s3 cp --recursive s3://mach-big-data-notebooks/ /var/lib/zeppelin/notebook/
sudo chmod -R 777 /var/lib/zeppelin/notebook/
sudo sh /tmp/post_boot.sh
(crontab -l 2>/dev/null; echo "0 4 * * * sh /home/hadoop/repair_base_tables.sh") | crontab -
(crontab -l 2>/dev/null; echo "0 4 * * * sh /home/hadoop/bash/restartzeppelin.sh") | crontab -
(crontab -l 2>/dev/null; echo "*/30 * * * * aws s3 sync /var/lib/zeppelin/notebook/ s3://mach-big-data-notebooks/") | crontab -
sudo service crond stop
sudo service crond start
sudo pip install pandas
