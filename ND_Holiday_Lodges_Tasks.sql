------------------------------------------------------------------------------------------------------------------
-- REQUIREMENT: Create a view
-- snapshot of revenue generated at any given point from the activities booked
-- can be used to determine differrent marketing strategies to take/ which ones have been successful etc
------------------------------------------------------------------------------------------------------------------

create view revenue_snapshot as
	select 
	ba.date_of_activity, ac.activity_name, ba.activities_booked_ID, ba.activity_ID, ba.quantity, ac.price as unit_price, ac.price * ba.quantity as revenue
	from 
	booked_activities ba
	inner join 
	activities ac on ba.activity_ID = ac.activity_ID

select * from revenue_snapshot

-- using revenue_snapshot for a query

select activity_name, max(revenue) 
from revenue_snapshot
group by activity_name

-- more complex view to find out who has booked multiple activities so we can provide them with a 10% discount on total paid for activities 

create view multiple_activities as
	select 
	ac.activity_name, ba.activities_booked_ID, ba.activity_ID, ba.quantity, ac.price, ba.quantity * ac.price as total_paid, b.booking_ID, b.guest_ID, count(gn.first_name), gn.last_name
	from 
	booked_activities ba
	inner join 
	activities ac on ba.activity_ID = ac.activity_ID
    inner join 
    bookings b on b.booking_ID = ba.booking_ID
    inner join
    guest_names gn on gn.guest_ID = b.guest_ID

select * from multiple_activities

-- use the above to find out who has booked more than 1 activity
    
select activity_name, first_name, count(first_name) from multiple_activities
group by activity_name, first_name
having count(first_name)>1

 -- creating a view to see full booking details
 
 create view full_booking_details as
	select b.booking_ID, b.date_booked, b.guest_ID, gn.first_name, gn.last_name, gn.address_ID, gn.email_address, gn.phone, bl.nights from bookings b
    inner join guest_names gn 
    on b.guest_ID = gn.guest_ID
    inner join booked_lodges bl
    on bl.booking_ID = b.booking_ID
 
select * from full_booking_details 

------------------------------------------------------------------------------------------------------------------
-- REQUIREMENT: Create a stored function
-- creating a function which will assign guests to a particular VIP status (Gold, Silver, Bronze) based on the number 
-- of nights they have booked with us 
------------------------------------------------------------------------------------------------------------------

DELIMITER //
create function VIP_status (nights INT)
returns varchar(20)
deterministic
begin
	declare guest_status varchar(20);
    if nights >=7 then
		set guest_status = 'Gold';
	elseif nights =6 then 
		set guest_status = 'Silver';
	elseif nights <=5 then 
		set guest_status = 'Bronze';
	end if;
    return (guest_status);
end// nights 
DELIMITER; 

select first_name, last_name, VIP_status(nights)
from full_booking_details

-- Creating function to provide 10% off for multiple activities booked 
-- I tried...
 
DELIMITER //
create function multiple_activites (price_before_discount float (2))
returns float(2) 
begin 
	declare price_after_discount float(2);
    set price_after_discount = price_before_discount - 10/100 * price_before_discount;
    return price_after_discount;
end//
DELIMITER ;

------------------------------------------------------------------------------------------------------------------
-- REQUIREMENT: create a trigger
-- I tried...
------------------------------------------------------------------------------------------------------------------

delimiter //
create trigger activitiesItem_Before_Insert
before insert on activities 
for each row 
begin
	set new.activity_name = CONCAT(UPPER(SUBSTRING(NEW.activity_name,1,1)),
							LOWER(SUBSTRING(NEW.activity_name FROM 2)));
end//
delimiter ; 

insert into activities 
(activity_ID, activity_name, price)
values
(6, 'nye fireworks', 20.00)

------------------------------------------------------------------------------------------------------------------
-- REQUIREMENT: Create a stored procedure
-- staff preparing the 'Breakfast with the Elves' activity need to know how many
-- people will be attending so they can prepare the tables/ decor accordingly 
-- and tell chefs what is required
------------------------------------------------------------------------------------------------------------------

delimiter //
create procedure breakfasts_needed ()
begin
	select  SUM(quantity)
	from multiple_activities 
	where multiple_activities.activity_name = 'Breakfast with Elves'
	and multiple_activities.date_of_activity = '2022-12-13';
end//
delimiter ;

call breakfasts_needed ();

-- staff preparing the 'Create a Stocking' activity need to know how many
-- people will be attending so they know how many materials are required and 
-- if any need to be ordered

delimiter //

create procedure stockings_needed ()
begin
	select  SUM(quantity)
	from multiple_activities 
	where multiple_activities.activity_name = 'Design a Stocking'
	and multiple_activities.date_of_activity = '2022-12-17';
end//
delimiter ;

call stockings_needed ();

-- staff preparing the 'Meet & Greet with Santa' activity need to know how many
-- people will be attending so they know how many preents are required and 
-- if any need to be ordered

delimiter //

create procedure  presents_required ()
begin
	select  SUM(quantity)
	from multiple_activities 
	where multiple_activities.activity_name = 'Meet & Greet Santa'
	and multiple_activities.date_of_activity = '2022-12-17';
end//
delimiter ;

call presents_required ();

------------------------------------------------------------------------------------------------------------------
-- REQUIREMENT: Example query with Group By
-- sadly, due to the snow fall and adverse weather conditions, the lodges with treehouses need to have some more maintanance done
-- need to find out which ones are booked so we can go and take a look
------------------------------------------------------------------------------------------------------------------

select l.lodge_ID, l.lodge_name, l.treehouse, bl.booking_ID, bl.arriving FROM lodges l
join booked_lodges bl
on l.lodge_ID = bl.lodge_ID
join guest_names gn
group by l.lodge_ID, l.lodge_name, l.treehouse, bl.booking_ID, bl.arriving
having
	l.treehouse = 1 -- this was boolean type
	and
	arriving = '2022-12-11';
    
-- potential customer has asked if there are any lodges available which are less than or equal to £65 per night

select lodge_name, lodge_ID, bedrooms, min(price) as lowest_price_available
from lodges
group by lodge_ID
having lowest_price_available <= 65.00

------------------------------------------------------------------------------------------------------------------
-- REQUIREMENT: create a subquery
-- we need to make sure that all of the visitors who have got a log burner booked in December have got 
-- a stock of wood for the burner, or else we will need to source some
-- Maintenance need to know how many more firewood logs to purchase from the supplier
-- each log burner requires one bag
-- therefore, need to know how many lodges have log burners to purchase accordingly
------------------------------------------------------------------------------------------------------------------

select count(lodge_ID)
from booked_lodges
where lodge_ID in (
	select lodge_ID from lodges
	where features = 'log burner'
); 
