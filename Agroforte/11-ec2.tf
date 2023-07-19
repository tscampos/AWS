resource "aws_instance" "example" {
  ami           = "ami-0dba2cb6798deb6d8"  # ID da AMI do Linux
  instance_type = "t2.micro"
  key_name      = "ec2-key"

  subnet_id = aws_subnet.public[1].id
  vpc_security_group_ids = [aws_security_group.service_security_group.id]

  user_data = <<-EOF
    #!/bin/bash
    sudo apt-get update -y
    sudo apt install nginx-core -y
    sudo bash -c 'cat << EOF > /var/www/html/index.html
    <!DOCTYPE html>
    <html>
    <head>
        <meta charset="UTF-8">
        <title>Bem-vindos corinthianos!</title>
        <style>
            body {
                width: 35em;
                margin: 0 auto;
                font-family: Tahoma, Verdana, Arial, sans-serif;
            }
        </style>
    </head>
    <body>
        <h1>Bem-vindos ao bando de loucos!</h1>
        <p>Se você está vendo essa tela é porque está decidido a fazer a escolha correta.</p>
        <p>Para mais detalhes, por favor, acesse: <a href="http://www.corinthians.com.br/">Quero ser mais um louco do bando!</a>.<br/>
        Juntos somos mais fortes!</p>
        <p><em>Obrigado!</em></p>
    </body>
    </html>
        EOF'
        sudo service nginx restart
    EOF

    tags = {
        Name = "${var.app_name}-vm-linux"
    }
}
