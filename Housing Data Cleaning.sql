/*

Cleaning data in SQL Queries 

*/

Select*
from PortfolioProjects.dbo.NashvilleHousing

--Standardizing date format 

Select SaleDateConverted, CONVERT(Date,SaleDate)
from PortfolioProjects.dbo.NashvilleHousing

ALTER TABLE NashvilleHousing
ADD SaleDateConverted Date;

UPDATE NashvilleHousing
SET SaleDateConverted = CONVERT(Date,SaleDate)



--Populate Property Address date

Select*
from PortfolioProjects.dbo.NashvilleHousing
--Where PropertyAddress is NULL 
order by ParcelID

Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
from PortfolioProjects.dbo.NashvilleHousing a
JOIN PortfolioProjects.dbo.NashvilleHousing b
	on a.ParcelID=b.ParcelID
	AND a.[UniqueID ]<> b.[UniqueID ]
	where a.PropertyAddress is null

UPDATE a
SET PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
from PortfolioProjects.dbo.NashvilleHousing a
JOIN PortfolioProjects.dbo.NashvilleHousing b
	on a.ParcelID=b.ParcelID
	AND a.[UniqueID ]<> b.[UniqueID ]
where a.PropertyAddress is null


--(1)Breaking out Address into Individual Columns (Address, City, States)

Select PropertyAddress
from PortfolioProjects.dbo.NashvilleHousing
--Where PropertyAddress is NULL 
--order by ParcelID
SELECT
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1) as Address
,SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress)) as Address

from PortfolioProjects.dbo.NashvilleHousing



ALTER TABLE NashvilleHousing
ADD PropertySplitAddress Nvarchar(255);

UPDATE NashvilleHousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1)

ALTER TABLE NashvilleHousing
ADD PropertySplitCity Nvarchar(255);

UPDATE NashvilleHousing
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress))

Select*
from PortfolioProjects.dbo.NashvilleHousing

--(2)Relative easy method to split column


Select OwnerAddress
from PortfolioProjects.dbo.NashvilleHousing


select
PARSENAME(REPLACE(OwnerAddress,',', '.'), 3)
, PARSENAME(REPLACE(OwnerAddress,',', '.'), 2)
, PARSENAME(REPLACE(OwnerAddress,',', '.'), 1)
from PortfolioProjects.dbo.NashvilleHousing

ALTER TABLE NashvilleHousing
ADD OwnerSplitAddress Nvarchar(255);

UPDATE NashvilleHousing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress,',', '.'), 3)

ALTER TABLE NashvilleHousing
ADD OwnerSplitCity Nvarchar(255);

UPDATE NashvilleHousing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress,',', '.'), 2)

ALTER TABLE NashvilleHousing
ADD OwnerSplitState Nvarchar(255);

UPDATE NashvilleHousing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress,',', '.'), 1)


Select*
from PortfolioProjects.dbo.NashvilleHousing

--Change Y and N to Yes and No in "Sold as Vacant" field 

Select Distinct(SoldasVacant), COUNT(SoldasVacant)
from PortfolioProjects.dbo.NashvilleHousing
Group by SoldasVacant
order by 2

Select SoldasVacant
, CASE When SoldasVacant= 'Y' THEN 'Yes'
       When SoldasVacant= 'N' THEN  'No'
	   ELSE SoldasVacant
	   END
 from PortfolioProjects.dbo.NashvilleHousing


--Remove the Duplicates
WITH RowNumCTE AS(
Select*,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
	             PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY 
					UniqueID
					) row_num

from PortfolioProjects.dbo.NashvilleHousing
)

Select*
From RowNumCTE
WHERE row_num >1
order by PropertyAddress
				
--Delete Unused Columns

Select*
from PortfolioProjects.dbo.NashvilleHousing


ALTER TABLE PortfolioProjects.dbo.NashvilleHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress,

ALTER TABLE PortfolioProjects.dbo.NashvilleHousing
DROP COLUMN SaleDate
