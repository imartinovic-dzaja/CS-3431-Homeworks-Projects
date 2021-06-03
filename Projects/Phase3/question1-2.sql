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


CREATE TABLE Employees (
    ID             VARCHAR(255) NOT NULL,
    fName        VARCHAR(30) NOT NULL,
    lName        VARCHAR(30) NOT NULL,
    title        VARCHAR(30) NOT NULL,
    salary        DECIMAL(13, 4),
    officeNum    INTEGER,
    empRank        VARCHAR(20),
    superID        VARCHAR(255),
    street        VARCHAR(30),
    town        VARCHAR(30),
    zip            NUMBER(5),
    CONSTRAINT employee_pk PRIMARY KEY (ID),
    CONSTRAINT checkEmpRank
        CHECK (empRank = 'Regular' OR empRank = 'Division' OR empRank = 'General'),
    CONSTRAINT employee_superID_fk FOREIGN KEY (superID)
        REFERENCES Employees (ID)
);

CREATE TABLE Doctors (
    ID             VARCHAR(255) NOT NULL,
    specialty    VARCHAR(30) NOT NULL,
    gender        VARCHAR(6) NOT NULL,
    school        VARCHAR(30) NOT NULL,
    CONSTRAINT doctor_id PRIMARY KEY (ID),
    CONSTRAINT regular_doc_emp_ID FOREIGN KEY (ID)
        REFERENCES Employees(ID),
    CONSTRAINT checkGender CHECK (gender = 'Male' OR gender = 'Female')
);

CREATE TABLE Technicians (
    ID             VARCHAR(255) NOT NULL,
    CONSTRAINT tech_ID PRIMARY KEY (ID),
    CONSTRAINT regular_tech_emp_ID FOREIGN KEY (ID)
        REFERENCES Employees(ID)
);

CREATE TABLE Equipments (
    ID             VARCHAR(255) NOT NULL,
    model        VARCHAR(255) NOT NULL,
    description VARCHAR(255),
    instruction VARCHAR(255),
    CONSTRAINT equipment_pk PRIMARY KEY (ID)
);

CREATE TABLE Repairs (
    ID             VARCHAR(255) NOT NULL,
    equipmentID VARCHAR(255) NOT NULL,
    CONSTRAINT repairs_pk PRIMARY KEY (ID,equipmentID),
    CONSTRAINT repairs_fk FOREIGN KEY (ID)
        REFERENCES Technicians (ID),
    CONSTRAINT equipmentID_fk FOREIGN KEY (equipmentID)
        REFERENCES Equipments (ID)
);

CREATE TABLE Units (
    ID             VARCHAR(255) NOT NULL,
    serialNum    VARCHAR(255) NOT NULL,
    roomNum       INTEGER NOT NULL,
    yearPurch    NUMBER(4) NOT NULL,
    description VARCHAR(255),
    inspection_date  TIMESTAMP(6) DEFAULT SYSDATE,
    CONSTRAINT unit_pk PRIMARY KEY (serialNum),
    CONSTRAINT unit_fk FOREIGN KEY (ID)
        REFERENCES Equipments (ID)
);

CREATE TABLE Rooms (
    rNum         INTEGER NOT NULL,
    occupied    VARCHAR(5),
    CONSTRAINT room_pk PRIMARY KEY (rNum),
CONSTRAINT check_bool CHECK (occupied = 'True' OR occupied = 'False')
);


CREATE TABLE Services (
    rNum        INTEGER NOT NULL,
    service     VARCHAR(255) NOT NULL,
    CONSTRAINT service_pk PRIMARY KEY (rNum, service),
    CONSTRAINT service_fk FOREIGN KEY (rNum)
        REFERENCES Rooms (rNum)
);

CREATE TABLE Patients (
    SSN            VARCHAR(12) NOT NULL,
    fName        VARCHAR(30) NOT NULL,
    lName        VARCHAR(30) NOT NULL,
    street        VARCHAR(30) NOT NULL,
    town        VARCHAR(30) NOT NULL,
    zip            NUMBER(5) NOT NULL,
    CONSTRAINT patient_pk PRIMARY KEY (SSN)
);

CREATE TABLE Admissions (
    ad_date        TIMESTAMP(6) DEFAULT CURRENT_TIMESTAMP,
    SSN            VARCHAR(12) NOT NULL,
    leave_date  TIMESTAMP(6) DEFAULT NULL,
    payment        DECIMAL(13, 4),
    insurance    DECIMAL(2, 2),
    appointment    TIMESTAMP(6),
    admission_id INTEGER UNIQUE NOT NULL,
    CONSTRAINT addmission_pk PRIMARY KEY (ad_date, SSN),
    CONSTRAINT addmission_fk FOREIGN KEY (SSN)
        REFERENCES Patients (SSN)
);

