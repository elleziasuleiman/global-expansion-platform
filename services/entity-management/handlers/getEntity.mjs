import { logEvent, createResponse } from '../utils/utils.mjs';

export const handler = async (event) => {
  const entityId = event.pathParameters?.id;

  logEvent("Fetching Detailed Entity Profile from GEP", { entityId });

  if (!entityId) {
    return createResponse(400, { error: "Entity ID is required" });
  }

  const mockGepEntity = {
    entityId: entityId,
    profile: {
      legalName: "Vistra Technology Solutions (SG) Pte. Ltd.",
      registrationNumber: "202308155H",
      jurisdiction: "Singapore",
      entityType: "Exempt Private Company Limited by Shares",
      incorporationDate: "2023-01-15",
      entityStatus: "ACTIVE", 
    },
    complianceSnapshot: {
      kycStatus: "APPROVED",
      nextAnnualReturnDue: "2024-07-15",
      nextAgmDue: "2024-06-15",
      isInGoodStanding: true
    },
    governance: {
      directorsCount: 3,
      shareholdersCount: 2,
      managedByVistra: true
    },
    metadata: {
      lastSync: new Date().toISOString(),
      sourceSystem: "GEP-CORE-SGP"
    }
  };

  logEvent("Entity profile retrieved successfully", { 
    entityId, 
    legalName: mockGepEntity.profile.legalName 
  });

  return createResponse(200, mockGepEntity);
};