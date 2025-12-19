import { logEvent, createResponse } from '../utils/utils.mjs';

export const handler = async (event) => {
  const id = event.pathParameters?.id;
  const body = JSON.parse(event.body || "{}");

  logEvent("Updating Entity Compliance Status", { id, newStatus: body.entityStatus });

  return createResponse(200, { 
    message: `Entity ${id} record updated successfully`,
    lastUpdated: new Date().toISOString(),
    status: body.entityStatus || "ACTIVE"
  });
};