CREATE TABLE Examinations (
    SSN         VARCHAR(12) NOT NULL,
    ad_date     TIMESTAMP(6) NOT NULL,
    doctorID    VARCHAR(255) NOT NULL,
    comments    VARCHAR(255),
    ex_date     TIMESTAMP(6) DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT examination_pk PRIMARY KEY (SSN, ad_date, doctorID, ex_date),
    CONSTRAINT examination_fk_ad_date FOREIGN KEY (ad_date, SSN)
        REFERENCES Admissions (ad_date, SSN),
    CONSTRAINT examination_fk_doctorID FOREIGN KEY (doctorID)
        REFERENCES Doctors (ID)
);

CREATE TABLE Accesses (
    ID             VARCHAR(255) NOT NULL,
    rNum         NUMBER(3) NOT NULL,
    CONSTRAINT access_pk PRIMARY KEY (ID, rNum),
    CONSTRAINT access_id_fk FOREIGN KEY (ID)
        REFERENCES Employees(ID),
   CONSTRAINT access_rNum_fk FOREIGN KEY (rNum)
    REFERENCES Rooms(rNum)
);


CREATE TABLE Occupancy (
    rNum         NUMBER(3) NOT NULL,
    SSN         VARCHAR(11) NOT NULL,
    ad_date     TIMESTAMP(6) NOT NULL,
    start_date    TIMESTAMP(6) NOT NULL,
    end_date     TIMESTAMP(6),
    CONSTRAINT occupancy_pk PRIMARY KEY (rNum, SSN, ad_date, start_date),
    CONSTRAINT occupancy_fk_room FOREIGN KEY (rNum)
        REFERENCES Rooms (rNum),
    CONSTRAINT occupancy_fk_ad_date FOREIGN KEY (ad_date, SSN)
        REFERENCES Admissions (ad_date, SSN)
);

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
INSERT INTO Rooms VALUES(310, NULL);
INSERT INTO Rooms VALUES(311, NULL);
INSERT INTO Rooms VALUES(312, NULL);
INSERT INTO Rooms VALUES(313, NULL);
INSERT INTO Rooms VALUES(314, NULL);
INSERT INTO Rooms VALUES(315, 'True');


/*EQUIPMENT TYPES*/
INSERT INTO Equipments VALUES('MRI', 'Amira', 'magnetic resonance imaging', 'instruction1');
INSERT INTO Equipments VALUES('CT', 'Optima 520', 'computed tomography', 'instruction2');
INSERT INTO Equipments VALUES('X-ray', 'AMX', 'x-ray imaging device', 'instruction3');
INSERT INTO Equipments VALUES('PET', 'BEAM', 'Positron Emission Tomography', 'instruction4');
INSERT INTO Equipments VALUES('Ultrasound', 'Condo 3000', 'diagnostic imaging technique', 'instruction5');
INSERT INTO Equipments VALUES('EKG', 'HEART2', 'Electrocardiography', 'instruction6');

/*EQUIPMENT UNITS*/
INSERT INTO Units VALUES('MRI', 'A01-02X', 300, 2000, 'oldest', SYSDATE);
INSERT INTO Units VALUES('MRI', 'A02-02X', 301, 2010, 'recent', SYSDATE);
INSERT INTO Units VALUES('MRI', 'A03-02X', 302, 2020, 'newest', SYSDATE);
INSERT INTO Units VALUES('CT', 'B01-02X', 303, 2010, 'oldest', SYSDATE);
INSERT INTO Units VALUES('CT', 'B02-02X', 304, 2010, 'recent', SYSDATE);
INSERT INTO Units VALUES('CT', 'B03-02X', 305, 2011, 'newest', SYSDATE);
INSERT INTO Units VALUES('X-ray', 'C01-02X', 306, 2000, 'oldest', SYSDATE);
INSERT INTO Units VALUES('X-ray', 'C02-02X', 307, 2010, 'recent', SYSDATE);
INSERT INTO Units VALUES('X-ray', 'C03-02X', 308, 2020, 'newest', SYSDATE);
INSERT INTO Units VALUES('PET', 'D01-02X', 310, 2011, 'newest', SYSDATE);
INSERT INTO Units VALUES('PET', 'D02-02X', 311, 2010, 'oldest', SYSDATE);
INSERT INTO Units VALUES('Ultrasound', 'E01-02X', 312, 2015, 'newest',SYSDATE);
INSERT INTO Units VALUES('EKG', 'F01-02X', 313, 2012, 'newest', SYSDATE);
INSERT INTO Units VALUES('EKG', 'F02-02X', 314, 2010, 'oldest', SYSDATE);

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
INSERT INTO Services VALUES(309, 'CT Scanner room');
INSERT INTO Services VALUES(309, 'PET Scanner room');

/* ADMISSIONS */
INSERT INTO Admissions VALUES (TO_TIMESTAMP('2019-07-02 06:14:00.742000000', 'YYYY-MM-DD HH24:MI:SS.FF'), '111-22-3333', (TO_TIMESTAMP('2019-08-02 06:14:00.742000000', 'YYYY-MM-DD HH24:MI:SS.FF')), 
                                5000, 0.50, TO_TIMESTAMP('2019-09-02 06:14:00.742000000', 'YYYY-MM-DD HH24:MI:SS.FF'), 1);

