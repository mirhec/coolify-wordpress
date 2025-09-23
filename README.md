# WordPress Docker with Configurable Upload Limits

A customized WordPress Docker image with configurable PHP upload limits and optimized settings for larger file uploads.

## Features

- 🚀 Based on the official WordPress Docker image
- 📁 Configurable file upload limits via environment variables
- ⚡ Optimized PHP settings for better performance
- 🔧 Runtime configuration without rebuilding the image
- 📋 Custom .htaccess support

## Quick Start

### Using Docker Run

```bash
# Run with default settings (512MB upload limit)
docker run -d \
  --name my-wordpress \
  -p 8080:80 \
  your-wordpress-image

# Run with custom upload limits
docker run -d \
  --name my-wordpress \
  -p 8080:80 \
  -e UPLOAD_MAX_FILESIZE=1G \
  -e POST_MAX_SIZE=1G \
  -e MEMORY_LIMIT=1G \
  your-wordpress-image
```

### Using Docker Compose

Create a `docker-compose.yml` file:

```yaml
version: '3.8'

services:
  wordpress:
    build: .
    ports:
      - "8080:80"
    environment:
      # Database connection
      WORDPRESS_DB_HOST: db:3306
      WORDPRESS_DB_USER: wordpress
      WORDPRESS_DB_PASSWORD: wordpress
      WORDPRESS_DB_NAME: wordpress
      
      # Upload configuration
      UPLOAD_MAX_FILESIZE: 1G
      POST_MAX_SIZE: 1G
      MEMORY_LIMIT: 1G
      MAX_EXECUTION_TIME: 600
      MAX_INPUT_TIME: 600
    volumes:
      - wordpress_data:/var/www/html
    depends_on:
      - db

  db:
    image: mysql:8.0
    environment:
      MYSQL_DATABASE: wordpress
      MYSQL_USER: wordpress
      MYSQL_PASSWORD: wordpress
      MYSQL_ROOT_PASSWORD: rootpassword
    volumes:
      - db_data:/var/lib/mysql

volumes:
  wordpress_data:
  db_data:
```

Then run:

```bash
docker-compose up -d
```

## Configuration Options

### Environment Variables

| Variable | Default | Description |
|----------|---------|-------------|
| `UPLOAD_MAX_FILESIZE` | `512M` | Maximum file upload size |
| `POST_MAX_SIZE` | `512M` | Maximum POST data size (should be >= upload_max_filesize) |
| `MEMORY_LIMIT` | `512M` | PHP memory limit |
| `MAX_EXECUTION_TIME` | `300` | Maximum script execution time in seconds |
| `MAX_INPUT_TIME` | `300` | Maximum input parsing time in seconds |

### Common Size Values

- `2M` - 2 Megabytes
- `64M` - 64 Megabytes
- `512M` - 512 Megabytes (default)
- `1G` - 1 Gigabyte
- `2G` - 2 Gigabytes

### Recommended Settings by Use Case

#### Small Blog/Website
```yaml
environment:
  UPLOAD_MAX_FILESIZE: 64M
  POST_MAX_SIZE: 64M
  MEMORY_LIMIT: 256M
```

#### Media-Heavy Website
```yaml
environment:
  UPLOAD_MAX_FILESIZE: 1G
  POST_MAX_SIZE: 1G
  MEMORY_LIMIT: 1G
  MAX_EXECUTION_TIME: 600
```

#### Enterprise/High-Traffic Site
```yaml
environment:
  UPLOAD_MAX_FILESIZE: 2G
  POST_MAX_SIZE: 2G
  MEMORY_LIMIT: 2G
  MAX_EXECUTION_TIME: 900
  MAX_INPUT_TIME: 900
```

## Building the Image

To build the Docker image yourself:

```bash
# Clone the repository
git clone <your-repo-url>
cd coolify-wordpress

# Build the image
docker build -t my-wordpress .

# Run the container
docker run -d -p 8080:80 my-wordpress
```

## Verification

After starting your container, you can verify the upload limits:

1. **Via WordPress Admin**: 
   - Go to Media → Add New
   - Check the maximum upload file size displayed

2. **Via PHP Info** (temporary):
   - Create a PHP file with `<?php phpinfo(); ?>`
   - Look for `upload_max_filesize`, `post_max_size`, and `memory_limit`

3. **Via Container Logs**:
   ```bash
   docker logs your-container-name
   ```

## Troubleshooting

### Upload Still Limited

If uploads are still limited after configuration:

1. **Check WordPress `wp-config.php`** - Some plugins may override PHP settings
2. **Verify environment variables**:
   ```bash
   docker exec your-container-name env | grep UPLOAD
   ```
3. **Check PHP configuration**:
   ```bash
   docker exec your-container-name cat /usr/local/etc/php/conf.d/uploads.ini
   ```

### Memory Issues

If you encounter memory errors:
- Increase `MEMORY_LIMIT`
- Consider increasing `MAX_EXECUTION_TIME` for large file processing

### Web Server Limits

Note that some reverse proxies (nginx, Apache) may have their own upload limits that need to be configured separately.

## Files Structure

```
├── Dockerfile              # Main Docker configuration
├── custom.htaccess         # Custom Apache configuration
├── coolify.json           # Coolify deployment configuration
└── README.md              # This file
```

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Support

For issues and questions:
- Open an issue on GitHub
- Check WordPress documentation for WordPress-specific problems
- Review Docker logs for container-related issues
