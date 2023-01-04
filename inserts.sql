-- Script name: inserts.sql
-- Author:      Qin Geng
-- Purpose:     insert sample data into the Blog Management database system

-- the database used to insert the data into.
-- USE a48FYmxc8H;
USE BlogManagementDB;

-- MailingList table inserts
INSERT INTO MailingList (list_id, number_of_members, list_name) VALUES (1, 20, 'WeLog'), (2, 25, 'MicroWeb'), (3, 23, 'Vlog');

-- GeneralUser table inserts
INSERT INTO GeneralUser (user_id, email, ip_address) VALUES (1, 'alice@gmail.com', '192.168.33.123'), (2, 'joey@gmail.com', '192.168.33.136'), 
(3, 'tim@gmail.com', '192.168.55.123'), (4, 'bobwang@gmail.com', '192.168.45.89'), 
(5, 'chris@gmail.com', '192.168.45.79'), (6, 'trudili@gmail.com', '192.168.42.89'),
(7, 'jeff@gmail.com', '192.168.33.179'), (8, 'bjim@gmail.com', '192.168.33.112'), 
(9, 'lucy@gmail.com', '192.168.23.89'), (10, 'Mevin@gmail.com', '192.168.23.101'),
(11, 'Lena@gmail.com', '192.168.23.53'), (12, 'tom@gmail.com', '192.168.23.44'), 
(13, 'obmar@gmail.com', '192.168.23.59'), (14, 'ruby@gmail.com', '192.168.23.17'),
(15, 'jone@gmail.com', '192.168.23.18'), (16, 'lucywhite@gmail.com', '192.168.23.23'),
(17, 'xabi@gmail.com', '192.168.23.20'), (18, 'emma@gmail.com', '192.168.24.23'),
(19, 'henry@gmail.com', '192.168.24.18'), (20, 'mason@gmail.com', '192.168.24.29'), 
(21, 'sophia@gmail.com', '192.168.24.19');

-- JoinList table inserts
INSERT INTO JoinList (join_id, list_id, user_id) VALUES (1, 1, 1), (2, 1, 2), (3, 3, 2);

-- Search table inserts
INSERT INTO Search (search_id, user_id, keyword) VALUES (1, 1, 'pets'), (2, 1, 'guinea pig'), (3, 2, 'travel');

-- Queries table inserts
INSERT INTO Queries (query_id, query_type, related_table) VALUES (1, 'user query', 'Account'), (2, 'post query', 'Post'), (3, 'group query', 'Group');

-- SearchUse table inserts
INSERT INTO SearchUse (use_id, search_id, query_id) VALUES (1, 1, 2), (2, 2, 2), (3, 3, 2);

-- SpecialPerson table inserts
INSERT INTO SpecialPerson (person_id, first_name, last_name, special_type) VALUES 
(1, 'Helen', 'Lee', 'helper'), (2, 'Shin', 'Sanguan', 'helper'), (3, 'Justin', 'Shaw', 'helper'),
(4, 'Kevin', 'Gates', 'advertizer'), 
(5, 'Robert', 'White', 'news media');

-- SpecialUser table inserts
INSERT INTO SpecialUser (special_user_id, person_id, email) VALUES (1, 1, 'helenlee@gmail.com'), (2, 2, 'shin@gmail.com'), (3, 3, 'justin@gmail.com'), 
(4, 4, 'kevin@gmail.com'), (5, 5, 'robert@gmail.com');

