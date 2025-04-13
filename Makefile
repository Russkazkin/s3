deploy:
	ssh deploy@${HOST} -p ${PORT} 'rm -rf s3 && mkdir s3'
	ssh deploy@${HOST} -p ${PORT} 'mkdir s3/secrets'
	scp -P ${PORT} compose.yml deploy@${HOST}:s3/compose.yml
	scp -P ${PORT} ./docker/secrets/aws_secret_access_key deploy@${HOST}:s3/secrets
	ssh deploy@${HOST} -p ${PORT} 'cd s3 && echo "COMPOSE_PROJECT_NAME=s3" >> .env'
	ssh deploy@${HOST} -p ${PORT} 'cd s3 && docker compose down --remove-orphans'
	ssh deploy@${HOST} -p ${PORT} 'cd s3 && docker compose pull'
	ssh deploy@${HOST} -p ${PORT} 'cd s3 && docker compose up -d'