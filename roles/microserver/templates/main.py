from fastapi import FastAPI, HTTPException
import requests
import datetime
from datetime import timedelta
from starlette.responses import RedirectResponse
from urllib3.util.retry import Retry
from requests.adapters import HTTPAdapter

s = requests.Session()

retries = Retry(total=5,
                backoff_factor=0.1,
                status_forcelist=[ 500, 502, 503, 504 ])

s.mount('https://', HTTPAdapter(max_retries=retries))

app = FastAPI()

cache = {}

@app.get("/api/micromamba/{platform}/{version}")
def get_micromamba(platform, version='latest'):
    cache_ts = cache.get(platform, {}).get(version, {}).get('ts', None)
    if cache_ts:
        if (datetime.datetime.now() - cache_ts) <= timedelta(minutes=30):
            url = cache[platform][version]['url']
            print(f"Cache hit: {int((datetime.datetime.now() - cache_ts).seconds / 60)}: {url}")
            return RedirectResponse(url)

    url = f"https://api.anaconda.org/release/conda-forge/micromamba/{version}"

    print("Getting Anaconda.org API")
    r = s.get(url, timeout=10)

    if r.ok:
        rj = r.json()
        tmp_cache = {}
        for d in rj["distributions"]:
            dplat = d["attrs"]["subdir"]
            cache_dict = {
                    'ts': datetime.datetime.now(),
                    'url': d["download_url"],
                    'build_number': d.get("attrs", {}).get("build_number", 0)
                }

            if dplat in tmp_cache:
                if cache_dict['build_number'] > tmp_cache[dplat][version]['build_number']:
                    tmp_cache[dplat][version] = cache_dict
            else:
                tmp_cache[dplat] = {version: cache_dict}

        for plat in tmp_cache:
            if version in cache:
                cache[plat][version] = tmp_cache[plat][version]
            else:
                cache[plat] = tmp_cache[plat]

    # check if we still have something in our cache
    url = cache.get(platform, {}).get(version, {}).get('url')
    if url:
        ts = datetime.datetime.now() - cache.get(platform, {}).get(version, {}).get('ts', None)
        print(f"Returning {platform}/{version}. Serving {url}. Age: {ts.seconds // 60}mn")
        return RedirectResponse(url=url)

    raise HTTPException(status_code=404, detail=f"No version found for {platform}/{version}")
