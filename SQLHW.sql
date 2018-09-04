SELECT * FROM sakila.actor;
Use sakila;

SELECT first_name,last_name from actor ;

SELECT  CONCAT(first_name,  '  ',  last_name) AS "Actor  Name"   FROM actor;
SELECT first_name,last_name,actor_id FROM actor
WHERE first_name = "JOE";
SELECT first_name,last_name  from actor 
WHERE last_name LIKE "%GEN%";

SELECT first_name from actor
WHERE last_name LIKE "%LI%"
ORDER by last_name and first_name  ASC;

SELECT country_id, country FROM country
WHERE country IN ('Afganistan','Bangladesh','China');

ALTER table actor
    Add column middle_name VARCHAR(30) AFTER first_name;
    
SELECT  * from actor LIMIT 5;
ALTER TABLE actor MODIFY COLUMN middle_name INTEGER;
ALTER TABLE actor DROP middle_name;

SELECT last_name, COUNT(last_name)
FROM actor
GROUP BY last_name LIMIT 10;

SELECT last_name , COUNT(last_name)
FROM actor
GROUP BY last_name
Having COUNT(last_name) >= 2;


UPDATE sakila.actor set first_name=REPLACE(first_name,'GROUCHO','HARPO') WHERE last_name='WILLIAMS';
UPDATE sakila.actor set first_name=REPLACE(first_name,'HARPO','GROUCHO');



/*5a locating the schema for the table address*/

show  databases;
show tables;
desc address;
/*6a      */              
use sakila;                            
CREATE VIEW staffaddy AS      
SELECT staff.first_name,staff.last_name,address.address
FROM staff
INNER JOIN address ON address.address_id  = staff.address_id;
/*6b                           */
SELECT staff.first_name,staff.last_name,payment.amount,payment.payment_date
FROM staff
INNER JOIN payment ON payment.staff_id  = staff.staff_id
WHERE  payment.payment_date >= "2005-08-01 00:00:00" AND payment.payment_date  < "2005-09-01 00:00:00"
GROUP BY staff.staff_id;
desc film;
/*6c    */
SELECT film.title,film_actor.actor_id
FROM film
INNER JOIN film_actor ON film.film_id = film_actor.film_id;
/*6d---*/

SELECT film.title,inventory.inventory_id
FROM film
INNER JOIN inventory ON inventory.film_id = film.film_id
WHERE film.title = "Hunchback Impossible";
#7a
SELECT film.title
FROM film
WHERE
    film.language_id IN (SELECT 
           language.language_id
           from language
           WHERE
            film.title like "K%" or film.title like  "Q%");
 #7b           
SELECT first_name, last_name           
FROM actor
WHERE actor_id IN (
SELECT actor_id
FROM film_actor
WHERE film_id IN(
SELECT film_id
FROM film
WHERE title = "ALONE TRIP")
);
#7d
SELECT film.title,category.name As "FIlm title"
FROM category
join film_category on (film_category.category_id = category.category_id)
join film on (film.film_id = film_category.film_id)
WHERE category.name = "Family";
#7c
SELECT customer.first_name,customer.last_name,customer.email,address.address,city.city,country.country
FROM customer 
JOIN address ON (customer.address_id = address.address_id)
JOIN city on  (address.city_id = city.city_id)
JOIN  country on (city.country_id = country.country_id)
WHERE country.country = "Canada";
#7e

SELECT f.title, count(r.rental_id)
FROM rental as r 
	JOIN inventory as i on (r.inventory_id= i.inventory_id)
    JOIN film as f on (i.film_id = f.film_id)
    group by f.title
    order by count(r.rental_id) desc;
#7f
select distinct (store_id) from inventory;
select * from store;

select  i.store_id, a.address,a.district, sum(p.amount) as "Total Business in '$'s"
#r.rental_id, r.inventory_id, p.payment_id, p.amount , i.store_id
from rental as r
    join payment as p on (r.rental_id = p.rental_id)
	join inventory as i on (r.inventory_id = i.inventory_id)
    join store as s on (i.store_id = s.store_id)
    join address as a on (s.address_id=a.address_id)
    group by i.store_id,a.address, a.district;
 #7g
 select s.store_id,  c.city, co.country 
	#a.address, a.district,
    from store as s 
      join address as a on (s.address_id=a.address_id)
      join city as c on (a.city_id = c.city_id)
      join country as co on (c.country_id = co.country_id);
    
 #7h
 select   c.name as "Genre" ,sum(p.amount) as "Gross Revenue"
#r.rental_id, r.inventory_id, p.payment_id, p.amount , i.store_id
from rental as r
    join payment as p on (r.rental_id = p.rental_id)
	join inventory as i on (r.inventory_id = i.inventory_id)
    join film_category as fc on (i.film_id = fc.film_id)
    join category as c on (fc.category_id=c.category_id)
    group by (c.name)
    order by sum(amount) desc
    limit 5;
    #8a
    create view top_earning_genres as 
select   c.name as "Genre" ,sum(p.amount) as "Gross Revenue"
#r.rental_id, r.inventory_id, p.payment_id, p.amount , i.store_id
from rental as r
    join payment as p on (r.rental_id = p.rental_id)
	join inventory as i on (r.inventory_id = i.inventory_id)
    join film_category as fc on (i.film_id = fc.film_id)
    join category as c on (fc.category_id=c.category_id)
    group by (c.name)
    order by sum(amount) desc
    limit 5;
    
