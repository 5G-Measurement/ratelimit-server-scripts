## STEPS FOR RATELIMIT TESTS

1. Go to Azure portal: Make virtual machine

2. In networking, add firewall rule for 5201 and modify for 443

3. SSH to the machine

4. Setup the server
    ```bash
    sudo yum install -y git && git clone https://github.com/m-lab/ndt-server.git && git clone https://github.com/ahmadhassan997/rawtcp-udp.git && git clone -b main https://github.com/5G-Measurement/ratelimit-server-scripts.git && cd ratelimit-server-scripts && bash ratelimit-server-setup.sh
    ```

5. Do a complete set of tests using run commands

6. Push logs to data branch
    ```bash
    git checkout -b data && git add iperf3logs/ && git commit -m "server logs" && git push origin data
    ```

7. Go to Azure portal again: delete the virtual machine

## Run Commands

1. ### iperf3.9 commands
    iperf-short-server is started during setup
    ```bash
    ./iperf-short-server.sh [ port number ] # 5201 by default
    ./iperf-long-server.sh [ port number ] # to run long iperf
    ```

2. ### faketcp commands (type ctrl+c to terminate)
    ```bash
    ./faketcp-server.sh # to run server
    sudo ./faketcp-client.sh [SERVERNAME] # to run client
    ```

3. ### ndt commands (client visits: http://[IP]/ndt7.html)
    it's already started when setup is run
    ```bash
    ./run-ndt-server.sh # to run server
    ```

## Things to remember
Make sure no processes are running after you complete a test

* To check ports that are listening for connections
    ```bash
    sudo lsof -i -P -n | grep LISTEN
    ```
* To kill a running process
    ```bash
    kill -9 [PID]
    ```

* To check the detached screens sessions
    ```bash
    screen -ls
    ```

* To attach to a detached screen
    ```bash
    screen -r [screen-name]
    ```
* To kill a screen session
    ```bash
    screen -XS [sessionid] quit
    ```