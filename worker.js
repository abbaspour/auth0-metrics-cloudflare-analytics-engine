addEventListener('fetch', event => {
    event.respondWith(handleRequest(event.request));
})

async function handleRequest(request) {
    request = new Request(request);
    const url = new URL(request.url);
    url.hostname = `${AUTH0_EDGE_RECORD}`;
    request.headers.set('cname-api-key', `${CNAME_API_KEY}`);
    return await fetch(url, request);
}