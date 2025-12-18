import { logEvent, createResponse } from '../utils/utils.mjs';

export const handler = async (event) => {
  const id = event.pathParameters?.id;
  logEvent("Delete entity", { id });
  return createResponse(200, { message: `Entity ${id} deleted` });
};