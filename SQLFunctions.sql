-- SCALAR VALUED FUNCT�ONS


--select GETDATE()
-- Geriye tek de�er d�n�yor. O y�zden Scalar Valued Functions dur.


use 
TestDb
go

create function BugununTarihi()
returns datetime      -- returns demek ben bu fonksiyondan geriye datetime tipini d�n�cem demek
as
begin
   declare @Tarih datetime
   set @Tarih=GETDATE()
   return @Tarih      -- return dedi�im zaman @Tarih de�i�keni i�indeki de�eri d�n demi� oluyorum.
end

select dbo.BugununTarihi()





use NORTHWND
go

create function KatAdet(@KatId int)
returns int
as
begin

    return
	    (select sum(od.Quantity) 
		from [Order Details] od inner join Products p
		on od.ProductID=p.ProductID
		where p.CategoryID=@KatId)
end

select dbo.KatAdet(2)





-- Sat�� yap�lan �r�nlerimizin hangi kategoriden ka� adet sat�ld���n� raporlay�n

select CategoryName,dbo.KatAdet(CategoryId) 'Toplam Sat�� Adedi'
from Categories

-- INLINE TABLE VALUED FUNCTIONS

create function KatUrunler(@KatId int)
returns table
as
  return (select * from Products where CategoryID=@KatId)


  -- �a��r�yoruz
  select * from KatUrunler(1)


  -- Sorguda foknsiyonu kulland�k
  select SupplierID,sum(UnitPrice) 'Toplam Fiyat'
  from KatUrunler(1)
  where UnitsInStock>50
  group by 
  SupplierID
  order by 'Toplam Fiyat' desc


  -- MULTISTATEMENT TABLE VALUED FUNTIONS

  create function Calisanlar(@Tip nvarchar(7))
  returns @Kisilerim table
  (
     Id int,
	 Isim nvarchar(50)
  )
  as
  begin
    if(@Tip='ad')
	begin
	   insert @Kisilerim
	   select EmployeeID,FirstName from Employees
	end
	else if(@Tip='adsoyad')
	begin
	    insert @Kisilerim
		select EmployeeID,FirstName+' '+LastName from Employees		
	end

	return

  end

  select * from Calisanlar('ad')
  select * from Calisanlar('adsoyad')
