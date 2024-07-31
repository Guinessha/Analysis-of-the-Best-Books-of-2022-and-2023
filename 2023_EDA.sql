use Best_Books_Analyst;

select * from [2023_Best_Books];

------------------------------CHANGING THE COLUMN DATA TYPE---------------------------------------

----------RATINGS----------
ALTER TABLE [2023_Best_Books]
ADD reviews_cleaned NVARCHAR(MAX);

UPDATE [2023_Best_Books]
SET reviews_cleaned = REPLACE(REPLACE(LTRIM(RTRIM(reviews)), ',', ''), CHAR(160), '');

ALTER TABLE [2023_Best_Books]
ADD reviews_int INT;

UPDATE [2023_Best_Books]
SET reviews_int = CAST(reviews_cleaned AS INT);

ALTER TABLE [2023_Best_Books]
DROP COLUMN reviews;
ALTER TABLE [2023_Best_Books]
DROP COLUMN reviews_cleaned;

EXEC sp_rename '2023_Best_Books.reviews_int', 'Reviews', 'COLUMN';

---------------------------------------FINISH----------------------------------------

-----------------------------EXPLORATORY DATA ANALYST--------------------------------

select TOP(5) genres, year_published, count(genres) as Sum_Genres, ROUND(AVG(Star), 2) AS AVG_Star from [2023_Best_Books]
Group by Genres, year_published
order by Sum_Genres desc;

select top(10) Author, year_published, count(Author)as Sum_Author, sum(Reviews) as Sum_Reviews from [2022_Best_Books]
group by Author, year_published
order by Sum_Author desc;

select sum(Ratings) as Sum_Ratings, sum(Reviews) as Sum_Reviews, ROUND(Avg(Star), 2) as Avg_Star, Year_Published
from [2022_Best_Books]

select top (5) title, Ratings, Reviews from [2022_Best_Books];

select genres, year_published, count(genres) as Sum_Genres from [2023_Best_Books]
Group by year_published;

SELECT COUNT(DISTINCT genres) AS genre_count
FROM [2023_Best_Books]
WHERE year_published = 2023;
---------------------------------------FINISH EDA----------------------------------------

