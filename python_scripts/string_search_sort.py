#! /usr/bin/python3

from thefuzz import process, fuzz
# from fuzzywuzzy import fuzz, process
# import pandas as pn

with open("profils_names.csv") as fp:
    prn = fp.readlines()

prn = [x.strip() for x in prn]
# print(prn)

with open("config_vars_names.csv") as fc:
    cvn = fc.readlines()

cvn = [x.strip() for x in cvn]
# print(cvn)

for profil in prn:
    match_ratios = process.extract(profil, cvn, scorer=fuzz.token_sort_ratio)
    print(profil)
    print(match_ratios)
    print("\n")


