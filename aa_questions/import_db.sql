PRAGMA foreign_keys = ON;

CREATE TABLE users (
    id INTEGER PRIMARY KEY,
    fname TEXT NOT NULL, 
    lname TEXT NOT NULL
);

CREATE TABLE questions (
    id INTEGER PRIMARY KEY,
    title TEXT NOT NULL,
    body TEXT NOT NULL,
    author_id INTEGER NOT NULL,
    FOREIGN KEY (author_id) REFERENCES users(id) 
);

CREATE TABLE question_follows (
    id INTEGER PRIMARY KEY,
    users_id INTEGER NOT NULL,
    questions_id INTEGER NOT NULL,
    FOREIGN KEY (users_id) REFERENCES users(id), 
    FOREIGN KEY (questions_id) REFERENCES questions(id)  
);

CREATE TABLE replies (
    id INTEGER PRIMARY KEY,
    subject_questions_id INTEGER NOT NULL, 
    parent_reply_id INTEGER,
    users_id INTEGER NOT NULL, 
    body TEXT NOT NULL,
    FOREIGN KEY (subject_questions_id) REFERENCES questions(id),
    FOREIGN KEY (parent_reply_id) REFERENCES replies(id),
    FOREIGN KEY (users_id) REFERENCES users(id)
);

CREATE TABLE question_likes (
    id INTEGER PRIMARY KEY,
    users_id INTEGER NOT NULL,
    questions_id INTEGER NOT NULL,
    FOREIGN KEY (users_id) REFERENCES users(id), 
    FOREIGN KEY (questions_id) REFERENCES questions(id) 
);

INSERT INTO
    users (fname, lname)
VALUES 
    ('Shahdi', 'Qurashi'),
    ('Hansaem', 'Kim'),
    ('John', 'Doe');

INSERT INTO     
    questions(title, body, author_id)
VALUES
    ('Algebra', 'x + 2 = 5', 3),
    ('Philosphy', 'What is the meaning of life?', 2),
    ('Question3', 'body of question3?', 2),
    ('Question4', 'body of question4?', 1),
    ('Question5', 'body of question5?', 2);
    
INSERT INTO 
    replies (subject_questions_id, parent_reply_id, users_id, body)
VALUES 
    (1, NULL, 1, 'x = 3'),
    (2, 1, 2, 'Nobody knows');

INSERT INTO 
    question_follows(users_id, questions_id)
    
VALUES
    (1, 2),
    (2, 1);

INSERT INTO
    question_likes(users_id, questions_id)
VALUES
    (1, 1),
    (2, 2);