-- Registered table inserts
INSERT INTO Registered (registered_id, user_id, username, passwords, first_name, last_name, address) VALUES 
(1, 1, 'alice@wonderland', ' ', 'Alice', 'Pillio', '1695 10th Ave, San Francisco, CA, 94122'), 
(2, 4, 'joker bob',  ' ', 'Bob', 'Wang', '1133 S Van Ness Ave, San Francisco, CA 94110'), 
(3, 6, 'hey trudi', ' ', 'Trudi', 'Li', '1212 Madison St, Albany, CA, 94706'),
(4, 7, 'smart jeff', ' ', 'Jeff', 'Johnson', '786 Red Oak Ave, Albany, CA, 94706'),
(5, 10, 'lucky mevin', ' ', 'Mevin', 'Forbis', '2412 Walnut Grove Ave, San Jose, CA 95128'),
(6, 11, 'lena002', ' ', 'Lena', 'Smith', '2371 Peachtree Ln, San Jose, CA 95128'),
(7, 12, 'Tom star', ' ', 'Tome', 'Taylor', '1467 Maria Ave, Concord, CA 94518'),
(8, 13, 'Ooobmar', ' ', 'Obmar', 'Wood', '2291 Pacheco St, Concord, CA 94520'),
(9, 15, 'Jones0', ' ', 'Jone', 'Smith', '25 Hacienda Cir, Orinda, CA 94563'),
(10, 16, 'Lucy8', ' ', 'Lucy', 'White', '7 North Ln, Orinda, CA 94563'),
(11, 17, 'xabi0', ' ', 'Xabi', 'Ruan', '1834 San Lorenzo Ave, Berkeley, CA 94707'),
(12, 18, 'emma_emma', ' ', 'Emma', 'He', '966 Jeanne Ave, San Jose, CA 95116'),
(13, 19, 'henry1', ' ', 'Henry', 'Jhonson', '201 S 22nd St, San Jose, CA 95116'),
(14, 20, 'mason00', ' ', 'Mason', 'Huang', '95 N Buena Vista Ave, San Jose, CA 95126'),
(15, 21, 'sophia3', ' ', 'Sophia', 'Peterson', '1445 San Juan Ave, Stockton, CA 95203');

-- Admin table inserts
INSERT INTO Admins (admin_id, registered_id) VALUES (1, 1), (2, 2), (3, 3);

-- Region table inserts
INSERT INTO Region (region_id, country, zone) VALUES (1, 'US', 'Atlantic'), (2, 'US', 'Eastern'), 
(3, 'US', 'Central'), (4, 'US', 'Mountain'), (5, 'US', 'Pacific'), (6, 'US', 'Alaska'), 
(7, 'US', 'Hawaii–Aleutian');

-- Accounts table inserts
INSERT INTO Accounts (account_id, user_id, special_user_id, admin_id, region_id) VALUES 
(1, 1, null, 1, 1), (2, 4, null, 2, 4), (3, 6, null, 3, 3), (4, 7, null, null, 3), 
(5, 10, null, null, 7), (6, 11, null, null, 5), (7, 12, null, null, 2), (8, 13, null, null, 5), 
(9, 15, null, null, 6), (10, 16, null, null, 4), (11, 17, null, null, 1), (12, 18, null, null, 2), 
(13, 19, null, null, 4), (14, 20, null, null, 6), (15, 21, null, null, 3), (16, null, 1, null, 1), 
(17, null, 2, null, 2), (18, null, 3, null, 4), (19, null, 4, null, 6), (20, null, 5, null, 3);

-- Roles table inserts
INSERT INTO Roles (role_id, role_name, descriptions) VALUES (1, 'registered', 'registered user'), (2, 'admin', 'backend admin, can delete post and users'), 
(3, 'DM Group User', 'can send message in DM groups'), (4, 'DM Adimin', 'Admin of DM group'), 
(5, 'Posting Group User', 'can also post in posting groups'), (6, 'Posting Admin', 'admin of posting group'), 
(7, 'Special User', 'can be a helper, advertizer, marketing, or news');

-- AccountUse table inserts
INSERT INTO AccountUse (account_use_id, account_id, role_id) VALUES (1, 1, 1), (2, 1, 2), (3, 2, 1),
(4, 3, 1), (5, 4, 1), (6, 4, 3), (7, 4, 4), (8, 5, 1), (9, 5, 3), (10, 6, 1), (11, 6, 3),
(12, 6, 5), (13, 6, 6), (14, 7, 1), (15, 7, 5), (16, 8, 1), (17, 8, 5), (18, 9, 1), (19, 10, 1), 
(20, 11, 7), (21, 12, 7), (22, 13, 7), (23, 14, 7), (24, 15, 7), (25, 16, 1), (26, 16, 5),
(27, 16, 6), (28, 17, 1), (29, 17, 5), (30, 18, 1), (31, 18, 3), (32, 18, 4), (33, 18, 5), 
(34, 19, 1), (35, 19, 3), (36, 20, 1), (37, 20, 3);

