#Configure the Calico Network Plugin
POD_CIDR="172.27.0.0/16"
KVMSG = "Kuberverse"
echo "********** $KVMSG ->> Configuring Kubernetes Cluster Calico Networking"
echo "********** $KVMSG ->> Downloading Calico YAML File"
wget -q https://docs.projectcalico.org/manifests/calico.yaml -O /tmp/calico-default.yaml
#wget -q https://bit.ly/kv-lab-k8s-calico-yaml -O /tmp/calico-default.yaml
sed "s+192.168.0.0/16+$POD_CIDR+g" /tmp/calico-default.yaml > /tmp/calico-defined.yaml
echo "********** $KVMSG ->> Applying Calico YAML File"
echo "********** $KVMSG"
echo "********** $KVMSG"
kubectl apply -f /tmp/calico-defined.yaml
rm /tmp/calico-default.yaml /tmp/calico-defined.yaml