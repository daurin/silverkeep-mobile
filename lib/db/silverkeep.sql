CREATE TABLE IF NOT EXISTS "TRANSACTION" (
	"id"	INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
	"id_user"	INTEGER NOT NULL,
	"id_account"	INTEGER NOT NULL,
	"id_account_transfer"	BLOB,
	"amount"	NUMERIC NOT NULL,
	"notes"	TEXT,
	"date"	TEXT NOT NULL,
	"date_finish"	TEXT,
	"transaction_type"	TEXT NOT NULL,
	"repeat_mode"	TEXT,
	"repeat_every"	TEXT,
	"repeat_count"	INTEGER,
	"monday"	INTEGER NOT NULL DEFAULT 0,
	"tuesday"	INTEGER NOT NULL DEFAULT 0,
	"wednesday"	INTEGER NOT NULL DEFAULT 0,
	"thursday"	INTEGER NOT NULL DEFAULT 0,
	"friday"	INTEGER NOT NULL DEFAULT 0,
	"saturday"	INTEGER NOT NULL DEFAULT 0,
	"sunday"	INTEGER NOT NULL DEFAULT 0,
	"notify_time_type"	INTEGER,
	"notify_times"	INTEGER,
	FOREIGN KEY("id_user") REFERENCES "USER"("id"),
	FOREIGN KEY("id_account") REFERENCES "ACCOUNT"("id")
);
CREATE TABLE IF NOT EXISTS "LABEL" (
	"id"	INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
	"name"	TEXT NOT NULL,
	"type"	TEXT,
	"color"	TEXT NOT NULL DEFAULT 'predetermined',
	"order_custom"	INTEGER
);
CREATE TABLE IF NOT EXISTS "ACCOUNT" (
	"id"	INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
	"id_user"	INTEGER,
	"name"	TEXT,
	"color"	TEXT,
	"order_custom"	INTEGER DEFAULT 0,
	FOREIGN KEY("id_user") REFERENCES "USER"("id")
);
CREATE TABLE IF NOT EXISTS "USER" (
	"id"	INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
	"first_name"	TEXT,
	"last_name"	TEXT,
	"email"	TEXT,
	"password"	TEXT
);
CREATE TABLE IF NOT EXISTS "BUDGET" (
	"id"	INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
	"description"	TEXT
);
CREATE TABLE IF NOT EXISTS "TRANSACTION_LABEL" (
	"id_transaction"	INTEGER NOT NULL,
	"id_label"	INTEGER NOT NULL,
	FOREIGN KEY("id_transaction") REFERENCES "TRANSACTION_LABEL"("id"),
	FOREIGN KEY("id_label") REFERENCES "LABEL"("id")
);
INSERT INTO "USER" ("id","first_name","last_name","email","password") VALUES (1,NULL,NULL,NULL,NULL),
 (2,'Invitado',NULL,NULL,NULL);
