## Project Overview

#### The following is the cleaning of the Nashville Housing dataset from kaggle. I load the dataset into an SQL database and perform data cleaning on it.  

Dataset file: [Nashville Housing](Nashville%20Housing%20Data.xlsx)    
SQL script: [EDA/Cleaning Script](SQL%20Cleaning%20Script.sql)   

## Data and Cleaning
The dataset has 19 columns of information, and I clean the following:   
- Create a new Date column by casting the existing date column to the Date format   
- Populate PropertyAddresses where null  
- Breaking up PropertyAddress string into PropertyAddressRoad and PropertyAddressCity  
- Breaking up OwnerAddress string into OwnerAddressRoad, OwnerAddressCity and OwnerAddressState    
- Standardize Y/N to Yes/No in SoldAsVacant column  
- Remove duplicate rows   

