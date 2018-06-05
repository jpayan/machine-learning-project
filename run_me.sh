mkdir model
mkdir submission
ipython data_preparation.py
R --vanilla < baseline.r
ipython preprocess_data.py
ipython rollingmean.py
ipython handle_zeros_parameters.py
ipython create_features.py
ipython vowpal_wabbit_creator.py
source  vowpal_wabbit_runner.sh 
ipython result_generator.py
