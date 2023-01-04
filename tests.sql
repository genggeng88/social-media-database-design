-- Script name: tests.sql
-- Author:      Qin Geng
-- Purpose:     test the integrity of the Blog Management database system

-- the database used to insert the data into.
USE BlogManagementDB;
SET SQL_SAFE_UPDATES = 0;

DELIMITER $$
-- -----------------------------------------------------
-- Triggers.
-- 1. Delete the Notify row when both the service_id and admin_id are null.
-- 2. Update the number_of_post in Topics before a new tagged item is inserted into Tagged.
-- 3. Update the number_of_post in Topics after a new tagged item is inserted into Tagged.
-- 4. Update the number_of_comments for a post before a new comment is left.
-- 5. Update the number_of_comments for a post after a new comment is left.
-- -----------------------------------------------------
CREATE TRIGGER Delete_after_service AFTER DELETE ON Service 
	FOR EACH ROW BEGIN
		DELETE FROM Notify WHERE service_id IS NULL AND admin_id IS NULL;
	END $$

CREATE TRIGGER Delete_after_admin AFTER DELETE ON Admins 
	FOR EACH ROW BEGIN
		DELETE FROM Notify WHERE service_id IS NULL AND admin_id IS NULL;
	END $$

CREATE TRIGGER Update_Topics_Before BEFORE INSERT ON Tagged
	FOR EACH ROW BEGIN
		DECLARE new_number_posts INT;
        DECLARE new_topic_id TINYINT;
	    SET new_topic_id = new.topic_id;
        CALL number_posts(new_topic_id, @number_posts);
        SET new_number_posts = @number_posts;
	
		UPDATE Topics SET number_posts = new_number_posts WHERE topic_id = new_topic_id; 
		
	END$$


CREATE TRIGGER Update_Topics_After AFTER INSERT ON Tagged 
	FOR EACH ROW BEGIN
		DECLARE new_number_posts  INT;
        DECLARE topic_id_exist INT;
	    SET topic_id_exist = (SELECT count(*) from Topics WHERE topic_id = new.topic_id);
        SET new_number_posts = (SELECT number_posts from Topics WHERE topic_id = new.topic_id) + 1;
        IF (new_number_posts > 0) THEN 
            UPDATE Topics SET number_posts = new_number_posts WHERE topic_id = new.topic_id; 
		ELSE 
            INSERT INTO Topics (topic_id, topic_tag, number_posts) VALUES (new.topic_id, 'new topic', new_number_posts);
		END IF;
	END$$

CREATE TRIGGER Update_Post_Before BEFORE INSERT ON Comments
	FOR EACH ROW BEGIN
		DECLARE new_number_comments INT;
        DECLARE new_post_id TINYINT;
	    SET new_post_id = new.post_id;
        CALL number_comments(new_post_id, @number_comments);
        SET new_number_comments = @number_comments;
		UPDATE Post SET number_comments = new_number_comments WHERE post_id = new_post_id; 
	END$$


CREATE TRIGGER Update_Post_After AFTER INSERT ON Comments 
FOR EACH ROW BEGIN
		DECLARE new_number_comments  INT;
        DECLARE post_id_exist INT;
	    SET post_id_exist = (SELECT count(*) from Post WHERE post_id = new.post_id);
        SET new_number_comments = (SELECT number_comments from Post WHERE post_id = new.post_id) + 1;
        IF (post_id_exist > 0) THEN 
            UPDATE Post SET number_comments = new_number_comments WHERE post_id = new.post_id; 
		END IF;
	END$$
    
    
-- -----------------------------------------------------
-- Procedures.
-- 1. caculate the number of posts under a specific topic.
-- 2. caculate the number of comments under a specific post.
-- -----------------------------------------------------
CREATE PROCEDURE number_posts(IN topic_id_in TINYINT, OUT number_of_posts INT)
	BEGIN
		SET number_of_posts = (
		SELECT COUNT(Tagged.post_id)  
		FROM Tagged 
        WHERE Tagged.topic_id = topic_id_in);
        UPDATE Topics SET number_posts = number_of_posts WHERE Topics.topic_id = topic_id_in;
	END $$

CREATE PROCEDURE number_comments(IN post_id_in TINYINT, OUT number_of_comments INT)
	BEGIN
		SET number_of_comments = (
		SELECT COUNT(Comments.comment_id)  
		FROM Comments 
        WHERE Comments.post_id = post_id_in);
        UPDATE Post SET number_comments = number_of_comments WHERE Post.post_id = post_id_in;
	END $$

