import { registerPlugin } from '@capacitor/core';

import type { PrincipalPlugin } from './definitions';

const Principal = registerPlugin<PrincipalPlugin>('Principal', {
  web: () => import('./web').then(m => new m.PrincipalWeb()),
});

export * from './definitions';
export { Principal };
