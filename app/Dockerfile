# multi stage build for optimization
FROM node:18-alpine AS builder

# Set working directory
WORKDIR /usr/src/app

# Copy package files first (Docker layer caching optimization)
COPY package*.json ./

# Install dependencies
RUN npm ci --only=production && npm cache clean --force

# Production stage
FROM node:18-alpine AS production

# Create app directory
WORKDIR /usr/src/app

# Create non-root user for security
RUN addgroup -g 1001 -S nodejs && \
    adduser -S nodejs -u 1001

    # Copy dependencies from builder stage
    COPY --from=builder /usr/src/app/node_modules ./node_modules

    # Copy application code
    COPY --chown=nodejs:nodejs . .

    # Switch to non-root user
    USER nodejs

    # Expose port
    EXPOSE 3000

    # Add health check (Docker native)
    HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
        CMD node -e "const http = require('http'); \
	        const options = { hostname: 'localhost', port: 3000, path: '/health', timeout: 2000 }; \
		        const req = http.request(options, (res) => { \
			            if (res.statusCode === 200) process.exit(0); \
				                else process.exit(1); \
						        }); \
							        req.on('error', () => process.exit(1)); \
								        req.on('timeout', () => process.exit(1)); \
									        req.end();"

										# Start application
										CMD ["npm", "start"]
