import { handler as complianceHandler } from './handlers/complianceAuditor.mjs';

export const handler = async (event) => {
  return await complianceHandler(event);
};
