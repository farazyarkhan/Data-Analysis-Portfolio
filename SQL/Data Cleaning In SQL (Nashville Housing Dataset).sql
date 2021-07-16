--Dataset That We Will Be Working On.
select * from HousingData

--Removing Timestamp from SaleDate Column.
alter table HousingData add CleanSaleDate date;
update HousingData set CleanSaleDate = CONVERT(Date, SaleDate)
alter table HousingData drop column SaleDate;
sp_rename 'HousingData.CleanSaleDate', 'SaleDate', 'COLUMN';
select SaleDate from HousingData

--Handling Null Values In PropertyAddress Column. 
select PropertyAddress from HousingData where PropertyAddress is null

update a set PropertyAddress = isnull(a.PropertyAddress, b.PropertyAddress)
from HousingData a join HousingData b on a.ParcelID = b.ParcelID and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null

--Spliting PropertyAddress Column into Two Different Columns of SplitPropAddress and SplitPropCity.
alter table HousingData add SplitPropAddress nvarchar(250);
update HousingData set SplitPropAddress = substring(PropertyAddress, 1, charindex(',', PropertyAddress) -1 )
select SplitPropAddress  from HousingData

alter table HousingData add SplitPropCitys nvarchar(250);
update HousingData set SplitPropCitys = substring (PropertyAddress, charindex(',', PropertyAddress) + 1 , len(PropertyAddress))
select SplitPropCitys  from HousingData

--Splitting OwnerAddress Column into Three Different Columns of SplitOwnAddress, SplitOwnCity, SplitOwnState.
alter table HousingData add SplitOwnAddress nvarchar(250);
update HousingData set SplitOwnAddress = parsename(replace(OwnerAddress, ',', '.'), 3)
select SplitOwnAddress  from HousingData

alter table HousingData add SplitOwnCity nvarchar(250);
update HousingData set SplitOwnCity = parsename(replace(OwnerAddress, ',', '.'), 2)
select SplitOwnCity  from HousingData

alter table HousingData add SplitOwnstate nvarchar(250);
update HousingData set SplitOwnState= parsename(replace(OwnerAddress, ',', '.'), 1)
select SplitOwnState  from HousingData


--Handling Redundancy in SoldAsVaccant Column by Changing 'Y' & 'N' to 'Yes' & 'No'.
update HousingData set SoldAsVacant =
case when SoldAsVacant = 'Y' then 'Yes'
	 when SoldAsVacant = 'N' then 'No'
	 else SoldAsVacant
end

select SoldAsVacant from HousingData


--Checking & Removing Duplicate Records (If Any).
select [UniqueID ], count(UniqueID) from HousingData group by [UniqueID ] having count(UniqueID)>1 --No Duplicates According to UniqueID

--Removing Unused Columns
alter table HousingData drop column PropertyAddress, OwnerAddress, TaxDistrict;
select * from HousingData