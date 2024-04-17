/*
 * Author: Amin Abbaspour
 * Date: 2024-04-17
 * License: MIT (https://github.com/abbaspour/auth0-metrics-cloudflare-analytics-engine/blob/master/LICENSE)
 */

const {S3Client, PutObjectCommand} = require("@aws-sdk/client-s3");

const s3Client = new S3Client();

exports.handler = async (event) => {

    const {bucketName, CF_TOKEN, CF_ACCOUNT_ID} = process.env;

    console.log(`uploading to bucket: ${bucketName} results of scanning WAE for CF Account ID: ${CF_ACCOUNT_ID}`);

    // RPS per tenant last 1 hours
    const query = `SELECT toStartOfInterval(timestamp, INTERVAL '1' SECOND) AS ts,
                          index1                                            as tenant,
                          sum(_sample_interval)                             as rps
                   FROM RATE_LIMIT
                   WHERE timestamp > NOW() - INTERVAL '1' HOUR
                   Group by tenant, ts
                   order by ts`;

    const API = `https://api.cloudflare.com/client/v4/accounts/${CF_ACCOUNT_ID}/analytics_engine/sql`;
    const response = await fetch(API, {
        method: 'POST',
        headers: {
            'Authorization': `Bearer ${CF_TOKEN}`,
        },
        body: query,
    });
    const Body = await response.text();

    //console.log(`CF SQL result: ${Body}`);

    // Define parameters for S3 upload
    const params = {
        Bucket: bucketName,
        Key: `rps-per-tenant-${Date.now()}.json`,
        Body
    };

    try {
        // Upload file to S3
        const data = await s3Client.send(new PutObjectCommand(params));
        console.log("File uploaded successfully:", data.Location);

        return {
            statusCode: 200,
            body: JSON.stringify('File uploaded successfully'),
        };
    } catch (error) {
        console.error("Error uploading file:", error);
        return {
            statusCode: 500,
            body: JSON.stringify('Error uploading file'),
        };
    }
};