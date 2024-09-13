# NYC Property Sales Price Prediction

This project aims to predict the sales prices of properties in New York City using machine learning techniques. We use a dataset that contains information about properties sold in NYC, including features such as square footage, number of units, and property age. The goal is to train a regression model to predict the `SALE PRICE` based on these features.

## Table of Contents
- [Dataset](#dataset)
- [Data Cleaning](#data-cleaning)
- [Feature Engineering](#feature-engineering)
- [Modeling](#modeling)
- [Evaluation](#evaluation)
- [Hyperparameter Tuning](#hyperparameter-tuning)
- [Results](#results)

## Dataset
The dataset includes information about buildings sold in New York City over a 1-year period. It contains the following key features:
- **BOROUGH**: The borough where the property is located.
- **LAND SQUARE FEET**: The land area of the property.
- **GROSS SQUARE FEET**: The total floor area of the property.
- **SALE PRICE**: The price for which the property was sold.
- **YEAR BUILT**: The year the property was constructed.
- **RESIDENTIAL UNITS**: The number of residential units in the building.
- **COMMERCIAL UNITS**: The number of commercial units in the building.

The goal is to use these features to predict the `SALE PRICE`.

## Data Cleaning
The data cleaning process involved the following steps:
1. Handling missing values by replacing missing values in numeric columns with the mean or median.
2. Removing zero and unrealistic values from important columns (e.g., properties with zero sale price).
3. Dropping unnecessary columns such as addresses and ZIP codes, which are irrelevant to the model.
4. Removing duplicates and outliers to ensure the quality of the data.

## Feature Engineering
We created new features to improve the model's performance:
- **Building Age**: Calculated as `2024 - YEAR BUILT`.
- Extracted year and month from the `SALE DATE` to investigate seasonal trends in property sales.
- Converted categorical variables such as `BOROUGH` into numerical representations using one-hot encoding.

## Modeling
We used the following regression models for predicting property prices:
- **Linear Regression**
- **Random Forest Regressor**
- **XGBoost Regressor**
- **LightGBM Regressor**

The **Random Forest Regressor** performed best in initial evaluations and was chosen for further tuning.

## Evaluation
The performance of the models was evaluated using the following metrics:
- **RMSE (Root Mean Squared Error)**: The square root of the average squared differences between predicted and actual values.
- **MAE (Mean Absolute Error)**: The average of the absolute differences between predicted and actual values.
- **R² Score**: A measure of how well the model explains the variance in the target variable.
# NYC Property Sales Data Transformation and Z-Score Calculation

This SQL script processes the NYC property sales dataset to perform several important calculations, including global and neighborhood-specific Z-scores for sale prices, price per unit, and square footage per unit.

## SQL Query Explanation

### Step 1: Data Selection and Calculations
In the **sales_data** CTE (Common Table Expression), we perform the following calculations:

- **Global Z-Score Components**:
  - `mean_sale_price`: The average sale price across all properties.
  - `stddev_sale_price`: The standard deviation of sale prices globally.

- **Neighborhood + Building Class Z-Score Components**:
  - `mean_sale_price_neighborhood`: The average sale price partitioned by `NEIGHBORHOOD` and `BUILDING CLASS AT PRESENT`. This allows us to calculate Z-scores within specific neighborhoods and building types.
  - `stddev_sale_price_neighborhood`: The standard deviation of sale prices within each neighborhood and building class.

- **Square Feet Per Unit**:
  - `square_ft_per_unit`: The gross square footage (`GROSS SQUARE FEET`) divided by the total number of units (`TOTAL UNITS`). If `TOTAL UNITS` is zero or null, the result is null.

- **Price Per Unit**:
  - `price_per_unit`: The sale price (`SALE PRICE`) divided by `TOTAL UNITS`. Again, division by zero or null values is handled by returning null.

### Step 2: Z-Score Calculations
In the final `SELECT` statement, we use the calculated means and standard deviations to compute the Z-scores:

- **Global Z-Score (`sale_price_zscore`)**:
  - This calculates how far the `SALE PRICE` deviates from the global mean, normalized by the standard deviation. If the standard deviation is zero, the result is set to null to avoid division by zero.

- **Neighborhood + Building Class Z-Score (`sale_price_zscore_neighborhood`)**:
  - Similar to the global Z-score, but this calculation is partitioned by neighborhood and building class. It normalizes the sale price based on the mean and standard deviation within each neighborhood and building class.

### Handling Edge Cases
- **Division by Zero**:
  - In both `square_ft_per_unit` and `price_per_unit` calculations, division by zero or null is handled by returning `NULL` if `TOTAL UNITS` is less than or equal to zero.
  
- **Z-Score Calculations**:
  - In both global and neighborhood Z-scores, if the standard deviation (`stddev_sale_price` or `stddev_sale_price_neighborhood`) is zero, the Z-score is set to null.

## SQL Components Breakdown

- **CTE (sales_data)**:
  The initial part of the query where calculations like average sale prices and standard deviations are computed for later use.

- **SAFE_CAST**:
  This function safely casts data into numeric format, avoiding errors if there are non-numeric values in the `SALE PRICE`, `GROSS SQUARE FEET`, or `TOTAL UNITS` columns.

- **PARTITION BY**:
  This clause is used to calculate neighborhood and building class-specific averages and standard deviations.

## Example Usage
This query is useful in analyzing​⬤
