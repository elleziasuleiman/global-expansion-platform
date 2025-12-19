import { logEvent, createResponse } from '../utils/utils.mjs';

export const handler = async () => {
  logEvent("Fetching Global Entity List");
  
  const mockEntities = [
    { id: "V-101", name: "GEP Singapore Holdings Ltd", jurisdiction: "Singapore", status: "ACTIVE" },
    { id: "V-102", name: "Vistra Tech Solutions (HK)", jurisdiction: "Hong Kong", status: "PENDING_KYC" },
    { id: "V-103", name: "Alpha Cayman Partners", jurisdiction: "Cayman Islands", status: "DORMANT" }
  ];

  return createResponse(200, {
    count: mockEntities.length,
    entities: mockEntities
  });
};