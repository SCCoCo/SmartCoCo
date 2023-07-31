# SmartCoCo of ASE‘23#874 
## SmartCoCo: Checking Comment-code Inconsistency in Smart Contracts via Constraint Propagation and Binding

**Thanks for your review.**
Attachments for ASE#874 SmartCoCo: Checking Comment-code Inconsistency in Smart Contracts via Constraint Propagation and Binding.

## Prototype 
**In the folder `SmartCoCo`.**

This is the artifact of the prototype. It is now implemented for research, and has an improvement on the design pattern.

To better use the following cmd, please `cd` to the folder.

### Requirements 
- python 3.10
- [CoreNLP](https://stanfordnlp.github.io/CoreNLP/) 
- solc with different version

So, you have to install python and CoreNLP to run the artifact. For Solidity compiler, it can automatically install with solcx by analyzing the version in smart contracts.

### Build from source
1. **Start CoreNLP server:**

Download from its web and unzip, then cd to its folder and run:

```shell
# Download, you can also refer to https://stanfordnlp.github.io/CoreNLP/
wget https://nlp.stanford.edu/software/stanford-corenlp-4.5.4.zip
unzip stanford-corenlp-4.5.4.zip
cd stanford-corenlp-4.5.4.zip
```

```shell
# Run corenlp server
nohup java -mx4g -cp "*" edu.stanford.nlp.pipeline.StanfordCoreNLPServer -port 9000 -timeout 15000 &
```

If you want to run the code with multiple processes, a better practice is to start NLP server with corresponding threads.

To stop the server, you can use:

```shell
wget "localhost:9000/shutdown?key=`cat /tmp/corenlp.shutdown`" -O -
```


2. **Install python packages:**

`cd` back to smartcoco, maybe you can use `cd ..`

If you use pip:

```shell
# Install required packages
pip install -r requirements.txt
```


3. **Initialize the settings:**

Setting the CoreNLP port and processes in `config.py `(Optional). 


4. **Run**

We have put some smart contracts with CCIs in the `test_dataset` folder. 
If you want to replay the whole experiment, please see `Full Dataset` in the following part.

**Note that the `python` refer to python3.10**


```shell
python analyzer/main.py -f <contract file or folder>
```

The `-f` is **required**, it indicates a smart contract or folder
The `-v` is to set and install solc with the related version, it is `optional`.


To avoid install multiple versions of solc, you can use this cmd to run contract with specific version:


```shell
python analyzer/main.py -f test_dataset/72bd6acb09bec09e2825b28d300b2e3d4488308f.sol -v 0.4.24
```

> If you still meet version errors, you may use the following cmd to install all or check the source code.

For running contracts with different versions, SmartCoCo need to install different solc versions to `~/.solcx`, so it would take some time.


```shell
python analyzer/main.py -f test_dataset -v all
```

> If you omit -v, it will not install them. Once installed, you do not need to use `-v` anymore. The tool can automatically recognize the version.

The results are in the `.temp` folder.
In the early version of SmartCoCo, we named the param(ct, fn, exp) as require(ct, fn, exp).

Run the full dataset in the paper:

Now we have added the 100K+ smart contracts to this repo, you can run it with the following cmd. 

```
python3 analyzer/main.py -f ../Full dataset
```

> You can see the folder `Full dataset` for more information and make sure the correctness of the path, e.g. `../Full dataset/contracts `. 


> If you still meet errors while running, you may need to look at the error information to fix them.



#### Summarized Patterns

Besides, our summarized patterns are in the folder `Pattern`.



## Dataset & Results

1. The full dataset

**See `Full dataset` folder.**

The `Full dataset` folder contains a csv file to collect the address of analyzed contracts, as well as all the source code of these contracts.

Please see [this repo](https://github.com/InPlusLab/ReentrancyStudy-Data) for more information of these unique dataset. Our full dataset is built on this. The deduplicated contracts is used as the full dataset in the evaluation.

2. The labeled dataset

Please see `Manually Labeled` folder to see the related files and labels. This dataset is only for research in this task.  


3. Raw result

We also save the detection results on consistencies and inconsistencies in the evaluation. The results are in the folder `Raw Detection Result`.


4. Compared to GPT Models

The source files are in the folder `GPT Result`.
