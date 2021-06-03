/* STUDENTS */
/* IVAN MARTINOVIC */
/* HOANG PHAN PHAM */
/* DROP TABLE CODE */
DROP TABLE Occupancy;
DROP TABLE Accesses;
DROP TABLE Examinations;
DROP TABLE Admissions;
DROP TABLE Patients;
DROP TABLE Services;
DROP TABLE Rooms;
DROP TABLE Units;
DROP TABLE Repairs;
DROP TABLE Equipments;
DROP TABLE Technicians;
DROP TABLE Doctors;
DROP TABLE Employees;

/* TASK 1 */
CREATE TABLE Employees (
	ID         	VARCHAR(255) NOT NULL,
	fName    	VARCHAR(30) NOT NULL,
	lName    	VARCHAR(30) NOT NULL,
	title    	VARCHAR(30) NOT NULL,
	salary    	DECIMAL(13, 4),
	officeNum	INTEGER,
	empRank    	VARCHAR(20),
	superID    	VARCHAR(255),
	street    	VARCHAR(30),
	town    	VARCHAR(30),
	zip        	NUMBER(5),
	CONSTRAINT employee_pk PRIMARY KEY (ID),
	CONSTRAINT checkEmpRank
    	CHECK (empRank = 'Regular' OR empRank = 'Division' OR empRank = 'General'),
	CONSTRAINT employee_superID_fk FOREIGN KEY (superID)
    	REFERENCES Employees (ID)
);

CREATE TABLE Doctors (
	ID         	VARCHAR(255) NOT NULL,
	specialty	VARCHAR(30) NOT NULL,
	gender    	VARCHAR(6) NOT NULL,
	school    	VARCHAR(30) NOT NULL,
	CONSTRAINT doctor_id PRIMARY KEY (ID),
	CONSTRAINT regular_doc_emp_ID FOREIGN KEY (ID)
    	REFERENCES Employees(ID),
	CONSTRAINT checkGender CHECK (gender = 'Male' OR gender = 'Female')
);

CREATE TABLE Technicians (
	ID         	VARCHAR(255) NOT NULL,
	CONSTRAINT tech_ID PRIMARY KEY (ID),
	CONSTRAINT regular_tech_emp_ID FOREIGN KEY (ID)
    	REFERENCES Employees(ID)
);

CREATE TABLE Equipments (
	ID         	VARCHAR(255) NOT NULL,
	model    	VARCHAR(255) NOT NULL,
	description VARCHAR(255),
	instruction VARCHAR(255),
	CONSTRAINT equipment_pk PRIMARY KEY (ID)
);

CREATE TABLE Repairs (
	ID         	VARCHAR(255) NOT NULL,
	equipmentID VARCHAR(255) NOT NULL,
	CONSTRAINT repairs_pk PRIMARY KEY (ID,equipmentID),
	CONSTRAINT repairs_fk FOREIGN KEY (ID)
    	REFERENCES Technicians (ID),
	CONSTRAINT equipmentID_fk FOREIGN KEY (equipmentID)
    	REFERENCES Equipments (ID)
);

CREATE TABLE Units (
	ID         	VARCHAR(255) NOT NULL,
	serialNum	VARCHAR(255) NOT NULL,
	roomNum   	INTEGER NOT NULL,
	yearPurch	NUMBER(4) NOT NULL,
	description VARCHAR(255),
	CONSTRAINT unit_pk PRIMARY KEY (serialNum),
	CONSTRAINT unit_fk FOREIGN KEY (ID)
    	REFERENCES Equipments (ID)
);

CREATE TABLE Rooms (
	rNum     	INTEGER NOT NULL,
	occupied	VARCHAR(5),
	CONSTRAINT room_pk PRIMARY KEY (rNum),
CONSTRAINT check_bool CHECK (occupied = 'True' OR occupied = 'False')
);
CREATE TABLE Services (
	rNum    	INTEGER NOT NULL,
	service 	VARCHAR(255) NOT NULL,
	CONSTRAINT service_pk PRIMARY KEY (rNum, service),
	CONSTRAINT service_fk FOREIGN KEY (rNum)
    	REFERENCES Rooms (rNum)
);