-- Post table inserts
INSERT INTO Post (post_id, post_date, is_general, is_special, is_group, transmits, likes, dislikes, content) VALUES 
(1, '2022-03-05', 1, 0, 0, 10, 20, 5, 'Beautiful dogs!'), (2, '2022-04-07', 1, 0, 0, 8, 18, 5, 'New Hairstyle!'), 
(3, '2022-04-23', 1, 0, 0, 15, 30, 15, 'House Deco!'), (4, '2022-03-08', 1, 0, 0, 6, 20, 5, 'Vedio games!'), 
(5, '2022-04-02', 0, 1, 0, 3, 18, 5, 'Roger from Concord needs help!' ), (6, '2022-04-09', 0, 1, 0, 7, 16, 9, 'Ryan and Rick from North Berkeley needs help!'), 
(7, '2022-04-13', 0, 1, 0, 7, 16, 9, 'Susan from San Francisco needs help!'), (8, '2022-05-02', 0, 1, 0, 3, 18, 5, 'Find your perfect WebLog tool!'), 
(9, '2022-05-18', 0, 1, 0, 7, 16, 9, 'COVID-19 Pandemic!'), (10, '2022-05-26', 0, 1, 0, 7, 16, 9, 'Russian and Ukrain!'),
(11, '2022-04-02', 0, 0, 1, 3, 18, 5, 'my dog'), (12, '2022-04-26', 0, 0, 1, 7, 16, 9, 'beautiful hairstyles'), 
(13, '2022-04-26', 0, 0, 1, 7, 16, 9, 'new house'), (14, '2022-04-15', 0, 0, 1, 4, 20, 3, 'beautiful flowers'), 
(15, '2022-04-26', 0, 0, 1, 7, 25, 7, 'my cats'), (16, '2022-04-26', 0, 0, 1, 3, 16, 3, 'new games');

-- Topics table inserts
INSERT INTO Topics (topic_id, topic_tag) VALUES (1, 'news'), (2, 'pets'), 
(3, 'beautity'), (4, 'ads'), (5, 'helper'), (6, 'marketing'), (7, 'housing'), (8, 'games');

-- Tagged table inserts
INSERT INTO Tagged (tagged_id, topic_id, post_id) VALUES (1, 2, 1 ), (2, 3, 2), (3, 7, 3), (4, 8, 4 ), 
(5, 5, 5), (6, 5, 6), (7, 5, 7), (8, 4, 8), (9, 1, 9), (10, 1, 10), (11, 2, 11), (12, 3, 12), (13, 7, 13), 
(14, 3, 14), (15, 2, 15), (16, 8, 16);

-- GeneralPost table inserts
INSERT INTO GeneralPost (general_post_id, post_id, registered_id) VALUES 
(1, 1, 1), (2, 2, 6), (3, 3, 7), (4, 4, 9);

-- SpecialPost table inserts
INSERT INTO SpecialPost (special_post_id, post_id, special_user_id, category) VALUES 
(1, 5, 1, 'helper'), (2, 6, 2, 'helper'), (3, 7, 3, 'helper'), (4, 8, 4, 'ads'), (5, 9, 5, 'news'), (6, 10, 5, 'news');

-- HelpInfo table inserts
INSERT INTO HelpInfo (help_info_id, special_post_id) VALUES (1, 1), (2, 2), (3, 3);
    
-- HelpNeeder table inserts
INSERT INTO HelpNeeder (needer_id, first_name, last_name, email) VALUES (1, 'Rick', 'Novak', 'rick@gmail.com'), 
(2, 'Susan', 'Cornnor', 'susan@gmail.com'), (3, 'Roger', 'Lum', 'roger@gmail.com'), (4, 'Ryan', 'Novak', 'ryan@gmail.com');

-- HelpRelated table inserts
INSERT INTO HelpRelated (related_id, help_info_id, needer_id) VALUES 
(1, 1, 3), (2, 2, 1), (3, 2, 4), (4, 3, 2);

-- ContentStyle table inserts
INSERT INTO ContentStyle (style_id, type_name, size) VALUES 
(1, 'text', 1), (2, 'picture', 10), (3, 'video', 100), (4, 'gif', 10);

-- PostStyle table inserts
INSERT INTO PostStyle (pair_id, post_id, style_id) VALUES 
(1, 1, 1), (2, 2, 1), (3, 2, 2), (4, 3, 1), (5, 3, 3), (6, 4, 2), (7, 5, 1),
(8, 5, 4), (9, 6, 1), (10, 6, 2), (11, 7, 3), (12, 8, 4), (13, 9, 1), (14, 10, 2),
(15, 11, 3), (16, 12, 1), (17, 12, 2), (18, 13, 1), (19, 13, 4);