INSERT INTO Admissions VALUES (TO_TIMESTAMP('2019-09-02 06:14:00.742000000', 'YYYY-MM-DD HH24:MI:SS.FF'), '111-22-3333', (TO_TIMESTAMP('2019-10-02 06:14:00.742000000', 'YYYY-MM-DD HH24:MI:SS.FF')), 
                                5000, 0.50, TO_TIMESTAMP('2019-11-02 06:14:00.742000000', 'YYYY-MM-DD HH24:MI:SS.FF'), 2);

INSERT INTO Admissions VALUES (TO_TIMESTAMP('2021-01-02 06:14:00.742000000', 'YYYY-MM-DD HH24:MI:SS.FF'), '111-22-3333', (TO_TIMESTAMP('2021-01-05 06:14:00.742000000', 'YYYY-MM-DD HH24:MI:SS.FF')), 
                                5000, 0.50, TO_TIMESTAMP('2021-03-02 14:00:00.742000000', 'YYYY-MM-DD HH24:MI:SS.FF'), 3);

INSERT INTO Admissions VALUES (TO_TIMESTAMP('2019-07-02 06:14:00.742000000', 'YYYY-MM-DD HH24:MI:SS.FF'), '111-22-3331', (TO_TIMESTAMP('2019-08-02 06:14:00.742000000', 'YYYY-MM-DD HH24:MI:SS.FF')), 
                                5000, 0.50, TO_TIMESTAMP('2019-09-02 06:14:00.742000000', 'YYYY-MM-DD HH24:MI:SS.FF'), 4);

INSERT INTO Admissions VALUES (TO_TIMESTAMP('2019-09-02 06:14:00.742000000', 'YYYY-MM-DD HH24:MI:SS.FF'), '111-22-3331', (TO_TIMESTAMP('2019-10-02 06:14:00.742000000', 'YYYY-MM-DD HH24:MI:SS.FF')), 
                                5000, 0.50, TO_TIMESTAMP('2019-11-02 06:14:00.742000000', 'YYYY-MM-DD HH24:MI:SS.FF'), 5);

INSERT INTO Admissions VALUES (TO_TIMESTAMP('2019-07-02 06:14:00.742000000', 'YYYY-MM-DD HH24:MI:SS.FF'), '111-22-3332', (TO_TIMESTAMP('2019-08-02 06:14:00.742000000', 'YYYY-MM-DD HH24:MI:SS.FF')), 
                                5000, 0.50, TO_TIMESTAMP('2019-09-02 06:14:00.742000000', 'YYYY-MM-DD HH24:MI:SS.FF'), 6);

INSERT INTO Admissions VALUES (TO_TIMESTAMP('2019-09-02 06:14:00.742000000', 'YYYY-MM-DD HH24:MI:SS.FF'), '111-22-3334', (TO_TIMESTAMP('2019-10-02 06:14:00.742000000', 'YYYY-MM-DD HH24:MI:SS.FF')), 
                                5000, 0.50, TO_TIMESTAMP('2019-11-02 06:14:00.742000000', 'YYYY-MM-DD HH24:MI:SS.FF'), 7);

INSERT INTO Admissions VALUES (TO_TIMESTAMP('2019-07-02 06:14:00.742000000', 'YYYY-MM-DD HH24:MI:SS.FF'), '111-22-3335', (TO_TIMESTAMP('2019-08-02 06:14:00.742000000', 'YYYY-MM-DD HH24:MI:SS.FF')), 
                                5000, 0.50, TO_TIMESTAMP('2019-09-02 06:14:00.742000000', 'YYYY-MM-DD HH24:MI:SS.FF'), 8);

INSERT INTO Admissions VALUES (TO_TIMESTAMP('2019-09-02 06:14:00.742000000', 'YYYY-MM-DD HH24:MI:SS.FF'), '111-22-3335', (TO_TIMESTAMP('2019-10-02 06:14:00.742000000', 'YYYY-MM-DD HH24:MI:SS.FF')), 
                                5000, 0.50, NULL, 9);

INSERT INTO Admissions VALUES (TO_TIMESTAMP('2020-09-02 06:14:00.742000000', 'YYYY-MM-DD HH24:MI:SS.FF'), '111-22-3335', (TO_TIMESTAMP('2019-10-02 06:14:00.742000000', 'YYYY-MM-DD HH24:MI:SS.FF')), 
                                5000, 0.50, NULL, 10);
                                
INSERT INTO Admissions VALUES (TO_TIMESTAMP('2020-10-02 06:14:00.742000000', 'YYYY-MM-DD HH24:MI:SS.FF'), '111-22-3336', (TO_TIMESTAMP('2019-10-02 06:14:00.742000000', 'YYYY-MM-DD HH24:MI:SS.FF')), 
                                5000, 0.50, NULL, 11);


/* EXAMINATIONS */
INSERT INTO Examinations VALUES('111-22-3333', 
	TO_TIMESTAMP('2019-07-02 06:14:00.742000000', 'YYYY-MM-DD HH24:MI:SS.FF'),
	111, 'This was my first examination of this dude and he definitely gon die',
	TO_TIMESTAMP('2019-07-02 07:15:00.742000000', 'YYYY-MM-DD HH24:MI:SS.FF'));
