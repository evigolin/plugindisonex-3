import { WebPlugin } from '@capacitor/core';

import type { PrincipalPlugin } from './definitions';

export class PrincipalWeb extends WebPlugin implements PrincipalPlugin {
  async echo(options: { value: string }): Promise<{ value: string }> {
    console.log('ECHO', options);
    return options;
  }
}
