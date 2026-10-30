// modules/lambda/src/index.js
exports.handler = async (event) => {
  return {
    statusCode: 200,
    headers: {
        "Content-Type": "application/json"
    },
    body: JSON.stringify({
        message: "Lambda executada com sucesso!",
        receivedEvent: event
    }),
  };
};
