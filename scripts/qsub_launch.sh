#! /bin/bash

#$ -wd /mnt/mfs/hgrcgrid/homes/tl3087/immunosenescence/
#$ -l mem_total=500G
#$ -l h_rt=150:00:00
#$ -j y
#$ -o jobs/my_phenograph_sortbysizemodified.qlog
#$ -V

/mnt/mfs/hgrcgrid/homes/tl3087/miniconda3/bin/python /mnt/mfs/hgrcgrid/homes/tl3087/immunosenescence/scripts/my_phenograph.py

#! /bin/bash

#$ -wd /mnt/mfs/hgrcgrid/homes/tl3087/immunosenescence/
#$ -l mem_total=500G
#$ -l h_rt=150:00:00
#$ -j y
#$ -o jobs/my_cell_level_glmer.qlog
#$ -V

/mnt/mfs/hgrcgrid/homes/tl3087/miniconda3/bin/Rscript /mnt/mfs/hgrcgrid/homes/tl3087/immunosenescence/scripts/my_cell_level_glmer.R

#! /bin/bash

#$ -wd /mnt/mfs/hgrcgrid/homes/tl3087/immunosenescence
#$ -N umap
#$ -o jobs/umap.olog
#$ -e jobs/umap.elog
#$ -l mem_total=400G
#$ -l h_rt=24:00:00

/mnt/mfs/hgrcgrid/homes/tl3087/miniconda3/bin/Rscript /mnt/mfs/hgrcgrid/homes/tl3087/immunosenescence/scripts/my_umap.R


#! /bin/bash

#$ -wd /mnt/mfs/hgrcgrid/homes/tl3087/immunosenescence
#$ -N mds
#$ -o jobs/mds.olog
#$ -e jobs/mds.elog
#$ -l mem_total=400G
#$ -l h_rt=24:00:00

/mnt/mfs/hgrcgrid/homes/tl3087/miniconda3/bin/Rscript /mnt/mfs/hgrcgrid/homes/tl3087/immunosenescence/scripts/my_mds.R