-- TechnicalStaff table inserts
INSERT INTO TechnicalStaff (technical_staff_id, staff_name, is_lead) VALUES 
(1, 'Mike Jun', 1), (2, 'Brian Howie', 0), (3, 'Joan Lao', 0), (4, 'Lisa Stone', 0);

-- Service table inserts
INSERT INTO Service (service_id, staff_id, technical_staff_id) VALUES 
(1, 2, 1), (2, 3, null), (3, 2, 1), (4, 4, 1);

-- Problem table inserts
INSERT INTO Problem (problem_id, registered_id, service_id, descriptions) VALUES 
(1, 3, 2, 'log in failed!'), (2, 9, 3, 'inappropriateness report!'), (3, 8, 2, 'image upload failed!'), 
(4, 10, 2, 'sign up failed!'), (5, 3, 1, 'nonrelavant posts report!'), (6, 8, 2, 'abuse post report!');
  
-- Bug table inserts
INSERT INTO Bug (bug_id, problem_id) VALUES (1, 1), (2, 3), (3, 4);

-- Notify table inserts
INSERT INTO Notify (notify_id, service_id, admin_id, descriptions) VALUES 
(1, 3, 1, 'inappropriateness report!'), (2, 1, 1, 'nonrelavant posts report!'), (3, 2, 1, 'abuse post report!');

-- BugType table inserts
INSERT INTO BugType (bug_type_id, title, urgency) VALUES 
(1, 'Functional errors!', 5), (2, 'Syntax errors', 3), (3, 'Logic errors', 5),
(4, 'Calculation errors', 4), (5, 'Unit-level errors', 4), (6, 'System-level integration errors', 5), 
(7, 'Out of bounds errors', 2);

-- Responsible table inserts
INSERT INTO Responsible (responsible_id, technical_staff_id, bug_type_id) VALUES 
(1, 1, 1), (2, 1, 5), (3, 2, 1), (4, 2, 3), (5, 3, 1), (6, 3, 6);

-- BugHave table inserts
INSERT INTO BugHave (have_id, bug_id, bug_type_id) VALUES 
(1, 1, 6), (2, 2, 1), (3, 2, 2), (4, 3, 3), (5, 3, 4);

-- SupportDevice table inserts
INSERT INTO SupportDevice (device_id, device_name, version) VALUES 
(1, 'cellphone', 'iphone'), (2, 'cellphone', 'android'), (3, 'pc', 'mac'), (4, 'pc', 'windows'), (5, 'pc', 'linux');

-- UserDevice table inserts
INSERT INTO UserDevice (user_device_id, device_id, registered_id) VALUES 
(1, 1, 1), (2, 3, 1), (3, 4, 2), (4, 2, 3), (5, 4, 3), (6, 5, 4), (7, 1, 5), 
(8, 1, 6), (9, 2, 6), (10, 3, 6), (11, 1, 7), (12, 2, 7), (13, 3, 8), (14, 4, 8),
(15, 1, 9), (16, 2, 10), (17, 3, 11), (18, 4, 11), (19, 1, 12), (20, 3, 12), (21, 5, 13),
(22, 4, 14), (23, 1, 15), (24, 2, 15), (25, 3, 15);

-- Interested table inserts
INSERT INTO Interested (interest_id, registered_id, topic_id) VALUES 
(1, 1, 2), (2, 1, 3), (3, 2, 7), (4, 3, null), (5, 4, 8), (6, 5, 7), (7, 6, 5), (8, 7, 3), 
(9, 8, 1), (10, 8, 8), (11, 9, 2), (12, 9, 3), (13, 10, 7), (14, 11, 8), (15, 12, 1), (16, 13, 1), 
(17, 13, 2), (18, 14, 7), (19, 14, 8), (20, 15, 5);

-- SpendTime table inserts
INSERT INTO SpendTime (time_id, registered_id, topic_id, spend_time, total_time) VALUES 
(1, 1, 2, 20, 100), (2, 1, 8, 1, 10), (3, 2, 7, 20, 58), (4, 3, 1, 30, 400), (5, 4, 8, 5, 35), 
(6, 5, 5, 10, 58), (7, 7, 3, 28, 45), (8, 8, 1, 25, 325), (9, 11, 8, 10, 90), (10, 13, 1, 22, 120) ;

