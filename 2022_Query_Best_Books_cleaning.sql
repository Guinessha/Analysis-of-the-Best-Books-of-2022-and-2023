--Selecting the Database Used---
use Best_Books_Analyst;

--Displays All Data---
select * from [2022_Best_Books];

--Displays the Grand Total of Data--
select count(*) from [2022_Best_Books];

--Displays Duplicate Data--
select title, count(*) from [2022_Best_Books]
group by title, author
having count(*) > 1
order by count(*) desc;

--Removing Duplicates--
CREATE TABLE #temp_books (
    title NVARCHAR(MAX),
    author NVARCHAR(255),
    min_star FLOAT,
    min_rating NVARCHAR(255),
    min_review NVARCHAR(255),
    min_pages INT,
    min_published NVARCHAR(255),
    min_year_published INT,
    min_genres NVARCHAR(255)
);

INSERT INTO #temp_books (title, author, min_star, min_rating, min_review, min_pages, min_published, min_year_published, min_genres)
SELECT 
    title, 
    author, 
    MIN(star) AS min_star, 
    MIN(rating) AS min_rating, 
    MIN(review) AS min_review, 
    MIN(pages) AS min_pages, 
    MIN(published) AS min_published, 
    MIN(year_published) AS min_year_published, 
    MIN(genres) AS min_genres
FROM [2022_Best_Books]
GROUP BY title, author;

WITH CTE AS (
    SELECT 
        title, 
        author, 
        star, 
        rating, 
        review, 
        pages, 
        published, 
        year_published, 
        genres,
        ROW_NUMBER() OVER (PARTITION BY title, author ORDER BY title, author) AS row_num
    FROM [2022_Best_Books]
)
DELETE FROM CTE
WHERE row_num > 1;

DROP TABLE #temp_books;

--Rename Column--
EXEC sp_rename '2022_Best_Books.column1', 'Title', 'COLUMN';
EXEC sp_rename '2022_Best_Books.column2', 'Author', 'COLUMN';
EXEC sp_rename '2022_Best_Books.column3', 'Star', 'COLUMN';
EXEC sp_rename '2022_Best_Books.column4', 'Ratings', 'COLUMN';
EXEC sp_rename '2022_Best_Books.column5', 'Reviews', 'COLUMN';
EXEC sp_rename '2022_Best_Books.column6', 'Pages', 'COLUMN';
EXEC sp_rename '2022_Best_Books.column7', 'Published', 'COLUMN';
EXEC sp_rename '2022_Best_Books.column8', 'Year_Published', 'COLUMN';
EXEC sp_rename '2022_Best_Books.column9', 'Genres', 'COLUMN';

--Remove the words 'ratings' and 'reviews' in the Data--
UPDATE [2022_Best_Books]
	SET Ratings = REPLACE(Ratings, 'ratings', '');

UPDATE [2022_Best_Books]
	SET Reviews = REPLACE(Reviews, 'reviews', '');
	
UPDATE [2022_Best_Books]
	SET Reviews = REPLACE(Reviews, 'review', '');

--Changing Column Type--
ALTER TABLE [2022_Best_Books]
ALTER COLUMN Published date;

--Displays Data That Does Not Match the Selected Type---
SELECT DISTINCT Published
FROM [2022_Best_Books]
WHERE ISDATE(Published) = 0;

--Deleting data that does not match the selected type---
DELETE FROM [2022_Best_Books]
WHERE ISDATE(Published) = 0;

--Changing Date Format--
SELECT FORMAT(CONVERT(DATE, Published, 23), 'MMMM dd, yyyy') AS FormattedPublished
FROM [2022_Best_Books];

SELECT FORMAT(CONVERT(DATE, Published), 'MMMM dd, yyyy') AS FormattedDate from [2022_Best_Books];

--Implement Date Format Changes--
UPDATE [2022_Best_Books]
SET Published = CONVERT(DATE, Published, 23); -- Assuming 'MM/DD/YYYY' format

--Deleting data that has years above/beyond 2022--
DELETE from [2022_Best_Books]
where year_published > 2022;

--Displays empty/NULL data from the selected column--
Select * from [2022_Best_Books]
where Title IS NULL;

--Displays data that is not the same as the selected data--
Select * from [2022_Best_Books]
where year_published != 2022;

--Converting Data to Decimal--
SELECT Star, 
    CONVERT(VARCHAR, CAST(Star / 100.0 AS DECIMAL(10, 2))) AS FormattedAmount
FROM [2022_Best_Books]

update [2022_Best_Books]
	SET Star = CONVERT(VARCHAR, CAST(Star / 100.0 AS DECIMAL(10, 2)))

--Converts to 2 numbers after the comma--
SELECT 
    Star, 
    FORMAT(Star, 'N2') AS FormattedAmount
FROM [2022_Best_Books]

UPDATE [2022_Best_Books]
SET Star = FORMAT(Star, 'N2');

--Removes all extra spaces to one space--
UPDATE [2022_Best_Books]
SET Author = REPLACE(LTRIM(RTRIM(Author)), '  ', ' ');

UPDATE [2022_Best_Books]
SET Title = REPLACE(LTRIM(RTRIM(Title)), '  ', ' ');