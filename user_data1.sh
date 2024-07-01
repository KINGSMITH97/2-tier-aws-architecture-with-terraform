#!/bin/bash

# Update the package index
sudo apt-get update

# Install Apache
sudo apt-get install -y apache2

# Start and enable Apache service
sudo systemctl start apache2
sudo systemctl enable apache2

# Create a small web design and replace the default index.html
cat <<EOL > /var/www/html/index.html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Welcome to My Website</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            text-align: center;
            background-color: #f4f4f4;
            margin: 0;
            padding: 0;
        }
        header {
            background-color: #4CAF50;
            color: white;
            padding: 10px 0;
        }
        main {
            padding: 20px;
        }
        footer {
            background-color: #4CAF50;
            color: white;
            padding: 10px 0;
            position: fixed;
            width: 100%;
            bottom: 0;
        }
    </style>
</head>
<body>
    <header>
        <h1>Welcome to SERVER ONE</h1>
    </header>
    <main>
        <p>This is a simple web page served by an Apache server on an Ubuntu machine.</p>
    </main>
    <footer>
        <p>&copy; 2024 My Website</p>
    </footer>
</body>
</html>
EOL

# Set t