INSERT INTO Examinations VALUES('111-22-3333', 
	TO_TIMESTAMP('2019-09-02 06:14:00.742000000', 'YYYY-MM-DD HH24:MI:SS.FF'),
	111, 'Dude how is this guy still alive',
	TO_TIMESTAMP('2019-09-02 06:15:00.742000000', 'YYYY-MM-DD HH24:MI:SS.FF'));
INSERT INTO Examinations VALUES('111-22-3333', 
	TO_TIMESTAMP('2021-01-02 06:14:00.742000000', 'YYYY-MM-DD HH24:MI:SS.FF'),
	111, 'He dead',
	TO_TIMESTAMP('2021-01-02 06:15:00.742000000', 'YYYY-MM-DD HH24:MI:SS.FF'));
    
    
INSERT INTO Examinations VALUES('111-22-3333', 
	TO_TIMESTAMP('2019-09-02 06:14:00.742000000', 'YYYY-MM-DD HH24:MI:SS.FF'),
	112, 'No Comment',
	TO_TIMESTAMP('2019-09-02 06:15:00.742000000', 'YYYY-MM-DD HH24:MI:SS.FF'));
INSERT INTO Examinations VALUES('111-22-3331', 
	TO_TIMESTAMP('2019-07-02 06:14:00.742000000', 'YYYY-MM-DD HH24:MI:SS.FF'),
	112, 'No Comment',
	TO_TIMESTAMP('2019-07-02 06:15:00.742000000', 'YYYY-MM-DD HH24:MI:SS.FF'));
INSERT INTO Examinations VALUES('111-22-3331', 
	TO_TIMESTAMP('2019-09-02 06:14:00.742000000', 'YYYY-MM-DD HH24:MI:SS.FF'),
	112, 'No Comment',
	TO_TIMESTAMP('2019-09-02 06:15:00.742000000', 'YYYY-MM-DD HH24:MI:SS.FF'));
INSERT INTO Examinations VALUES('111-22-3332', 
	TO_TIMESTAMP('2019-07-02 06:14:00.742000000', 'YYYY-MM-DD HH24:MI:SS.FF'),
	112, 'No Comment',
	TO_TIMESTAMP('2019-07-02 06:15:00.742000000', 'YYYY-MM-DD HH24:MI:SS.FF'));
    
INSERT INTO Examinations (SSN, ad_date, doctorid, comments, ex_date)
    SELECT SSN, ad_date, 113 AS doctorid, 'No Comment' AS comments, ad_date AS ex_date
    FROM Admissions;
    


INSERT INTO Examinations VALUES('111-22-3334', 
	TO_TIMESTAMP('2019-09-02 06:14:00.742000000', 'YYYY-MM-DD HH24:MI:SS.FF'),
	114, 'No Comment',
	TO_TIMESTAMP('2019-09-02 06:15:00.742000000', 'YYYY-MM-DD HH24:MI:SS.FF'));
INSERT INTO Examinations VALUES('111-22-3335', 
	TO_TIMESTAMP('2019-07-02 06:14:00.742000000', 'YYYY-MM-DD HH24:MI:SS.FF'),
	114, 'No Comment',
	TO_TIMESTAMP('2019-07-02 06:15:00.742000000', 'YYYY-MM-DD HH24:MI:SS.FF'));
INSERT INTO Examinations VALUES('111-22-3335', 
	TO_TIMESTAMP('2019-09-02 06:14:00.742000000', 'YYYY-MM-DD HH24:MI:SS.FF'),
	114, 'No Comment',
	TO_TIMESTAMP('2019-09-02 06:14:00.742000000', 'YYYY-MM-DD HH24:MI:SS.FF'));

INSERT INTO Examinations VALUES('111-22-3335', 
	TO_TIMESTAMP('2019-07-02 06:14:00.742000000', 'YYYY-MM-DD HH24:MI:SS.FF'),
	115, 'No Comment',
	TO_TIMESTAMP('2019-07-02 06:15:00.742000000', 'YYYY-MM-DD HH24:MI:SS.FF'));

INSERT INTO Examinations (SSN, ad_date, doctorid, comments, ex_date)
    SELECT SSN, ad_date, 116 AS doctorid, 'No Comment' AS comments, ad_date AS ex_date
    FROM Admissions;

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

INSERT INTO Occupancy VALUES (300, '111-22-3333', 
	TO_TIMESTAMP('2019-07-02 06:14:00.742000000', 'YYYY-MM-DD HH24:MI:SS.FF'),
	TO_TIMESTAMP('2019-07-02 06:15:00.742000000', 'YYYY-MM-DD HH24:MI:SS.FF'), 
	TO_TIMESTAMP('2019-07-03 10:00:00.742000000', 'YYYY-MM-DD HH24:MI:SS.FF'));
