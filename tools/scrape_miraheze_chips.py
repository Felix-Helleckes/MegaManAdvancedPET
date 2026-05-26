"""
Minimal Miraheze chip scraper template.

Usage:
  python tools/scrape_miraheze_chips.py --base https://example.miraheze.org/wiki --out assets/data/chips.json

This script is a template and attempts to find a table of chips on a Miraheze wiki.
Adjust selectors based on the target wiki layout. It saves JSON entries with fields:
  id, name, damage, element, category, code, description, image_url

Run manually — the script does not run automatically.
"""
import requests
from bs4 import BeautifulSoup
import json
import argparse

def scrape_index(base_url, index_path='/'):
    # naive fetch — user should provide correct index page
    r = requests.get(base_url)
    r.raise_for_status()
    soup = BeautifulSoup(r.text, 'html.parser')
    # try to find links to "Battle Chip" pages
    links = []
    for a in soup.select('a'):
        href = a.get('href')
        if href and 'Battle_Chip' in href:
            links.append(href)
    return links

def fetch_chip(url):
    r = requests.get(url)
    r.raise_for_status()
    soup = BeautifulSoup(r.text, 'html.parser')
    title = soup.find('h1')
    name = title.text.strip() if title else url.split('/')[-1]
    # look for infobox or table
    info = {'name': name, 'source_url': url}
    # image
    img = soup.select_one('.infobox img') or soup.select_one('.thumbimage')
    if img and img.get('src'):
        info['image_url'] = img.get('src')
    # description
    p = soup.select_one('p')
    if p:
        info['description'] = p.text.strip()
    return info

def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('--base', required=True)
    parser.add_argument('--out', default='assets/data/chips.json')
    args = parser.parse_args()

    links = scrape_index(args.base)
    chips = []
    for rel in links:
        if rel.startswith('/'): rel = args.base.rstrip('/') + rel
        elif rel.startswith('http'): pass
        else: rel = args.base.rstrip('/') + '/' + rel.lstrip('/')
        try:
            chips.append(fetch_chip(rel))
        except Exception as e:
            print('Failed', rel, e)

    with open(args.out, 'w', encoding='utf-8') as fh:
        json.dump(chips, fh, indent=2, ensure_ascii=False)
    print('Wrote', len(chips), 'chips to', args.out)

if __name__ == '__main__':
    main()
