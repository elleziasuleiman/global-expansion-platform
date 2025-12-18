import { logEvent, createResponse } from '../utils/utils.mjs';

export const handler = async (event) => {
  logEvent("Processing Create Entity request", { path: event.path });

  try {
    const body = JSON.parse(event.body || "{}");

    if (!body.name || !body.type) {
      return createResponse(400, { error: "Missing required fields: name and type" });
    }

    logEvent("Entity validated successfully", { entityName: body.name });
    
    return createResponse(201, { 
      message: "Entity created successfully (Mock)", 
      id: Date.now().toString() 
    });
  } catch (error) {
    logEvent("Error creating entity", { error: error.message });
    return createResponse(500, { error: "Internal Server Error" });
  }
};