-- -----------------------------------------------------
-- Functions.
-- 1. Caculate the number of groups a registered user has joined.
-- 2. Caculate the number of posts a registered user or a special user has posted.
-- -----------------------------------------------------
CREATE FUNCTION compute_groups (registered_id_in INT) RETURNS INT DETERMINISTIC 
   BEGIN 
         DECLARE number_groups INT;
         SET number_groups = (SELECT COUNT(group_id) FROM JoinGroup WHERE registered_id = registered_id_in);
         RETURN number_groups;
   END $$

CREATE FUNCTION compute_posts (user_id_in INT, is_special Bool) RETURNS INT DETERMINISTIC 
   BEGIN 
         DECLARE number_posts INT;
         DECLARE group_posts INT;
		 DECLARE general_posts INT;
         IF is_special = 1 THEN
			SET number_posts = (SELECT COUNT(post_id) FROM SpecialPost WHERE special_user_id = user_id_in);
         ELSE
			SET general_posts = (SELECT COUNT(post_id) FROM GeneralPost WHERE registered_id = user_id_in);
			SET group_posts = (SELECT COUNT(post_id) 
								FROM GroupPost 
                                JOIN PostingGroupUser ON GroupPost.posting_user_id = PostingGroupUser.posting_user_id
                                WHERE PostingGroupUser.posting_user_id = user_id_in);
			SET number_posts = general_posts + group_posts;
         END IF;
         RETURN number_posts;
   END $$

DELIMITER ;


-- -----------------------------------------------------
-- -- Business requirement #1 implementation
-- -----------------------------------------------------
SELECT Registered.registered_id as 'Registered id', Registered.last_name as 'Last Name', Registered.first_name as 'First Name', 
Topics.topic_tag as 'topic' 
FROM Registered
Join Interested ON Registered.registered_id = Interested.registered_id 
Join Topics on Interested.topic_id = Topics.topic_id  
Having Topic = 'news'  
ORDER BY Registered.registered_id;
-- -----------------------------------------------------
-- Business requirement #1 Output 
-- -----------------------------------------------------
-- '8','Wood','Obmar','news'
-- '12','He','Emma','news'
-- '13','Jhonson','Henry','news'



-- -----------------------------------------------------
-- Business requirement #2 implementation
-- -----------------------------------------------------
SELECT Accounts.user_id AS 'User id', Registered.last_name as 'Last Name', Registered.first_name as 'First Name', 
Count(AccountUse.role_id) as 'Number of Roles' 
FROM AccountUse
JOIN Roles on Roles.role_id = AccountUse.role_id 
JOIN Accounts on Accounts.account_id = AccountUse.account_id 
JOIN Registered on Registered.user_id = Accounts.user_id 
WHERE Accounts.user_id  is not null 
GROUP BY AccountUse.account_id, Accounts.user_id, Registered.last_name, Registered.first_name  
ORDER BY Accounts.user_id;
-- -----------------------------------------------------
-- Business requirement #2 Output
-- -----------------------------------------------------
-- '1','Pillio','Alice','2'
-- '4','Wang','Bob','1'
-- '6','Li','Trudi','1'
-- '7','Johnson','Jeff','3'
-- '10','Forbis','Mevin','2'
-- '11','Smith','Lena','4'
-- '12','Taylor','Tome','2'
-- '13','Wood','Obmar','2'
-- '15','Smith','Jone','1'
-- '16','White','Lucy','1'
-- '17','Ruan','Xabi','1'
-- '18','He','Emma','1'
-- '19','Jhonson','Henry','1'
-- '20','Huang','Mason','1'
-- '21','Peterson','Sophia','1'



-- -----------------------------------------------------
-- Business requirement #3 implementation
-- -----------------------------------------------------
SELECT Registered.registered_id as Registered_id, Registered.last_name as 'Last Name', Registered.first_name as 'First Name', 
max(total_time) as 'Total Time Spend', Topics.topic_tag as Topic 
FROM Registered
JOIN SpendTime on Registered.registered_id = SpendTime.registered_id 
JOIN Topics on SpendTime.topic_id = Topics.topic_id 
GROUP BY Topic, Registered_id, Registered.last_name, Registered.first_name 
ORDER BY Registered_id;
-- -----------------------------------------------------
-- Business requirement #3 Output
-- -----------------------------------------------------
-- '1','Pillio','Alice','100','pets'
-- '1','Pillio','Alice','10','games'
-- '2','Wang','Bob','58','housing'
-- '3','Li','Trudi','400','news'
-- '4','Johnson','Jeff','35','games'
-- '5','Forbis','Mevin','58','helper'
-- '7','Taylor','Tome','45','beautity'
-- '8','Wood','Obmar','325','news'
-- '11','Ruan','Xabi','90','games'
-- '13','Jhonson','Henry','120','news'



