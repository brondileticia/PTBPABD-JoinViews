-- LETÍCIA BRONDI CARVALHEIRO
-- PT3037801

--================================
-- EXERCÍCIO 1: Instrutores e número de seções ministradas
--================================

SELECT 
    i.ID,
    i.name,
    COUNT(t.course_id) AS NumeroSecoes
FROM instructor i
LEFT JOIN teaches t ON i.ID = t.ID
GROUP BY i.ID, i.name
ORDER BY i.ID;

--================================
-- EXERCÍCIO 2: Instrutores e número de seções (com subconsulta escalar)
--================================

SELECT 
    i.ID,
    i.name,
    (SELECT COUNT(*)
     FROM teaches t
     WHERE t.ID = i.ID) AS NumeroSecoes
FROM instructor i
ORDER BY i.ID;

--================================
-- EXERCÍCIO 3: Seções da primavera de 2010 com instrutores
--================================

SELECT 
    s.course_id,
    s.sec_id,
    s.building,
    s.room_number,
    COALESCE(i.name, '-') AS NomeInstrutor
FROM section s
LEFT JOIN teaches t ON 
    s.course_id = t.course_id 
    AND s.sec_id = t.sec_id 
    AND s.semester = t.semester 
    AND s.year = t.year
LEFT JOIN instructor i ON t.ID = i.ID
WHERE s.semester = 'Spring' 
    AND s.year = 2010
ORDER BY s.course_id, s.sec_id, i.name;

--================================
-- EXERCÍCIO 4: Pontos totais por aluno
--================================

-- Criar a tabela grade_points
CREATE TABLE grade_points (
    grade VARCHAR(2) PRIMARY KEY,
    points DECIMAL(3,1) NOT NULL
);

-- Inserir os valores de conversão (conforme especificado)
INSERT INTO grade_points VALUES ('A+', 4.0);
INSERT INTO grade_points VALUES ('A', 3.7);
INSERT INTO grade_points VALUES ('A-', 3.4);
INSERT INTO grade_points VALUES ('B+', 3.1);
INSERT INTO grade_points VALUES ('B', 2.8);
INSERT INTO grade_points VALUES ('B-', 2.5);
INSERT INTO grade_points VALUES ('C+', 2.2);
INSERT INTO grade_points VALUES ('C', 1.9);
INSERT INTO grade_points VALUES ('C-', 1.6);
INSERT INTO grade_points VALUES ('D+', 1.3);
INSERT INTO grade_points VALUES ('D', 1.0);
INSERT INTO grade_points VALUES ('F', 0.0);

-- Pontos totais por aluno
SELECT 
    s.ID,
    s.name,
    SUM(c.credits * gp.points) AS PontosTotais
FROM student s
INNER JOIN takes t ON s.ID = t.ID
INNER JOIN course c ON t.course_id = c.course_id
INNER JOIN grade_points gp ON t.grade = gp.grade
GROUP BY s.ID, s.name
ORDER BY PontosTotais DESC

--================================
-- EXERCÍCIO 5: Criar view
--================================

CREATE VIEW coeficiente_rendimento AS
SELECT 
    s.ID,
    s.name,
    s.dept_name,
    SUM(c.credits * gp.points) AS PontosTotais,
    SUM(c.credits) AS CreditosTotais,
    CAST(SUM(c.credits * gp.points) / SUM(c.credits) AS DECIMAL(3,2)) AS GPA
FROM student s
INNER JOIN takes t ON s.ID = t.ID
INNER JOIN course c ON t.course_id = c.course_id
INNER JOIN grade_points gp ON t.grade = gp.grade
GROUP BY s.ID, s.name, s.dept_name


