Create Database Ola;
Use Ola;

#1. Retrieve all succesful boolings:
Create View Successful_Bookings As
SELECT * FROM bookings
WHERE Booking_Status = 'Success';

#1. Retrieve all succesful bookings:
Select * From Successful_Bookings;

#2.Find the average ride distance for each vehicle type:
Create View ride_distance_for_each_vehicle As
SELECT Vehicle_Type, AVG(Ride_Distance)
as avg_distance FROM bookings
GROUP BY Vehicle_Type;

#2.Find the average ride distance for each vehicle type:
Select * from ride_distance_for_each_vehicle;

#3.get the total number of cancle rides by customers:
Create View  canceled_rides_by_customers As
SELECT COUNT(*) FROM bookings
WHERE Booking_Status = 'Canceled by Customer';

#3.get the total number of cancle rides by customers:
 select * from canceled_rides_by_customers;

#4.List the top 5 customers who booked the highest number of rides:
Create View Top_5_Customers As
SELECT Customer_ID, COUNT(Booking_ID) as total_rides
FROM bookings
GROUP BY Customer_ID
ORDER BY total_rides DESC LIMIT 5;  

Select * from Top_5_Customers;

#5.Get the number of rides canceled by driver due to personal and car-related issues:
Create View Rides_Canceled_by_Drivers_P_C_Issues As
SELECT COUNT(*) FROM bookings
WHERE Canceled_Rides_by_Driver = 'Personal & Car related issue';

select * from Rides_canceled_by_Drivers_P_C_Issues;

#6.Finds the maximum and minimum driver ratings from prime sedan bookings:
Create View MAX_MIN_Driver_Rating As
SELECT 
    MAX(Driver_Ratings) AS max_rating,
    MIN(Driver_Ratings) AS min_rating
FROM bookings
WHERE Vehicle_Type = 'Prime Sedan';

select * from Max_Min_Driver_Rating;

#7.Retrieve all rides where payments was made using upi:
Create View UPI_Payment As
SELECT * FROM bookings
WHERE Payment_Method = 'UPI';

select * from UPI_Payment;

#8.Find the average customer rating per vehicle type:
Create View AVG_cust_Rating As
SELECT Vehicle_Type, AVG(Customer_Rating) as avg_customer_rating
FROM bookings
GROUP BY Vehicle_Type;

select * from AVG_Cust_Rating;

#9.calculate the total booking value of rides completed successfully:
Create View total_successful_ride_value As
SELECT 
SUM(Booking_Value) AS total_successful_ride_value
FROM bookings
WHERE Booking_Status = 'Success';

select * from total_successful_ride_value;

#10. List All the incomplete rides along with the reason:
Create View Incomplete_Rides_Reason As
SELECT Booking_Id, Incomplete_Rides_Reason
FROM bookings
WHERE Incomplete_Rides = 'Yes';

select * from Incomplete_Rides_Reason;


