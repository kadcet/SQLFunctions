-- SCALAR VALUED FUNCTÝONS


--select GETDATE()
-- Geriye tek deðer dönüyor. O yüzden Scalar Valued Functions dur.


use 
TestDb
go

create function BugununTarihi()
returns datetime      -- returns demek ben bu fonksiyondan geriye datetime tipini dönücem demek
as
begin
   declare @Tarih datetime
   set @Tarih=GETDATE()
   return @Tarih      -- return dediðim zaman @Tarih deðiþkeni içindeki deðeri dön demiþ oluyorum.
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





-- Satýþ yapýlan ürünlerimizin hangi kategoriden kaç adet satýldýðýný raporlayýn

select CategoryName,dbo.KatAdet(CategoryId) 'Toplam Satýþ Adedi'
from Categories

-- INLINE TABLE VALUED FUNCTIONS

create function KatUrunler(@KatId int)
returns table
as
  return (select * from Products where CategoryID=@KatId)


  -- Çaðýrýyoruz
  select * from KatUrunler(1)


  -- Sorguda foknsiyonu kullandýk
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
