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
-- Obtén el nombre y correo electrónico de los clientes de Canadá usando subconsultas. Haz lo mismo con uniones. Ten en cuenta que para crear una unión, tendrás que identificar las tablas correctas con sus claves primarias y claves foráneas, que te ayudarán a obtener la información relevante.
-- ¿Cuáles son las películas protagonizadas por el actor más prolífico? El actor más prolífico se define como el actor que ha actuado en el mayor número de películas. Primero tendrás que encontrar al actor más prolífico y luego usar ese actor_id para encontrar las diferentes películas en las que ha protagonizado.
-- Películas alquiladas por el cliente más rentable. Puedes usar la tabla de clientes y la tabla de pagos para encontrar al cliente más rentable, es decir, el cliente que ha realizado la mayor suma de pagos.
-- Obtén el client_id y el total_amount_spent de esos clientes que gastaron más que el promedio del total_amount gastado por cada cliente.