CREATE TABLE Patients (
	SSN        	VARCHAR(12) NOT NULL,
	fName    	VARCHAR(30) NOT NULL,
	lName    	VARCHAR(30) NOT NULL,
	street    	VARCHAR(30) NOT NULL,
	town    	VARCHAR(30) NOT NULL,
	zip        	NUMBER(5) NOT NULL,
	CONSTRAINT patient_pk PRIMARY KEY (SSN)
);

CREATE TABLE Admissions (
	ad_date    	TIMESTAMP(6) DEFAULT CURRENT_TIMESTAMP,
	SSN        	VARCHAR(12) NOT NULL,
	leave_date  TIMESTAMP(6),
	payment    	DECIMAL(13, 4),
	insurance	DECIMAL(2, 2),
	appointment	TIMESTAMP(6),
	CONSTRAINT addmission_pk PRIMARY KEY (ad_date, SSN),
	CONSTRAINT addmission_fk FOREIGN KEY (SSN)
    	REFERENCES Patients (SSN)
);

CREATE TABLE Examinations (
	SSN     	VARCHAR(12) NOT NULL,
	ad_date 	TIMESTAMP(6) NOT NULL,
	doctorID 	VARCHAR(255) NOT NULL,
	comments	VARCHAR(255),
    ex_date    	TIMESTAMP(6) DEFAULT CURRENT_TIMESTAMP,

	CONSTRAINT examination_pk PRIMARY KEY (SSN, ad_date, doctorID, ex_date),
	CONSTRAINT examination_fk_ad_date FOREIGN KEY (ad_date, SSN)
    	REFERENCES Admissions (ad_date, SSN),
	CONSTRAINT examination_fk_doctorID FOREIGN KEY (doctorID)
    	REFERENCES Doctors (ID)
);



CREATE TABLE Accesses (
	ID         	VARCHAR(255) NOT NULL,
	rNum     	NUMBER(3) NOT NULL,
	CONSTRAINT access_pk PRIMARY KEY (ID, rNum),
	CONSTRAINT access_id_fk FOREIGN KEY (ID)
    	REFERENCES Employees(ID),
   CONSTRAINT access_rNum_fk FOREIGN KEY (rNum)
	REFERENCES Rooms(rNum)
);


CREATE TABLE Occupancy (
	rNum     	NUMBER(3) NOT NULL,
	SSN     	VARCHAR(11) NOT NULL,
	ad_date 	TIMESTAMP(6) NOT NULL,
	start_date	TIMESTAMP(6) NOT NULL,
	end_date 	TIMESTAMP(6),
	CONSTRAINT occupancy_pk PRIMARY KEY (rNum, SSN, ad_date, start_date),
	CONSTRAINT occupancy_fk_room FOREIGN KEY (rNum)
    	REFERENCES Rooms (rNum),
	CONSTRAINT occupancy_fk_ad_date FOREIGN KEY (ad_date, SSN)
    	REFERENCES Admissions (ad_date, SSN)
);

/* TASK 3 */

/* GENERAL MANAGERS */
INSERT INTO Employees (ID, fName, lName, title, salary, officeNum, empRank, superID, street, town, zip) VALUES(1, 'gen', 'Man1', 'generalManager1', 210, 1, 'General', NULL, 'street1', 'town1', 12345);

INSERT INTO Employees (ID, fName, lName, title, salary, officeNum, empRank, superID, street, town, zip) VALUES(2, 'gen', 'Man2', 'generalManager2', 220, 2, 'General', NULL, 'street2', 'town2', 67890);

/* DIVISION MANAGERS */
INSERT INTO Employees VALUES (11, 'div', 'dMan1', 'DivisionManager1', 200, 11, 'Division', 1, 'street1', 'town1', 12345);

INSERT INTO Employees VALUES (12, 'div', 'dMan2', 'DivisionManager2', 200, 12, 'Division', 1, 'street1', 'town1', 12345);


INSERT INTO Employees VALUES (13, 'div', 'dMan3', 'DivisionManager3', 200, 13, 'Division', 2, 'street1', 'town1', 12345);

INSERT INTO Employees VALUES (14, 'div', 'dMan4', 'DivisionManager4', 200, 14, 'Division', 2, 'street1', 'town1', 12345);

/* REGULAR EMPLOYEES */
/*DOCTORS*/
INSERT INTO Employees (ID, fName, lName, title, salary, officeNum, empRank, superID, street, town, zip) VALUES(111, 'doc', 'tor1', 'doctor', 210, 1, 'Regular' , 11, 'street1', 'town1', 12345);

