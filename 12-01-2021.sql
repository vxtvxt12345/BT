use testing_system_assignment_1;
SELECT * FROM testing_system_assignment_1;
SELECT * FROM `account` a join department b
 ON a.DepartmentID= b.DepartmentID;
 -- Lấy ra tất cả phòng ban
SELECT * FROM `Department`;

-- Lấy ra id của phòng ban Sale
SELECT * FROM `Department`
WHERE DepartmentName = 'Sale';

-- Lấy ra thông tin account có fullname dài nhất
SELECT * FROM `Account`
WHERE length(FullName) = (SELECT MAX(Length(FullName)) FROM `Account`) ;

--  Lấy ra thông tin account có fullname dài nhất và thuộc phòng ban có id bằng = 3
SELECT * FROM `Account`
WHERE length(FullName) = (SELECT MAX(Length(FullName)) FROM `Account`) 
AND DepartmentID = 3;

-- Lấy ra tên group đã tham gia trước ngày 20/12/2019 
SELECT * FROM `Group`
WHERE CreateDate < '2019-12-20';

-- Lấy ra ID của question có >= 4 câu trả lời
SELECT QuestionID, COUNT(AnswerID) 
FROM Answer
GROUP BY QuestionID 
HAVING Count(AnswerID) >= 4;

-- Lấy ra các mã đề thi có thời gian thi >= 60 phút và được tạo trước ngày 20/12/2019 
SELECT `Code` FROM `Exam` 
WHERE Duration >= '1:00:00' AND CreatDate < '2019-12-20';

-- Lấy ra 5 group được tạo gần đây nhất
SELECT * FROM `Group`
ORDER BY CreateDate DESC 
LIMIT 5;

-- Đếm số nhân viên thuộc department có id = 2
SELECT Count(AccountID) AS SONHANVIEN FROM `Account` 
WHERE DepartmentID = 2;

--  Lấy ra nhân viên có tên bắt đầu bằng chữ "D" và kết thúc bằng chữ "o" 
SELECT FullName FROM `Account`
WHERE FullName LIKE 'D%o';

-- Xóa tất cả các exam được tạo trước ngày 20/12/2019 
DELETE FROM `Exam`
WHERE CreateDate < '2019-12-20';

-- Xóa tất cả các question có nội dung bắt đầu bằng từ "câu hỏi" 
DELETE FROM `Question`
WHERE Content LIKE 'câu hỏi';

-- Update thông tin của account có id = 5 thành tên "Nguyễn Bá Lộc" và email thành loc.nguyenba@vti.com.vn 
UPDATE `Account`
SET FullName = 'Nguyễn Bá Lộc',Email = 'loc.nguyenba@vti.com.vn'
WHERE AccountID = 5;

--  update account có id = 5 sẽ thuộc group có id = 4 
UPDATE `GroupAccount`
SET GroupID = 4
WHERE AccountID = 5;
----- Question 1: Viết lệnh để lấy ra danh sách nhân viên và thông tin phòng ban của họ
SELECT * 
FROM account 
JOIN department 
ON account.DepartmentID = department.DepartmentID;
-- Question 2: Viết lệnh để lấy ra thông tin các account được tạo sau ngày 20/12/2010
SELECT * 
	FROM account 
		WHERE CreateDate > '2010-12-20';
        
-- Question 3: Viết lệnh để lấy ra tất cả các developer
SELECT *
FROM account 
JOIN department 
ON account.DepartmentID= department.DepartmentID
WHERE department.DepartmentName='Developer';
-- Question 4: Viết lệnh để lấy ra danh sách các phòng ban có >3 nhân viên

SELECT department.DepartmentID, department.DepartmentName  FROM account Join department ON account.DepartmentID = department.DepartmentID
 GROUP BY (account.DepartmentID) HAVING count(account.DepartmentID)>3 ;
 
-- Question 5: Viết lệnh để lấy ra danh sách câu hỏi được sử dụng trong đề thi nhiều nhất
Select * From examquestion GROUP BY QuestionID HAVing  count(QuestionID) ;


DROP TABLE  IF EXISTS TEMP;
CREATE TABLE TEMP (ID INT,NUM INT);
INSERT INTO TEMP  ( Select QuestionID, count(QuestionID)  From examquestion
 GROUP BY QuestionID )  ;
 SELECT ID FROM TEMP WHERE NUM=(select MAX(NUM) FROM TEMP);
 SELECT * FROM question JOIN TEMP ON question.QuestionID=TEMP.ID
 WHERE NUM=(select MAX(NUM) FROM TEMP);
 --- 
SELECT  * FROM question  
     WHERE question.QuestionID = 
          (SELECT bb2.QuestionID 
				FROM( 
					SELECT bb1.QuestionID , MAX(bb1.cou)  
           FROM  ( Select questionID,  count(QuestionID) as cou  From examquestion
 GROUP BY QuestionID) as bb1 ) as bb2 );
 
 ----

