select * from nashville

--standardize date format
select saledate, cast(saledate as date) desired_result
from nashville


alter table nashville
add SaleDateConverted Date

update nashville
set saledateconverted = cast(saledate as date)

select saledate, saledateconverted, cast(saledate as date) desired_result
from nashville

--drop SaleDate
alter table nashville
drop column saledate
----------------------------------------------------------------------------------------------------

--populate property address data
select *
from nashville
where propertyaddress is null


--parcelID is tied to propertyaddress / ownername / owneraddress
select *
from nashville
where parcelid in
(
select parcelid
from nashville
where propertyaddress is null
)
--64 rows returned


--check that there are 64 uniqueIDs to ensure uniqueID is not tied to any of the above columns
with cte as(
select *
from nashville
where parcelid in
(
select parcelid
from nashville
where propertyaddress is null
)
)
select count (distinct uniqueID)
from cte


select *
from nashville
where parcelid in
(
select parcelid
from nashville
where propertyaddress is null
)


--self join to get rows with NULL propertyaddress but same parcelIDs
select t1.uniqueid, t1.parcelid, t1.propertyaddress, t2.uniqueid, t2.parcelid, t2.propertyaddress
from nashville t1
join nashville t2
on t1.parcelid = t2.parcelid
and t1.uniqueid <> t2.uniqueid
where t1.propertyaddress is null


--update the NULLS
update t1
set propertyaddress = t2.propertyaddress
from nashville t1
join nashville t2
on t1.parcelid = t2.parcelid
and t1.uniqueid <> t2.uniqueid
where t1.propertyaddress is null
----------------------------------------------------------------------------------------------------

----split PropertyAddress into PropertyAddressRoad and PropertyAddressCity
select propertyaddress
from nashville


--substring():
--e.g. "298  GARRY DR, NASHVILLE"
--14 is the comma, 15 is the space between the comma and 'N' in NASHVILLE, 16 is N, LEN("298  GARRY DR, NASHVILLE") = 24 where 'E' in NASHVILLE = 24.
--first substring propertyaddress, start at 1, end at 14-1 which is the character before the comma.
--second substring propertyaddress, start at 14+2, which is the 2 characters after the comma, and end at the length of property address which is the character at the end of property address
select substring(propertyaddress, 1, charindex(',', propertyaddress) -1) road,
	   substring(propertyaddress, charindex(',', propertyaddress) +2, len(propertyaddress)) city
from nashville


--add column to hold the street/road name of the PropertyAddress
alter table nashville
add PropertyAddressRoad nvarchar(255)

update nashville
set propertyaddressroad = substring(propertyaddress, 1, charindex(',', propertyaddress) -1)

--add column to hold the city name of the PropertyAddress
alter table nashville
add PropertyAddressCity nvarchar(255)

update nashville
set propertyaddresscity = substring(propertyaddress, charindex(',', propertyaddress) +2, len(propertyaddress))

--drop PropertyAddress
alter table nashville
drop column propertyaddress
----------------------------------------------------------------------------------------------------

--split owner address into street/road, city, state
--parsename uses '.' as the delimitter for splitting strings, hence replace ',' in address with '.' with replace() before using parsename()
select owneraddress,
parsename(replace(owneraddress, ',', '.'), 3) road,
parsename(replace(owneraddress, ',', '.'), 2) city,
parsename(replace(owneraddress, ',', '.'), 1) state
from nashville


alter table nashville
add OwnerAddressRoad nvarchar(255),
OwnerAddressCity nvarchar(255),
OwnerAddressState nvarchar(255)

update nashville
set OwnerAddressRoad = parsename(replace(owneraddress, ',', '.'), 3)

update nashville
set OwnerAddressCity = parsename(replace(owneraddress, ',', '.'), 2)

update nashville
set OwnerAddressState = parsename(replace(owneraddress, ',', '.'), 1)

--drop OwnerAddress
alter table nashville
drop column owneraddress
----------------------------------------------------------------------------------------------------