INSERT INTO Occupancy VALUES (303, '111-22-3333',
	TO_TIMESTAMP('2019-09-02 06:14:00.742000000', 'YYYY-MM-DD HH24:MI:SS.FF'),
	TO_TIMESTAMP('2019-09-02 06:15:00.742000000', 'YYYY-MM-DD HH24:MI:SS.FF'),
	TO_TIMESTAMP('2019-09-03 10:15:00.742000000', 'YYYY-MM-DD HH24:MI:SS.FF'));
INSERT INTO Occupancy VALUES (305, '111-22-3333',
	TO_TIMESTAMP('2021-01-02 06:14:00.742000000', 'YYYY-MM-DD HH24:MI:SS.FF'),
	TO_TIMESTAMP('2021-01-02 06:15:00.742000000', 'YYYY-MM-DD HH24:MI:SS.FF'),
	TO_TIMESTAMP('2021-01-03 11:15:00.742000000', 'YYYY-MM-DD HH24:MI:SS.FF'));
INSERT INTO Occupancy VALUES (304, '111-22-3331',
	TO_TIMESTAMP('2019-07-02 06:14:00.742000000', 'YYYY-MM-DD HH24:MI:SS.FF'),
	TO_TIMESTAMP('2019-07-02 06:15:00.742000000', 'YYYY-MM-DD HH24:MI:SS.FF'),
	TO_TIMESTAMP('2019-07-03 12:15:00.742000000', 'YYYY-MM-DD HH24:MI:SS.FF'));
INSERT INTO Occupancy VALUES (303, '111-22-3331',
	TO_TIMESTAMP('2019-09-02 06:14:00.742000000', 'YYYY-MM-DD HH24:MI:SS.FF'),
	TO_TIMESTAMP('2019-09-02 06:15:00.742000000', 'YYYY-MM-DD HH24:MI:SS.FF'),
	TO_TIMESTAMP('2019-09-10 13:40:00.742000000', 'YYYY-MM-DD HH24:MI:SS.FF'));
INSERT INTO Occupancy VALUES (303, '111-22-3332',
	TO_TIMESTAMP('2019-07-02 06:14:00.742000000', 'YYYY-MM-DD HH24:MI:SS.FF'),
	TO_TIMESTAMP('2019-07-02 06:15:00.742000000', 'YYYY-MM-DD HH24:MI:SS.FF'),
	TO_TIMESTAMP('2019-07-03 11:15:00.742000000', 'YYYY-MM-DD HH24:MI:SS.FF'));
INSERT INTO Occupancy VALUES (305, '111-22-3332',
	TO_TIMESTAMP('2019-07-02 06:14:00.742000000', 'YYYY-MM-DD HH24:MI:SS.FF'),
	TO_TIMESTAMP('2019-07-03 11:15:00.742000000', 'YYYY-MM-DD HH24:MI:SS.FF'),
	TO_TIMESTAMP('2019-07-04 12:15:00.742000000', 'YYYY-MM-DD HH24:MI:SS.FF'));
INSERT INTO Occupancy VALUES (308, '111-22-3334',
	TO_TIMESTAMP('2019-09-02 06:14:00.742000000', 'YYYY-MM-DD HH24:MI:SS.FF'),
	TO_TIMESTAMP('2019-09-02 06:15:00.742000000', 'YYYY-MM-DD HH24:MI:SS.FF'),
	TO_TIMESTAMP('2019-09-05 09:30:00.742000000', 'YYYY-MM-DD HH24:MI:SS.FF'));
INSERT INTO Occupancy VALUES (300, '111-22-3335',
	TO_TIMESTAMP('2019-07-02 06:14:00.742000000', 'YYYY-MM-DD HH24:MI:SS.FF'),
	TO_TIMESTAMP('2019-07-02 06:15:00.742000000', 'YYYY-MM-DD HH24:MI:SS.FF'),
	TO_TIMESTAMP('2019-07-10 08:20:00.742000000', 'YYYY-MM-DD HH24:MI:SS.FF'));
INSERT INTO Occupancy VALUES (303, '111-22-3335',
	TO_TIMESTAMP('2019-09-02 06:14:00.742000000', 'YYYY-MM-DD HH24:MI:SS.FF'),
	TO_TIMESTAMP('2019-09-02 06:16:00.742000000', 'YYYY-MM-DD HH24:MI:SS.FF'),
	TO_TIMESTAMP('2019-09-11 07:45:00.742000000', 'YYYY-MM-DD HH24:MI:SS.FF'));
INSERT INTO Occupancy VALUES (305, '111-22-3335',
	TO_TIMESTAMP('2019-09-02 06:14:00.742000000', 'YYYY-MM-DD HH24:MI:SS.FF'),
	TO_TIMESTAMP('2019-09-11 08:00:00.742000000', 'YYYY-MM-DD HH24:MI:SS.FF'),
	TO_TIMESTAMP('2019-09-15 09:45:00.742000000', 'YYYY-MM-DD HH24:MI:SS.FF'));
INSERT INTO Occupancy VALUES (305, '111-22-3335',
	TO_TIMESTAMP('2019-09-02 06:14:00.742000000', 'YYYY-MM-DD HH24:MI:SS.FF'),
	TO_TIMESTAMP('2019-09-11 12:00:00.742000000', 'YYYY-MM-DD HH24:MI:SS.FF'),
	TO_TIMESTAMP('2019-09-15 13:45:00.742000000', 'YYYY-MM-DD HH24:MI:SS.FF'));
