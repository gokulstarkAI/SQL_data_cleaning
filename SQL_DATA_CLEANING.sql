/*
  SQL data cleaning project
 */

-- The data that I am using

select * from projects_db.dbo.Nashville_Housing nh;

--------------------------------------------------------------------------------------------------------------------------

-- Standardize Date Format

select SaleDate 
from projects_db.dbo.Nashville_Housing nh;

alter table projects_db.dbo.Nashville_Housing 
add SaleDateConverted Date;

update projects_db.dbo.Nashville_Housing 
set SaleDateConverted = convert(Date,SaleDate);

select SaleDateConverted, SaleDate
from projects_db.dbo.Nashville_Housing nh;

 --------------------------------------------------------------------------------------------------------------------------

-- Breaking out Address into Individual Columns (Address, City, State)

select PropertyAddress 
from projects_db.dbo.Nashville_Housing;

select 
substring(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1) as address,
substring(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, len(PropertyAddress)) as address
from projects_db.dbo.Nashville_Housing;


alter table projects_db.dbo.Nashville_Housing 
add PropertySplitAddress Nvarchar(255);

Update projects_db.dbo.Nashville_Housing
SET PropertySplitAddress = substring(PropertyAddress, 1, CHARINDEX(',', PropertyAddress));

alter table projects_db.dbo.Nashville_Housing 
add PropertySplitCity Nvarchar(255);

update projects_db.dbo.Nashville_Housing 
set PropertySplitCity = substring(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, len(PropertyAddress));

select * from projects_db.dbo.Nashville_Housing nh;

select 
PARSENAME(replace(OwnerAddress,',','.'),1),
PARSENAME(replace(OwnerAddress,',','.'),2),
PARSENAME(replace(OwnerAddress,',','.'),3),
OwnerAddress
from projects_db.dbo.Nashville_Housing;

alter table projects_db.dbo.Nashville_Housing
add OwnerSplitAddress Nvarchar(255);

update projects_db.dbo.Nashville_Housing
set OwnerSplitAddress = PARSENAME(replace(OwnerAddress,',','.'),3);

alter table projects_db.dbo.Nashville_Housing 
add OwnerSplitCity Nvarchar(255);

update projects_db.dbo.Nashville_Housing 
set OwnerSplitCity = PARSENAME(replace(OwnerAddress,',','.'),2);

alter table projects_db.dbo.Nashville_Housing 
add OwnerSplitState Nvarchar(255);

update projects_db.dbo.Nashville_Housing 
set OwnerSplitState = PARSENAME(replace(OwnerAddress,',','.'),1);

select * from projects_db.dbo.Nashville_Housing nh;

--------------------------------------------------------------------------------------------------------------------------


-- Change Y and N to Yes and No in "Sold as Vacant" field

select DISTINCT(SoldAsVacant), count(SoldAsVacant)
from projects_db.dbo.Nashville_Housing
group by SoldAsVacant 
order by 2;

select SoldAsVacant,
case when SoldAsVacant = 'Y' then 'Yes'
	 when SoldAsVacant = 'N' then 'No'
	 else SoldAsVacant 
	 end
from projects_db.dbo.Nashville_Housing;

update projects_db.dbo.Nashville_Housing
set SoldAsVacant = case when SoldAsVacant = 'Y' then 'Yes'
	 					when SoldAsVacant = 'N' then 'No'
	 					else SoldAsVacant 
	 					end;

-----------------------------------------------------------------------------------------------------------------------------------------------------------

-- Remove Duplicates
with RowNumCTE as(	 				
select *,
	ROW_NUMBER() OVER(
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SaleDate,
				 SalePrice,
				 LegalReference
				 order by 
				 [UniqueID ]
	) row_num
from projects_db.dbo.Nashville_Housing
)
select * -- use delete instead of select * to delete duplicate rows
from RowNumCTE
where row_num > 1
order by PropertyAddress;

select * from projects_db.dbo.Nashville_Housing;

---------------------------------------------------------------------------------------------------------

-- Delete Unused Columns

alter table projects_db.dbo.Nashville_Housing
drop column PropertyAddress, SaleDate, OwnerAddress;

select * from projects_db.dbo.Nashville_Housing;



















