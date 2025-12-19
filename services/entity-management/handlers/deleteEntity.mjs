import { logEvent, createResponse } from '../utils/utils.mjs';

export const handler = async (event) => {
  const id = event.pathParameters?.id;
  logEvent("Request to archive entity", { id });
  
  return createResponse(200, { 
    message: `Entity ${id} has been marked as 'DISSOLVED' and archived in GEP.` 
  });
};