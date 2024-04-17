const { S3Client, PutObjectCommand } = require("@aws-sdk/client-s3");

const s3Client = new S3Client();

exports.handler = async (event) => {

    const { bucketName, fileName, fileContent } = process.env;

    console.log(`uploading to bucket: ${bucketName}`);

    // Define parameters for S3 upload
    const params = {
        Bucket: bucketName,
        Key: `metrics-${Date.now()}.json`,
        Body: `${Date.now()}`
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