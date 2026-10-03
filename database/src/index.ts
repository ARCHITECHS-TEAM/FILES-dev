import { PrismaPg } from "@prisma/adapter-pg";

export const createAdapter = (connectionString: string) =>
  new PrismaPg({ connectionString });

export * from "../generated/prisma";