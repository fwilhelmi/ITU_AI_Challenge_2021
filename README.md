# README #

# ITU_AI_Challenge_2021
IEEE 802.11ax Spatial Reuse through Federated Learning - ITU AI Challenge 2021

### Authors
* [Francesc Wilhelmi](https://fwilhelmi.github.io/) (CTTC)
* Jernej Hribar (CONNECT Centre, Trinity College Dublin)
* Selim F. Yilmaz (King's College London)
* Emre Ozfatura (King's College London)
* Kerem Ozfatura (King's College London)
* Ozlem Yildiz (New York University)
* Deniz Gündüz (King's College London)
* Hao Chen (Xiamen University)
* Xiaoying Ye (Xiamen University)
* Lizhao You (Xiamen University)
* Yulin Shao (Xiamen University)
* [Paolo Dini](http://www.cttc.es/people/pdini/) (CTTC)
* [Boris Bellalta](http://www.dtic.upf.edu/~bbellalt/) (Universitat Pompeu Fabra)

### Project description

As wireless standards evolve, more complex functionalities are introduced to address the increasing requirements in terms of throughput, latency, security, and efficiency. To unleash the potential of such new features, artificial intelligence (AI) and machine learning (ML) are currently being exploited for deriving models and protocols from data, rather than by hand-programming. In this paper, we explore the feasibility of applying ML in next-generation wireless local area networks (WLANs). More specifically, we focus on the IEEE 802.11ax spatial reuse (SR) problem and predict its performance through federated learning (FL) models. The set of FL solutions overviewed in this work is part of the 2021 International Telecommunication Union (ITU) AI for 5G Challenge.

To meet the overarching goal of this project, a dataset was generated with the [Komondor simulator](https://github.com/wn-upf/Komondor/), which was provided to train FL models with (preferably) TensorFlow.

[Video](https://aiforgood.itu.int/event/unleashing-the-potential-of-machine-learning-to-address-spatial-reuse-in-future-ieee-802-11-wlans-an-introduction-to-two-problem-statements-for-the-itu-ai-challenge/) Presentation of the IEEE 802.11ax SR topic and introduction to the problem statement.

### Repository description
This repository contains the main resources of problem statement [*PS-004: Federated Learning for Spatial Reuse in a multi-BSS (Basic Service Set) scenario*](https://www.upf.edu/web/wnrg/2021-edition) of the [ITU AI for 5G Challenge (2021)](https://challenge.aiforgood.itu.int/).

#### Repository organization

#### How-to guide

1. Download the dataset from [Zenodo](https://zenodo.org/record/5656866#.YfelZPXML0p).
2. Pre-process the dataset (see, for instance, the files in [Code>TensorFlow Federated](https://github.com/fwilhelmi/ITU_AI_Challenge_2021/tree/main/Code/Matlab%20-%20Plot%20results)).
3. Install TensorFlow Federated (TFF) or other FL libraries (e.g., Pytorch) to create and train an FL model. Some basic examples can be found in [Code>TensorFlow Federated](https://github.com/fwilhelmi/ITU_AI_Challenge_2021/tree/main/Code/Matlab%20-%20Plot%20results).
4. Process the results (see, for instance, the files in [Code>Matlab - Plot results](https://github.com/fwilhelmi/ITU_AI_Challenge_2021/tree/main/Code/Matlab%20-%20Plot%20results)).

### Acknowledgements


### Contribute

If you want to contribute, please contact to [fwilhelmi@cttc.cat](fwilhelmi@cttc.cat)
