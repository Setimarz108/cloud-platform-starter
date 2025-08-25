const express = require('express');
const app = express();
const port = process.env.PORT || 3000;

// Middleware for JSON parsing
app.use(express.json());

// Request logging middleware (simple version)
app.use((req, res, next) => {
    console.log(`${new Date().toISOString()} - ${req.method} ${req.path}`);
    next();
});

// Root endpoint - Basic info
app.get('/', (req, res) => {
    res.json({ 
        service: 'Cloud Platform Starter',
        message: 'Infrastructure Automation & SRE Demo',
        timestamp: new Date().toISOString(),
        version: '1.0.0',
        status: 'healthy',
        environment: process.env.NODE_ENV || 'development'
    });
});

// Health check endpoint - Critical for SRE/containers
app.get('/health', (req, res) => {
    const healthData = {
        status: 'healthy',
        timestamp: new Date().toISOString(),
        uptime: process.uptime(),
        memory: {
            used: Math.round(process.memoryUsage().heapUsed / 1024 / 1024),
            total: Math.round(process.memoryUsage().heapTotal / 1024 / 1024),
            unit: 'MB'
        },
        pid: process.pid,
        version: '1.0.0'
    };

    // Simple health logic - in real apps, you'd check database, external services
    const isHealthy = process.uptime() > 5; // Healthy after 5 seconds
    
    if (isHealthy) {
        res.status(200).json(healthData);
    } else {
        res.status(503).json({ ...healthData, status: 'starting' });
    }
});

// Metrics endpoint - For monitoring/observability
app.get('/metrics', (req, res) => {
    res.json({
        timestamp: new Date().toISOString(),
        requests_total: Math.floor(Math.random() * 1000) + 100,
        response_time_avg: Math.floor(Math.random() * 50) + 10,
        active_connections: Math.floor(Math.random() * 20) + 1,
        memory_usage_mb: Math.round(process.memoryUsage().heapUsed / 1024 / 1024),
        cpu_usage_percent: Math.round(Math.random() * 30) + 5
    });
});

// Info endpoint - For troubleshooting
app.get('/info', (req, res) => {
    res.json({
        node_version: process.version,
        platform: process.platform,
        architecture: process.arch,
        memory: process.memoryUsage(),
        uptime: process.uptime(),
        environment: process.env.NODE_ENV || 'development',
        pid: process.pid
    });
});

// Simple error endpoint for testing error handling
app.get('/error', (req, res) => {
    console.error('Intentional error endpoint hit');
    res.status(500).json({ error: 'This is a test error', timestamp: new Date().toISOString() });
});

// 404 handler
app.use((req, res) => {
    res.status(404).json({ 
        error: 'Not Found', 
        path: req.path,
        timestamp: new Date().toISOString()
    });
});

// Error handler
app.use((err, req, res, next) => {
    console.error('Error:', err);
    res.status(500).json({ 
        error: 'Internal Server Error',
        timestamp: new Date().toISOString()
    });
});

// Graceful shutdown handling
process.on('SIGTERM', () => {
    console.log('Received SIGTERM, shutting down gracefully');
    process.exit(0);
});

process.on('SIGINT', () => {
    console.log('Received SIGINT, shutting down gracefully');
    process.exit(0);
});

// Start server
app.listen(port, () => {
    console.log(`🚀 Cloud Platform Starter running on port ${port}`);
    console.log(`📊 Health check: http://localhost:${port}/health`);
    console.log(`📈 Metrics: http://localhost:${port}/metrics`);
});

module.exports = app;