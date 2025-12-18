import { logEvent, createResponse } from '../utils/utils.mjs';

export const handler = async (event) => {
  const id = event.pathParameters?.id;
  logEvent("Get entity", { id });
  return id ? createResponse(200, { id, name: "Mock Entity" }) : createResponse(400, { error: "ID missing" });
};