--GROUP PROJECT work by ferroro-rocher group
-- 3. Deliverables
-- 	a. Develop some general recommendations about the price range, genre, content rating, or any other app characteristics that the company should target.

WITH app_store AS (SELECT name,size_bytes AS size, price::money, review_count::int, rating, content_rating, primary_genre, 'app_store' 
				   AS store FROM app_store_apps),
play_store AS (SELECT name, size, price::money, review_count, rating, CASE WHEN content_rating = 'Everyone 10+' THEN '10+' WHEN content_rating = 'Teen' THEN '12+' 
																	       WHEN content_rating = 'Everyone' THEN '4+' WHEN content_rating = 'Adults only 18+' THEN '18+' 
																		   WHEN content_rating = 'Mature 17+' THEN '17+' ELSE 'Unrated' 
																		   END AS content_rating, genres AS primary_genre, 'play_store' 
	       AS store FROM play_store_apps)
SELECT name, MAX(play_store.price) AS play_store_price, MAX(app_store.price) AS app_store_price, play_store.content_rating, play_store.primary_genre, 
ROUND((AVG(play_store.review_count+app_store.review_count)/2),2) AS review_count, 
ROUND((AVG(play_store.rating+app_store.rating)/2),2) AS rating FROM app_store 
INNER JOIN play_store USING(name)
WHERE play_store.review_count > 100000  OR app_store.review_count > 100000 
GROUP BY name, play_store.content_rating, play_store.primary_genre 
ORDER BY rating DESC;
--Based on this query we believe the company should target apps with a price above $2.50 range, content
-- rating of 4+, games that are some type of game genre, with a 4.6 rating or above.



-- PART B. Develop a Top 10 List of the apps that App Trader should buy based on profitability/return on investment as the sole priority.
WITH app_store AS (SELECT name,size_bytes AS size, price::money, review_count::int, rating, content_rating, primary_genre, 'app_store' 
				   AS store FROM app_store_apps),
play_store AS (SELECT name, size, price::money, review_count, rating, CASE WHEN content_rating = 'Everyone 10+' THEN '10+' WHEN content_rating = 'Teen' THEN '12+' 
																	       WHEN content_rating = 'Everyone' THEN '4+' WHEN content_rating = 'Adults only 18+' THEN '18+' 
																		   WHEN content_rating = 'Mature 17+' THEN '17+' ELSE 'Unrated' 
																		   END AS content_rating, genres AS primary_genre, 'play_store' 
	       AS store FROM play_store_apps)
SELECT name, MAX(play_store.price) AS play_store_price, MAX(app_store.price) AS app_store_price, play_store.content_rating, play_store.primary_genre, 
ROUND((AVG(play_store.review_count+app_store.review_count)/2),2) AS review_count, 
ROUND((AVG(play_store.rating+app_store.rating)/2),2) AS rating FROM app_store 
INNER JOIN play_store USING(name)
WHERE play_store.review_count > 100000  OR app_store.review_count > 100000 
GROUP BY name, play_store.content_rating, play_store.primary_genre 
ORDER BY rating DESC
LIMIT 10;




--PART C. Develop a Top 4 list of the apps that App Trader should buy that are profitable but that also are thematically appropriate for the upcoming Halloween themed campaign.

WITH app_store AS (SELECT name,size_bytes AS size, price::money, review_count::int, rating, content_rating, primary_genre, 'app_store' 
				   AS store FROM app_store_apps),
play_store AS (SELECT name, size, price::money, review_count, rating, CASE WHEN content_rating = 'Everyone 10+' THEN '10+' WHEN content_rating = 'Teen' THEN '12+' 
																		   WHEN content_rating = 'Everyone' THEN '4+' WHEN content_rating = 'Adults only 18+' THEN '18+' 
																		   WHEN content_rating = 'Mature 17+' THEN '17+' ELSE 'Unrated' 
																		  END AS content_rating, genres AS primary_genre, 'play_store' 
		   AS store FROM play_store_apps)

SELECT name, MAX(play_store.price) AS play_store_price, 
			 MAX(app_store.price) AS app_store_price, MAX(play_store.content_rating) AS play_store_rating, 		
			 MAX(play_store.primary_genre) AS play_store_genre, MAX(play_store.review_count) AS play_store_review_count, 
			 MAX(app_store.review_count) AS app_store_review_count, 
			 MAX(play_store.rating) AS play_store_rating, MAX(app_store.rating) AS app_store_rating FROM app_store 
FULL JOIN play_store USING(name)
WHERE (name ilike '%candy%' OR name ilike '%halloween%' OR name ilike '%ghost%' OR name ilike '%goblin%'  OR name ilike '%skeleton%') 
AND (play_store.rating >= '4.5'  OR app_store.rating >= '4.5') AND (play_store.review_count > 10000  OR app_store.review_count > 10000) 
GROUP BY name, play_store.content_rating, play_store.primary_genre 
ORDER BY MAX(play_store.rating) DESC
LIMIT 4



