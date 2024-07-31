use Best_Books_Analyst;

select * from [2022_Best_Books];

------------------------------CHANGING THE COLUMN DATA TYPE---------------------------------------

----------RATINGS----------
ALTER TABLE [2022_Best_Books]
ADD ratings_cleaned NVARCHAR(MAX);

UPDATE [2022_Best_Books]
SET ratings_cleaned = REPLACE(REPLACE(LTRIM(RTRIM(ratings)), ',', ''), CHAR(160), '');

ALTER TABLE [2022_Best_Books]
ADD reviews_int INT;

UPDATE [2022_Best_Books]
SET reviews_int = CAST(ratings_cleaned AS INT);

ALTER TABLE [2022_Best_Books]
DROP COLUMN Ratings;
ALTER TABLE [2022_Best_Books]
DROP COLUMN ratings_cleaned;

EXEC sp_rename '2022_Best_Books.reviews_int', 'Ratings', 'COLUMN';

---------------------------------------FINISH----------------------------------------

-----------------------------EXPLORATORY DATA ANALYST--------------------------------

select TOP(5) genres, count(genres) as Sum_Genres, ROUND(AVG(Star), 2) AS AVG_Star from [2022_Best_Books]
Group by Genres
order by Sum_Genres desc;

select Author, count(Author)as Sum_Author, sum(Reviews) as Sum_Reviews from [2022_Best_Books]
group by Author
order by Sum_Author desc;

select sum(Ratings) as Sum_Ratings, sum(Reviews) as Sum_Reviews, ROUND(Avg(Star), 2) as Avg_Star 
from [2022_Best_Books]

select top (5) title, Ratings, Reviews from [2022_Best_Books];

update [2022_Best_Books]
	SET Star = CONVERT(VARCHAR, CAST(Star / 100.0 AS DECIMAL(10, 2)))

UPDATE [2022_Best_Books]
SET Star = Star * 10
WHERE Star < 1;

---------------------------------------FINISH EDA----------------------------------------