INSERT INTO Doctors(ID, specialty, gender, school) VALUES (111, 'surgeon', 'Female', 'WPI');
INSERT INTO Employees (ID, fName, lName, title, salary, officeNum, empRank, superID, street, town, zip) VALUES(112, 'doc', 'tor2', 'doctor', 210, 112, 'Regular' , 11, 'street1', 'town2', 12345);
INSERT INTO Doctors(ID, specialty, gender, school) VALUES (112, 'surgeon', 'Male', 'WPI');

INSERT INTO Employees (ID, fName, lName, title, salary, officeNum, empRank, superID, street, town, zip) VALUES(113, 'doc', 'tor3', 'doctor', 210, 113, 'Regular' , 12, 'street1', 'town3', 12345);
INSERT INTO Doctors(ID, specialty, gender, school) VALUES (113, 'dentist', 'Female', 'WPI');

INSERT INTO Employees (ID, fName, lName, title, salary, officeNum, empRank, superID, street, town, zip) VALUES(114, 'doc', 'tor4', 'doctor', 210, 114, 'Regular' , 12, 'street1', 'town4', 12345);
INSERT INTO Doctors(ID, specialty, gender, school) VALUES (114, 'dermatologist', 'Male', 'NYU');


INSERT INTO Employees (ID, fName, lName, title, salary, officeNum, empRank, superID, street, town, zip) VALUES(115, 'doc', 'tor5', 'doctor', 210, 115, 'Regular' , 13, 'street1', 'town5', 12345);
INSERT INTO Doctors(ID, specialty, gender, school) VALUES (115, 'brain surgeon', 'Male', 'NYU');

INSERT INTO Employees (ID, fName, lName, title, salary, officeNum, empRank, superID, street, town, zip) VALUES(116, 'doc', 'tor6', 'doctor', 210, 116, 'Regular' , 13, 'street1', 'town6', 12345);
INSERT INTO Doctors(ID, specialty, gender, school) VALUES (116, 'orthopedic surgeon', 'Male', 'NYU');

/* TECHNICIANS */
INSERT INTO Employees (ID, fName, lName, title, salary, officeNum, empRank, superID, street, town, zip) VALUES(211, 'tech', 'nician1', 'technician', 210, 211, 'Regular' , 12, 'street1', 'town1', 12345);
INSERT INTO Technicians(ID) VALUES(211);

INSERT INTO Employees (ID, fName, lName, title, salary, officeNum, empRank, superID, street, town, zip) VALUES(212, 'tech', 'nician2', 'technician', 210, 212, 'Regular' , 11, 'street1', 'town1', 12345);
INSERT INTO Technicians(ID) VALUES(212);


INSERT INTO Employees (ID, fName, lName, title, salary, officeNum, empRank, superID, street, town, zip) VALUES(213, 'tech', 'nician3', 'technician', 210, 213, 'Regular' , 12, 'street1', 'town1', 12345);
INSERT INTO Technicians(ID) VALUES(213);

INSERT INTO Employees (ID, fName, lName, title, salary, officeNum, empRank, superID, street, town, zip) VALUES(214, 'tech', 'nician4', 'technician', 210, 214, 'Regular' , 13, 'street1', 'town1', 12345);
INSERT INTO Technicians(ID) VALUES(214);


INSERT INTO Employees (ID, fName, lName, title, salary, officeNum, empRank, superID, street, town, zip) VALUES(215, 'tech', 'nician5', 'technician', 210, 215, 'Regular' , 12, 'street1', 'town1', 12345);
INSERT INTO Technicians(ID) VALUES(215);


/*RANDOMS*/
INSERT INTO Employees (ID, fName, lName, title, salary, officeNum, empRank, superID, street, town, zip) VALUES(216, 'ran', 'dom1', 'regular1', 210, 216, 'Regular' , 11, 'street1', 'town1', 12345);

INSERT INTO Employees (ID, fName, lName, title, salary, officeNum, empRank, superID, street, town, zip) VALUES(217, 'ran', 'dom2', 'regular2', 210, 217, 'Regular' , 11, 'street1', 'town1', 12345);

INSERT INTO Employees (ID, fName, lName, title, salary, officeNum, empRank, superID, street, town, zip) VALUES(218, 'ran', 'dom3', 'regular3', 210, 218, 'Regular' , 11, 'street1', 'town1', 12345);

