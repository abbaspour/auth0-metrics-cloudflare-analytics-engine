exports.handler = async (event) => {
    const { filename } = event; // Assuming the filename is passed in the event

    // Your logic here to use the filename parameter

    return {
        statusCode: 200,
        body: JSON.stringify('File processed successfully'),
    };
};