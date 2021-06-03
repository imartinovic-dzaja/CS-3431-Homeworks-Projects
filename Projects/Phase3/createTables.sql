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

DROP VIEW CriticalCase;
DROP VIEW DoctorsLoad;

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

/* should return a single patient with 5 admissions*/
SELECT  SSN, fName, lName, numberOfAdmissionsToICU 
FROM CriticalCase
WHERE  numberOfAdmissionsToICU > 4;

/*should return a single doctor ID 113*/
SELECT e.ID, e.fName, e.lName
FROM Employees e, DoctorsLoad dl
WHERE e.ID = dl.ID AND dl.load = 'Overloaded' and dl.school = 'WPI';

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

