from bs4 import BeautifulSoup
import pandas as pd 
import numpy as np
import requests
import re
from sqlalchemy import create_engine
import urllib.request
from urllib import request
import json
import time

headers = {'user-agent': 'Chrome/87.0.4280.66', 'Content-Type': 'text/html',}

URL = 'https://rarbg.to/top100.php?category%5b%5d=14&category%5b%5d=15&category%5b%5d=16&category%5b%5d=17&category%5b%5d=21&category%5b%5d=22&category%5b%5d=42&category%5b%5d=44&category%5b%5d=45&category%5b%5d=46&category%5b%5d=47&category%5b%5d=48'
page = requests.get(URL, headers)
print(page.content)


engine = create_engine('mysql+pymysql://root:Dad2nai2!@127.0.0.1/movies')

html_data = BeautifulSoup(open('C:/Users/cruel/Desktop/rarbg_website.html'), 'html.parser')

df = pd.DataFrame()
imdb_df = pd.DataFrame()
titles = []
imdb_id = []
sizes = []
seeders = []
leechers = []
imdb_api_ids = []
imdb_titles = []
imdb_keywords = []


class Tr_Lista:
    def __init__(self):
        self = self

    def scrape_lista(self,data):
        results = data.get_text()
        results = re.search('<table width="100%" class="lista2t">(.+?)</table>', results).group(1)
        results = re.findall('<tr class="lista2">(.+?)</tr>', results)
        for lista2 in results:
            title = str(re.findall('title="(.+?)">', lista2))
            title = title[2:-2]
            titles.append(title)
            imdb = str(re.findall('imdb=(.+?)">', lista2))
            imdb = imdb[2:-2]
            imdb_id.append(imdb)
            size = str(re.findall('width="100px" class="lista">(.+?)<', lista2))
            size = size[2:-2]
            sizes.append(size)
            seeder = str(re.findall('000">(.+?)<', lista2))
            seeder = seeder[2:-2]
            seeders.append(seeder)
            leecher = re.findall('width="50px" class="lista">(.+?)<', lista2)
            leecher = str(leecher[1])
            leechers.append(leecher)

    def create_dataframe(self,list1,list2,list3,list4,list5):
        df['Titles']  = list1
        df['IMDB_ID']  = list2
        df['Sizes']  = list3
        df['Seeders']  = list4
        df['Leechers']  = list5
        
        for columns in df.columns:        
            df[columns] = df[columns].str.strip("[]")

class IMDB_API:
    def __init__(self):
        self = self
    
    def id_search(self,idms,api_key):
        movie_url = f'https://api.themoviedb.org/3/find/{idms}?api_key={api_key}&language=en-US&external_source=imdb_id'
        urs = urllib.request.urlopen(movie_url)
        m_data = urs.read()
        json_data = json.loads(m_data)
        first = json_data.get('movie_results')
        imdb_title = first[0].get('title')
        imdb_titles.append(imdb_title)
        web_id = first[0].get('id')
        movie_url2 =f'https://api.themoviedb.org/3/movie/{idms}/keywords?api_key={api_key}'
        urs2 = urllib.request.urlopen(movie_url2)
        m_data2 = urs2.read()
        json_data2 = json.loads(m_data2)
        imdb_keyword = json_data2.get('keywords')
        imdb_keyword = [i.get('name') for i in imdb_keyword]
        imdb_keyword = [','.join(imdb_keyword)]
        imdb_keywords.append(imdb_keyword)
        movie_url3 = f'https://api.themoviedb.org/3/movie/{web_id}?api_key={api_key}'
        urs3 = urllib.request.urlopen(movie_url3)
        m_data3 = urs3.read()
        json_data3 = json.loads(m_data3)
        imdb_id_search = json_data3.get('imdb_id')
        imdb_api_ids.append(imdb_id_search)


        
    def create_imdb_dataframe(self,movie_id,movie_title,movie_keywords):
        imdb_df['IMDB_ID_2'] = imdb_api_ids
        imdb_df['IMDB_title'] = imdb_titles
        imdb_df['IMDB_keyword'] = imdb_keywords 



a = Tr_Lista()
a.scrape_lista(html_data)
a.create_dataframe(titles,imdb_id,sizes,seeders,leechers)
df.to_sql('movies_tor', con=engine, if_exists='append', index=False)

movie_search = IMDB_API()
for movies in df['IMDB_ID'].tolist():
    if movies != "":
        movie_search.id_search(movies,'21ac8244281f5dc5cda62f66695c6560')
    else:
        pass

movie_search.create_imdb_dataframe(imdb_api_ids,imdb_titles,imdb_keywords)
imdb_df.to_sql('imdb_info', con=engine, if_exists='append', index=False)

sql = "CREATE TABLE torrent_imdb as (SELECT * FROM movies_tor JOIN IMDB_info ON movies_tor.IMDB_ID = imdb_info.IMDB_ID_2 )"

with engine.connect() as connection:
    result = connection.execute(sql)

