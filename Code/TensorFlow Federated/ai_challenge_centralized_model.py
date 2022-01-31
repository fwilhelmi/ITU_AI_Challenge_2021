import tensorflow as tf
import pandas as pd
import numpy as np

train_data_set = pd.read_csv("../simulator_output/processed_outputs/processed_output_s2_norm.csv",
                             names=['context', 'obss_pd', 'throughput', 'interference', 'rssi', 'sinr'],
                             sep=";", skiprows=1, )

eval_data_set = pd.read_csv("../simulator_output/processed_outputs/processed_output_test_norm.csv",
                            names=['context', 'obss_pd', 'throughput', 'interference', 'rssi', 'sinr'],
                            sep=";", skiprows=1, )

# print(train_data_set.info())
# print(train_data_set[0:3])

print(train_data_set.mean(axis=0))

# Copy the dataframe to manipulate it
dataset_features = train_data_set.copy()
# Remove the "context" for the centralized solution
dataset_features.pop('context')
# Separate features from labels
dataset_labels = dataset_features.pop('throughput')

# Convert features into an array
dataset_features = np.array(dataset_features)
print('Features ')
print(dataset_features)
# print('Labels ')
# print(dataset_labels.head())

# Do the same for the eval. dataset
eval_features = eval_data_set.copy()
eval_features.pop('context')
eval_labels = eval_features.pop('throughput')
eval_features = np.array(eval_features)
print('Eval Features ')
print(eval_features)

# Define the ML model
model = tf.keras.Sequential()
model.add(tf.keras.layers.Dense(1024, input_shape=(4,)))
model.add(tf.keras.layers.Activation('relu'))
model.add(tf.keras.layers.Dropout(0.1))

model.add(tf.keras.layers.Dense(512))
model.add(tf.keras.layers.Activation('relu'))
model.add(tf.keras.layers.Dropout(0.1))

model.add(tf.keras.layers.Dense(256))
model.add(tf.keras.layers.Activation('relu'))
model.add(tf.keras.layers.Dropout(0.1))
model.add(tf.keras.layers.Dense(1))

# Compile the model and assign losses and optimizer
model.compile(loss='mean_absolute_error', optimizer=tf.keras.optimizers.SGD(learning_rate=0.01, nesterov=True))

# Train the model with the dataset
model.fit(dataset_features, dataset_labels, epochs=5, verbose=1)

# Evaluate the model on the test data using `evaluate`
print("Evaluate on test data")
results = model.evaluate(eval_features, eval_labels, batch_size=128)
print("test loss, test acc:", results)

# Predict the throughput in the test dataset
print("Generate predictions")
predictions = model.predict(eval_features)
np.savetxt('predictions.txt', predictions)
print("predictions shape:", predictions.shape)
