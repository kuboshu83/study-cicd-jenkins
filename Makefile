start:
	@docker compose up -d
	@echo "gitbucket is running at localhost:8081"
	@echo "jenkins is running at localhost:8082"
stop:
	@docker compose down
	@echo "stop gitbucket"
	@echo "stop jenkins"