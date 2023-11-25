# Automatic Speech Recognition (ASR) Research Project

## Overview

In the realm of machine learning, the quantity of training materials plays a pivotal role in determining test accuracy and error. Researchers often grapple with the challenge of ascertaining the optimal amount of training data for achieving the best outcomes. The constraints of acquiring topic-specific datasets, coupled with the demanding and costly nature of the process, underscore the need to explore the minimum dataset size that yields reasonable results. Despite the critical importance of this aspect in machine learning, little research has been conducted across domains on determining the ideal number of training materials.

This study addresses this research gap in the domain of automatic speech recognition (ASR), specifically focusing on keyword spotting. The primary research question driving this investigation is: "How many training materials are sufficient for keyword spotting?" The core emphasis of the study lies in varying the amount of training data across models and subsequently comparing the test accuracy of each model.

### Convolutional Neural Network (CNN) Model

The study employs a Convolutional Neural Network (CNN) model for keyword spotting. This multi-layered neural network utilizes the dataset as input for the first layer and certain identifiable features for the second layer. The results are represented graphically, and critical points on the graph are thoroughly examined. Four types of critical points are analyzed: (1) global maximum, (2) global minimum, (3) local maxima, and (4) local minima. The significance of these critical points lies in their ability to indicate the best and worst outcomes of the model, both globally and within specific ranges of approximations.

### Speech Data

The Google Commands Dataset serves as the training material for this experiment. This dataset comprises 65,000 one-second-long utterances of 30 short words spoken by thousands of different people. Originally designed for applications, the dataset enables the development of basic voice interfaces. For this experiment, 10 words from the Google Commands Dataset, including "down," "go," "left," "no," "off," "on," "right," "stop," "up," and "yes," were selected as the training materials.

The study aims to provide valuable insights into the nuanced relationship between the quantity of training materials and the efficacy of keyword spotting in automatic speech recognition.


## Results

![ASR Research Result](https://github.com/mijin-gwak/PortfolioProjects/blob/main/ASR%20Research%20Result.png)

The results revealed the following critical points on the learning curve:

- **Global Maximum:**
  - Achieved when approximately 90% of the dataset was utilized.

- **Local Maxima:**
  - Elicited when approximately 25%, 50%, and 70% of the dataset was used.

- **Local Minima:**
  - Indicated when approximately 35%, 60%, and 80% of the dataset was used.

- **Global Minimum:**
  - Not represented on the graph, as x approaches negative infinity.

## Methodology

The study investigated predictive accuracy on test materials as a function of the number of training materials. The critical points on the learning curve were examined to identify the most ideal dataset size. The global maximum, around 90% of the dataset, emerged as the point with the best test accuracy.

## Recommendations

- **Global Maximum (90%):**
  - Indicates the best overall test accuracy.

- **Local Maxima (25%, 50%, 70%):**
  - Suggests the best outcome within specific dataset size ranges.

- **Local Minima (35%, 60%, 80%):**
  - Should be avoided, as they resulted in the worst outcomes within given ranges.

## Code for training the model

```python
import librosa
import os
import json

DATASET_PATH = "dataset"
JSON_PATH = "data.json"
SAMPLES_TO_CONSIDER = 22050 # 1 sec. of audio


def preprocess_dataset(dataset_path, json_path, num_mfcc=13, n_fft=2048, hop_length=512):
    """Extracts MFCCs from music dataset and saves them into a json file.
    :param dataset_path (str): Path to dataset
    :param json_path (str): Path to json file used to save MFCCs
    :param num_mfcc (int): Number of coefficients to extract
    :param n_fft (int): Interval we consider to apply FFT. Measured in # of samples
    :param hop_length (int): Sliding window for FFT. Measured in # of 
samples
    :return:
    """

    # dictionary where we'll store mapping, labels, MFCCs and filenames
    data = {
        "mapping": [],
        "labels": [],
        "MFCCs": [],
        "files": []
    }

    # loop through all sub-dirs
    for i, (dirpath, dirnames, filenames) in 
        enumerate(os.walk(dataset_path)):

        # ensure we're at sub-folder level
        if dirpath is not dataset_path:

            # save label (i.e., sub-folder name) in the mapping
            label = dirpath.split("/")[-1]
            data["mapping"].append(label)
            print("\nProcessing: '{}'".format(label))

            # process all audio files in sub-dir and store MFCCs
            for f in filenames:
                file_path = os.path.join(dirpath, f)

                # load audio file and slice it to ensure length consistency among different files
                signal, sample_rate = librosa.load(file_path)

                # drop audio files with less than pre-decided number of samples
                if len(signal) >= SAMPLES_TO_CONSIDER:

                    # ensure consistency of the length of the signal
                    signal = signal[:SAMPLES_TO_CONSIDER]

                    # extract MFCCs
                    MFCCs = librosa.feature.mfcc(signal, sample_rate, n_mfcc=num_mfcc, n_fft=n_fft,
                                                 hop_length=hop_length)

                    # store data for analysed track
                    data["MFCCs"].append(MFCCs.T.tolist())
                    data["labels"].append(i-1)
                    data["files"].append(file_path)
                    print("{}: {}".format(file_path, i-1))

    # save data in json file
    with open(json_path, "w") as fp:
        json.dump(data, fp, indent=4)


if __name__ == "__main__":
    preprocess_dataset(DATASET_PATH, JSON_PATH)
# ...
