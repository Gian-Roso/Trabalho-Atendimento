CREATE TABLE atendimento (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    nome TEXT NOT NULL,
    nome_cliente TEXT,
    data TEXT NOT NULL,
    criado_em TEXT DEFAULT (datetime('now', 'localtime')),
    descricao TEXT,
    status INTEGER,
    foto TEXT,
    foto_finalizacao TEXT
);