-- PART D. Submit a report based on your findings. The report should include both of your lists of apps along with your analysis of their cost and potential profits. 
-- All analysis work must be done using PostgreSQL, however you may export query results to create charts in Excel for your report.



WITH cte AS ((SELECT name, price::money, rating FROM app_store_apps)
				UNION				   
			(SELECT name, price::money, rating FROM play_store_apps))
SELECT * FROM cte
WHERE NAME IN ('Ghost Lens+Scary Photo Video Edit&Collage Maker',
'Haunted Halloween Escape', 'Candy Blast Mania', 'Candy Pop Story')


--JZ's personal notes
SELECT COUNT(name), rating
FROM play_store_apps
GROUP BY rating
ORDER BY rating DESC;

SELECT name
FROM play_store_apps
 	INNER JOIN app_store_apps
	USING (name);

/*This table shows all but 328 rows of both tables*/
SELECT p.name, p.rating, a.rating, p.review_count, a.review_count, p.install_count
FROM play_store_apps AS p
	FULL JOIN app_store_apps AS a
	ON p.name = a.name
WHERE p.review_count = > 500
ORDER BY p.rating, a.rating, 
	
	
SELECT p.name, p.rating
FROM play_store_apps AS p
	FULL JOIN app_store_apps AS a
	ON p.name = a.name
GROUP BY CUBE (p.name, p.rating)


SELECT name, rating, review_count, primary_genre
FROM app_store_apps;



/*763 have 5 star ratings*/
SELECT name, rating, review_count, genres, content_rating
FROM play_store_apps
UNION
SELECT name, rating, review_count::integer, primary_genre, content_rating
FROM app_store_apps
ORDER BY rating DESC NULLS LAST, review_count DESC;



SELECT *
FROM play_store_apps
	FULL JOIN app_store_apps
	USING (name)
WHERE name ILIKE '%hallowee%' OR name ILIKE '%pumpkin%' OR name ILIKE '%ghost%'


--UNION of all tables
SELECT name,
	   size_bytes AS size, 
	   price::money, 
	   review_count::int, 
	   rating, 
	   content_rating, 
	   primary_genre, 
	   'app_store' AS store 
FROM app_store_apps
UNION ALL
SELECT name, 
	   size, 
	   price::money, 
	   review_count, 
	   rating, 
	   CASE WHEN content_rating = 'Everyone 10+' THEN '10+' 
	   	    WHEN content_rating = 'Teen' THEN '12+' 
			WHEN content_rating = 'Everyone' THEN '4+' 
			WHEN content_rating = 'Adults only 18+' THEN '18+' 
			WHEN content_rating = 'Mature 17+' THEN '17+' 
			ELSE 'Unrated' 
			END AS content_rating, 
		genres AS primary_genre, 
		'play_store' AS store 
FROM play_store_apps
WHERE rating IS NOT NULL
ORDER BY rating DESC, review_count DESC;




 

--Final answer
WITH app_store AS (SELECT name,size_bytes AS size, price::money, review_count::int, rating, content_rating, primary_genre, 'app_store'
				   AS store FROM app_store_apps),
play_store AS (SELECT name, size, price::money, review_count, rating, CASE WHEN content_rating = 'Everyone 10+' THEN '10+' WHEN content_rating = 'Teen' THEN '12+'
																		WHEN content_rating = 'Everyone' THEN '4+' WHEN content_rating = 'Adults only 18+' THEN '18+'
																		WHEN content_rating = 'Mature 17+' THEN '17+' ELSE 'Unrated'
																		END AS content_rating, genres AS primary_genre, 'play_store'
			   AS store FROM play_store_apps)
SELECT name, MAX(play_store.price), MAX(app_store.price), play_store.content_rating, play_store.primary_genre, ROUND((AVG(play_store.review_count+app_store.review_count)/2),2) AS review_count,
ROUND((AVG(play_store.rating+app_store.rating)/2),2) AS rating FROM app_store
INNER JOIN play_store USING(name)
WHERE play_store.review_count > 100000  OR app_store.review_count > 100000
GROUP BY name, play_store.content_rating, play_store.primary_genre
ORDER BY rating DESC;


SELECT 
FROM app_store_apps AS a
FULL JOIN play_store_apps AS p
USING (name)
WHERE name IN ('Candy Pop Story', 'Candy Blast Mania', 'Haunted Halloween Escape', 'Ghost Lens+Scary Photo Video Edit&Collage Maker');

SELECT name, rating
FROM app_store_apps
UNION
SELECT name, rating
FROM play_store_apps
WHERE name IN ('Candy Pop Story', 'Candy Blast Mania', 'Haunted Halloween Escape', 'Ghost Lens+Scary Photo Video Edit&Collage Maker');