--standardize Y/N Yes/No in SoldAsVacant column
select distinct soldasvacant, count(soldasvacant)
from nashville
group by soldasvacant 
order by 2 desc


select soldasvacant, case
	when soldasvacant = 'Y' then 'Yes'
	when soldasvacant = 'N' then 'No'
	else soldasvacant
	end
from nashville
where soldasvacant in ('Y', 'N')


update nashville
set soldasvacant = case
	when soldasvacant = 'Y' then 'Yes'
	when soldasvacant = 'N' then 'No'
	else soldasvacant
	end
where soldasvacant in ('Y', 'N')


select distinct soldasvacant, count(soldasvacant)
from nashville
group by soldasvacant 
order by 2 desc
----------------------------------------------------------------------------------------------------

--remove duplicates

--parcelID appears > 1 time in data.
select parcelid, count(parcelid)
from nashville
group by parcelid
having count(parcelid) > 1


--pull all data that has same count(parcelID) > 1
select * from nashville
where parcelid in
(
select parcelid
from nashville
group by parcelid
having count(parcelid) > 1
)


--temp table to hold duplicate ParcelIDs
drop table if exists #temp_DuplicateParcelIDSubset
create table #temp_DuplicateParcelIDSubset (
	[UniqueID ] [float] NULL,
	[ParcelID] [nvarchar](255) NULL,
	[LandUse] [nvarchar](255) NULL,
	[SalePrice] [float] NULL,
	[LegalReference] [nvarchar](255) NULL,
	[SoldAsVacant] [nvarchar](255) NULL,
	[OwnerName] [nvarchar](255) NULL,
	[Acreage] [float] NULL,
	[TaxDistrict] [nvarchar](255) NULL,
	[LandValue] [float] NULL,
	[BuildingValue] [float] NULL,
	[TotalValue] [float] NULL,
	[YearBuilt] [float] NULL,
	[Bedrooms] [float] NULL,
	[FullBath] [float] NULL,
	[HalfBath] [float] NULL,
	[SaleDateConverted] [date] NULL,
	[PropertyAddressRoad] [nvarchar](255) NULL,
	[PropertyAddressCity] [nvarchar](255) NULL,
	[OwnerAddressRoad] [nvarchar](255) NULL,
	[OwnerAddressCity] [nvarchar](255) NULL,
	[OwnerAddressState] [nvarchar](255) NULL
)

insert into #temp_DuplicateParcelIDSubset
select * from nashville
where parcelid in
(
select parcelid
from nashville
group by parcelid
having count(parcelid) > 1
)


select * from #temp_DuplicateParcelIDSubset


--check if all other columns are the same between the rows with same parcelID
with cte as (
select *, row_number()
over (partition by
parcelid,
landuse,
saleprice,
legalreference,
soldasvacant,
ownername,
acreage,
taxdistrict,
landvalue,
buildingvalue,
totalvalue,
yearbuilt,
bedrooms,
fullbath,
halfbath,
saledateconverted,
propertyaddressroad,
propertyaddresscity,
owneraddressroad,
owneraddresscity,
owneraddressstate
order by uniqueid) row_num
from #temp_DuplicateParcelIDSubset
)
select *
from cte
where row_num > 1


--use parcelID from first row of the results where row_num > 1, '081 02 0 144.00'
--we see that all columns are same except for UniqueID.
select *
from #temp_DuplicateParcelIDSubset
where parcelid = '081 02 0 144.00'


--delete duplicate records in the actual nashville table
with cte as (
select *, row_number()
over (partition by
parcelid,
landuse,
propertyaddress,
saledate,
saleprice,
legalreference,
soldasvacant,
ownername,
owneraddress,
acreage,
taxdistrict,
landvalue,
buildingvalue,
totalvalue,
yearbuilt,
bedrooms,
fullbath,
halfbath
order by uniqueid) row_num
from nashville
)
delete
from cte
where row_num > 1
----------------------------------------------------------------------------------------------------