create table appleStore_description_combined AS
Select * from appleStore_description1

union all 

select * from appleStore_description2

union all 

select * from appleStore_description3

union ALL

select * from appleStore_description4

--check the number of unique apps in both tables(to identify missing data)

select count(distinct id) as uniqueappIDs
from AppleStore

select count(distinct id) as uniqueappIds
from appleStore_description_combined

--check if any missing values in some key fieldsAppleStore

select count(*) as missingvalues
from AppleStore
where track_name is null OR user_rating is null OR prime_genre is NULL

select count(*) as missingvalues
from appleStore_description_combined
where app_desc is null 

--find out number of apps per genre

select prime_genre , COUNT(*) as num_apps
from AppleStore
group by prime_genre
ORDER by num_apps DESC

--get an overview of app's ratings

select min(user_rating) as min_user_rating,
       max(user_rating) as max_user_rating,
       avg(user_rating) as avg_user_rating
 From AppleStore     
 
 --determine whether paid apps have higher ratingsAppleStore
 
 SELECT CASE
            when price > 0 then "paid"
            else "free"
            END as app_type,
            avg(user_rating) as avg_user_rating
from AppleStore
GROUP by app_type
      
--apps that support multiple languages have higher rating

SELECT case
            when lang_num < 10 then "<10languages"
            when lang_num BETWEEN 10 AND 30 then "10-30languages"
            else ">30languages"
            end as lang_data,
            avg(user_rating) as avg_rating
from AppleStore
GROUP by lang_data
order by avg_rating desc

--check genre with low ratings

select prime_genre,  avg(user_rating) as avg_rating
from AppleStore
GROUP by prime_genre
order by avg_rating asc
limit 10 

--check if there is correlation between length of the app description vs rating

SELECT case 
          when length(d.app_desc) < 500 then "short"
          when length(d.app_desc) BETWEEN 500 and 1000 then "medium"
          else "long"
          end as app_desc_len,  avg(user_rating) as avg_rating
from AppleStore as a
join appleStore_description_combined as d
on a.id = d.id
group by app_desc_len
order by avg_rating

--Data analysis/reccomendations
#Paid apps have higher ratings than free apps.
#Apps that supports anywhere between 10 to 30 languages have better ratings.
#Finance and Book apps have lower ratings.
#Apps that provide longer descriptions have better ratings 
#A new app should focus on getting their rating higher than 3.5 and above to stand out.

