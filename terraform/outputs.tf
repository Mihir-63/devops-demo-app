output "public_ip" {
  description = "Public IP address of the app server"
  value       = aws_instance.app_server.public_ip
}

output "app_url" {
  description = "URL to access the running app"
  value       = "http://${aws_instance.app_server.public_ip}:5000"
}