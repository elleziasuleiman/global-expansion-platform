import { handler as createHandler } from './handlers/createEntity.mjs';
import { handler as listHandler } from './handlers/listEntities.mjs';
import { handler as getHandler } from './handlers/getEntity.mjs';
import { handler as updateHandler } from './handlers/updateEntity.mjs';
import { handler as deleteHandler } from './handlers/deleteEntity.mjs';
import { createResponse, logEvent } from './utils/utils.mjs';

export const handler = async (event) => {
  const { httpMethod, resource } = event;
  logEvent("Request received", { method: httpMethod, path: resource });

  if (resource === "/entities") {
    if (httpMethod === "POST") return await createHandler(event);
    if (httpMethod === "GET") return await listHandler(event);
  }
  
  if (resource === "/entities/{id}") {
    if (httpMethod === "GET") return await getHandler(event);
    if (httpMethod === "PUT") return await updateHandler(event);
    if (httpMethod === "DELETE") return await deleteHandler(event);
  }

  return createResponse(404, { error: "Route not found" });
};
