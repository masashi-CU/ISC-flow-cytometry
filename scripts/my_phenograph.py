print("\nImporting libraries\n")
import phenograph
import pyreadr
import pandas as pd
from timeit import default_timer as timer
from datetime import timedelta
import scipy.io as sio

print("Loading data\n")
data = pyreadr.read_r('results/cytof.logicle.markers.rds')
data = data[None].to_numpy()
print("Data shape: ", data.shape, "\n")

print("Running phenograph...\n")
start = timer()
communities, graph, Q = phenograph.cluster(data, primary_metric="euclidean", n_jobs=10, seed=123)
end = timer()
print("Elapsed wall time: ", timedelta(seconds=end-start), "\n")  #3:52:39 #6:43:33 # 3:58:19
print("Q:", Q, "\n") # Q_{ga}:0.889235

print("Saving cluster assignment\n")
pyreadr.write_rds('results/clust.pg.logicle.2.rds', pd.DataFrame(communities))
print("Saving graph\n")
sio.mmwrite('results/clust.pg.logicle.2.mtx', graph)

print("EOF")
