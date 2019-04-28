use sakila
-- Requirement 1a
SELECT 
first_name,
last_name
FROM sakila.actor;

-- Requirement 1b
ALTER TABLE `sakila`.`actor`
DROP COLUMN actor_name;
ALTER TABLE `sakila`.`actor`
ADD COLUMN actor_name VARCHAR(45) NOT NULL AFTER `last_update`;
UPDATE actor SET actor_name=CONCAT(first_name," ",last_name);

-- Requirement 2a
SELECT actor_id, first_name, last_name
FROM actor
WHERE first_name = "Joe";

-- Requirement 2b
SELECT *
FROM actor
WHERE last_name LIKE "%GEN%";

-- Requirement 2c
SELECT *
FROM actor
WHERE last_name LIKE "%LI%" 
ORDER By last_name, first_name;

-- Requirement 2d
SELECT *
FROM country
WHERE country IN ('Afghanistan', 'Bangladesh','China');

-- Requirement 3a
ALTER TABLE `sakila`.`actor`
ADD COLUMN description BLOB NOT NULL AFTER `last_update`;

-- Requirement 3b
ALTER TABLE `sakila`.`actor`
DROP COLUMN description;

-- Requirement 4a
SELECT last_name, COUNT(*)
FROM actor
GROUP BY last_name;

-- Requirement 4b
SELECT last_name, COUNT(*)
FROM actor
GROUP BY last_name
HAVING COUNT(*) >=2;

-- Requirement 4c
UPDATE actor
SET first_name = REPLACE(first_name,'GROUCHO', 'HARPO')
WHERE first_name = 'GROUCHO' AND last_name = 'WILLIAMS'

-- Requirement 4d
UPDATE actor
SET first_name = REPLACE(first_name,'HARPO', 'GROUCHO')
WHERE first_name = 'HARPO' AND last_name = 'WILLIAMS'

-- Requirement 5a 
DESCRIBE address

-- Requirement 6a - Not working
SELECT staff.first_name, staff.last_name, address.address
FROM staff
JOIN address
ON staff.address_id = address.address_id

-- Requirement 6b
SELECT staff.first_name, staff.last_name,  ts_by_sales_id.Total_Sales
FROM staff
JOIN (SELECT payment.staff_id ,
		SUM(payment.amount) 
		AS Total_Sales
        FROM payment 
        GROUP BY staff_id) AS ts_by_sales_id
ON staff.staff_id = ts_by_sales_id.staff_id;

-- Requirement 6c
SELECT film.title, actor_count_by_film.actor_count
FROM film
JOIN (SELECT film_actor.film_id, COUNT(film_actor.actor_ID) AS actor_count
		FROM film_actor
		GROUP BY actor_ID) AS actor_count_by_film
ON film.film_id = actor_count_by_film.film_id;

-- Requirement 6d
SELECT film.title, film_lookup.inventory_count
FROM film
JOIN (SELECT film_ID, COUNT(inventory.film_ID) as inventory_count
FROM inventory
GROUP BY inventory.film_ID) AS film_lookup
ON film.film_id = film_lookup.film_id
WHERE film.title = 'Hunchback Impossible';

-- Requirement 6e
 SELECT customer.customer_id, customer_payments.total_payments_by_customer
 FROM customer
 JOIN  (SELECT payment.customer_id, SUM(payment.amount) AS total_payments_by_customer
 FROM payment
 GROUP By customer_id) AS customer_payments
 ON customer.customer_id = customer_payments.customer_id;
 
-- Requirement 7a
SELECT film.title
FROM film
WHERE title LIKE'Q%' OR title LIKE'K%'
AND language_id in (SELECT language_id FROM language WHERE name = 'English');

-- Requirement 7b
SELECT actor.actor_name
FROM (SELECT film.title, film.film_id
	FROM film
	WHERE film.title = 'Alone Trip') AS film_and_id
JOIN film_actor
ON film_and_id.film_id = film_actor.film_id
JOIN actor
ON film_actor.actor_id = actor.actor_id;

-- Requirement 7c
SELECT customer.first_name, customer.last_name, customer.email
FROM customer
JOIN address ON customer.address_id = address.address_id
JOIN city ON address.city_id = city.city_id
JOIN country ON country.country_id = country.country_id
WHERE country.country = 'Canada';

-- Requirement 7d
SELECT film.title
FROM film
JOIN film_category ON film.film_id = film_category.film_id
JOIN category ON film_category.category_id = category.category_id
WHERE category.name = 'Family'

-- Requirement 7e 
SELECT film.title, SUM(total_rentals.total_rentals) AS total_rentals
FROM film
JOIN inventory ON film.film_id = inventory.film_id
JOIN(SELECT rental.inventory_id, COUNT(rental.inventory_id) AS total_rentals
	FROM rental GROUP BY inventory_id) AS total_rentals 
    ON inventory.inventory_id = total_rentals.inventory_id
GROUP BY film.title
ORDER BY total_rentals DESC;

-- Requirement 7f how much business in dollars from each store
SELECT staff.store_id, dollars_by_staffid.total_rental_dollars
FROM staff
JOIN (SELECT payment.staff_id, SUM(payment.amount) AS total_rental_dollars
	FROM payment GROUP BY staff_id) AS dollars_by_staffid
ON staff.staff_id = dollars_by_staffid.staff_id;


-- Requirement 7g Each Store ,store ID, city, and country
SELECT store.store_id, city.city, country.country
FROM store
JOIN address ON store.address_id = address.address_id
JOIN city ON address.city_id = city.city_id
JOIN country ON city.country_id = country.country_id;

-- Requirement 7h top five genres gross rev in descening order
SELECT category.name AS genre, SUM(payment.amount) AS gross_revenue
FROM category
JOIN film_category ON category.category_id = film_category.category_id
JOIN inventory ON film_category.film_id = inventory.film_id
JOIN rental ON inventory.inventory_id = rental.inventory_id
JOIN payment ON rental.rental_id = payment.rental_id
GROUP BY genre ORDER BY gross_revenue DESC;

-- Requirement 8a
CREATE VIEW gross_revenue_by_genre AS
SELECT category.name AS genre, SUM(payment.amount) AS gross_revenue
FROM category
JOIN film_category ON category.category_id = film_category.category_id
JOIN inventory ON film_category.film_id = inventory.film_id
JOIN rental ON inventory.inventory_id = rental.inventory_id
JOIN payment ON rental.rental_id = payment.rental_id
GROUP BY genre ORDER BY gross_revenue DESC;

-- Requirement 8b
SELECT * FROM gross_revenue_by_genre;

-- Requirement 8c
DROP VIEW gross_revenue_by_genre;