INSERT INTO Occupancy VALUES (305, '111-22-3335',
	TO_TIMESTAMP('2019-09-02 06:14:00.742000000', 'YYYY-MM-DD HH24:MI:SS.FF'),
	TO_TIMESTAMP('2019-09-11 18:00:00.742000000', 'YYYY-MM-DD HH24:MI:SS.FF'),
	TO_TIMESTAMP('2019-09-15 20:45:00.742000000', 'YYYY-MM-DD HH24:MI:SS.FF'));

/*PART 1*/
DROP VIEW CriticalCase;
DROP VIEW DoctorsLoad;

/*Question 1*/
CREATE VIEW CriticalCase AS
SELECT p.SSN, fName, lName, numberOfAdmissionsToICU
FROM PATIENTS p, (
	SELECT SSN, COUNT(ad_date) AS numberOfAdmissionsToICU
	FROM Occupancy
	WHERE Occupancy.rNum IN
    	(SELECT rNum FROM Services WHERE Services.service = 'Intensive care unit (ICU)')
	GROUP BY SSN
	HAVING COUNT(ad_date)>=2
	) temp
WHERE p.SSN = temp.ssn;

/*Question 2*/
CREATE VIEW DoctorsLoad AS (
(SELECT d.id, d.school, 'Overloaded' AS load 
FROM Doctors d, ( 
SELECT doctorid, count(ad_date) AS l
FROM (SELECT DISTINCT SSN, ad_date, doctorID FROM Examinations)
GROUP BY doctorid) temp1 
WHERE temp1.l > 10 AND d.id=temp1.doctorid)
UNION
(SELECT d.id, d.school, 'Underloaded' AS load 
FROM Doctors d, ( 
SELECT doctorid, count(ad_date) AS l
FROM (SELECT DISTINCT SSN, ad_date, doctorID FROM Examinations)
GROUP BY doctorid) temp2 
WHERE temp2.l <= 10 AND d.id=temp2.doctorid));

/* Question 3 */
/* should return a single patient with 5 admissions*/
SELECT  SSN, fName, lName, numberOfAdmissionsToICU 
FROM CriticalCase
WHERE  numberOfAdmissionsToICU > 4;

/* Question 4 */
/*should return a single doctor ID 113*/
SELECT e.ID, e.fName, e.lName
FROM Employees e, DoctorsLoad dl
WHERE e.ID = dl.ID AND dl.load = 'Overloaded' and dl.school = 'WPI';

/* Question 5 */
/*Should return 3 entries for docId 111, 2 entries for docId's 112 and 114, and 1 entry for 115*/
SELECT doctorID as ID, SSN, comments
FROM Examinations
WHERE doctorID IN
(
	SELECT ID
	FROM DoctorsLoad
	WHERE load = 'Underloaded'
)
AND SSN IN
(
	SELECT SSN
	FROM CriticalCase
);

/* Part 2 */

/*Trigger 1 Code*/
CREATE OR REPLACE TRIGGER ICUComment
BEFORE INSERT OR UPDATE ON Examinations
FOR EACH ROW
DECLARE 
    countR NUMBER;
BEGIN
    SELECT COUNT(*) INTO countR FROM Occupancy WHERE ssn = :new.ssn AND ad_date = :new.ad_date AND rnum IN (SELECT rnum FROM Services WHERE service = 'Intensive care unit (ICU)');
    IF(countR > 0) THEN
        IF (:new.comments IS NULL) THEN
            	RAISE_APPLICATION_ERROR(20001, 'Must leave comment');
        END IF;
    END IF;
END;
/


/*Trigger 1 test cases*/ 
DELETE FROM Examinations WHERE SSN = '111-22-3335' AND ad_date = TO_TIMESTAMP('2019-09-02 06:14:00.742000000', 'YYYY-MM-DD HH24:MI:SS.FF') 
                                AND doctorID = 115 AND ex_date = TO_TIMESTAMP('2019-07-02 06:15:00.742000000', 'YYYY-MM-DD HH24:MI:SS.FF');
/* Note '111-22-3335',
	TO_TIMESTAMP('2019-09-02 06:14:00.742000000', 'YYYY-MM-DD HH24:MI:SS.FF') has been to an ICU */
/*This fails*/
INSERT INTO Examinations VALUES('111-22-3335', 
	TO_TIMESTAMP('2019-09-02 06:14:00.742000000', 'YYYY-MM-DD HH24:MI:SS.FF'),
	115, NULL,
	TO_TIMESTAMP('2019-07-02 06:15:00.742000000', 'YYYY-MM-DD HH24:MI:SS.FF'));
/*This passes*/
INSERT INTO Examinations VALUES('111-22-3335', 
	TO_TIMESTAMP('2019-09-02 06:14:00.742000000', 'YYYY-MM-DD HH24:MI:SS.FF'),
	115, 'No Comment',
	TO_TIMESTAMP('2019-07-02 06:15:00.742000000', 'YYYY-MM-DD HH24:MI:SS.FF'));
 
