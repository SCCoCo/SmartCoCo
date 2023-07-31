def upper_bound(a, x, lo=0, hi=None):
    """Return the index where to insert item x in list a, assuming a is sorted.
    The return value i is such that all e in a[:i] have e <= x, and all e in
    a[i:] have e > x.  So if x already appears in the list, a.insert(x) will
    insert just after the rightmost x already there.
    Optional args lo (default 0) and hi (default len(a)) bound the
    slice of a to be searched.
    """
 
    if lo < 0:
        raise ValueError('lo must be non-negative')
    if hi is None:
        hi = len(a)
    while lo < hi:
        mid = (lo+hi)//2
 
        if x <= a[mid]:
            hi = mid
        else:
            lo = mid+1
    return lo

def bisect_left(a, x, lo=0, hi=None):
    """Return the index where to insert item x in list a, assuming a is sorted.
    The return value i is such that all e in a[:i] have e < x, and all e in
    a[i:] have e >= x.  So if x already appears in the list, a.insert(x) will
    insert just before the leftmost x already there.
    Optional args lo (default 0) and hi (default len(a)) bound the
    slice of a to be searched.
    """
 
    if lo < 0:
        raise ValueError('lo must be non-negative')
    if hi is None:
        hi = len(a)
    while lo < hi:
        mid = (lo+hi)//2
        if a[mid] <= x: lo = mid+1
        else: hi = mid
    return lo


def check_in_lst(a, x):
    lo = upper_bound(a, x)
    try:
        if a[lo] == x:
            return lo
    except:
        return -1
    return -1


def test_():
    a = [1,3,5,6,7,8,9,22]
    x = 3
    y = 10
    print(upper_bound(a, x))
    print(check_in_lst(a, x))
    # print(bisect_left(a, y))

test_()