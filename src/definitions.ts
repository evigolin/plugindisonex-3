export interface PrincipalPlugin {
  echo(options: { value: string }): Promise<{ value: string }>;
}
