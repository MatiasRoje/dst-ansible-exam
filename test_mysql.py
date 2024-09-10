def test_mysql_service(host):
    mysql = host.service("mysql")
    assert mysql.is_running
    assert mysql.is_enabled