-- -----------------------------------------------------
-- Business requirement #4 implementation
-- -----------------------------------------------------
SELECT PostingGroupUser.posting_user_id AS Posting_user_id, Registered.last_name AS 'Last Name', 
		Registered.first_name AS 'First Name', COUNT(GroupPost.post_id)
       FROM PostingGroupUser
       JOIN Registered ON Registered.registered_id = PostingGroupUser.registered_id 
       JOIN GroupPost ON GroupPost.posting_user_id = PostingGroupUser.posting_user_id 
       GROUP BY Posting_user_id, Registered.registered_id, Registered.first_name, Registered.last_name;
-- -----------------------------------------------------
-- Business requirement #4 Output
-- -----------------------------------------------------
-- '2','Taylor','Tome','1'
-- '3','Wood','Obmar','1'
-- '4','Smith','Jone','1'
-- '5','White','Lucy','1'
-- '7','He','Emma','1'
-- '8','Jhonson','Henry','1'



-- -----------------------------------------------------
-- Business requirement #5 implementation
-- -----------------------------------------------------
SELECT R.registered_id AS 'Registered ID', R.last_name AS 'Last Name', R.first_name AS 'First Name', 
	(SELECT COUNT(Interested.interest_id) FROM Interested WHERE Interested.registered_id = R.registered_id) AS 'Number Of Interested Topics', 
    SUM(S.total_time) AS 'Total Time On Interested Topics' 
    FROM Registered R 
    JOIN SpendTime S ON R.registered_id = S.registered_id 
    JOIN Interested I ON I.registered_id = R.registered_id 
    WHERE I.topic_id = S.topic_id 
    GROUP BY R.registered_id, S.registered_id, R.first_name, R.last_name;
-- -----------------------------------------------------
-- Business requirement #5 Output
-- -----------------------------------------------------
-- '1','Pillio','Alice','2','100'
-- '2','Wang','Bob','1','58'
-- '4','Johnson','Jeff','1','35'
-- '7','Taylor','Tome','1','45'
-- '8','Wood','Obmar','2','325'
-- '11','Ruan','Xabi','1','90'
-- '13','Jhonson','Henry','2','120'



-- -----------------------------------------------------
-- Business requirement #6 implementation
-- -----------------------------------------------------
SELECT R.registered_id AS 'Registered ID', R.last_name AS 'Last Name', R.first_name AS 'First Name', 
	(SELECT COUNT(Comments.comment_id) FROM Comments WHERE Comments.registered_id = R.registered_id) AS 'Number Of Comments', 
    COUNT(GP.post_id) AS 'Number Of Posts' 
    FROM Registered R 
    JOIN GeneralPost GP ON R.registered_id = GP.registered_id 
    GROUP BY R.registered_id, GP.registered_id, R.first_name, R.last_name;
-- -----------------------------------------------------
-- Business requirement #6 Output
-- -----------------------------------------------------
-- '1','Pillio','Alice','0','1'
-- '6','Smith','Lena','3','1'
-- '7','Taylor','Tome','1','1'
-- '9','Smith','Jone','1','1'



-- -----------------------------------------------------
-- Business requirement #7 implementation
-- -----------------------------------------------------
SET @topic_id = 1;
SELECT @topic_id AS 'Topic ID', number_posts AS 'Original Number of Post' FROM Topics WHERE topic_id = @topic_id;
UPDATE Topics SET number_posts = 0 WHERE topic_id = @topic_id;
SELECT @topic_id AS 'Topic ID', number_posts AS 'Number of Post Set To 0' FROM Topics WHERE topic_id = @topic_id;
-- 
INSERT INTO Post (post_id, post_date, is_general, is_special, is_group, transmits, likes, dislikes, content) VALUES 
(100, '2022-03-08', 1, 0, 0, 10, 20, 5, 'This is a test general post!');

INSERT INTO Tagged (tagged_id, topic_id, post_id) VALUES (100, 1, 100);