-- Comments table inserts
INSERT INTO Comments (comment_id, post_id, registered_id, content) VALUES 
(1, 1, 6, 'so cute'), (2, 1, 13, 'I love it'), (3, 2, 12, 'looks nice'), (4, 5, 2, 'bless you'), 
(5, 6, 3, 'I want to help'), (6, 9, 5, 'Unbelievable'), (7, 9, 6, 'God bless you!'), (8, 11, 6, 'cute dog'), 
(9, 11, 7, 'sweet dog'), (10, 12, 8, 'look so nice!'), (11, 13, 8, 'nice house'), (12, 14, 8, 'really beautiful'), 
(13, 14, 9, 'I love flowers'), (14, 14, 10, 'where are these flowers?'), (15, 15, 12, 'nice cats'), (16, 16, 13, 'interesting game');

-- Group_s table inserts
INSERT INTO Group_s (group_id, group_name) VALUES 
(1, 'DM Group 1'), (2, 'DM Group 2'), (3, 'DM Group 3'), 
(4, 'Posting Group 1'), (5, 'Posting Group 2'), (6, 'Posting Group 3');

-- DMGroupUser table inserts
INSERT INTO DMGroupUser (dm_user_id, registered_id) VALUES 
(1, 2), (2, 3), (3, 4), (4, 5), (5, 6), (6, 13), (7, 14), (8, 15);

-- DMAdmin table inserts
INSERT INTO DMAdmin (dm_admin_id, dm_user_id) VALUES 
(1, 1), (2, 3), (3, 6);

-- DMGroup table inserts
INSERT INTO DMGroup (dm_group_id, group_id, dm_admin_id) VALUES 
(1, 1, 1), (2, 2, 2), (3, 3, 3);

-- PostingGroupUser table inserts
INSERT INTO PostingGroupUser (posting_user_id, registered_id) VALUES 
(1, 6), (2, 7), (3, 8), (4, 9), (5, 10), (6, 11), (7, 12), (8, 13);
  
-- PostingAdmin table inserts
INSERT INTO PostingAdmin (posting_admin_id, posting_user_id) VALUES 
(1, 1), (2, 5), (3, 6);

-- PostingGroup table inserts
INSERT INTO PostingGroup (posting_group_id, group_id, posting_admin_id) VALUES 
(1, 4, 1), (2, 5, 2), (3, 6, 3);

-- JoinGroup table inserts
INSERT INTO JoinGroup (join_id, group_id, registered_id) VALUES 
(1, 1, 2), (2, 1, 3), (3, 1, 4), (4, 2, 4), (5, 2, 5), (6, 2, 6), 
(7, 3, 13), (8, 3, 14), (9, 3, 15), (10, 4, 6), (11, 4, 7), (12, 4, 8),
(13, 5, 8), (14, 5, 9), (15, 5,10), (16, 6, 11), (17, 6, 12), (18, 6, 13);

-- GroupPost table inserts
INSERT INTO GroupPost (group_post_id, post_id, posting_user_id, posting_group_id) VALUES 
(1, 11, 2, 1), (1, 12, 3, 1), (3, 13, 4, 2), (4, 14, 5, 2), (5, 15, 7, 3), (6, 16, 8, 3);

-- Message table inserts
INSERT INTO Message (message_id, dm_group_id, dm_user_id, content) VALUES 
(1, 1, 1, 'Hi!'), (2, 1, 2, 'Hello!'), (3, 1, 3, 'Nice to meet you!'), (4, 1, 1, 'have a good day'), 
(5, 2, 3, 'nice wether'), (6, 2, 5, 'yes, sunny day'), (7, 2, 4, 'I love it'), (8, 2, 4, 'great'), 
(9, 3, 6, 'hello, guys'), (10, 3, 7, 'hello, everyone'), (11, 3, 8, 'good mornig'), (12, 3, 7, 'nice to meet you');

-- Reply table inserts
INSERT INTO Reply (reply_id, comment_id, registered_id, content) VALUES 
(1, 1, 8, 'I agree'), (2, 1, 9, 'I love it, too.'), (3, 5, 9, 'let us help'), (4, 6, 7, 'I cannot believe either.'), 
(5, 7, 3, 'god bless them'), (6, 8, 7, 'really cute'), (7, 9, 8, 'I love it!'), (8, 10, 6, 'yes, really good!'), 
(9, 11, 9, 'beautiful house'), (10, 12, 10, 'I think so!'), (11, 13, 8, 'I like flower too!'), (12, 14, 8, 'I have same question.');
