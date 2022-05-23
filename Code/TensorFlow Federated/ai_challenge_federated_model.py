import tensorflow as tf
import pandas as pd
import numpy as np
import collections
import tensorflow_federated as tff

NUM_EPOCHS = 5
BATCH_SIZE = 10
SHUFFLE_BUFFER = 100
NUM_ROUNDS_FL = 10
PREFETCH_BUFFER = 1

feature_names = ['obss_pd', 'interference', 'rssi', 'sinr']
label_names = ['throughput']


# Pre-processing function
def make_federated_data(client_data, context_ids):
    # Create the TF datasets for each context
    tf_datasets = []
    # for context_id in set(client_data['context']):
    for context_id in context_ids:
        # Get subset of features belonging to a particular context/user
        context_data = client_data[client_data['context'] == context_id]
        features = context_data[feature_names]
        labels = context_data[label_names]
        od = collections.OrderedDict(
            x=np.array(features),
            y=np.array(labels)/50.0)
        tf_dataset = tf.data.Dataset.from_tensor_slices(od)
        tf_dataset = tf_dataset.repeat(NUM_EPOCHS).shuffle(SHUFFLE_BUFFER, seed=1).batch(BATCH_SIZE).prefetch(PREFETCH_BUFFER)
        tf_datasets.append(tf_dataset)

    return tf_datasets


# Load the training and test data sets as DataFrame objects
train_data_set = pd.read_csv("../simulator_output/processed_outputs/processed_output_s2_norm.csv",
                             names=['context', 'obss_pd', 'throughput', 'interference', 'rssi', 'sinr'],
                             sep=";", skiprows=1, )

# Convert the dataset into a federated on
context_ids = set(train_data_set['context'])
train_datasets = make_federated_data(train_data_set, context_ids)
sample_data_set = train_datasets[0]
print(sample_data_set)


# Define the ML model
def create_keras_model():
    return tf.keras.models.Sequential([
        tf.keras.layers.InputLayer(input_shape=(4,)),
        tf.keras.layers.Dense(64, activation='relu'),
        tf.keras.layers.Dense(1, activation='softmax', kernel_initializer='zeros'),
    ])


# Model constructor (needed to be passed to TFF, instead of a model instance)
def model_fn():
    keras_model = create_keras_model()
    return tff.learning.from_keras_model(
        keras_model,
        input_spec=sample_data_set.element_spec,
        loss=tf.keras.losses.SparseCategoricalCrossentropy(),
        metrics=[tf.keras.metrics.SparseCategoricalAccuracy()])


# Define the iterative process to be followed for training both clients and the server
# More optimizers here: https://www.tensorflow.org/api_docs/python/tf/keras/optimizers
iterative_process = tff.learning.build_federated_averaging_process(
    model_fn,
    client_optimizer_fn=lambda: tf.keras.optimizers.SGD(learning_rate=0.01, nesterov=True),
    server_optimizer_fn=lambda: tf.keras.optimizers.SGD(learning_rate=1.00, nesterov=True))


# Generate a fed evaluation
fed_evaluation = tff.learning.build_federated_evaluation(model_fn)

# Initialize the server state
state = iterative_process.initialize()

print(state.model)

# Iterate for each communication round in FL
for round_num in range(0, NUM_ROUNDS_FL):
    # Training round
    iter_data = train_datasets[0:10]
    # print(iter_data)
    state, train_metrics = iterative_process.next(state, iter_data)
    print('Round  {}, test metrics={}'.format(round_num, train_metrics))

    # test_metrics = fed_evaluation(state.model, iter_data)
    # print('Round  {}, test metrics={}'.format(round_num, test_metrics))

print(state.model)