SELECT @topic_id AS 'Topic ID', number_posts AS 'Number of Post After Insert' FROM Topics WHERE topic_id = @topic_id;
-- -----------------------------------------------------
-- Business requirement #7 Output
-- -----------------------------------------------------
-- Since the Trigger after insert only increment the number_posts by 1, we set the number_posts to 0 before insert and 
-- the number_posts became 3 after inserts.
-- This means the trigger before insert works and update the number_posts to 2 before insert.
-- original data: '1','2'
-- reseting data: '1','0'
-- result after insert:'1','3'



-- -----------------------------------------------------
-- Business requirement #8 implementation
-- -----------------------------------------------------
SET @post_id = 1;
SET @registered_id = 5;
SELECT @post_id AS 'Post ID', number_comments AS 'Original Number of comments' FROM Post WHERE post_id = @post_id;
UPDATE Post SET number_comments = 0 WHERE post_id = @post_id;
SELECT @post_id AS 'Post ID', number_comments AS 'Number of comments Set To 0' FROM Post WHERE post_id = @post_id;

INSERT INTO Comments (comment_id, post_id, registered_id, content) VALUES (100, @post_id, @registered_id, 'This is a test comment!');

SELECT @post_id AS 'Post ID', number_comments AS 'Number of comments After Insert' FROM Post WHERE post_id = @post_id;
-- -----------------------------------------------------
-- Business requirement #8 Output
-- -----------------------------------------------------
-- Since the Trigger after insert only increment the number_comments by 1, we set the number_comments to 0 before insert and 
-- the number_comments became 3 after inserts.
-- This means the trigger before insert works and update the number_comments to 2 before insert.
-- original data: '1','2'
-- reseting data: '1','0'
-- result after insert:'1','3'



-- -----------------------------------------------------
-- Business requirement #9 implementation
-- -----------------------------------------------------
SET @topic_name = 'helper';
SET @topic_id = (SELECT topic_id FROM Topics WHERE topic_tag = @topic_name);
CALL number_comments(@topic_id, @number_of_comments);
SELECT @topic_id AS 'Topic ID', @topic_name AS 'Topic Name', @number_of_comments AS 'Number of Posts';
-- -----------------------------------------------------
-- Business requirement #9 Output
-- -----------------------------------------------------
-- '5','helper','1'



-- -----------------------------------------------------
-- Business requirement #10 implementation
-- -----------------------------------------------------
SET @post_id = 5;
CALL number_comments(@post_id, @number_of_posts);
SELECT @post_id AS 'Post ID', Post.content AS 'Post Content', @number_of_posts AS 'Number of Comments'
	FROM Post
    WHERE Post.post_id = @post_id;
-- -----------------------------------------------------
-- Business requirement #10 Output
-- -----------------------------------------------------
-- '5','Roger from Concord needs help!','1'



-- -----------------------------------------------------
-- Business requirement #11 implementation
-- -----------------------------------------------------
SELECT Registered.registered_id AS Registered_ID, Registered.last_name AS 'Last Name', 
		Registered.first_name AS 'First Name', (SELECT compute_groups(Registered_ID)) AS Number_of_Groups 
	   FROM Registered 
       HAVING Number_of_Groups > 0 
       ORDER BY Registered_ID;
-- -----------------------------------------------------
-- Business requirement #11 Output
-- -----------------------------------------------------
-- '2','Wang','Bob','1'
-- '3','Li','Trudi','1'
-- '4','Johnson','Jeff','2'
-- '5','Forbis','Mevin','1'
-- '6','Smith','Lena','2'
-- '7','Taylor','Tome','1'
-- '8','Wood','Obmar','2'
-- '9','Smith','Jone','1'
-- '10','White','Lucy','1'
-- '11','Ruan','Xabi','1'
-- '12','He','Emma','1'
-- '13','Jhonson','Henry','2'
-- '14','Huang','Mason','1'
-- '15','Peterson','Sophia','1'


        
-- -----------------------------------------------------
-- Business requirement #12 implementation
-- -----------------------------------------------------
SET @is_special = 1;
SET @is_reigster = 0;
SELECT Registered.registered_id AS ID, @is_reigster AS 'Is_special', Registered.last_name AS 'Last Name', 
		Registered.first_name AS 'First Name', (SELECT compute_posts(ID, @is_reigster)) AS Number_of_Posts 
	   FROM Registered 
       HAVING Number_of_Posts > 0 
       