INSERT INTO Employees (ID, fName, lName, title, salary, officeNum, empRank, superID, street, town, zip) VALUES(219, 'ran', 'dom4', 'regular4', 210, 219, 'Regular' , 11, 'street1', 'town1', 12345);

/*PATIENTS*/
INSERT INTO Patients values('111-22-3330', 'patient0', 'last0', 'street1111', 'town1111', 01609);
INSERT INTO Patients values('111-22-3331', 'patient1', 'last1', 'street1111', 'town1111', 01609);
INSERT INTO Patients values('111-22-3332', 'patient2', 'last2', 'street1111', 'town1111', 01609);
INSERT INTO Patients values('111-22-3333', 'patient3', 'last3', 'street1111', 'town1111', 01609);
INSERT INTO Patients values('111-22-3334', 'patient4', 'last4', 'street1111', 'town1111', 01609);
INSERT INTO Patients values('111-22-3335', 'patient5', 'last5', 'street1111', 'town1111', 01609);
INSERT INTO Patients values('111-22-3336', 'patient6', 'last6', 'street1111', 'town1111', 01609);
INSERT INTO Patients values('111-22-3337', 'patient7', 'last7', 'street1111', 'town1111', 01609);
INSERT INTO Patients values('111-22-3338', 'patient8', 'last8', 'street1111', 'town1111', 01609);
INSERT INTO Patients values('111-22-3339', 'patient9', 'last9', 'street1111', 'town1111', 01609);

/*ROOMS*/
INSERT INTO Rooms VALUES(300, NULL);
INSERT INTO Rooms VALUES(301, NULL);
INSERT INTO Rooms VALUES(302, NULL);
INSERT INTO Rooms VALUES(303, NULL);
INSERT INTO Rooms VALUES(304, NULL);
INSERT INTO Rooms VALUES(305, NULL);
INSERT INTO Rooms VALUES(306, NULL);
INSERT INTO Rooms VALUES(307, NULL);
INSERT INTO Rooms VALUES(308, NULL);
INSERT INTO Rooms VALUES(309, NULL);

/*EQUIPMENT TYPES*/
INSERT INTO Equipments VALUES('MRI', 'Amira', 'magnetic resonance imaging', 'instruction1');
INSERT INTO Equipments VALUES('CT', 'Optima 520', 'computed tomography', 'instruction2');
INSERT INTO Equipments VALUES('X-ray', 'AMX', 'x-ray imaging device', 'instruction3');
INSERT INTO Equipments VALUES('PET', 'BEAM', 'Positron Emission Tomography', 'instruction4');
INSERT INTO Equipments VALUES('Ultrasound', 'Condo 3000', 'diagnostic imaging technique', 'instruction5');
INSERT INTO Equipments VALUES('EKG', 'HEART2', 'Electrocardiography', 'instruction6');

/*EQUIPMENT UNITS*/
INSERT INTO Units VALUES('MRI', 'A01-02X', 300, 2000, 'oldest');
INSERT INTO Units VALUES('MRI', 'A02-02X', 301, 2010, 'recent');
INSERT INTO Units VALUES('MRI', 'A03-02X', 302, 2020, 'newest');
INSERT INTO Units VALUES('CT', 'B01-02X', 303, 2010, 'oldest');
INSERT INTO Units VALUES('CT', 'B02-02X', 304, 2010, 'recent');
INSERT INTO Units VALUES('CT', 'B03-02X', 305, 2011, 'newest');
INSERT INTO Units VALUES('X-ray', 'C01-02X', 306, 2000, 'oldest');
INSERT INTO Units VALUES('X-ray', 'C02-02X', 307, 2010, 'recent');
INSERT INTO Units VALUES('X-ray', 'C03-02X', 308, 2020, 'newest');
INSERT INTO Units VALUES('PET', 'D01-02X', 310, 2011, 'newest');
INSERT INTO Units VALUES('PET', 'D02-02X', 311, 2010, 'oldest');
INSERT INTO Units VALUES('Ultrasound', 'E01-02X', 312, 2015, 'newest');
INSERT INTO Units VALUES('EKG', 'F01-02X', 313, 2012, 'newest');
INSERT INTO Units VALUES('EKG', 'F02-02X', 314, 2010, 'oldest');