/*This Fails*/
UPDATE Examinations SET Comments = NULL WHERE SSN ='111-22-3335' AND ad_date = 
	TO_TIMESTAMP('2019-09-02 06:14:00.742000000', 'YYYY-MM-DD HH24:MI:SS.FF') AND doctorID = 
	115 AND ex_date = TO_TIMESTAMP('2019-07-02 06:15:00.742000000', 'YYYY-MM-DD HH24:MI:SS.FF');


/*Trigger 2*/
CREATE OR REPLACE TRIGGER constantInsurance
BEFORE INSERT OR UPDATE ON Admissions
FOR EACH ROW
BEGIN
	IF (:new.insurance <> 0.65) THEN
        :new.insurance := 0.65;
	END IF;
END;
/

/*Trigger 2 Test Cases*/
/* INSURANCE SHOULD BE AUTOMATICALLY SET TO 0.65 */
UPDATE Admissions
SET insurance = 0.40
WHERE ad_date = TO_TIMESTAMP('2019-07-02 06:14:00.742000000', 'YYYY-MM-DD HH24:MI:SS.FF') AND SSN = '111-22-3333';

/*SHOULD PASS*/
SELECT insurance FROM Admissions
WHERE ad_date = TO_TIMESTAMP('2019-07-02 06:14:00.742000000', 'YYYY-MM-DD HH24:MI:SS.FF') AND SSN = '111-22-3333';

/* Triggers 3 and 4 CODE */

CREATE OR REPLACE TRIGGER rightManagers
BEFORE INSERT OR UPDATE ON Employees
FOR EACH ROW
DECLARE
	PRAGMA autonomous_transaction;
	manRank VARCHAR(32);
BEGIN
    SELECT empRank INTO manRank FROM Employees WHERE ID = :new.superID;
    IF (:new.empRank = 'Regular') THEN
        IF (manRank <> 'Division') THEN
        	RAISE_APPLICATION_ERROR(20002, 'Regular employees has to have Division Manager');
        END IF;
    END IF;
    IF (:new.empRank = 'Division') THEN
        IF (manRank <> 'General') THEN
            RAISE_APPLICATION_ERROR(20002, 'Division managers has to have General Manager');
        END IF;
    END IF;
    IF (:new.empRank = 'General') THEN
        IF (manRank IS NOT NULL ) THEN
            RAISE_APPLICATION_ERROR(20002, 'General managers should not have supervision');
        END IF;
    END IF;
COMMIT;
END;
/

/* Triggers 3 and 4 Tests*/ 
/* SHOULD RAISE TRIGGER ERROR */
UPDATE Employees
SET superID = 2
WHERE ID = 1;

/* SHOULD BE OK */
UPDATE Employees
SET superID = 2
WHERE ID = 11;

/* SHOULD RAISE TRIGGER ERROR */
UPDATE Employees
SET superID = 12
WHERE ID = 11;

/* SHOULD BE OK */
UPDATE Employees
SET superID = 12
WHERE ID = 112;

/* SHOULD NOT BE OK */
UPDATE Employees
SET superID = 1
WHERE ID = 111;

UPDATE Employees
SET superID = 111
WHERE ID = 113;


/*Trigger 5*/
CREATE OR REPLACE TRIGGER defaultCheckUp
AFTER INSERT OR UPDATE ON Occupancy
FOR EACH ROW
DECLARE 
	isEmergency INT;
BEGIN
	SELECT count(*) INTO isEmergency
	FROM Services
	WHERE rNum = :new.rNum AND service = 'Emergency room';
	IF (isEmergency != 0) THEN
        UPDATE Admissions SET appointment = ADD_MONTHS(:new.ad_date, 2) WHERE SSN = :new.SSN AND ad_date = :new.ad_date;
    END IF;
END;
/

/* Trigger 5 Test Cases */
/* Room 303 is an Emergency room */
DELETE FROM Admissions WHERE ad_date = TO_TIMESTAMP('2020-10-22 06:14:00.742000000', 'YYYY-MM-DD HH24:MI:SS.FF') AND SSN = '111-22-3336';
/* Should return NULL*/    
SELECT appointment FROM Admissions WHERE ad_date = TO_TIMESTAMP('2020-10-22 06:14:00.742000000', 'YYYY-MM-DD HH24:MI:SS.FF') AND SSN = '111-22-3336';

INSERT INTO Admissions VALUES (TO_TIMESTAMP('2020-10-22 06:14:00.742000000', 'YYYY-MM-DD HH24:MI:SS.FF'), '111-22-3336', (TO_TIMESTAMP('2019-10-02 06:14:00.742000000', 'YYYY-MM-DD HH24:MI:SS.FF')), 
                                5000, 0.65, NULL, 12);
                                

DELETE FROM Occupancy WHERE ad_date = TO_TIMESTAMP('2020-10-22 06:14:00.742000000', 'YYYY-MM-DD HH24:MI:SS.FF') AND SSN = '111-22-3336';