UNION
SELECT SpecialUser.special_user_id AS ID, @is_special AS 'Is_special', SpecialPerson.last_name AS 'Last Name', 
		SpecialPerson.first_name AS 'First Name', (SELECT compute_posts(ID, @is_special)) AS Number_of_Posts 
	   FROM SpecialUser 
       JOIN SpecialPerson ON SpecialUser.person_id = SpecialPerson.person_id 
       HAVING Number_of_Posts > 0 
       ORDER BY ID;
-- -----------------------------------------------------
-- Business requirement #12 Output
-- -----------------------------------------------------        
-- '1','0','Pillio','Alice','1'
-- '1','1','Lee','Helen','1'
-- '2','0','Wang','Bob','1'
-- '2','1','Sanguan','Shin','1'
-- '3','0','Li','Trudi','1'
-- '3','1','Shaw','Justin','1'
-- '4','0','Johnson','Jeff','1'
-- '4','1','Gates','Kevin','1'
-- '5','0','Forbis','Mevin','1'
-- '5','1','White','Robert','2'
-- '6','0','Smith','Lena','1'
-- '7','0','Taylor','Tome','2'
-- '8','0','Wood','Obmar','1'
-- '9','0','Smith','Jone','1'



-- -----------------------------------------------------
-- Business requirement #13 implementation
-- -----------------------------------------------------
SELECT comment_id AS 'Comment ID', number_replies AS 'Number Of Replies' FROM Comments;
WITH testTable AS (SELECT Reply.comment_id AS Comment_id, COUNT(Reply.reply_id) AS Counts FROM Reply GROUP BY Reply.comment_id) 
-- Before UPDATE, the number_replies are all default value, 0.
-- After UUPDATE, the number_replies are corresponding value of number_of_replies under each comment.
UPDATE Comments 
    JOIN testTable ON Comments.comment_id = testTable.comment_id 
    SET Comments.number_replies =  testTable.Counts;   

SELECT comment_id AS 'Comment ID', number_replies AS 'Number Of Replies' FROM Comments;
-- -----------------------------------------------------
-- Business requirement #13 Output
-- -----------------------------------------------------
-- Before Update
-- '1','0'
-- '2','0'
-- '3','0'
-- '4','0'
-- '5','0'
-- '6','0'
-- '7','0'
-- '8','0'
-- '9','0'
-- '10','0'
-- '11','0'
-- '12','0'
-- '13','0'
-- '14','0'
-- '15','0'
-- '16','0'
-- '100','0'

-- After Update
-- '1','2'
-- '2','0'
-- '3','0'
-- '4','0'
-- '5','1'
-- '6','1'
-- '7','1'
-- '8','1'
-- '9','1'
-- '10','1'
-- '11','1'
-- '12','1'
-- '13','1'
-- '14','1'
-- '15','0'
-- '16','0'
-- '100','0'



-- -----------------------------------------------------
-- Business requirement #14 implementation
-- -----------------------------------------------------
SELECT group_id AS 'Group ID', number_users AS 'Number Of Users', number_posts AS 'Number Of Posts' FROM Group_s;
WITH testUsers AS (SELECT JoinGroup.group_id AS Group_ID, COUNT(JoinGroup.registered_id) AS Number_Users 
					FROM JoinGroup 
					GROUP BY Group_ID)
-- Before UPDATE, the number_users are all default value, 0.
-- After UUPDATE, the number_users are corresponding value of number_users in each group.
UPDATE Group_s 
	JOIN testUsers ON Group_s.group_id = testUsers.Group_ID 
    SET Group_s.number_users = testUsers.Number_Users;                     

WITH testPosts AS (SELECT Group_s.group_id AS Groupid, COUNT(GroupPost.post_id) AS NumberUsers  
					FROM Group_s 
                    JOIN PostingGroup ON Group_s.group_id = PostingGroup.group_id 
                    JOIN GroupPost ON PostingGroup.posting_group_id = GroupPost.posting_group_id
                    GROUP BY GroupPost.posting_group_id, PostingGroup.group_id, Group_s.group_id, GroupPost.posting_group_id)  
-- Before UPDATE, the number_posts are all default value, 0.
-- After UUPDATE, the number_posts are corresponding value of number_posts of each group.
UPDATE Group_s 
	JOIN testPosts ON Group_s.group_id = testPosts.Groupid 
    SET Group_s.number_posts = testPosts.NumberUsers;      

