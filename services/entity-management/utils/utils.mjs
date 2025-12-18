export const createResponse = (statusCode, body) => {
  return {
    statusCode,
    headers: {
      "Content-Type": "application/json",
      "Access-Control-Allow-Origin": "*",
      "Access-Control-Allow-Methods": "GET,POST,PUT,DELETE,OPTIONS"
    },
    body: JSON.stringify(body)
  };
};

export const logEvent = (message, data = {}) => {
  console.log(JSON.stringify({
    timestamp: new Date().toISOString(),
    message,
    ...data
  }));
};