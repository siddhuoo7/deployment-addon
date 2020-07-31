while true
echo "Please select an option :"
service=('message-service' 'rpp-connector-service' 'payment-service' 'payment-response-service' 'transform-service' 'traditional-message-service')
do
# Parent menu items declared here
select item in watch restart scale clear_db Quit
do

# case statement to compare the first menu items
case $item in
watch)
echo "Enter the namespace : "  
read ns  
watch kubectl get pods -n $ns
;;
restart | scale)
for i in "${service[@]}"
do
   : 
echo "Do you wish to $item $i?"
select yn in "Yes" "No"; do
case $yn in
Yes )
if [ scale == $item ] 
then 
echo "Number of replicas needed : "  
read replica 
a="--replicas=$replica"
b=""
echo 
else
a=""
b="rollout"
fi  
kubectl $b $item $a deploy $i
break;;
No ) 
break;;

esac
done
done
break
;;
clear_db)
echo 'Truncating MongoDb'
kubectl -n mongo exec -it pod/mongodb-standalone-0 -- /bin/bash -ec 'mongo DBNAME<<"FOO"
use admin
db.auth("admin", "Ecssupport09")
use messages;
db.message.remove({})
db.countMetrics.remove({})
db.countHourMetrics.remove({})
db.getCollectionNames().forEach(function(collName) { 
    db.runCommand({dropIndexes: collName, index: "*"});
});
use payments;
db.getCollectionNames().forEach(function(collName) { 
    db.runCommand({dropIndexes: collName, index: "*"});
});
db.payment.remove({})
use rpp-messages;
db.getCollectionNames().forEach(function(collName) { 
    db.runCommand({dropIndexes: collName, index: "*"});
});
db.message.remove({})
FOO
'
echo 'Truncating Postgres database'
postgres=( $(kubectl get pods | grep postgres | awk '{print $1}'))
kubectl exec -it $postgres -- /bin/bash -ec  ' psql -d pymtresp -U  postgres <<"FOO"
SELECT count(*) from payment;
SELECT count(*) from response;
TRUNCATE TABLE message,message_properties,response,payment RESTART IDENTITY;
SELECT count(*) from payment;
SELECT count(*) from response;
FOO
'
break # return to current (main) menu
;;
Quit)
# return from the script
break 2
esac
done
done