SELECT group_id AS 'Group ID', number_users AS 'Number Of Users', number_posts AS 'Number Of Posts' FROM Group_s;
-- -----------------------------------------------------
-- Business requirement #14 Output
-- -----------------------------------------------------
-- Before Update
-- '1','0','0'
-- '2','0','0'
-- '3','0','0'
-- '4','0','0'
-- '5','0','0'
-- '6','0','0'

-- After Update
-- '1','3','0'
-- '2','3','0'
-- '3','3','0'
-- '4','3','2'
-- '5','3','2'
-- '6','3','2'



-- -----------------------------------------------------
-- Business requirement #15 implementation
-- -----------------------------------------------------
SELECT * FROM Search;
SELECT * FROM Accounts;
SET @user_id = 1;
DELETE FROM GeneralUser WHERE user_id = @user_id;
SELECT * FROM Search;
SELECT * FROM Accounts;
-- -----------------------------------------------------
-- Business requirement #15 Output
-- -----------------------------------------------------
-- Search table befor Delete ON GeneralUser
-- '1','1','pets'
-- '2','1','guinea pig'
-- '3','2','travel'

-- Search table after Delete ON GeneralUser
-- '3','2','travel'

-- Accounts table befor Delete ON GeneralUser
-- '1','1',NULL,'1','1'
-- '2','4',NULL,'2','4'
-- '3','6',NULL,'3','3'
-- '4','7',NULL,NULL,'3'
-- '5','10',NULL,NULL,'7'
-- '6','11',NULL,NULL,'5'
-- '7','12',NULL,NULL,'2'
-- '8','13',NULL,NULL,'5'
-- '9','15',NULL,NULL,'6'
-- '10','16',NULL,NULL,'4'
-- '11','17',NULL,NULL,'1'
-- '12','18',NULL,NULL,'2'
-- '13','19',NULL,NULL,'4'
-- '14','20',NULL,NULL,'6'
-- '15','21',NULL,NULL,'3'
-- '16',NULL,'1',NULL,'1'
-- '17',NULL,'2',NULL,'2'
-- '18',NULL,'3',NULL,'4'
-- '19',NULL,'4',NULL,'6'
-- '20',NULL,'5',NULL,'3'

-- Accounts table after Delete ON GeneralUser
-- '2','4',NULL,'2','4'
-- '3','6',NULL,'3','3'
-- '4','7',NULL,NULL,'3'
-- '5','10',NULL,NULL,'7'
-- '6','11',NULL,NULL,'5'
-- '7','12',NULL,NULL,'2'
-- '8','13',NULL,NULL,'5'
-- '9','15',NULL,NULL,'6'
-- '10','16',NULL,NULL,'4'
-- '11','17',NULL,NULL,'1'
-- '12','18',NULL,NULL,'2'
-- '13','19',NULL,NULL,'4'
-- '14','20',NULL,NULL,'6'
-- '15','21',NULL,NULL,'3'
-- '16',NULL,'1',NULL,'1'
-- '17',NULL,'2',NULL,'2'
-- '18',NULL,'3',NULL,'4'
-- '19',NULL,'4',NULL,'6'
-- '20',NULL,'5',NULL,'3'


-- -----------------------------------------------------
-- Business requirement #16 implementation
-- -----------------------------------------------------
SELECT * FROM DMGroupUser;
SELECT * FROM PostingGroupUser;
SET @register_id = 13;
DELETE FROM Registered WHERE registered_id = @register_id;
SELECT * FROM DMGroupUser;
SELECT * FROM PostingGroupUser;
-- -----------------------------------------------------
-- Business requirement #16 Output
-- -----------------------------------------------------
-- DMGroupUser table before Delete ON GeneralUser
-- '1','2'
-- '2','3'
-- '3','4'
-- '4','5'
-- '5','6'
-- '6','13'
-- '7','14'
-- '8','15'

-- DMGroupUser table after Delete ON GeneralUser
-- '1','2'
-- '2','3'
-- '3','4'
-- '4','5'
-- '5','6'
-- '7','14'
-- '8','15'

-- PostingGroupUser table before Delete ON GeneralUser
-- '1','6'
-- '2','7'
-- '3','8'
-- '4','9'
-- '5','10'
-- '6','11'
-- '7','12'
-- '8','13'

-- PostingGroupUser table after Delete ON GeneralUser
-- '1','6'
-- '2','7'
-- '3','8'
-- '4','9'
-- '5','10'
-- '6','11'
-- '7','12'
