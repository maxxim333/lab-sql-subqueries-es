USE SAKILA;

-- ¿Cuántas copias de la película El Jorobado Imposible existen en el sistema de inventario?
SELECT COUNT(DISTINCT inventory.inventory_id) FROM inventory
JOIN film on film.film_id = inventory.film_id
WHERE film.title LIKE "HUNCHBACK IMPOSSIBLE";

-- Lista todas las películas cuya duración sea mayor que el promedio de todas las películas.
SELECT title, length / (SELECT AVG(length) FROM film) AS length_ratio
FROM film;


-- Usa subconsultas para mostrar todos los actores que aparecen en la película Viaje Solo.
WITH true_film_id AS (
	SELECT film_id FROM film
    WHERE title LIKE "%alone%"
    )
SELECT actor.first_name, actor.last_name FROM true_film_id
JOIN film_actor ON film_actor.film_id = true_film_id.film_id
JOIN actor ON actor.actor_id = film_actor.actor_id;

-- Las ventas han estado disminuyendo entre las familias jóvenes, y deseas dirigir todas las películas familiares a una promoción. Identifica todas las películas categorizadas como películas familiares.
SELECT film.title, category.name FROM category
JOIN film_category ON film_category.category_id = category.category_id
JOIN film ON film.film_id = film_category.film_id
WHERE category.name = "Family";

-- Obtén el nombre y correo electrónico de los clientes de Canadá usando subconsultas. Haz lo mismo con uniones. Ten en cuenta que para crear una unión, tendrás que identificar las tablas correctas con sus claves primarias y claves foráneas, que te ayudarán a obtener la información relevante.
SELECT customer.first_name, customer.last_name, customer.email, country.country FROM address
JOIN city ON city.city_id = address.city_id
JOIN country ON country.country_id = city.country_id
JOIN customer ON customer.address_id = address.address_id
WHERE country.country = "Canada";

WITH joined AS (
SELECT customer.first_name, customer.last_name, customer.email, country.country AS def FROM address
JOIN city ON city.city_id = address.city_id
JOIN country ON country.country_id = city.country_id
JOIN customer ON customer.address_id = address.address_id
)
SELECT * FROM joined
WHERE def = "Canada";


-- ¿Cuáles son las películas protagonizadas por el actor más prolífico? El actor más prolífico se define como el actor que ha actuado en el mayor número de películas. Primero tendrás que encontrar al actor más prolífico y luego usar ese actor_id para encontrar las diferentes películas en las que ha protagonizado.
SELECT actor_id, COUNT(film_id) AS count FROM film_actor
GROUP BY actor_id
ORDER BY count DESC
LIMIT 1; -- Es el actor con ID 107

SELECT film.title FROM film_actor
JOIN actor ON actor.actor_id = film_actor.actor_id
JOIN film ON film.film_id = film_actor.film_id
WHERE film_actor.actor_id = 107;



-- Películas alquiladas por el cliente más rentable. Puedes usar la tabla de clientes y la tabla de pagos para encontrar al cliente más rentable, es decir, el cliente que ha realizado la mayor suma de pagos.
SELECT customer_id, SUM(AMOUNT) AS sum FROM payment
GROUP BY customer_id
ORDER BY sum DESC
LIMIT 1; -- es el 526

SELECT DISTINCT film.title FROM rental
JOIN inventory ON inventory.inventory_id = rental.inventory_id
JOIN film ON film.film_id = inventory.film_id
WHERE customer_id = 526;



-- Obtén el client_id y el total_amount_spent de esos clientes que gastaron más que el promedio del total_amount gastado por cada cliente.


SET @average_length := (
    SELECT AVG(avg_by_user) 
    FROM (
        SELECT AVG(amount) AS avg_by_user 
        FROM payment 
        GROUP BY customer_id
    ) AS promedio
);

WITH avg_by_user_2 AS (
	SELECT customer_id, AVG(amount) AS avg_by_user 
	FROM payment 
	GROUP BY customer_id
    )
SELECT * from avg_by_user_2
WHERE avg_by_user > @average_length;