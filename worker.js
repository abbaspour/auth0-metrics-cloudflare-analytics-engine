/*
 * Author: Amin Abbaspour
 * Date: 2024-04-12
 * License: MIT (https://github.com/abbaspour/auth0-metrics-cloudflare-analytics-engine/blob/master/LICENSE)
 */

/*
 *  todo 1: consider cf-cache-status in response header
 *  todo 2: try/catch
 */
function writeMetrics(env, path, limit, remaining, took, status) {
    if (limit === undefined || remaining === undefined) return;

    console.log(`${env.TENANT}, ${path}, ${status}, ${took}ms, ${limit}, ${remaining}`);

    env.RATE_LIMIT.writeDataPoint({
        'blobs': [path],
        'doubles': [limit, remaining, took, status],
        'indexes': [env.TENANT]
    });
}

export default {
    async fetch(request, env, ctx) {
        request = new Request(request);
        const url = new URL(request.url);
        url.hostname = env.AUTH0_EDGE_RECORD;
        request.headers.set('cname-api-key', env.CNAME_API_KEY);

        const start = Date.now();
        const response = await fetch(url, request);
        const took = Date.now() - start;

        const ratelimit_remaining = response.headers.get('x-ratelimit-remaining');
        const ratelimit_limit = response.headers.get('x-ratelimit-limit');

        writeMetrics(env, url.pathname, ratelimit_limit, ratelimit_remaining, took, response.status);

        return response;
    }
}