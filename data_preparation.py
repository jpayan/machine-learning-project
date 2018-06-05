import pandas as pd
import numpy as np


def write_file(data, path):
    with open(path, 'wb') as f: 
        f.write("store_nbr,item_nbr\n")
        for sno, ino in data:
            f.write("{},{}\n".format(sno, ino))


def get_valid_combinations(data_set):
    data_frame = data_set.copy()
    data_frame['log1p'] = np.log(data_frame['units'] + 1)
    
    group = data_frame.groupby(["store_nbr", "item_nbr"])['log1p'].mean()
    group = group[group > 0.0]
    
    store_nbrs = group.index.get_level_values(0)
    item_nbrs = group.index.get_level_values(1)
    
    return sorted(zip(store_nbrs, item_nbrs), key = lambda t: t[1] * 10000 + t[0] )


if __name__ == "__main__":
	data_frame_train = pd.read_csv("data/train.csv")
	store_item_nbrs = get_valid_combinations(data_frame_train)
	write_file(store_item_nbrs, "model/store_item_nbrs.csv")

