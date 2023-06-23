/** @type {import('next').NextConfig} */
const nextConfig = {
    // 启用增量编译
    experimental: {
        optimizeCss: true, // CSS
        optimizeImages: true, // 图片
        workerThreads: true, // 启用 Worker Threads
        pageEnv: true, // 启用页面环境
        concurrentFeatures: true, // 启用并行编译
    },
}

module.exports = nextConfig
