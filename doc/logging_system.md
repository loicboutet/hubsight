# Logging System Implementation

## Overview

This document describes the dual logging system implemented in the HubSight application, based on the configuration from the `ideal` project.

## Implementation Details

### Production Environment

The application now uses **ActiveSupport::BroadcastLogger** to simultaneously write logs to two destinations:

1. **STDOUT** - For Docker/Kamal deployments and container orchestration
2. **File** (`log/production.log`) - For persistent storage and web-based log viewing

### Configuration

Location: `config/environments/production.rb`

```ruby
# Log to STDOUT with the current request id as a default log tag.
config.log_tags = [ :request_id ]

# Log to both STDOUT (for Docker) and file (for web interface)
stdout_logger = ActiveSupport::Logger.new(STDOUT)
file_logger = ActiveSupport::Logger.new(Rails.root.join('log', 'production.log'))

# Combine both loggers using broadcast
config.logger = ActiveSupport::BroadcastLogger.new(stdout_logger, file_logger)
config.logger = ActiveSupport::TaggedLogging.new(config.logger)
```

## Benefits

### 1. **Docker/Container Compatibility**
- Logs stream to STDOUT for Docker container logging
- Compatible with Kamal deployment and container orchestration tools
- Allows log aggregation services to capture logs from container output

### 2. **Persistent Storage**
- Logs are saved to `log/production.log` for historical analysis
- Enables building web-based log viewer interfaces
- Provides backup for troubleshooting when container logs are rotated

### 3. **Request Tagging**
- Each log entry is tagged with `request_id`
- Makes it easy to trace all log entries for a specific request
- Improves debugging of distributed transactions

### 4. **No Additional Dependencies**
- Uses built-in Rails functionality (ActiveSupport::BroadcastLogger)
- No external gems required
- Minimal performance overhead

## Log Levels

The log level can be controlled via environment variable:

```bash
RAILS_LOG_LEVEL=debug  # Log everything (use cautiously in production)
RAILS_LOG_LEVEL=info   # Default - standard production logging
RAILS_LOG_LEVEL=warn   # Only warnings and errors
RAILS_LOG_LEVEL=error  # Only errors
```

Default: `info`

## Health Check Filtering

Health check requests to `/up` are silenced to prevent log clutter:

```ruby
config.silence_healthcheck_path = "/up"
```

## Log File Management

### Location
- Production logs: `log/production.log`
- Development logs: `log/development.log`
- Test logs: `log/test.log`

### Rotation
Consider implementing log rotation using:
- **logrotate** on Linux systems
- Custom rake task for application-level rotation
- Cloud storage integration for long-term archival

### Example logrotate configuration:
```
/path/to/hubsight/log/production.log {
    daily
    missingok
    rotate 30
    compress
    delaycompress
    notifempty
    copytruncate
}
```

## Development Environment

The development environment currently uses standard Rails logging (file-based). If dual logging is needed in development, apply the same BroadcastLogger pattern to `config/environments/development.rb`.

## Testing the Configuration

### 1. Verify STDOUT logging:
```bash
rails runner "Rails.logger.info 'Test log entry'"
# Should see output in terminal
```

### 2. Verify file logging:
```bash
rails runner "Rails.logger.info 'Test log entry'"
tail -f log/production.log
# Should see the entry in the file
```

### 3. Verify request tagging:
Make a request to the application and check logs for `request_id` tags.

## Future Enhancements

### Potential Additions:
1. **Web-based Log Viewer**
   - Build admin interface to view/search `log/production.log`
   - Add filtering by request_id, timestamp, severity
   
2. **Log Analytics**
   - Integrate with ELK stack (Elasticsearch, Logstash, Kibana)
   - Send logs to cloud logging services (AWS CloudWatch, etc.)
   
3. **Structured Logging**
   - Consider using JSON formatted logs for better parsing
   - Add custom log tags (user_id, tenant_id, etc.)

4. **Performance Monitoring**
   - Log slow queries and requests
   - Track response times and database query counts

## Comparison with Previous Configuration

### Before:
```ruby
config.log_tags = [ :request_id ]
config.logger   = ActiveSupport::TaggedLogging.logger(STDOUT)
```
- Only logged to STDOUT
- Logs were lost if not captured by container orchestration
- No persistent storage for debugging

### After:
```ruby
config.log_tags = [ :request_id ]

stdout_logger = ActiveSupport::Logger.new(STDOUT)
file_logger = ActiveSupport::Logger.new(Rails.root.join('log', 'production.log'))

config.logger = ActiveSupport::BroadcastLogger.new(stdout_logger, file_logger)
config.logger = ActiveSupport::TaggedLogging.new(config.logger)
```
- Dual output to STDOUT and file
- Persistent storage for historical analysis
- Better for production troubleshooting

## References

- [Rails Logging Guide](https://guides.rubyonrails.org/debugging_rails_applications.html#the-logger)
- [ActiveSupport::BroadcastLogger](https://api.rubyonrails.org/classes/ActiveSupport/BroadcastLogger.html)
- [Tagged Logging](https://api.rubyonrails.org/classes/ActiveSupport/TaggedLogging.html)

---

**Last Updated:** December 1, 2025  
**Author:** Development Team  
**Status:** Implemented in Production
