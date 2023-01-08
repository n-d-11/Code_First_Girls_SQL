------------------------------------------------------------------------------------------------------------------
-- Welcome to my SQL Project!
-- The 'holiday_lodges' DB contains details of my Winter Holiday Lodges business. 
------------------------------------------------------------------------------------------------------------------

create database holiday_lodges;

use holiday_lodges;

-- table to store guest addresses
create table guest_addresses (
   address_ID INTEGER NOT NULL, 
   first_line VARCHAR(50) NOT NULL, 
   second_line VARCHAR(50), 
   town VARCHAR(50), 
   post_code VARCHAR(10) NOT NULL, 
   primary key (address_ID)
);

-- table to create guest names
create table guest_names (
   guest_ID INTEGER NOT NULL, 
   first_name VARCHAR(25) NOT NULL, 
   last_name VARCHAR(25) NOT NULL, 
   address_ID INTEGER NOT NULL,
   email_address VARCHAR(100) NOT NULL, 
   phone VARCHAR(20) NOT NULL, 
   primary key (guest_ID), 
   foreign key (address_ID) REFERENCES guest_addresses(address_ID)
);

-- information about the lodges where people can stay 
create table lodges (
   lodge_ID INTEGER NOT NULL,
   lodge_name VARCHAR(55) NOT NULL,
   treehouse BOOLEAN,
   bedrooms INTEGER(2) NOT NULL,
   guests INTEGER (2) NOT NULL, 
   price FLOAT(2) NOT NULL,
   features VARCHAR(55), 
   primary key (lodge_ID)
);
-- information about the bookings that have been made 
create table bookings (
   booking_ID INTEGER NOT NULL,
   date_booked DATE NOT NULL,
   guest_ID INTEGER NOT NULL,
   primary key (booking_ID), 
   foreign key (guest_ID) references guest_names(guest_ID)
);

-- table to store what lodges have been booked and when
create table booked_lodges(
    lodge_booking_id INT NOT NULL AUTO_INCREMENT, 
    lodge_ID INT NOT NULL, 
    arriving DATE NOT NULL, 
    departing DATE NOT NULL, 
    nights INT,
    booking_ID INT NOT NULL, 
    primary key (lodge_booking_id), 
    foreign key (lodge_ID) REFERENCES lodges(lodge_ID), 
    foreign key (booking_ID) REFERENCES bookings(booking_ID)
);

-- table for storing data on what activities have been booked and when
create table booked_activities(
	activities_booked_ID INT NOT NULL, 
    activity_ID INT NOT NULL, 
    date_of_activity DATE, 
    quantity INT NOT NULL, 
    booking_ID INT, 
    primary key (activities_booked_ID), 
    foreign key (activity_ID) REFERENCES activities(activity_ID), 
    foreign key (booking_ID) REFERENCES bookings(booking_ID)
);

-- what activities can be participated in during the stay
create table activities (
	activity_ID INTEGER NOT NULL,
    avtivity_name VARCHAR(50) NOT NULL,
    price FLOAT (2) NOT NULL,
    primary key (activity_ID)
);

-- realised a spelling mistake with my table 
alter table activities change avtivity_name activity_name VARCHAR(50) NOT NULL;

-- this is the section where data has been entered into the tables
insert into activities
(activity_ID, avtivity_name, price)
values 
(1, 'Meet & Greet Santa', 50.00),
(2, 'Wreath Making', 30.00),
(3, 'Design a Stocking', 15.00),
(4, 'Festive Trail', 10.00),
(5, 'Breakfast with Elves', 25.00)

insert into bookings
(booking_ID, date_booked, guest_ID)
values
(1, '2022-01-01', 47),
(2, '2022-01-23', 9),
(3, '2022-02-02', 49),
(4, '2022-02-07', 41),
(5, '2022-03-01', 37), 
(6, '2022-03-02', 10),
(7, '2022-04-27', 26),
(8, '2022-05-08', 40),
(9, '2022-05-09', 8), 
(10, '2022-05-10', 18), 
(11, '2022-05-11', 1),
(12, '2022-05-16', 17),
(13, '2022-05-19', 31), 
(14, '2022-05-20', 21), 
(15, '2022-05-22', 46), 
(16, '2022-05-27', 20), 
(17, '2022-06-01', 45), 
(18, '2022-06-11', 3), 
(19, '2022-06-17', 40), 
(20, '2022-07-20', 31), 
(21, '2022-07-28', 50),
(22, '2022-08-08', 1),
(23, '2022-09-09', 47), 
(24, '2022-09-10', 7), 
(25, '2022-10-10', 17), 
(26, '2022-10-20', 46), 
(27, '2022-11-01', 8), 
(28, '2022-11-11', 28), 
(29, '2022-11-18', 11), 
(30, '2022-12-01', 47)

insert into booked_activities
(activities_booked_ID, activity_ID, date_of_activity, quantity, booking_ID)
values
(1, 1, '2022-12-12', 1, 1),
(2, 1, '2022-12-12', 2, 2),
(3, 2, '2022-12-12', 3, 5),
(4, 2, '2022-12-12', 1, 4),
(5, 5, '2022-12-13', 3, 4), 
(6, 3, '2022-12-13', 2, 13), 
(7, 4, '2022-12-13', 4, 15), 
(8, 4, '2022-12-13', 5, 15),  
(9, 1, '2022-12-13' 1, 16), 
(10, 2, '2022-12-14', 1, 17), 
(11, 3, '2022-12-14', 2, 18), 
(12, 1, '2022-12-12', 4, 21),
(13, 4, '2022-12-12', 3, 1),
(14, 1, '2022-12-14', 3, 19), 
(15, 2, '2022-12-14', 4, 20), 
(16, 1, '2022-12-15', 2, 21), 
(17, 3, '2022-12-15', 2, 22), 
(18, 1, '2022-12-15', 1, 23), 
(19, 1, '2022-12-15', 2, 24), 
(20, 2, '2022-12-16', 2, 25), 
(21, 2, '2022-12-17', 1, 26), 
(22, 4, '2022-12-17', 5, 27),
(23, 5, '2022-12-17', 2, 28), 
(24, 3, '2022-12-17', 4, 29), 
(25, 1, '2022-12-18', 3, 16), 
(26, 2, '2022-12-18', 2, 9), 
(27, 5, '2022-12-19', 2, 19), 
(28, 4, '2022-12-19', 4, 10), 
(29, 2, '2022-12-19', 4, 13), 
(30, 1, '2022-12-19', 5, 1),

-- other tables have been populated using Import Wizard 
-- see CSV files in the project folder

-- checking all tables have been populated correctly 

select * from activities;
select * from booked_activities; 
select * from booked_lodges;
select * from bookings;
select * from guest_addresses; 
select * from guest_names;  
select * from lodges; 