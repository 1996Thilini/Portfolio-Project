/*
Claning Data in SQL Queries
*/
Select *
From PortfolioProject.dbo.NashvilleHousing$

----------------------
--Standalize Date Format
Alter Table NashvilleHousing$
Add SaleDate2 Date

Update NashvilleHousing$
Set SaleDate2 = CONVERT(Date,SaleDate)

Select *
From PortfolioProject.dbo.NashvilleHousing$

-----------------------
--Populate Property Address Data
Select PropertyAddress
From PortfolioProject.dbo.NashvilleHousing$
Where PropertyAddress is null

Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress,ISNULL(a.PropertyAddress,b.PropertyAddress)
From PortfolioProject.dbo.NashvilleHousing$ a
Join PortfolioProject.dbo.NashvilleHousing$ b
	on a.ParcelID = b.ParcelID
	And a.[UniqueID] <> b.[UniqueID]
Where a.PropertyAddress is null

Update a
Set PropertyAddress=ISNULL(a.PropertyAddress,b.PropertyAddress)
From PortfolioProject.dbo.NashvilleHousing$ a
Join PortfolioProject.dbo.NashvilleHousing$ b
	on a.ParcelID = b.ParcelID
	And a.[UniqueID] <> b.[UniqueID]
Where a.PropertyAddress is null
----------------------------
--Breaking out Address into Individual Columns(Address,City,State)
Select PropertyAddress
From PortfolioProject.dbo.NashvilleHousing$

Select Substring(PropertyAddress,1, Charindex(',', PropertyAddress) -1) as Address,
	Substring(PropertyAddress, Charindex(',', PropertyAddress)+1, LEN(PropertyAddress)) as Address
From PortfolioProject.dbo.NashvilleHousing$

Alter Table NashvilleHousing$
Add PropertySlitAddress Nvarchar(255)

Update NashvilleHousing$
Set PropertySlitAddress = Substring(PropertyAddress,1, Charindex(',', PropertyAddress) -1)

Alter Table NashvilleHousing$
Add PropertySlitCity Nvarchar(255)

Update NashvilleHousing$
Set PropertySlitCity = Substring(PropertyAddress, Charindex(',', PropertyAddress)+1, LEN(PropertyAddress))

Select *
From PortfolioProject.dbo.NashvilleHousing$



Select OwnerAddress
From PortfolioProject.dbo.NashvilleHousing$

Select PARSENAME(REPLACE(OwnerAddress,',','.'),3),
	PARSENAME(REPLACE(OwnerAddress,',','.'),2),
	PARSENAME(REPLACE(OwnerAddress,',','.'),1)
From PortfolioProject.dbo.NashvilleHousing$

Alter Table NashvilleHousing$
Add OwnerSlitAddress Nvarchar(255)

Update NashvilleHousing$
Set OwnerSlitAddress = PARSENAME(REPLACE(OwnerAddress,',','.'),3)

Alter Table NashvilleHousing$
Add OwnerSlitCity Nvarchar(255)

Update NashvilleHousing$
Set OwnerSlitCity = PARSENAME(REPLACE(OwnerAddress,',','.'),2)

Alter Table NashvilleHousing$
Add OwnerSlitState Nvarchar(255)

Update NashvilleHousing$
Set OwnerSlitState = PARSENAME(REPLACE(OwnerAddress,',','.'),1)

Select *
From PortfolioProject.dbo.NashvilleHousing$

--------------------------
--Change Y and N to Yes and No in "Sold as Vacant" field
Select Distinct(SoldAsVacant),Count(SoldAsVacant)
From PortfolioProject.dbo.NashvilleHousing$
Group by SoldAsVacant
order by 2

Select SoldAsVacant, Case when SoldAsVacant='Y' THEN 'Yes'
	when SoldAsVacant='N' THEN 'No'
	Else SoldAsVacant
	End
From PortfolioProject.dbo.NashvilleHousing$

Update NashvilleHousing$
Set SoldAsVacant = Case when SoldAsVacant='Y' THEN 'Yes'
	when SoldAsVacant='N' THEN 'No'
	Else SoldAsVacant
	End

Select *
From PortfolioProject.dbo.NashvilleHousing$

-------------------------
--Remove Duplicates
WITH RowNumCTE AS(
Select *,
	ROW_NUMBER() Over(
		Partition by ParcelID,
			PropertyAddress,
			SalePrice,
			SaleDate,
			LegalReference
			Order by
				UniqueID
					)row_num
From PortfolioProject.dbo.NashvilleHousing$
)
Select *
From RowNumCTE
Where row_num>1
--Order by PropertyAddress

--Delete them
WITH RowNumCTE AS(
Select *,
	ROW_NUMBER() Over(
		Partition by ParcelID,
			PropertyAddress,
			SalePrice,
			SaleDate,
			LegalReference
			Order by
				UniqueID
					)row_num
From PortfolioProject.dbo.NashvilleHousing$
)
Delete
From RowNumCTE
Where row_num>1

Select *
From PortfolioProject.dbo.NashvilleHousing$

-----------------------
--Delete Unused Columns
Alter Table PortfolioProject.dbo.NashvilleHousing$
Drop column OwnerAddress, TaxDistrict, PropertyAddress, SaleDate

Select *
From PortfolioProject.dbo.NashvilleHousing$