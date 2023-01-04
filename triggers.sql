-- USE a48FYmxc8H;
USE BlogManagementDB;

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

