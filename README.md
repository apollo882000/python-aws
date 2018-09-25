# Task 
Cryptocurrency prices have seen some large fluctuations in the past few years. In this project, we introduce a system that monitors sizeable fluctuations in the price of USDT to ETH.

You should design the architecture of the **entire system**, which includes all three modules. The architecture design should be documented in a diagram that is part of the deliverables.

Implement **only one portion of the system, either the Data Ingestion module or the Data Analysis module.** The module has to be deployed onto the cloud with a deployment tool (CloudFormation, Terraform, Ansible, etc) of your choice.

You have the freedom to choose the programming language and tools of your choice, with the constraint that the cloud platform has to be either `Azure` or `AWS`.

You do not have to implement a production-ready system but do document your ideas and thoughts on how the system should be implemented for it to be so. This will a **big part** of our assessment as it is the main channel for us to assess your thought process.

You do not have to be concerned with the quality of the data provided and the depth of the analysis for the data. The core goals of this test is to assess your knowledge of the cloud tools, your ability to manage time, and also your thought process while designing cloud architectures. 

Do timebox yourself to 12 hours, we do not expect a comprehensive implementation but **we will focus more on the design process and documentation**.

We also prefer that you err on the side of being verbose on your documentation and commits - it allows us to have insight into your thought process, rather than viewing only the end product.

All of the deliverables are to be contained in a Github repository:
- implementation of one of two modules
- a deployment script (make, bash, etc) that will deploy the module
- documents for the following:
  - a simple breakdown of the overall time spent on the project (research, implementation, documentation, etc)
  - the architecture design for the entire solution
  - the assumptions that you have for your architecture design
  - the constraints/limits that your architecture has
  - what you would do to make the system a well-architected production-ready system
  - tradeoffs in the design decision(s) that you made

The system consists of the following three modules:

## Data Ingestion Module
This component pulls data from various data sources into the system's cloud platform. 
> In the future, it is expected that data will come from several sources and might appear in various formats (xml, text, etc). Data ingestion should be designed so that new modules can be added without too much overhead.

If you have chosen this portion of the project to implement, then the implementation should:
- pull data from an S3 bucket using this [link](https://s3-ap-southeast-1.amazonaws.com/tgr-hire-devops-test). Only data from the subfolder `/crypto/01-data-ingestion` should be used.

Each record contains trade prices over a 5 minute interval.
Here is a data dictionary of the fields in the data:

| Name | Type | Description |
| ---- | ---- | ----------- |
| `date` | timestamp | UTC timestamp of the start of the 5 minute interval where the trade data was summarized |
| `high` | float | the highest price for this period. |
| `low` | float | the lowest price for this period. |
| `open` | float | opening price for this period. |
| `close` | float | closing price for this period. |
| `volume` | float | volume of the first currency pair (USDT) |
| `quoteVolume` | float | volume of the second currency pair (ETH) | 
| `weightedAverage` | float |  weighted average of trades |


## Data Analysis Module
This component runs various analysis on the data that was ingested and creates alerts 
> In the future, it is expected that multiple engineers will work on this component and they will run different analysis scripts on the data. This part of the system is expected to scale to allow several analysis scripts and several engineers to work on them.

If you have chosen this portion of the project to implement, then the implementation should:
- run the following analysis: for each data record in the datastore, capture the records where `weighted_average` is equal or more than a **0.5 percent absolute change** from the `weighted_average` of the previous data record (in chronological order). 
- Populate the datastore with the file from this [link](https://s3-ap-southeast-1.amazonaws.com/tgr-hire-devops-test/crypto/02-data-analysis/USDT_ETH.csv). This population step does not have to be automated - the population of the datastore will be performed by the data ingestion module in a real environment.


The following table shows some sample records. With the criteria above, the second and fourth row should be captured.

| date | weightedAverage |
| ---- | ----------- |
1504224300 | 100.00
1504224600 | 100.50
1504224900 | 100.40
1504225200 | 99.40


## Notification Module
This component notifies end users or systems of an alert that was created in the Data Analysis stage. A SMS will be sent to end users of this system.
> In the future, it is expected that there will be different subscription mechanisms (email, slack). This part of the system should be designed so that new types of subscription mechanisms can be added without much overhead.