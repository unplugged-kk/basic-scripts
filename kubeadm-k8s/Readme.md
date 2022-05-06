Install 2 servers of Ubuntu either in local / cloud 

Run the master script as sh install_k8smaster.sh in master node
Run the worker script as sh install_k8sworker.sh in worker node

follow the instructions properly , once the join token generated in master node copy it and run on worker node after the worker script completed.

to verify the worker got added or not . run kubernetes get nodes on master it will show the nodes as ready.


