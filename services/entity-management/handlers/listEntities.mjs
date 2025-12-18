import { logEvent, createResponse } from '../utils/utils.mjs';

export const handler = async () => {
  logEvent("Listing entities");
  return createResponse(200, [{ id: "1", name: "Mock Entity" }]);
};