/** @type {import('next').NextConfig} */
const nextConfig = {
    // 启用增量编译
    experimental: {
        optimizeCss: true, // CSS
        workerThreads: true, // 启用 Worker Threads
        pageEnv: true, // 启用页面环境
        cpus: 1
    },
}

module.exports = nextConfig
