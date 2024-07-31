import time
import random
from bs4 import BeautifulSoup
import pandas as pd
import requests
from requests.adapters import HTTPAdapter
from requests.packages.urllib3.util.retry import Retry
import lxml

# Set up retry strategy
retry_strategy = Retry(
    total=3,  # Total retries
    backoff_factor=1,  # Delay between retries
    status_forcelist=[429, 500, 502, 503, 504],  # Status codes to retry
    allowed_methods=["HEAD", "GET", "OPTIONS"]  # Allowed methods to retry
)
adapter = HTTPAdapter(max_retries=retry_strategy)
http = requests.Session()
http.mount("https://", adapter)
http.mount("http://", adapter)

baseurl = 'https://www.goodreads.com'
url = 'https://www.goodreads.com/list/show/183940.Best_Books_of_2023?page={i}'
headers = {
    'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:89.0) Gecko/20100101 Firefox/89.0'
}

# Menggunakan requests.Session untuk efisiensi
session = requests.Session()
session.headers.update(headers)

books = []

# Fungsi untuk mendapatkan detail buku
def get_book_details(link):
    try:
        r = session.get(link)
        soup = BeautifulSoup(r.content, 'lxml')
        book_info = soup.find('div', class_='BookPage__mainContent')
        
        if book_info:
            title = book_info.find('h1', class_='Text Text__title1').text.strip()
            author = book_info.find('span', class_='ContributorLink__name').text
            star = book_info.find('div', class_='RatingStatistics__rating').text
            rating = book_info.find('span', {'data-testid': 'ratingsCount'}).text
            review = book_info.find('span', {'data-testid': 'reviewsCount'}).text
            pages = book_info.find('p', {'data-testid': 'pagesFormat'})
            published = book_info.find('p', {'data-testid': 'publicationInfo'})
            
            pages1 = pages.text.split()[0] if pages else None  # Asumsi halaman adalah angka pertama
            
            published_text = published.text.strip() if published else None
            published2 = published_text[16:] if published_text else None
            year_published = published2[-4:] if published2 else None

            genres = [genre.text.strip() for genre in book_info.find_all('a', class_='Button Button--tag-inline Button--medium')]
            first_genre = genres[0] if genres else None

            books.append({
                'title': title,
                'author': author,
                'star': star,
                'rating': rating,
                'review': review,
                'pages': pages1,
                'published': published2,
                'year_published': year_published,
                'genres': first_genre
            })
    except requests.exceptions.RequestException as e:
        print(f"Error fetching {link}: {e}")
        time.sleep(random.uniform(1, 3))  # Delay sebelum mencoba lagi

# Loop untuk halaman
for i in range(1, 13):  # Sesuaikan jumlah halaman yang diinginkan
    try:
        response = session.get(url.format(i=i))
        soup = BeautifulSoup(response.content, 'lxml')
        list_page = soup.find_all('td', {'valign': "top"})
        
        book_link = [baseurl + link['href'] for td in list_page for link in td.find_all('a', class_='bookTitle', href=True)]
        
        for idx, link in enumerate(book_link, start=1):
            get_book_details(link)
            time.sleep(random.uniform(1, 3))  # Delay untuk setiap request buku
            print(f"Scraping buku ke-{idx} dari halaman {i}")
    except requests.exceptions.RequestException as e:
        print(f"Error fetching page {i}: {e}")
        time.sleep(random.uniform(1, 3))  # Delay sebelum mencoba lagi

# Simpan data ke dalam DataFrame Pandas
df = pd.DataFrame(books)

# Simpan DataFrame ke dalam file CSV
csv_filename = '2023_Best_Books.csv'
df.to_csv(csv_filename, index=False)

print(f"Data telah disimpan ke dalam file: {csv_filename}")

# Jangan lupa untuk menutup sesi
session.close()