INSERT INTO Occupancy VALUES (303, '111-22-3336',
    TO_TIMESTAMP('2020-10-22 06:14:00.742000000', 'YYYY-MM-DD HH24:MI:SS.FF'),
    TO_TIMESTAMP('2020-10-22 06:14:00.742000000', 'YYYY-MM-DD HH24:MI:SS.FF'),
	TO_TIMESTAMP('2020-10-23 06:14:00.742000000', 'YYYY-MM-DD HH24:MI:SS.FF'));

/* Should return Dec 22 2020 */    
SELECT appointment FROM Admissions WHERE ad_date = TO_TIMESTAMP('2020-10-22 06:14:00.742000000', 'YYYY-MM-DD HH24:MI:SS.FF') AND SSN = '111-22-3336';

/* We should be able to update */
UPDATE Admissions SET appointment = TO_TIMESTAMP('2020-11-22 06:14:00.742000000', 'YYYY-MM-DD HH24:MI:SS.FF') WHERE ad_date = TO_TIMESTAMP('2020-10-22 06:14:00.742000000', 'YYYY-MM-DD HH24:MI:SS.FF') AND SSN = '111-22-3336';

/* Now returns Nov 22 2020*/
SELECT appointment FROM Admissions WHERE ad_date = TO_TIMESTAMP('2020-10-22 06:14:00.742000000', 'YYYY-MM-DD HH24:MI:SS.FF') AND SSN = '111-22-3336';

/*Trigger 6*/
CREATE OR REPLACE TRIGGER newUnitInspection
BEFORE INSERT ON Units
FOR EACH ROW
DECLARE 
    numTechnicians NUMBER; 
BEGIN
IF (:new.inspection_date < ADD_MONTHS(SYSDATE, -1)) THEN 
    SELECT COUNT(ID) INTO numTechnicians FROM Repairs r WHERE r.equipmentid = :new.id;
	IF (numTechnicians > 0) THEN
      :new.inspection_date := SYSDATE;
    END IF;
END IF;
END;
/

/*Trigger 6 Test Cases*/ 
/* This one should be added and unmodified*/
DELETE FROM Units WHERE id = 'MRI' AND serialnum = 'A04-02X';
DELETE FROM Units WHERE id = 'MRI' AND serialnum = 'A05-02X';


INSERT INTO Units VALUES('MRI', 'A04-02X', 300, 2000, 'new newest', SYSDATE);
SELECT inspection_date FROM Units WHERE id = 'MRI' AND serialnum = 'A04-02X';

/*This one should get modified*/
INSERT INTO Units VALUES('MRI', 'A05-02X', 300, 2000, 'new newest', TO_TIMESTAMP('2019-09-02 06:14:00.742000000', 'YYYY-MM-DD HH24:MI:SS.FF'));
SELECT inspection_date FROM Units WHERE id = 'MRI' AND serialnum = 'A05-02X';

/*Trigger 7 */
SET SERVEROUTPUT ON;
CREATE OR REPLACE TRIGGER printPatientWhoLeaves
AFTER UPDATE OF leave_date ON Admissions
FOR EACH ROW
DECLARE 
    fname VARCHAR(32);
    lname VARCHAR(32);
    street VARCHAR(32);
    town VARCHAR(32);
    zip VARCHAR(32);
    doctor VARCHAR(32);
    comment VARCHAR(1024);
    CURSOR c1 IS SELECT fname AS dname, lname AS dlname, comments FROM Examinations e, Employees d WHERE e.doctorid = d.id AND :new.SSN = e.SSN and :new.ad_date = e.ad_date; 
BEGIN
    SELECT fname, lname, street, town, zip INTO fname, lname, street, town, zip FROM Patients p WHERE :new.ssn = p.ssn; 
    dbms_output.put_line('Name: ' || fname); 
    dbms_output.put_line('Last Name: ' || lname); 
    dbms_output.put_line('Street: ' || street); 
    dbms_output.put_line('Town: ' || town); 
    dbms_output.put_line('zip: ' || zip); 
    FOR rec IN c1 LOOP 
        dbms_output.put_line('Doctor: ' || rec.dname || ' ' || rec.dlname); 
        dbms_output.put_line('Comment: ' || rec.comments);
    END LOOP;
END;
/

/* Trigger 7 Test Cases */

DELETE FROM Admissions WHERE ad_date = TO_TIMESTAMP('2021-10-02 06:14:00.742000000', 'YYYY-MM-DD HH24:MI:SS.FF') AND SSN = '111-22-3336';

INSERT INTO Admissions VALUES (TO_TIMESTAMP('2021-10-02 06:14:00.742000000', 'YYYY-MM-DD HH24:MI:SS.FF'), '111-22-3336', NULL, 
                                5000, 0.65, NULL, 13);
                                
UPDATE Admissions SET leave_date = SYSDATE, insurance = 0.65 WHERE ad_date = TO_TIMESTAMP('2020-10-02 06:14:00.742000000', 'YYYY-MM-DD HH24:MI:SS.FF') AND SSN = '111-22-3336';


