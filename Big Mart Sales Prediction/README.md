## Project Overview

### Problem Statement
Sales data of 1559 items across 10 stores in different locations have been collected in the year 2013. Each product has certain attributes that sets it apart from other products. Same is the case with each store.

The goal is to build a predictive model to find out the sales of each product at a particular store.

Dataset: [big mart part 1](data/train.csv)  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;[big mart part 2](data/test.csv)  
Python notebook: [Big mart EDA/regression modeling](BigMart%20Sales.ipynb)  

## Metadata  
The dataset has 12 columns with 1 column being an item identifier and the remaining columns being details of the item and the details of the outlet it was sold at.   
part 1 of the dataset has 8523 rows of data while part 2 has 5681 rows of data.  

__Item_Identifier__: unique product ID  
__Item_Weight__: weight of product  
__Item_Fat_Content__: whether the product is low fat or not  
__Item_Visibility__: the % of total display area of all products in a store allocated to the particular product   
__Item_Type__: the category to which the product belongs  
__Item_MRP__: maximum retail price (list price) of the product  
__Outlet_Identifier__: unique store ID  
__Outlet_Establishment_Year__: the year in which store was established  
__Outlet_Size__: the size of the store in terms of ground area covered  
__Outlet_Location_Type__: the type of city in which the store is located    
__Outlet_Type__: whether the outlet is just a grocery store or some sort of supermarket   
__Item_Outlet_Sales__: sale of the product in the particular store. <ins>This is also the outcome variable to be predicted</ins>  

## Data Cleaning/Exploration/Visualisation
I join the two-part dataset to get the full pictures when doing exploration.    

#### Data Overview
![Data Overview](imgs/data_overview.png)  

There are null values which I look to clean up before exploring.  
![Null values](imgs/null_values.png)  

2439 missing values for Item_Weight  
4016 missing values for Outlet_Size  
The 5681 missing Item_Outlet_Sales values is the target variable to be predicted in test.csv  

Some summary statistics of our features:  
![Summary Statistics](imgs/summary_statistics.png)  

#### Target variable Item_Outlet_Sales distribution:   
![Item Outlet Sales distribution](imgs/target_variable_hist.png)  

Target variable is right skewed.  
<br>

#### Numeric Features distribution:
![Numeric Features Distribution](imgs/numeric_features_distribution)  
Item_Weight has some missing values. Based on the distribution, we can just go with a simple mean imputation.  
Item_Visibility has an large number of 0s. Also, 0% Item Visibility doesn't quite make sense. A segment of items with <2000 sales have more visibility (0.2 - 0.34) than the majority of items.  
Item_MRP (Max Retail Price) has a positive linear relationship with Item_Outlet_Sales. There also seems to be 4 distinguished Item_MRP ranges.  
<br>

#### Outlet Establishment Year distribution:
![Outlet Establishment Year Distribution](imgs/outlet_establishment_year_dist)  








