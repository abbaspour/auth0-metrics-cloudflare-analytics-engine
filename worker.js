/*
 * Author: Amin Abbaspour
 * Date: 2024-04-12
 * License: MIT (https://github.com/abbaspour/auth0-metrics-cloudflare-analytics-engine/blob/master/LICENSE)
 */

function writeRateLimit(env, path, limit, remaining) {
    console.log(`${env.TENANT}, ${path}, ${limit}, ${remaining}`);
    env.RATE_LIMIT.writeDataPoint({
        'blobs': [env.TENANT],
        'doubles': [limit, remaining],
        'indexes': [path]
    });
}

export default {
    async fetch(request, env, ctx) {
        /*
        */
        request = new Request(request);
        const url = new URL(request.url);
        url.hostname = env.AUTH0_EDGE_RECORD;
        request.headers.set('cname-api-key', env.CNAME_API_KEY);

        const response = await fetch(url, request);

        const ratelimit_remaining = response.headers.get('x-ratelimit-remaining') ?? '0';
        const ratelimit_limit = response.headers.get('x-ratelimit-limit') ?? '0';

        writeRateLimit(env, url.pathname, ratelimit_limit, ratelimit_remaining);

        return response;
    }
}