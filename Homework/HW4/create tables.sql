CREATE TABLE Emp( 
eid INTEGER,
ename CHAR(255),
age INTEGER,
salary FLOAT,
PRIMARY KEY (eid)
);

CREATE TABLE Works(
eid INTEGER,
did INTEGER,
pct_time INTEGER,
PRIMARY KEY (eid,did),
FOREIGN KEY (eid) REFERENCES Emp (eid),
FOREIGN KEY (did) REFERENCES Dept (did)
);

CREATE TABLE Dept(
did INTEGER,
dname CHAR(255), 
budget FLOAT,
managerid INTEGER,
PRIMARY KEY (did),
FOREIGN KEY (managerid) REFERENCES Emp (eid)
);
