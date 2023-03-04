-- cleaning data in SQL Queries --
Select *
From NashvilleHousing

--standardize Data Format

Select  SaleDateConverted, CONVERT(Date, SaleDate)
From NashvilleHousing

update NashvilleHousing
SET SaleDate = CONVERT(Date, SaleDate)

ALTER TABLE NashvilleHousing
Add SaleDateConverted Date;

update NashvilleHousing
SET SaleDateConverted = CONVERT(Date, SaleDate)


--populate property address data

Select  *
From NashvilleHousing
--where PropertyAddress is null
order by ParcelID


Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
From NashvilleHousing a
JOIN NashvilleHousing b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null

update a
SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
From NashvilleHousing a
JOIN NashvilleHousing b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null

-- breaking out address into individual columns (Address, City, State )

Select PropertyAddress
From NashvilleHousing
--where PropertyAddress is null
--order by ParcelID

SELECT 
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1) as Address,
SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1, LEN(PropertyAddress)) as City
From NashvilleHousing


ALTER TABLE NashvilleHousing
Add PropertySplitAdress Nvarchar(255);

update NashvilleHousing
SET PropertySplitAdress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1)

ALTER TABLE NashvilleHousing
Add PropertySplitCity Nvarchar(255);

update NashvilleHousing
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1, LEN(PropertyAddress))

select *
From NashvilleHousing


--By use of PARSENAME AND A PERIOD (.)--

select OwnerAddress
From NashvilleHousing

select
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3) 
,PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2) 
,PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1) 
From NashvilleHousing

ALTER TABLE NashvilleHousing
Add OwnersplitAddress Nvarchar(255);

update NashvilleHousing
SET OwnersplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3)

ALTER TABLE NashvilleHousing
Add OwnersplitCity Nvarchar(255);

update NashvilleHousing
SET OwnersplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2)

ALTER TABLE NashvilleHousing
Add Ownersplitstate Nvarchar(255);

update NashvilleHousing
SET Ownersplitstate = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1)


--CHANGE Y AND N TO YES AND NO IN "SOLD AS VACANNT" FIELD

select Distinct(SoldAsVacant), COUNT(SoldAsVacant)
From NashvilleHousing
Group by SoldAsVacant
order by 2

select SoldAsVacant
, CASE When SoldAsVacant ='Y' THEN 'Yes'
		When SoldAsVacant ='N' THEN 'No'
		ELSE SoldAsVacant
		END
From NashvilleHousing

update NashvilleHousing
SET SoldAsVacant = CASE When SoldAsVacant ='Y' THEN 'Yes'
		When SoldAsVacant ='N' THEN 'No'
		ELSE SoldAsVacant
		END


-- Removing duplicates

WITH RowNumCTE AS(
select *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID, PropertyAddress, SalePrice, SaleDate,LegalReference
	ORDER BY uniqueID ) row_num


From NashvilleHousing
--order by ParcelID
)
select *  -- YOU CAN USE THE DELETE TO REMOVE THE DUPLICATES
From RowNumCTE
where row_num > 1
order by PropertyAddress



-- DELETE THE UNUSED COLUMNS
Select *
from NashvilleHousing

ALTER TABLE NashvilleHousing
DROP COLUMN OwnerAddress, TaxDistrict,PropertyAddress