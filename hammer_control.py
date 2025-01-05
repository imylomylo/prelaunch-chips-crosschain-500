import os
import docker
from concurrent.futures import ThreadPoolExecutor
import time
from py_verus_node_rpc.verus_node_rpc import NodeRpc
from dotenv import load_dotenv
load_dotenv(verbose=True)
THIS_NODE_RADDRESS = str(os.environ['THIS_NODE_RADDRESS'])

verusd_rpc_user="userCHANGEME"
verusd_rpc_password="passeCHANGEME"
verusd_rpc_host="127.0.0.1"

# Docker client setup
client = docker.from_env()

# Step 2: Fetch the mapped RPC ports for "instance-" containers
def get_mapped_ports():
    container_ports = {}
    for container in client.containers.list():
        print(container.name)
        if container.name.startswith("verusd.chips_"):
            ports = container.attrs['NetworkSettings']['Ports']
            for port, bindings in ports.items():
                # print(bindings)
                # Check if port 12122/tcp is mapped and has bindings
                if port == "12122/tcp" and bindings:
                    host_port = bindings[0]['HostPort']
                    container_ports[container.name] = host_port
                    #print(f"{host_port} -> {port}")

    return container_ports

# Step 3: Define the task function using RPCClient
def execute_getinfo(container_name, port, executor, future_results):
    print(f"{verusd_rpc_user}:{verusd_rpc_password}@{verusd_rpc_host}:{port}")
    verusd = NodeRpc(verusd_rpc_user, verusd_rpc_password, port, verusd_rpc_host)

    # Execute the initial command
    result = verusd.get_wallet_info()
    #result = verusd.get_info()
    #result = verusd.get_utxos()
    print(result)
    future_results[container_name].append(result)
    result = verusd.z_get_operation_status(result)
    print(f"{container_name} get_info(): {result}")


# Step 3: Define the task function using RPCClient
def execute_sendcurrency(container_name, port, executor, future_results):
    print(f"{verusd_rpc_user}:{verusd_rpc_password}@{verusd_rpc_host}:{port}")
    verusd = NodeRpc(verusd_rpc_user, verusd_rpc_password, port, verusd_rpc_host)

    from_address="*"
    #to_address="RLDmncLM7jom8PrMro5jofGzx3geejFSRh"
    to_address="RGpQB82v6RMcjwYANaj6ee7QjXXu9SGCo7"
    #export_to="vrsctest"
    currency="CHIPS777"
    amount=0.00001777
    tx_params = {}
    tx_params["address"] = to_address
    tx_params["currency"] = currency
    tx_params["amount"] = amount
    tx_params["convertto"] = "VRSCTEST"
    tx_params["via"] = "Bridge.CHIPS777"
    #tx_params["exportto"] = export_to
    # Execute the initial command
    #result = verusd.get_info()
    #print(result)
    print(from_address)
    print([tx_params])
    result = verusd.send_currency(from_address, [tx_params])
    #result = verusd.get_wallet_info()
    #result = verusd.get_balance()
    #result = verusd.get_utxos(THIS_NODE_RADDRESS)
    future_results[container_name].append(result)
    #time.sleep(0.25)
    result = verusd.z_get_operation_status(result)
    print(f"{container_name} send_currency(): {result}")

    # Determine if another command is needed
#    next_command = determine_next_command(result)
#    if next_command:
        # Execute the next command by submitting a new task
#        executor.submit(execute_next_command, container_name, rpc_client, next_command, executor, future_results)

# Function to execute the next command if needed
def execute_next_command(container_name, rpc_client, command, executor, future_results):
    result = rpc_client.send_command(command)
    future_results[container_name].append(result)
    print(f"{container_name} {command}(): {result}")

# Step 4: Define logic to determine if another command is needed
def determine_next_command(result):
    if "specific_condition" in result:  # Example condition
        return "another_rpc_command"
    return None

# Step 5: Control function with ThreadPoolExecutor
def control_containers():
    container_ports = get_mapped_ports()
    future_results = {name: [] for name in container_ports}

    with ThreadPoolExecutor(max_workers=6) as executor:
        # Submit initial commands
        for i in range(555):
        #for i in range(5):
            for container_name, port in container_ports.items():
                executor.submit(execute_sendcurrency, container_name, port, executor, future_results)
                time.sleep(0.05)
                #executor.submit(execute_getinfo, container_name, port, executor, future_results)
            time.sleep(0.25)

# Run control function
if __name__ == "__main__":
    start_time = time.time()
    control_containers()
    print(f"Completed in {time.time() - start_time:.2f} seconds")
