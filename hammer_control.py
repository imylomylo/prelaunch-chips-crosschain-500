import docker
from concurrent.futures import ThreadPoolExecutor
import time
from py_verus_node_rpc.verus_node_rpc import NodeRpc

verusd_rpc_user="loveischange"
verusd_rpc_password="changeisgood"
verusd_rpc_host="127.0.0.1"

# Docker client setup
client = docker.from_env()

# Step 2: Fetch the mapped RPC ports for "instance-" containers
def get_mapped_ports():
    container_ports = {}
    for container in client.containers.list():
        if container.name.startswith("instance-"):
            ports = container.attrs['NetworkSettings']['Ports']
            for port, bindings in ports.items():
                if bindings:
                    container_ports[container.name] = bindings[0]['HostPort']
    return container_ports

# Step 3: Define the task function using RPCClient
def execute_command(container_name, port, executor, future_results):
    verusd = NodeRpc(verusd_rpc_user, verusd_rpc_password, port, verusd_rpc_host)

    # Execute the initial command
    result = verusd.get_info()
    future_results[container_name].append(result)
    print(f"{container_name} getinfo(): {result}")

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

    with ThreadPoolExecutor(max_workers=12) as executor:
        # Submit initial commands
        for container_name, port in container_ports.items():
            executor.submit(execute_command, container_name, port, executor, future_results)

# Run control function
if __name__ == "__main__":
    start_time = time.time()
    control_containers()
    print(f"Completed in {time.time() - start_time:.2f} seconds")
