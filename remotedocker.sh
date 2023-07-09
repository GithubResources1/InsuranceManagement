until [[ -f /var/lib/cloud/instance/boot-finished ]]; do

    sleep 1

done

sudo apt-get remove docker docker-engine docker.io
sudo apt-get update
sudo apt-get install apt-transport-https ca-certificates curl software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
sudo apt-get update
sudo apt-get install docker-ce
service docker start
usermod -a -G docker ec2-user
docker run -itd -p 8084:8081 samarthrao/insure-me:3.0
