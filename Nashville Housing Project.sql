/* 

Cleaning Data in SQL Queries

*/



Select *
From NashvilleHousingProject.dbo.NashvilleHousing

 
 -- Standardise Data Format --

Select SaleDate, CONVERT(Date,SaleDate)
From NashvilleHousingProject.dbo.NashvilleHousing 


Update  NashvilleHousingProject.dbo.NashvilleHousing 
SET SaleDate = CONVERT(Date,SaleDate)


---> as the above did not update correctly, required to do this step 
ALTER TABLE NashvilleHousingProject.dbo.NashvilleHousing 
Add SaleDateConverted  Date; 


Update  NashvilleHousingProject.dbo.NashvilleHousing 
SET SaleDateConverted = CONVERT(Date,SaleDate)


---> checking 
Select SaleDateConverted,	CONVERT(Date,SaleDate)
From NashvilleHousingProject.dbo.NashvilleHousing 



-- Populate Property Address -- 

Select *
From NashvilleHousingProject.dbo.NashvilleHousing 
-- Where PropertyAddress is null 
Order BY ParcelID

Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
From NashvilleHousingProject.dbo.NashvilleHousing a
JOIN NashvilleHousingProject.dbo.NashvilleHousing b
	ON a.ParcelID = b.ParcelID
	AND a.[UniqueID]<>b.[UniqueID]
Where a.PropertyAddress is null 


Update a
SET PropertyAddress =  ISNULL(a.PropertyAddress, b.PropertyAddress)
From NashvilleHousingProject.dbo.NashvilleHousing a
JOIN NashvilleHousingProject.dbo.NashvilleHousing b
	ON a.ParcelID = b.ParcelID
	AND a.[UniqueID]<>b.[UniqueID]
Where a.PropertyAddress is null 



-- Breaking out Address into Individual Columns (Address, City, State) -- 

Select PropertyAddress
From NashvilleHousingProject.dbo.NashvilleHousing


Select 
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 ) as Address    ---> removes the commas
, SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress)) as Address   ---> seperates after the comma 
From NashvilleHousingProject.dbo.NashvilleHousing



ALTER TABLE NashvilleHousingProject.dbo.NashvilleHousing 
Add PropertySplitAddress  Nvarchar(255); 


Update  NashvilleHousingProject.dbo.NashvilleHousing 
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 )

ALTER TABLE NashvilleHousingProject.dbo.NashvilleHousing 
Add PropertySplitCity  Nvarchar(255); 


Update  NashvilleHousingProject.dbo.NashvilleHousing 
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress))


---> checking 
Select * 
From NashvilleHousingProject.dbo.NashvilleHousing






Select OwnerAddress
From NashvilleHousingProject.dbo.NashvilleHousing



Select
PARSENAME(REPLACE(OwnerAddress, ',', '.'),3)
,PARSENAME(REPLACE(OwnerAddress, ',', '.'),2)
,PARSENAME(REPLACE(OwnerAddress, ',', '.'),1)
From NashvilleHousingProject.dbo.NashvilleHousing 



ALTER TABLE NashvilleHousingProject.dbo.NashvilleHousing 
Add OwnerSplitAddress  Nvarchar(255); 


Update  NashvilleHousingProject.dbo.NashvilleHousing 
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.'),3)



ALTER TABLE NashvilleHousingProject.dbo.NashvilleHousing 
Add OwnerySplitCity  Nvarchar(255); 


Update  NashvilleHousingProject.dbo.NashvilleHousing 
SET OwnerySplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.'),2)



ALTER TABLE NashvilleHousingProject.dbo.NashvilleHousing 
Add OwnerSplitState Nvarchar(255); 


Update  NashvilleHousingProject.dbo.NashvilleHousing 
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.'),1)



---> checking 
Select * 
From NashvilleHousingProject.dbo.NashvilleHousing




-- Change Y and N to Yes and No in "Sold as Vacant" field --


Select Distinct(SoldAsVacant), COUNT(SoldAsVacant)
From NashvilleHousingProject.dbo.NashvilleHousing
Group by SoldAsVacant 
Order by 2



Select SoldAsVacant
, CASE When SoldAsVacant = 'Y' THEN 'Yes'
	When SoldAsVacant = 'N' THEN 'No'
	ELSE SoldAsVacant
	END
From NashvilleHousingProject.dbo.NashvilleHousing


Update  NashvilleHousingProject.dbo.NashvilleHousing 
SET SoldAsVacant = CASE When SoldAsVacant = 'Y' THEN 'Yes'
	When SoldAsVacant = 'N' THEN 'No'
	ELSE SoldAsVacant
	END







-- Remove Duplicates --

WITH RowNumCTE AS(
Select *, 
	ROW_NUMBER() OVER (
	PARTITION  BY ParcelID,
				PropertyAddress, 
				SalePrice, 
				SaleDate,
				LegalReference 
				ORDER BY 
					UniqueID
					) row_num

From  NashvilleHousingProject.dbo.NashvilleHousing 
-- Order by ParcelID
)
Delete
From RowNumCTE
Where row_num > 1


---> to check if duplicates are deleted 
WITH RowNumCTE AS(
Select *, 
	ROW_NUMBER() OVER (
	PARTITION  BY ParcelID,
				PropertyAddress, 
				SalePrice, 
				SaleDate,
				LegalReference 
				ORDER BY 
					UniqueID
					) row_num

From  NashvilleHousingProject.dbo.NashvilleHousing 
-- Order by ParcelID
)
Select *
From RowNumCTE
Where row_num > 1




-- Delete Unused Columns --

ALTER TABLE NashvilleHousingProject.dbo.NashvilleHousing
DROP Column OwnerAddress, TaxDistrict, PropertyAddress, SaleDate

Select *
From NashvilleHousingProject.dbo.NashvilleHousing



