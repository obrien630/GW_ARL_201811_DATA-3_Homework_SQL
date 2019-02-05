USE sakila;

-- 1a.
SELECT 
	first_name as `First Name`
    ,last_name as `Last Name`
FROM actor;

-- 1b.
SELECT CONCAT(first_name, ' ', last_name) as `Actor Name`
FROM actor;

-- 2a. 
SELECT 
	actor_ID as `Actor ID`
    ,first_name as `First Name`
    ,last_name as `Last Name`
FROM actor
WHERE first_name = 'Joe';

-- 2b.
SELECT 
	first_name as `First Name`
    ,last_name as `Last Name`
FROM actor
WHERE last_name LIKE '%GEN%';

-- 2c.
SELECT 
	 last_name as `Last Name`
    ,first_name as `First Name`
FROM actor
WHERE last_name LIKE '%LI%';

-- 2d.
SELECT
	country_ID as `Country ID`
    , country as `Country`
FROM country    
WHERE country IN ('Afghanistan', 'Bangladesh', 'China');

-- 3a.
ALTER TABLE actor
ADD COLUMN Description BLOB
AFTER last_name;

-- 3b.
ALTER TABLE actor
DROP COLUMN Description;

-- 4a. 
SELECT 
	last_name as `Last Name`,
	COUNT(last_name) as `Total Actors`
FROM actor
GROUP BY last_name
ORDER BY `Total Actors` DESC;

-- 4b.
SELECT 
	last_name as `Last Name`,
	COUNT(last_name) as `Total Actors`
FROM actor
GROUP BY last_name
HAVING COUNT(last_name) >= 2
ORDER BY `Total Actors` DESC;

-- 4c. 
UPDATE actor
SET first_name = "HARPO"
WHERE first_name = "GROUCHO"
AND last_name = "WILLIAMS";

-- 4d. 
UPDATE actor
SET first_name = "GROUCHO"
WHERE first_name = "HARPO"
AND last_name = "WILLIAMS";

-- 5a. 
DESCRIBE address;

-- 6a.
SELECT
s.first_name as `First Name`
,s.last_name as `Last Name`
,a.address as `Address`
FROM
	staff s
JOIN address a
ON a.address_ID = s.address_ID;

-- 6b.
SELECT
s.staff_ID
,s.first_name as `First Name`
,s.last_name as `Last Name`
,SUM(p.amount) as `Total Amount`
FROM
	staff s
JOIN payment p
ON p.staff_ID = s.staff_ID AND p.payment_date LIKE '2005-08%'
GROUP BY s.staff_ID;

-- 6c. 
SELECT
f.title as `Film Title`
,COUNT(fa.actor_ID) as `Number of Actors`
FROM
	film f
INNER JOIN film_actor fa
ON f.film_ID = fa.film_ID
GROUP BY f.title;

-- 6d.
SELECT
f.title as `Film Title`
,COUNT(i.inventory_ID) as `Number of Copies`
FROM
	film f
INNER JOIN inventory i
ON f.film_ID = i.film_ID 
WHERE f.title = "Hunchback Impossible";

-- 6e.
SELECT
c.first_name as `First Name`
,c.last_name as `Last Name`
,SUM(p.amount) as `Amount Paid`
FROM
	customer c
JOIN payment  p
ON c.customer_ID = p.customer_ID
GROUP BY c.customer_ID
ORDER BY last_name ASC;

-- 7a. 
SELECT
	*
FROM
	film
WHERE
	title IN
  (
		SELECT
			title
		FROM
			film
            WHERE (title LIKE 'K%' OR title LIKE 'L%')
			AND language_id = 
            (SELECT language_id
            FROM language
            WHERE name = 'English')
  );

-- 7b.
SELECT
	first_name as `First Name`
   ,last_name as `Last Name`
FROM actor
WHERE actor_id IN
(
  SELECT actor_ID
  FROM film_actor
  WHERE film_id IN
  (
    SELECT film_id
    FROM film
    WHERE title = 'Alone Trip'
  ) 
);

-- 7c. 
SELECT
c.first_name as `First Name`
,c.last_name as `Last Name`
,c.email as `Email`
,co.country as `Country`
FROM
	customer c
JOIN address a
ON c.address_ID = a.address_ID 
JOIN city ci
ON a.city_ID = ci.city_ID 
JOIN country co
ON ci.country_ID = co.country_ID 
WHERE co.country = 'Canada';

-- 7d.
SELECT
f.title as `Film Title`
,c.name as `Category`
FROM
	film f
JOIN film_category fc
ON f.film_ID = fc.film_ID 
JOIN category c
ON c.category_ID = fc.category_ID 
WHERE c.name = 'Family';

-- 7e. 
SELECT 
	f.title as `Title`
	,COUNT(*) as `Number of Times Rented`
FROM 
	rental r
JOIN inventory i 
ON r.inventory_id = i.inventory_id
JOIN film f 
ON i.film_id = f.film_id
GROUP BY f.title
ORDER BY 2 DESC;

-- 7f.
SELECT 
	s.store_ID as `Store`
	,SUM(p.amount) as `Total Sales`
FROM 
	store s
JOIN staff st 
ON s.store_id = st.store_id
JOIN payment p 
ON st.staff_ID = p.staff_ID
GROUP BY s.store_ID;

-- 7g.
SELECT
s.store_ID as `Store`
,ci.city as `City`
,co.country as `Country`
FROM
	store s
JOIN address a
ON s.address_ID = a.address_ID 
JOIN city ci
ON a.city_ID = ci.city_ID 
JOIN country co
ON ci.country_ID = co.country_ID;

-- 7h.
SELECT
	c.name as `Genre`
    ,SUM(p.amount) as `Gross Revenue`
FROM
	category c
JOIN film_category fc
ON c.category_ID = fc.category_ID 
JOIN inventory i
ON fc.film_ID = i.film_ID 
JOIN rental r
ON i.inventory_ID = r.inventory_ID
JOIN payment p
ON r.rental_ID = p.rental_ID
GROUP BY c.name
ORDER BY 2 DESC
LIMIT 5;

-- 8a.
CREATE VIEW top_five_grossing_genres
as
SELECT
	c.name as `Genre`
    ,SUM(p.amount) as `Gross Revenue`
FROM
	category c
JOIN film_category fc
ON c.category_ID = fc.category_ID 
JOIN inventory i
ON fc.film_ID = i.film_ID 
JOIN rental r
ON i.inventory_ID = r.inventory_ID
JOIN payment p
ON r.rental_ID = p.rental_ID
GROUP BY c.name
ORDER BY 2 DESC
LIMIT 5;

-- 8b. 
SELECT * FROM top_five_grossing_genres;

-- 8c. 
DROP VIEW top_five_grossing_genres;
