from nltk.parse.corenlp import CoreNLPParser
# from time import time
from config import Config

url = Config.CORENLP_HTTP

# a = time()

pos_tagger = CoreNLPParser(url=url, tagtype='pos')

# b = time()

# def keep_only_noun(entxt):
#     res = pos_tagger.tag(entxt.split())
#     print(res)

# keep_only_noun("being the owner")

# c = time()

# print(b-a, c-b)