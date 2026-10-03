## Database Setup

> **Local development only.** These steps set up a personal database on your own machine.

### 1. Install PostgreSQL

Download and install PostgreSQL from https://www.postgresql.org/download/. During installation, take note of the **password** and **port** you set (the default port is `5432`).

### 2. Add PostgreSQL to your PATH (Windows)

1. Open Settings and search for "Edit the system environment variables".
2. Under System Properties > Advanced, click **Environment Variables**.
3. Under System variables, select **Path** and click **Edit**.
4. Click **New** and add your PostgreSQL `bin` folder, e.g. `C:\Program Files\PostgreSQL\18\bin` (replace `18` with the version you installed).
5. Click OK on all dialogs, then **close and reopen** any open terminals and your code editor.

### 3. Create the database

Open cmd and run:

```
psql -U postgres
```

Enter the password you set during installation, then run:

```sql
CREATE DATABASE files_dev;
\q
```

If you see `'psql' is not recognized`, the PATH step didn't apply yet. Reopen your terminal (or restart your PC) and try again.

### 4. Configure your `.env`

Copy `.env.example` to a new file named `.env` in the **root of the repository** (one level above `apps/` and `database/`). Prisma and the backend both read this single file.

```
DATABASE_URL="postgresql://USERNAME:PASSWORD@localhost:PORT/files_dev"
```

- `USERNAME` is `postgres` by default.
- `PORT` is `5432` by default.
- If your password contains special characters, URL-encode them (e.g. `@` becomes `%40`, `#` becomes `%23`, `/` becomes `%2F`, `:` becomes `%3A`).

`.env` is git-ignored, so your credentials stay on your machine.

### 5. Install dependencies and create the tables

Run these from the **repository root**, in order:

```
npm install
npm run migrate:deploy -w database
npm run build -w database
```

- `npm install` installs every workspace (apps and database) in one go. Run it first so the project's pinned Prisma version is used. Running `npx prisma` without it may download a different, incompatible version.
- `migrate:deploy` deploys the database tables according to the migration history.`.
- `build` generates the Prisma client and compiles the `database` package. The backend needs this before it can start.

### 6. Run the backend

From the repository root:

```
npm run start:dev -w apps/backend
```

When you see `Nest application successfully started`, the backend is listening on `http://localhost:3000`. Check it by opening `http://localhost:3000/users/1` after seeding (see below). A user JSON means the database connection works.

### Seeding and resetting (optional)

From the repository root:

- `npm run db-seed -w database` seeds the tables with sample rows. Seed before creating users through the API, since users need an existing role.
- `npm run db-reset -w database` **truncates and deletes every row** in the database. Use with caution, and only against your local database.
- `npm run db-refresh -w database` runs `db-reset` and then `db-seed`. Same caution applies.

### Troubleshooting

- **`connection refused` / can't reach database:** make sure the PostgreSQL service is running (Windows Services > `postgresql-x64-XX` > Start).
- **`password authentication failed`:** double-check the password in your `DATABASE_URL`, including URL-encoding of special characters.
- **`database "files_dev" does not exist`:** redo step 3.
- **`Cannot find module '@files-system/database'`:** run `npm install` and then `npm run build -w database` from the root.
- **Backend says `DATABASE_URL` is missing:** check that `.env` is in the repository root, not inside `apps/backend` or `database`.
- **`EADDRINUSE: address already in use :::3000`:** another process is using the port. Close the old terminal running the backend, or set `PORT=3001` in `.env`.
- **`Missing engine binaries`:** some machines may skip the script installs. When Prisma looks for these, run `npm install-scripts ls` from the root and simply approve all packages.