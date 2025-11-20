CREATE TABLE atendimento (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    nome TEXT NOT NULL,
    data TEXT NOT NULL,
    criado_em TEXT DEFAULT (datatime('now', 'localtime')),
    descricao TEXT,
    status INT,
    foto TEXT
);

