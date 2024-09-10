import os
from dotenv import load_dotenv

# Load environment variables from a .env file
load_dotenv()

def test_wordpress_service(host):
    apache = host.service("apache2")
    assert apache.is_running
    assert apache.is_enabled

def test_wordpress_page(host):
    wordpress_page = host.addr("localhost")
    assert wordpress_page.is_reachable
    assert wordpress_page.port(80).is_reachable

def test_mysql_connection(host):
    # Construct the MySQL command to test the connection
    command = (
        f"mysql -h {os.environ['DB_HOST']} -u {os.environ['DB_USER']} -p{os.environ['DB_PASSWORD']} -e 'SHOW DATABASES;'"
    )
    result = host.run(command)

    # Check if the command succeeded
    assert result.rc == 0, f"Failed to connect to MySQL database: {result.stderr}"

    # Check if the expected database is in the list of databases
    assert os.environ['DB_NAME'] in result.stdout, f"Database '{os.environ['DB_NAME']}' not found in MySQL"
