import sys, os, shutil 

sys.path.append('/usr/local/lib/python3.7/site-packages/')
os.environ['NUMBAPRO_NVVM'] = '/usr/local/cuda/nvvm/lib64/libnvvm.so'
os.environ['NUMBAPRO_LIBDEVICE'] = '/usr/local/cuda/nvvm/libdevice/'
os.environ["CONDA_PREFIX"] = "/usr/local"

for so in ['cudf', 'rmm', 'nccl', 'cuml', 'cugraph', 'xgboost', 'cuspatial', 'cupy', 'geos','geos_c']: 
    fn = 'lib'+so+'.so' 
    source_fn = '/usr/local/lib/'+fn 
    dest_fn = '/usr/lib/'+fn 
    if os.path.exists(source_fn): 
        print(f'Copying {source_fn} to {dest_fn}') 
        shutil.copyfile(source_fn, dest_fn)

import cudf
import io, requests

url="https://github.com/plotly/datasets/raw/master/tips.csv"
content = requests.get(url).content.decode('utf-8')
tips_df = cudf.read_csv(io.StringIO(content))
tips_df['tip_percentage'] = tips_df['tip']/tips_df['total_bill']*100
print(tips_df.groupby('size').tip_percentage.mean())

import cuml

df_float = cudf.DataFrame()
df_float['0'] = [1.0, 2.0, 5.0]
df_float['1'] = [4.0, 2.0, 1.0]
df_float['2'] = [4.0, 2.0, 1.0]
dbscan_float = cuml.DBSCAN(eps=1.0, min_samples=1)

dbscan_float.fit(df_float)

print(dbscan_float.labels_)
