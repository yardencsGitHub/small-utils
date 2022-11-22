#%%
import torch
import torchmetrics
import vak
# %%
import numpy as np
def levenshtein(source, target):
    """Levenshtein distance: number of deletions, insertions,
    or substitutions required to convert source string
    into target string.
    Parameters
    ----------
    source, target : str
    Returns
    -------
    distance : int
    number of deletions, insertions, or substitutions
    required to convert source into target.
    adapted from https://github.com/toastdriven/pylev/blob/master/pylev.py
    to fix issues with the Numpy implementation in
    https://en.wikibooks.org/wiki/Algorithm_Implementation/Strings/Levenshtein_distance#"""
    if source == target:
        return 0
    # We call tuple() to force strings to be used as sequences
    # ('c', 'a', 't', 's') - numpy uses them as values by default.
    source = np.array(tuple(source))
    target = np.array(tuple(target))
    len_source = source.size
    len_target = target.size
    if len_source == 0:
        return len_target
    if len_target == 0:
        return len_source
    if len_source > len_target:
        source, target = target, source
        len_source, len_target = len_target, len_source
    # We use a dynamic programming algorithm, but with the
    # added optimization that we only need the last two rows
    # of the matrix.
    d0 = np.arange(len_target + 1)
    d1 = np.arange(len_target + 1)
    for i in range(len_source):
        d1[0] = i + 1
        for j in range(len_target):
            cost = d0[j]
            if source[i] != target[j]:
                cost += 1 # substitution
                x_cost = d1[j] + 1 # insertion
                if x_cost < cost:
                    cost = x_cost
                y_cost = d0[j + 1] + 1
                if y_cost < cost:
                    cost = y_cost

            d1[j + 1] = cost
        d0, d1 = d1, d0
    return d0[-1]
# %%
levenshtein("Cat", "Bat")

# %%