/*REPAIRS*/
INSERT INTO Repairs VALUES(211, 'MRI');
INSERT INTO Repairs VALUES(213, 'MRI');
INSERT INTO Repairs VALUES(211, 'CT');
INSERT INTO Repairs VALUES(215, 'CT');
INSERT INTO Repairs VALUES(211, 'X-ray');
INSERT INTO Repairs VALUES(212, 'X-ray');
INSERT INTO Repairs VALUES(213, 'X-ray');
INSERT INTO Repairs VALUES(211, 'PET');
INSERT INTO Repairs VALUES(214, 'PET');
INSERT INTO Repairs VALUES(211, 'Ultrasound');
INSERT INTO Repairs VALUES(212, 'EKG');



/*SERVICES*/
INSERT INTO Services VALUES(300, 'Intensive care unit (ICU)');
INSERT INTO Services VALUES(301, 'Consulting room');
INSERT INTO Services VALUES(301, 'Ward room');
INSERT INTO Services VALUES(302, 'Ward room');
INSERT INTO Services VALUES(303, 'Operating room');
INSERT INTO Services VALUES(303, 'Intensive care unit (ICU)');
INSERT INTO Services VALUES(303, 'Emergency room');
INSERT INTO Services VALUES(304, 'Operating room');
INSERT INTO Services VALUES(305, 'Intensive care unit (ICU)');
INSERT INTO Services VALUES(306, 'Consulting room');
INSERT INTO Services VALUES(307, 'Ward room');
INSERT INTO Services VALUES(308, 'Emergency room');
INSERT INTO Services VALUES(309, 'Operating room');
INSERT INTO Services VALUES(309, 'Emergency room');
INSERT INTO Services VALUES(309, 'CT Scan room');
INSERT INTO Services VALUES(309, 'PET Scan room');

/* ADMISSIONS */
INSERT INTO Admissions VALUES (TO_TIMESTAMP('2019-07-02 06:14:00.742000000', 'YYYY-MM-DD HH24:MI:SS.FF'), '111-22-3333', (TO_TIMESTAMP('2019-08-02 06:14:00.742000000', 'YYYY-MM-DD HH24:MI:SS.FF')),
                            	5000, 0.50, TO_TIMESTAMP('2019-09-02 06:14:00.742000000', 'YYYY-MM-DD HH24:MI:SS.FF'));

INSERT INTO Admissions VALUES (TO_TIMESTAMP('2019-09-02 06:14:00.742000000', 'YYYY-MM-DD HH24:MI:SS.FF'), '111-22-3333', (TO_TIMESTAMP('2019-10-02 06:14:00.742000000', 'YYYY-MM-DD HH24:MI:SS.FF')),
                            	5000, 0.50, TO_TIMESTAMP('2019-11-02 06:14:00.742000000', 'YYYY-MM-DD HH24:MI:SS.FF'));

INSERT INTO Admissions VALUES (TO_TIMESTAMP('2021-01-02 06:14:00.742000000', 'YYYY-MM-DD HH24:MI:SS.FF'), '111-22-3333', (TO_TIMESTAMP('2021-01-05 06:14:00.742000000', 'YYYY-MM-DD HH24:MI:SS.FF')),
                            	5000, 0.50, TO_TIMESTAMP('2021-04-02 14:00:00.742000000', 'YYYY-MM-DD HH24:MI:SS.FF'));

INSERT INTO Admissions VALUES (TO_TIMESTAMP('2019-07-02 06:14:00.742000000', 'YYYY-MM-DD HH24:MI:SS.FF'), '111-22-3331', (TO_TIMESTAMP('2019-08-02 06:14:00.742000000', 'YYYY-MM-DD HH24:MI:SS.FF')),
                            	5000, 0.50, TO_TIMESTAMP('2019-09-02 06:14:00.742000000', 'YYYY-MM-DD HH24:MI:SS.FF'));

INSERT INTO Admissions VALUES (TO_TIMESTAMP('2019-09-02 06:14:00.742000000', 'YYYY-MM-DD HH24:MI:SS.FF'), '111-22-3331', (TO_TIMESTAMP('2019-10-02 06:14:00.742000000', 'YYYY-MM-DD HH24:MI:SS.FF')),
                            	5000, 0.50, TO_TIMESTAMP('2019-11-02 06:14:00.742000000', 'YYYY-MM-DD HH24:MI:SS.FF'));

