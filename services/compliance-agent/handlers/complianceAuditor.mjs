import { logEvent, createResponse } from '../utils/utils.mjs';

export const calculateDeadlines = (jurisdiction, incDate) => {
  switch (jurisdiction) {
    case 'Singapore':
      return { task: 'Annual Return (AR)', dueInDays: 210 };
    case 'Hong Kong':
      return { task: 'Annual Return (NAR1)', dueInDays: 42 };
    case 'BVI':
    case 'Cayman Islands':
      return { task: 'Annual Fee Payment', dueInDays: 30 };
    default:
      return { task: 'General Compliance Review', dueInDays: 90 };
  }
};

export const handler = async (event) => {
  logEvent('Compliance auditor triggered', { source: event.source || event['detail-type'] || 'scheduled' });

   const sampleEntities = [
    { entityId: 'ent-1', jurisdiction: 'Singapore', incDate: '2023-01-15' },
    { entityId: 'ent-2', jurisdiction: 'Hong Kong', incDate: '2022-08-01' },
    { entityId: 'ent-3', jurisdiction: 'BVI', incDate: '2020-05-20' }
  ];

  const results = sampleEntities.map(e => ({
    entityId: e.entityId,
    jurisdiction: e.jurisdiction,
    ...calculateDeadlines(e.jurisdiction, e.incDate)
  }));

  logEvent('Compliance scan results sample', { results });
  return createResponse(200, { message: 'Compliance scan completed.', results });
};
