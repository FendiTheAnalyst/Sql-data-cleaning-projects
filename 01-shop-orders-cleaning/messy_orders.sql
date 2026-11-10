-- =====================================================
-- SQL DATA CLEANING PROJECT: messy_orders
-- Run this whole script in MySQL Workbench to load the data.
-- Every column is VARCHAR on purpose (the "wrong data types" problem).
-- No primary key, so exact duplicate rows are allowed.
-- =====================================================

CREATE DATABASE IF NOT EXISTS cleaning_project;
USE cleaning_project;

DROP TABLE IF EXISTS messy_orders;

CREATE TABLE messy_orders (
    order_id      VARCHAR(20),
    customer_name VARCHAR(100),
    email         VARCHAR(100),
    phone         VARCHAR(30),
    city          VARCHAR(50),
    product       VARCHAR(100),
    category      VARCHAR(50),
    quantity      VARCHAR(20),
    unit_price    VARCHAR(30),
    order_date    VARCHAR(30),
    status        VARCHAR(20)
);

INSERT INTO messy_orders VALUES
('1001','Adaeze Okafor','adaeze.okafor@mail.com','08031234567','Lagos','Rice 50kg','Groceries','2','45000','2026-01-05','Delivered'),
('1002','  chinedu eze','Chinedu.Eze@mail.com ','0803 987 6543','lagos','Phone Charger','Electronics','1','3500.00','05/01/2026','delivered'),
('1003','FATIMA BELLO','fatima.bello@mail.com','+2348051112222','Abuja','Blender','Appliances','1','28000','Jan 7, 2026','Delivered'),
('1004','Tunde Adeyemi',NULL,'08024445555','Ibadan','Bluetooth Speaker','electronics','2','NGN 12,000','2026-01-08','Shipped'),
('1005','Ngozi Nwosu','ngozi.nwosu@mail','07066667777','Port Harcourt','Rice 50kg','Groceries','one','45000','08/01/2026','Delivered'),
('1006','Emeka Obi','emeka.obi@mail.com','','Lgos','Office Chair','Furniture','1','65000','2026/01/10','Pending'),
('1007','Aisha Mohammed','aisha.m@mail.com','09012345678','Kano','Cooking Oil 5L','Groceries','3','8500','10 January 2026','Delivered'),
('1008','Segun Balogun','segun.balogun@mail.com','08133334444','LAGOS','Notebook (Pack of 10)','Stationery','5','2500','11-Jan-2026','Delivered'),
('1009','Blessing Udo','blessing.udo@mail.com','08055556666','Abudja','Phone Charger','Electrnics','2','3500','2026-01-12','Cancelled'),
('1010','Ibrahim Sani','ibrahim.sani@mail.com','07088889999','abuja','Blender','Appliances','1','28000','12/01/2026','Delivered'),
('1011','Folake Johnson','folake.j@mail.com','08099990000','Ibadan','rice 50kg','groceries','2','45000','2026-01-14','Canceled'),
('1012','Kelechi Onu',NULL,'08021112233','Enugu','Bluetooth Speakr','Electronics','1','12000','Jan 15, 2026','Delivred'),
('1013','Yusuf Garba','yusuf.garba@mail.com','N/A','kano','Office Chair','Furniture','2','65000','15/01/2026','Shipped'),
('1014','Chioma Eze','chioma.eze@mail.com','08144445555','Port-Harcourt','Cooking Oil 5L','Groceries','','8500','2026-01-16','Delivered'),
('1015','Oluwaseun Ade','seun.ade@mail.com','08166667777','Lagos ','Notebook (Pack of 10)','Stationery','4','2500','16 January 2026','Delivered'),
('1016','Hauwa Lawal','hauwa.l@mail.com','09077778888','Kano','Rice 50 kg','Groceries','1','45000','17-Jan-2026','Pending'),
('1017','Victor Okoro','victor.okoro@mail.com','08033332222','PH','Phone Charger','Electronics','3','$5','2026-01-18','Delivered'),
('1018','Amina Yakubu','amina.y@mail.com','08099887766','Abuja','Blender','Appliances','-1','28000','18/01/2026','Cancelled'),
('1019','Damilola Fashola','dami.fashola@mail.com','08122223333','Lagos','Office Chair','Furniture','1','65000','2026/01/20','Shipped'),
('1020','peter nnamdi','PETER.NNAMDI@MAIL.COM','08055554444','Enugu','Cooking Oil 5L','Groceries','2','8500','Jan 21, 2026','delivered'),
('1021','Rukayat Bello','rukayat.b@mail.com','07011112222','Ibadan','Bluetooth Speaker','Electronics','2','12000','21/01/2026','Delivered'),
('1022','Obinna Eze','obinna.eze@mail.com','08077776666','Lagos','Rice 50kg','Groceries','2','45000','22-Jan-2026','DELIVERED'),
('1023','Zainab Musa','zainab.musa@mail.com','','Kano','Notebook (Pack of 10)','Stationery','three','2500','2026-01-23','Delivered'),
('1024','Tobi Adebayo','tobi.a@mail.com','08188889999','Lagos','Phone Charger','Electronics','1','3500','23 January 2026','Shipped'),
('1025','Grace Effiong','grace.effiong@mail.com','08011223344','Port Harcourt','Blender','Appliances','1','2800000','2026-01-25','Delivered'),
('1026','Mustapha Aliyu','mustapha.a@mail.com','09099887711','Abuja','Cooking Oil 5L','Groceries','4','8500','25/01/2026','Pending'),
('1027','Ifeoma Nwankwo','ifeoma.n@mail.com',NULL,'Enugu','Office Chair','Furniture','1','NGN 65,000','Jan 27, 2026','Delivered'),
('1028','  Sunday Okon','sunday.okon@mail.com','08066665555','Lagos','Rice 50kg','Groceries','2','45000','2026-01-28','Delivered'),
-- ---- exact duplicates and near duplicates ----
('1001','Adaeze Okafor','adaeze.okafor@mail.com','08031234567','Lagos','Rice 50kg','Groceries','2','45000','2026-01-05','Delivered'),
('1003','fatima bello ','Fatima.Bello@mail.com','+2348051112222','abuja','blender','Appliances','1','28000','Jan 7, 2026','delivered'),
('1010','Ibrahim Sani','ibrahim.sani@mail.com','07088889999','abuja','Blender','Appliances','1','28000','12/01/2026','Delivered'),
('1010','Ibrahim Sani','ibrahim.sani@mail.com','07088889999','abuja','Blender','Appliances','1','28000','12/01/2026','Delivered'),
('1019','Damilola Fashola','dami.fashola@mail.com','08122223333','Lagos','Office Chair','Furniture','1','65000','2026/01/20','Shipped'),
-- ---- more rows with missing values ----
('1029',NULL,'anon1@mail.com','08000000001','Lagos','Phone Charger','Electronics','1','3500','2026-01-30','Delivered'),
('1030','Halima Dauda','halima.d@mail.com','08000000002','','Cooking Oil 5L','Groceries','2','8500','30/01/2026','Delivered'),
('1031','Chidi Anozie','chidi.a@mail.com','08000000003','Enugu','Notebook (Pack of 10)',NULL,'6','2500','Feb 1, 2026','Delivered'),
('1032','Bola Tinubu Jr','bola.j@mail.com','08000000004','Lagos','Bluetooth Speaker','Electronics','1','unknown','2026-02-02','Pending'),
('1033','Latifat Ojo','latifat.ojo@mail.com','08000000005','Ibadan','Rice 50kg','Groceries','1','45000',NULL,'Shipped'),
('1034','Philip Ekong','philip.e@mail.com','08000000006','Port Harcourt','Office Chair','Furniture','1','65000','03/02/2026','');