INSERT INTO Admissions VALUES (TO_TIMESTAMP('2019-07-02 06:14:00.742000000', 'YYYY-MM-DD HH24:MI:SS.FF'), '111-22-3332', (TO_TIMESTAMP('2019-08-02 06:14:00.742000000', 'YYYY-MM-DD HH24:MI:SS.FF')),
                            	5000, 0.50, TO_TIMESTAMP('2019-09-02 06:14:00.742000000', 'YYYY-MM-DD HH24:MI:SS.FF'));

INSERT INTO Admissions VALUES (TO_TIMESTAMP('2019-09-02 06:14:00.742000000', 'YYYY-MM-DD HH24:MI:SS.FF'), '111-22-3334', (TO_TIMESTAMP('2019-10-02 06:14:00.742000000', 'YYYY-MM-DD HH24:MI:SS.FF')),
                            	5000, 0.50, TO_TIMESTAMP('2019-11-02 06:14:00.742000000', 'YYYY-MM-DD HH24:MI:SS.FF'));

INSERT INTO Admissions VALUES (TO_TIMESTAMP('2019-07-02 06:14:00.742000000', 'YYYY-MM-DD HH24:MI:SS.FF'), '111-22-3335', (TO_TIMESTAMP('2019-08-02 06:14:00.742000000', 'YYYY-MM-DD HH24:MI:SS.FF')),
                            	5000, 0.50, TO_TIMESTAMP('2019-09-02 06:14:00.742000000', 'YYYY-MM-DD HH24:MI:SS.FF'));

INSERT INTO Admissions VALUES (TO_TIMESTAMP('2019-09-02 06:14:00.742000000', 'YYYY-MM-DD HH24:MI:SS.FF'), '111-22-3335', (TO_TIMESTAMP('2019-10-02 06:14:00.742000000', 'YYYY-MM-DD HH24:MI:SS.FF')),
                            	5000, 0.50, NULL);

/* EXAMINATIONS */
INSERT INTO Examinations VALUES('111-22-3333',
    TO_TIMESTAMP('2019-07-02 06:14:00.742000000', 'YYYY-MM-DD HH24:MI:SS.FF'),
    111, 'No Comment');
INSERT INTO Examinations VALUES('111-22-3333',
    TO_TIMESTAMP('2019-07-02 06:14:00.742000000', 'YYYY-MM-DD HH24:MI:SS.FF'),
    112, 'No Comment');
INSERT INTO Examinations VALUES('111-22-3333',
    TO_TIMESTAMP('2019-09-02 06:14:00.742000000', 'YYYY-MM-DD HH24:MI:SS.FF'),
    111, 'No Comment');
INSERT INTO Examinations VALUES('111-22-3333',
    TO_TIMESTAMP('2019-09-02 06:14:00.742000000', 'YYYY-MM-DD HH24:MI:SS.FF'),
    112, 'No Comment');
INSERT INTO Examinations VALUES('111-22-3333',
    TO_TIMESTAMP('2019-09-02 06:14:00.742000000', 'YYYY-MM-DD HH24:MI:SS.FF'),
    113, 'No Comment');
INSERT INTO Examinations VALUES('111-22-3333',
    TO_TIMESTAMP('2021-01-02 06:14:00.742000000', 'YYYY-MM-DD HH24:MI:SS.FF'),
    111, 'No Comment');
INSERT INTO Examinations VALUES('111-22-3333',
    TO_TIMESTAMP('2021-01-02 06:14:00.742000000', 'YYYY-MM-DD HH24:MI:SS.FF'),
    112, 'No Comment');
INSERT INTO Examinations VALUES('111-22-3331',
    TO_TIMESTAMP('2019-07-02 06:14:00.742000000', 'YYYY-MM-DD HH24:MI:SS.FF'),
    112, 'No Comment');
INSERT INTO Examinations VALUES('111-22-3331',
    TO_TIMESTAMP('2019-09-02 06:14:00.742000000', 'YYYY-MM-DD HH24:MI:SS.FF'),
    112, 'No Comment');
INSERT INTO Examinations VALUES('111-22-3332',
    TO_TIMESTAMP('2019-07-02 06:14:00.742000000', 'YYYY-MM-DD HH24:MI:SS.FF'),
    112, 'No Comment');
INSERT INTO Examinations VALUES('111-22-3334',
    TO_TIMESTAMP('2019-09-02 06:14:00.742000000', 'YYYY-MM-DD HH24:MI:SS.FF'),
    114, 'No Comment');
