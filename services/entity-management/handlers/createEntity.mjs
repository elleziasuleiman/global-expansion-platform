import { logEvent, createResponse } from '../utils/utils.mjs';

export const handler = async (event) => {
  logEvent("Initiating Entity Onboarding", { path: event.path });

  try {
    const body = JSON.parse(event.body || "{}");

    if (!body.legalName || !body.jurisdiction) {
      return createResponse(400, { error: "Missing legalName or jurisdiction for onboarding" });
    }

    const entityId = `VISTRA-${Math.floor(Math.random() * 100000)}`;
  
    const entityData = {
      entityId,
      legalName: body.legalName,
      entityType: body.entityType || "Private Limited",
      jurisdiction: body.jurisdiction,
      entityStatus: 'PENDING_KYC', 
      complianceDeadline: new Date(Date.now() + 90 * 24 * 60 * 60 * 1000).toISOString(),
      onboardedBy: "GEP-API-PROD"
    };

    logEvent("Entity validated and prepared for GEP onboarding", { entityId });
    
    return createResponse(201, { 
      message: "Entity successfully queued for onboarding", 
      data: entityData 
    });
  } catch (error) {
    logEvent("GEP Onboarding Error", { error: error.message });
    return createResponse(500, { error: "Internal Server Error during entity creation" });
  }
};