CREATE TABLE IF NOT EXISTS "TRANSACTION" (
	"id"	INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
	"id_user"	INTEGER,
	"id_account"	INTEGER NOT NULL,
	"id_account_transfer"	INTEGER,
	"id_transaction_parent"	INTEGER,
	"number_group"	INTEGER,
	"amount"	NUMERIC NOT NULL,
	"description"	TEXT,
	"notes"	TEXT,
	"date"	TEXT NOT NULL,
	"date_finish"	TEXT,
	"transaction_type"	TEXT NOT NULL,
	"repeat_mode"	BLOB,
	"repeat_every"	TEXT,
	"repeat_every_count"	INTEGER,
	"finish_after_repeat"	INTEGER,
	"finish_repeat_mode"	TEXT,
	"monday"	INTEGER NOT NULL DEFAULT 0,
	"tuesday"	INTEGER NOT NULL DEFAULT 0,
	"wednesday"	INTEGER NOT NULL DEFAULT 0,
	"thursday"	INTEGER NOT NULL DEFAULT 0,
	"friday"	INTEGER NOT NULL DEFAULT 0,
	"saturday"	INTEGER NOT NULL DEFAULT 0,
	"sunday"	INTEGER NOT NULL DEFAULT 0,
	"notify_time_type"	INTEGER,
	"notify_times"	INTEGER,
	"status"	TEXT,
	FOREIGN KEY("id_user") REFERENCES "USER"("id"),
	FOREIGN KEY("id_transaction_parent") REFERENCES "ACCOUNT"("id"),
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