INSERT INTO Examinations VALUES('111-22-3335',
    TO_TIMESTAMP('2019-07-02 06:14:00.742000000', 'YYYY-MM-DD HH24:MI:SS.FF'),
    114, 'No Comment');
INSERT INTO Examinations VALUES('111-22-3335',
    TO_TIMESTAMP('2019-07-02 06:14:00.742000000', 'YYYY-MM-DD HH24:MI:SS.FF'),
    115, 'No Comment');
INSERT INTO Examinations VALUES('111-22-3335',
    TO_TIMESTAMP('2019-09-02 06:14:00.742000000', 'YYYY-MM-DD HH24:MI:SS.FF'),
    114, 'No Comment');

/* ACCESSES */
INSERT INTO Accesses VALUES (1, 300);
INSERT INTO Accesses VALUES (1, 301);
INSERT INTO Accesses VALUES (1, 302);
INSERT INTO Accesses VALUES (1, 303);
INSERT INTO Accesses VALUES (1, 304);
INSERT INTO Accesses VALUES (1, 305);
INSERT INTO Accesses VALUES (2, 304);
INSERT INTO Accesses VALUES (2, 305);
INSERT INTO Accesses VALUES (2, 306);
INSERT INTO Accesses VALUES (2, 307);
INSERT INTO Accesses VALUES (2, 308);
INSERT INTO Accesses VALUES (2, 309);
INSERT INTO Accesses VALUES (11, 300);
INSERT INTO Accesses VALUES (12, 301);
INSERT INTO Accesses VALUES (13, 302);
INSERT INTO Accesses VALUES (14, 303);
INSERT INTO Accesses VALUES (11, 304);
INSERT INTO Accesses VALUES (12, 305);
INSERT INTO Accesses VALUES (13, 304);
INSERT INTO Accesses VALUES (14, 305);

/* TASK2 */

/* 1) */
SELECT ID, specialty, gender, school
FROM Doctors D
WHERE D.school = 'WPI';

/* 2) */
SELECT ID, e.fname, e.lname, salary
FROM Employees e
WHERE e.superid = 11 AND e.emprank = 'Regular';


/* 3) */
SELECT SSN, SUM(a.insurance*a.payment) AS totalInsurance
FROM Admissions a
GROUP BY SSN;

/* 4) */
SELECT p.ssn, p.fname, p.lname, COUNT(a.ad_date) AS numOfVisits
FROM Admissions a, Patients p
WHERE a.ssn = p.ssn
GROUP BY p.SSN, p.fname, p.lname;

/* 5) */
SELECT u.roomnum
FROM Units u
WHERE u.serialnum = 'A01-02X';

/* 6) */
SELECT id, numOfRooms
FROM (
SELECT a.id,COUNT(a.rnum) AS numOfRooms
 	FROM Accesses a
 	GROUP BY a.id)
	 
WHERE numOfRooms IN

(SELECT MAX(numOfRooms) AS maxRooms
FROM
	(SELECT a.id,COUNT(a.rnum) AS numOfRooms
 	FROM Accesses a
 	GROUP BY a.id)
 	);

/* 7) */
SELECT e.emprank AS Type, COUNT(e.ID) AS Count
FROM Employees e
GROUP BY e.emprank;

/* 8) */
SELECT p.ssn, p.fname, p.lname, a.appointment
FROM Patients p, Admissions a, (SELECT a.ssn, MAX(a.ad_date) AS recent_date
FROM Admissions a
GROUP BY a.ssn)q

WHERE p.ssn = a.ssn AND a.appointment IS NOT NULL AND q.ssn = a.ssn AND a.ad_date = q.recent_date;


/* Q9 */
SELECT equipmentID
FROM Repairs
GROUP BY equipmentID
HAVING COUNT(ID) < 2;

/* Q10 */
SELECT appointment
FROM Admissions
WHERE SSN = '111-22-3333'
AND appointment > CURRENT_TIMESTAMP;

/* Q11 */
SELECT doctorID
FROM Examinations
WHERE SSN = '111-22-3333'
GROUP BY doctorID
HAVING COUNT(SSN) > 2;

/* Q12 */
SELECT ID
FROM Units
WHERE yearPurch = 2010
INTERSECT
SELECT ID
FROM Units
WHERE yearPurch = 2011;

