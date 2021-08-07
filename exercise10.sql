/**
When to Use Clustered or Non-Clustered Indexes
Now that you know the differences between a clustered 
and a non-clustered index, let’s see the different scenarios 
for using each of them.

1.   Number of Indexes
This is pretty obvious. If you need to create multiple 
indexes on your database, go for non-clustered index 
since there can be only one clustered index.

2.   SELECT Operations
If you want to select only the index value that is used 
to create and index, non-clustered indexes are faster. 
For example, if you have created an index on the “name” 
column and you want to select only the name, 
non-clustered indexes will quickly return the name.

However, if you want to select other column values such as age, 
gender using the name index, the SELECT operation will be 
slower since first the name will be searched 
from the index and then the reference to 
the actual table record will be used to search the age and gender.

On the other hand, with clustered indexes since all the records 
are already sorted, the SELECT operation is faster 
if the data is being selected from columns other than the column 
with clustered index.

3.   INSERT/UPDATE Operations
The INSERT and UPDATE operations are faster with non-clustered 
indexes since the actual records are not required to be 
sorted when an INSERT or UPDATE operation is performed. 
Rather only the non-clustered index needs updating.

4.   Disk Space
Since, non-clustered indexes are stored at a separate location 
than the original table, non-clustered indexes 
consume additional disk space. If disk space is a problem, 
use a clustered index.

5.   Final Verdict
As a rule of thumb, every table should have at least 
one clustered index preferably on the column that is used for 
SELECTING records and contains unique values. 
The primary key column is an ideal candidate for a clustered index.

On the other hand columns that are often involved in 
INSERT and UPDATE queries should have a non-clustered index 
assuming that disk space isn’t a concern.
**/

-- 1. Trường GiaMua trong bảng VATTU
CREATE NONCLUSTERED INDEX indx_vattu_giamua 
ON [dbo].[VATTU]([GIAMUA])

-- 2. Trường SLTon trong bảng VATTU
CREATE NONCLUSTERED INDEX indx_vattu_slton
ON [dbo].[VATTU]([SLTON])
-- 3. Trường Ngay trong bảng HOADON.
CREATE NONCLUSTERED INDEX indx_hoadon_ngay
ON [dbo].[HOADON]([NGAY])
