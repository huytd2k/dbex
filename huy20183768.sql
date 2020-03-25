CREATE DATABASE EducationDB;
GO


USE EducationDB;

CREATE TABLE student (
	student_id CHAR(8) PRIMARY KEY NOT NULL,
	first_name VARCHAR(20) NOT NULL,
	last_name VARCHAR(20) NOT NULL,
	dob DATE NOT NULL,
	gender char(1) NOT NULL CHECK (gender = 'F' OR gender = 'M'),
	address VARCHAR(30),
	note TEXT,
	clazz_id CHAR(8),
);
GO

CREATE TABLE subject (
	subject_id CHAR(6) PRIMARY KEY NOT NULL,
	name VARCHAR(30) NOT NULL,
	credit INT NOT NULL CHECK (1<= credit AND credit <=5),
	percentage_final INT NOT NULL CHECK(0 <= percentage_final AND percentage_final <= 100),
);
GO

CREATE TABLE lecturer (
	lecturer_id CHAR(5) PRIMARY KEY NOT NULL,
	first_name VARCHAR(20) NOT NULL,
	last_name VARCHAR(20) NOT NULL,
	dob DATE NOT NULL,
	gender CHAR(1) CHECK (gender = 'F' OR gender = 'M'),
	address VARCHAR(30),
	email VARCHAR(40)
);
GO

CREATE TABLE teaching (
	subject_id CHAR(6) NOT NULL,
	lecturer_id CHAR(5) NOT NULL,

	CONSTRAINT fk1_teaching
		FOREIGN KEY(subject_id)
		REFERENCES subject (subject_id),
	CONSTRAINT fk2_teaching
		FOREIGN KEY(lecturer_id)
		REFERENCES lecturer(lecturer_id),
	CONSTRAINT pk_teaching
		PRIMARY KEY(subject_id,lecturer_id),
);
GO

CREATE TABLE grade (
	code VARCHAR(30) PRIMARY KEY CHECK (code in ('A','B','C','D','E','F')),
	from_score DECIMAL(3,1) NOT NULL CHECK(0<= from_score and from_score<= 10),
	to_score DECIMAL(3,1) NOT NULL CHECK(0<= to_score and to_score<= 10)
);
GO

CREATE TABLE clazz (
	clazz_id CHAR(8) PRIMARY KEY NOT NULL,
	name VARCHAR(20),
	lecturer_id CHAR(5),
	monitor_id CHAR(8),

	CONSTRAINT fk1_clazz
		FOREIGN KEY (lecturer_id)
		REFERENCES lecturer(lecturer_id),
	CONSTRAINT fk2_clazz
		FOREIGN KEY (monitor_id)
		REFERENCES student(student_id),
);
GO

CREATE TABLE enrollment(
	student_id CHAR(8) NOT NULL,
	subject_id CHAR(8) NOT NULL,
	sesmester CHAR(5) NOT NULL,
	midterm_score DECIMAL CHECK (0 <= midterm_score AND midterm_score <= 10 AND (midterm_score % 0.5 = 0)),
	final_score DECIMAL CHECK (0 <= final_score AND final_score <= 10 AND (final_score % 0.5 = 0)),

	CONSTRAINT pk_enrollment
		PRIMARY KEY (student_id,subject_id,sesmester),
);
GO