select *  FROM question JOIN examquestion ON question.QuestionID =examquestion.QuestionID
GROUP BY examquestion.QuestionID having count(examquestion.QuestionID)=( 
Select MAX(b1.cou) FROM (
 Select questionID,  count(QuestionID) as cou  From examquestion
 GROUP BY QuestionID ) as b1 ) ;
 
 
 
 
-- Question 6: Thông kê mỗi category Question được sử dụng trong bao nhiêu Question

SELECT examquestion.QuestionID,count(examquestion.QuestionID) FROM question 
JOIN examquestion ON question.QuestionID=examquestion.QuestionID
GROUP BY question.QuestionID;

 -- Question 11: Thống kê mỗi phòng ban có bao nhiêu dev, test, scrum master, PM
 SELECT *
 FROM account JOIN department on account.DepartmentID = department.DepartmentID
 GROUP BY account.DepartmentID ;
 
 CREATE VIEW view1 AS 
 Select * FROM account WHERE DepartmentID=1 or DepartmentID='6';
 
 SELECT * FROM view1;
 DROP VIEW view1;
 
 

-----

CREATE VIEW VIEW2 as (SELECT  * FROM question  
     WHERE question.QuestionID = 
          (SELECT bb2.QuestionID 
				FROM( 
					SELECT bb1.QuestionID , MAX(bb1.cou)  
           FROM  ( Select questionID,  count(QuestionID) as cou  From examquestion
 GROUP BY QuestionID) as bb1 ) as bb2 ));
 SELECT * FROm view2;
 
SET @IDdep= 1;
CALL acc(4,@IDdep);
SELECT @IDdep;
 Call ten();
 -- Cau1 Bai6 .
 CALL tenphongban('Support');
-- cau3 bai 6 : 
DROP PROCEDURE IF EXISTS cau3()
DELIMITER $$
CREATE PROCEDURE cau3()
BEGIN
	SELECT TQ.TypeID, count(TQ.TypeID) AS soluong FROM Question Q 
	JOIN typequestion TQ 
	ON q.typeID =TQ.typeID
	WHERE month(Q.CreateDate)=10
	GROUP BY TQ.TypeID  ;
END$$
DELIMITER ;
CALL cau3();

-- Q.3 Assignment 6:

DROP PROCEDURE IF EXISTS SP_Cau_Hoi_Trong_Thang;
DELIMITER $$
CREATE PROCEDURE SP_Cau_Hoi_Trong_Thang ()
BEGIN
	SELECT	TQ.typeid, TQ.typename, count(Q.questionid) AS So_Q
    FROM	Question Q
    JOIN	TypeQuestion TQ ON Q.typeid = TQ.typeid
    WHERE	MONTH(Q.createdate) = 10
		AND YEAR(Q.createdate) = 2020
    GROUP BY	TQ.typeid
    ;
END $$
DELIMITER ;

CALL SP_Cau_Hoi_Trong_Thang();

-- Question 7:
DROP PROCEDURE IF EXISTS insert_account;
DELIMITER $$
CREATE PROCEDURE insert_account(IN in_full_name VARCHAR(255), IN in_email VARCHAR(100))
BEGIN
	DECLARE v_department_id INT(10) DEFAULT 0;
    DECLARE v_position_id INT(10) DEFAULT 0;
    
    SELECT departmentid INTO v_department_id
    FROM departments 
    WHERE departmentname = 'Waiting Room';
       
	SELECT positionid INTO v_position_id
    FROM positions 
    WHERE positionname = 'Developer';
    
    INSERT INTO account 
	(email, 		user_name, 								full_name, 		department_id, 		position_id) VALUES
    (in_email, 		SUBSTRING_INDEX(in_email, '@', 1), 		in_full_name, 	v_department_id, 	v_position_id);
    
    IF ROW_COUNT() > 0 THEN
		SELECT 'You created record successfully!';
    ELSE 
		SELECT 'You did not create record successfully!';
	END IF;
END$$
DELIMITER ;
 
 -- Question 6: 
DROP PROCEDURE IF EXISTS Question6;
DELIMITER $$
CREATE PROCEDURE Question6( IN Nhap Varchar(30), IN Group_OR_User Varchar(10))
BEGIN
	IF Group_OR_User = 'group' THEN
	SELECT GroupName  FROM  `group`    Where	GroupName Like concat('%' , Nhap ,'%');
	Else
			SELECT AccountID, Email, Username, Fullname
            From account	
            Where Username like concat('%' , Nhap ,'%');
	END IF;
END$$
    DELIMITER ;
    
DROP TRIGGER IF EXISTS Question3;
DELIMITER $$
CREATE TRIGGER Question3 
BEFORE INSERT ON groupaccount
FOR EACH ROW
BEGIN
DECLARE V_ACC INT;
  SELECT GroupID FROM ( SELECT AccountID , count(AccountID) FROM groupaccount  
  GROUP BY AccountID HAVING count (AccountID) =5 ) t1
END
DELIMITER     
 






