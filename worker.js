/*
 * Author: Amin Abbaspour
 * Date: 2024-04-12
 * License: MIT
 */

async function handleRequest(request, env) {
    request = new Request(request);
    const url = new URL(request.url);
    url.hostname = env.AUTH0_EDGE_RECORD;
    request.headers.set('cname-api-key', env.CNAME_API_KEY);
    return await fetch(url, request);
}

export default {
    async fetch(request, env, ctx) {
        env.WEATHER.writeDataPoint({
            'blobs': ["Seattle", "USA", "pro_sensor_9000"], // City, State
            'doubles': [25, 0.5],
            'indexes': ["a3cd45"]
        });
        return handleRequest(request, env);
    }
}