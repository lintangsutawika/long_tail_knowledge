import hashlib
import numpy as np
import numba as nb
from tqdm.auto import tqdm
import pdb

from functools import partial
from collections import Counter
import multiprocess as mp

# def sort_entity_map(entity_map):
#     _entity_map = {}
#     for e in tqdm(entity_map.keys()):
#         _entity_map[e] = np.sort(np.unique(entity_map[e]))
#     return _entity_map

def divide_chunks(l, n):
    for i in range(0, len(l), n):
        yield l[i:i + n]

def split(a, n):
    k, m = divmod(len(a), n)
    return (a[i*k+min(i, m):(i+1)*k+min(i+1, m)] for i in range(n))

def sort_entity_map(keys, file_path):

    def _sort(keys, file_path):
        entity_map = np.load(file_path)

        all_dict = {}
        for key in tqdm(keys, total=len(keys)):
            all_dict[key] = np.sort(np.unique(entity_map[key]))

        return all_dict

    num_proc = mp.cpu_count()-1
    with mp.Pool(processes=num_proc) as pool:
        keys_per_pool = list(split(keys, num_proc))
        _entity_map = list(pool.map(partial(_sort, file_path=file_path), keys_per_pool))

    _all_entity_map = Counter()
    for idx, _dict in enumerate(tqdm(_entity_map)):
        _all_entity_map.update(_dict)
    
    return _all_entity_map


@nb.njit
def intersect(l1, l2):
    i = j = k = 0
    ret = np.empty((min(l1.size, l2.size),))
    while i < l1.size and j < l2.size:
        if l1[i] == l2[j]:
            ret[k] = l1[i]
            i += 1
            j += 1
            k += 1
        elif l1[i] < l2[j]:
            i += 1
        else:
            j += 1
    return ret[:k]

@nb.njit
def difference(l1, l2):
    i = j = k = 0
    ret = np.empty((l1.size,))
    while i < l1.size:
        if j >= l2.size:
            ret[k] = l1[i]
            i += 1
            k += 1
        elif l1[i] == l2[j]:
            i += 1
            j += 1
        elif l1[i] < l2[j]:
            ret[k] = l1[i]
            i += 1
            k += 1
        else:
            j += 1
    return ret[:k]
