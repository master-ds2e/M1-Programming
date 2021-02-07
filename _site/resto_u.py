from bs4 import BeautifulSoup
import urllib3
import re
import time
import datetime
from datetime import timedelta
import numpy as np

def get_page(urlpage,element ,html_class):
    """
    From an link and a html class that you select by inspecting manually the page
    Return a list with elements that matched this class
    """
    # Get page in html
    req = urllib3.PoolManager()
    res = req.request('GET', urlpage)
    soup = BeautifulSoup(res.data, 'html.parser')
    
    # Return elements that matched the html class in a list
    content = soup.find_all(element ,class_= html_class)
    
    return content 

def get_all_links():
    """
    Get all restaurants links and create a dict of link with ru_names as keys
    """
    # Webpage from which we extract all links
    urlpage = 'https://www.crous-strasbourg.fr/restauration/vos-restaurants-et-leurs-menus/'
    
    # Use our get_page function to extract a list with all list
    links = get_page(urlpage,'div','links')
    
    # Create an empty dict
    names_links = {}
    
    # Iterate over each link
    for link in links:
        # Check if the restaurant is open, it is written in the url !
        if bool(re.search('ouvert',str(link))):
            # Extract the name of the restaurant
            name = re.findall('restaurant/(.*)-ouvert/',str(link))[0]
            # Extract the link
            link = re.search('http:.*ouvert/',str(link)).group()
            # Update the dict
            names_links.update({name : link})
            
    return names_links
    


def get_menu(content):
    """
    Get meal content, pole names, clean the menu and store it in a dict
    """
    # Extract first titles using the class 'name'
    names = re.findall('<span class="name">(.*?)</span>',str(content))
    
    # Extract meals with the class 'liste-plats'
    meals = re.findall('<ul class="liste-plats">(.*?)</ul>',str(content))
    
    # Select everything within 'li' tags
    meals_list = [re.findall('<li>(.*?)</li>',item) for item in meals]
    
    # Remove some words that you want to throwaway
    to_remove =  ['UNIQUEMENT A EMPORTER','A EMPORTER','','-','ou']
    clean_meals_list = [list(filter(lambda x: x not in to_remove,meals)) for meals in meals_list]
    
    # Create a Dict with the name of the pole as key and meal content as value
    dict_content = {name : meal for name, meal in zip(names,clean_meals_list)}
    
    return dict_content


def show_item(list_):
    i = 1
    for item in list_:
        print('%s : %s'%(str(i),item))
        i+=1

all_ru_menu = {}
n_days = 3
meal_keys = ['breakfast','lunch','dinner']

# Get all links for opened restaurants
links = get_all_links()

# Loop over the links, since it is a dict it with loop on the keys, wich are the names
for name in links:
    print('retrieve menu of the '+name)
    # Get the content
    page = get_page(links[name],
                    element = 'ul',
                    html_class = 'slides')
    
    # Clean dates and meals
    dates = re.findall('<h3>(.*)</h3>',str(page))[:n_days]
    restaurant = re.findall('<div class="content-repas"><div>(.*?)</div>',str(page))[:n_days*3]
    # update dict keys if the date is new
    for date in dates:
        if date not in all_ru_menu:
            all_ru_menu.update({date:{meal:{} for meal in meal_keys}})
    
    # Loop over the content and use the keys to feed the dict
    # Since there is 3 types of lunch we repeat dates thee times
    date_meal_menu = zip(np.repeat(dates,3).tolist(),meal_keys*n_days,restaurant)
    
    for date, meal, meal_menu in date_meal_menu:
        # Get the menu and clean it a bit
        menu = get_menu(meal_menu)
        
        # if the menu is not empy
        if bool(menu):
            # update the dictionary with the name of the restaurant and the menu
            all_ru_menu[date][meal].update({name:menu})
    # ZzZzz
    time.sleep(2)

print('Download finished')



quit = 'N'
change_rest = 'Y'
while quit=='N':
    dates = list(all_ru_menu.keys())
    show_item(dates)
    date_choosed = int(input('Select the date (type the number aside)'))
    show_item(meal_keys)
    meal_choosed = int(input('Select the meal (type the number aside)'))
    restaurants = list(all_ru_menu[dates[date_choosed-1]][meal_keys[meal_choosed-1]].keys())
    while change_rest == 'Y':
        show_item(restaurants)
        rest_choosed = int(input('Select the restaurant (type the number aside)'))
        menu = all_ru_menu[dates[date_choosed-1]][meal_keys[meal_choosed-1]][restaurants[rest_choosed-1]]
        for meal in menu:
            print('''%s :
            %s
              '''%(meal,menu[meal]))
        change_rest = input('Do you want to select another restaurant ? (Y/N)')
    
    
    quit = input('Do you want to quit ? (Y/N)')
        

