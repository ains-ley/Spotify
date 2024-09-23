SELECT * FROM public.spotify
LIMIT 100

-- EDA
select count(*) from spotify s ;

select count (distinct artist) from spotify s ;

select distinct album_type from spotify s ;

select max(duration_min) from spotify s ;
select min(duration_min) from spotify s ;

select * from spotify s 
where duration_min = 0;

delete from spotify where duration_min = 0;

select distinct channel from spotify s ;

select distinct most_played_on from spotify s ;

/*
-- -------------
-- Data Analysis 
-- -------------
*/

-- Q.1 Retrieve the track names that have been streamed on Spotify more than YouTube

SELECT * FROM 
(SELECT
	track,
	COALESCE (SUM(CASE WHEN most_played_on = 'Youtube' THEN stream END), 0) stream_on_youtube,
	COALESCE (SUM(CASE WHEN most_played_on = 'Spotify' THEN stream END), 0) stream_on_spotify
FROM spotify s 
GROUP BY 1) t1
WHERE 
	stream_on_spotify > stream_on_youtube
	AND 
	stream_on_youtube != 0;

-- Q.2 Top 3 most-viewed tracks for each artist

WITH ranking_artist AS (
SELECT
	artist,
	track,
	SUM("views") total_views,
	DENSE_RANK() OVER (PARTITION BY artist ORDER BY SUM("views") DESC) rank
FROM spotify s
GROUP BY artist, track 
ORDER BY artist, total_views DESC
)
SELECT * FROM ranking_artist
WHERE "rank" <= 3;

-- Q.3 Tracks where the liveness score is above the average

SELECT
  track,
  liveness
FROM
  spotify
WHERE
  liveness > (SELECT AVG(liveness) FROM spotify);

-- Q.4 The difference between the highest and lowest energy values for tracks in each album

SELECT
  album,
  MAX(energy) - MIN(energy) AS energy_difference
FROM
  spotify
GROUP BY
  album
ORDER BY
  energy_difference DESC;






