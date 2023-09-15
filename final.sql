 create database pardhu;
  use pardhu;
  --creating tables
create table Author(
auth_id int primary key,
Auth_name varchar(100) not null,
Auth_country varchar(100) not null,
created_date datetime,
);
--creating books
create table Books(
book_id int primary key,
book_title varchar(100)  not null,
book_category varchar(100) not null,
book_price money not null,
book_ISBN bigint UNIQUE not null,
auth_id int foreign key references author(auth_id),
created_date datetime not null
);

--creating inventory
create table Inventory(
inventory_id int identity(301,1) primary key,
book_id int  foreign key references Books(book_id),

stock_level_used int not null ,
stock_level_available int not null,
createdAt datetime not null
);
--creating customers 
create table customers(
cust_id int identity(501,1) primary key,
cust_name varchar(100) not null,
cust_mobile  bigint unique  not null check(cust_mobile>=1000000000 and cust_mobile<=9999999999),
email_id varchar(100) unique not null,
postal_code int not null,
state varchar(100) not null,
password varchar(100) not null,
createdAt date
);
alter table customers alter column createdat date
--creating the admin table
create table admins(
admin_id int identity(1,1) primary key,
email_id varchar(100) unique not null,
name varchar(100) not null,
phone_number bigint unique  not null check(phone_number>=1000000000 and phone_number<=9999999999),
address text not null,
password varchar(100) not null,
createdAt datetime 
)

-----CREATION  OF BUCKET TABLE----------
create table bucket(
bucket_id int identity(1001,1) primary key,
cust_id int foreign key references customers(cust_id),
book_id int  foreign key references Books(book_id),
quantity int,
price money,
);

-----CREATION OF PAYMENT------
create table payment(
pay_id int identity(601,1) primary key,
cust_id int foreign key references customers(cust_id),
order_date datetime,
tax money,
total_amount money);
------CREATION OF ORDERS TABLE-----

create table orders(
ord_id int identity(1,1) primary key,
cust_id int foreign key references customers(cust_id),
order_date datetime,
total_amount_after_tax int
);
-----CREATION OF ORDER-ITEM TABLE---
create table orderitems(
item_id int identity(701,1) primary key,
ord_id int foreign key references orders(ord_id),
cust_id int foreign key references customers(cust_id),
book_id int foreign key references books(book_id),
order_date datetime,
created_date datetime
);

-------------------------------------------------------------------------------------------------------------------
--insert values into author 
insert into author values(101,'valmiki','india',getdate()),(102,'justin','australia',getdate());
insert into author values(103,'Shiv Khera','india',getdate()),(104,'Kishimoto','Japan',getdate());
insert into author values(105,'Oda','Japan',getdate());
 select*from author;
----procedures
--creating the admin procedure
create procedure admin_sign_up
(
	@email_id varchar(100),
	@name varchar(50),
	@phone_number bigint,
	@address text,
	@password varchar(20)
)
as insert into admins(email_id,name,phone_number,address,password,createdAt) values(@email_id,@name,@phone_number,@address,@password,getdate())

exec admin_sign_up 'raju@gmail.com','raju' ,1236547890,'Hitech city' ,'Raju@123'
exec admin_sign_up 'himansu@123','himansu' ,8985874922,'Hitech city' ,'himansu@123'

select * from admins
-----------------------------------------------------------------------------------------------------------------------------------------------
--creating the insert_into_books procedure				
alter procedure insert_into_books(
	@email varchar(100),
	@password varchar(100),
	@book_id int,
	@title varchar(100),
	@category varchar(100),
	@price money,
	@isbn bigint ,
	@author_id int,
	@quantity int

)
as
begin
	if (select count(*) from admins where email_id = @email and password=@password) = 1
	begin
		if(select count(*) from books where book_id = @book_id) = 1
		begin
			update inventory set stock_level_available+=@quantity where book_id=@book_id
			print 'Book already exists and we updated your inventory' 
		end
		else
			begin
				insert into books values(@book_id ,@title,@category,@price,@isbn,@author_id,getdate())
				insert into inventory values(@book_id,0,@quantity,getdate())
			end
	end
	else
		begin
			print ' No user exists with given credential'
		end
end


select * from books
exec  insert_into_books 'raju@gmail.com','Raju@123', 201,'ramayana','epic',1500,8985878541,101,20;
exec  insert_into_books 'raju@gmail.com','Raju@123', 203,'mahabarata','epic',1500,878541111,102,20;
exec  insert_into_books 'raju@gmail.com','Raju@123', 204,'The secrect','thriller',1500,8781541111,103,20;
exec  insert_into_books 'raju@gmail.com','Raju@123', 206,'Zootopia','animated',1500,671541111,103,20;
exec  insert_into_books 'raju@gmail.com','Raju@123', 207,'Dhasavatar','epic',1500,984541111,103,20;
exec  insert_into_books 'raju@gmail.com','Raju@123', 208,'cata combo','Horror',1350,6715411111,103,20;
exec  insert_into_books 'raju@gmail.com','Raju@123', 209,'Girl_in_Trouble','Thriller',1500,6711541111,103,20;
exec  insert_into_books 'raju@gmail.com','Raju@123', 210,'Simpsons','animated',1500,6715141111,103,20;
exec  insert_into_books 'raju@gmail.com','Raju@123', 211,'Mommin','comic',1500,371541111,103,20;
exec  insert_into_books 'raju@gmail.com','Raju@123', 212,'Black forest','Horror',1400,2547541111,103,20;
exec  insert_into_books 'raju@gmail.com','Raju@123', 206,'Zootopia','animated',1500,671541111,103,20;
exec  insert_into_books 'raju@gmail.com','Raju@123', 207,'Spiderman-venom','animated',2000,6715401111,103,20;







insert into books values(201,'ramayana','epic',1500,951478521,101,getdate());
insert into books values(202,'naruto','Manga',500,452222211,104,getdate());
insert into books values(203,'You can win','Motivation',1500,8564676412,103,getdate());
insert into books values(204,'One piece','Manga',500,6488764764,105,getdate());
insert into books values(205,'Rap','Motivation',1500,9654761764,102,getdate());
insert into books values(206,'abc','kjgfn',1500,4846654784,102,getdate());
insert into books values(210,'Life of pie','Motivation',1500,654765417654,102,getdate());
------------------------------------------------------------------------------------
--procedure1
alter procedure view_books_by_title( 
@book_title varchar(100)
)
as begin

select * from books where booktitle=@book_title

end
exec view_books_by_title @book_title='ramayana'

--procedure 2

create procedure view_books_by_Author @auth_id int
as begin
select * from books where auth_id=@auth_id
end

exec view_books_by_Author @auth_id=101
--procedure 3

alter procedure view_books_by_category @book_category varchar(100)
as begin
select * from books where category=@book_category

end
exec view_books_by_category @book_category='epic'
----Procedure for customers signup-----
alter PROCEDURE customer_signup (

  @cust_name varchar(100),
  @cust_mobile numeric(10,0),
  @email_id varchar(100),
  @postal_code int,
  @state varchar(100),
  @password varchar(100),
  @createdAt date
  )
as begin

    insert into customers

  values(
  @cust_name ,
  @cust_mobile,
  @email_id,
  @postal_code,
  @state,
  @password,
  GETDATE()
  )
end
exec customer_signup 'ajay',6301457891,'ajay@gmail.com',535002,'telangana','@123','2023-09-05';
exec customer_signup 'Vijay',8974537363,'Vijay@gmail.com',500083,'Karnataka','@234','2023-09-05';
exec customer_signup 'Sanjay',9345637218,'Sanjay@gmail.com',534728,'Mumbai','@345','2023-09-05';
exec customer_signup 'Bhargav',6389372837,'Bhargav@gmail.com',535056,'Karnataka','@456','2023-09-05';
exec customer_signup 'Ravi',7894927483,'Ravi@gmail.com',535742,'Tamilnadu','@567','2023-09-05';
exec customer_signup 'Rajesh',9865614763,'Rajesh@gmail.com',538981,'Kerala','@678','2023-09-05';
--creating procedure for bucket

create PROCEDURE insertintobucket(
    @book_id INT,
    @cust_id INT,
    @quantity int
)
as begin
declare @price money
select @price=book_price from books where book_id=@book_id
 insert into bucket(book_id,cust_id,price,quantity) values (@book_id, @cust_id,@price,@quantity);
end
exec insertintobucket @book_id=201,@cust_id=501,@quantity=20;
exec insertintobucket @book_id=205,@cust_id=502,@quantity=20
exec insertintobucket @book_id=201,@cust_id=503,@quantity=20
exec insertintobucket @book_id=202,@cust_id=504,@quantity=20


select * from inventory

------------procedure for bucket to payment-------------
alter procedure makepayment(@cust_id int)
as begin
declare @total_amount money,@stock_level_used int,@Book_id int
select @total_amount = sum(price)from bucket where cust_id=@cust_id
declare @total_amount_after_tax money
set @total_amount_after_tax=(@total_amount)*0.05 + @total_amount;
if(@total_amount is not null)
insert into payment(cust_id,total_amount) values(@cust_id,@total_amount_after_tax)
end
 exec makepayment @cust_id =502

--creating trigger to insert into orders
alter trigger paymenttrigger on dbo.payment
for insert as begin
declare @cust_id int,@order_date date,@total_amount_after_tax money,@quantity int,@book_id int
select @cust_id=cust_id from bucket
select @order_date=order_date from inserted
select @total_amount_after_tax= total_amount from inserted
select @quantity = quantity from bucket where cust_id=@cust_id

select @book_id =book_id from bucket where cust_id=@cust_id
insert into orders(cust_id,order_date,total_amount_after_tax) values(@cust_id,@order_date,@total_amount_after_tax)
declare @order_id int
print @quantity
select @order_id = ord_id from orders
insert into orderitems(created_date,ord_id,cust_id,book_id,order_date) values(getdate(),@order_id,@cust_id,@book_id,getdate())
update inventory set stock_level_available-=@quantity where book_id=@book_id
update inventory set stock_level_used+=@quantity where book_id=@book_id
delete from bucket where cust_id=@cust_id
end
--procedure for customer order history
alter procedure Customerorderhistory(@cust_id int)
as begin
    select o.ord_id, o.order_date, p.total_amount,c.cust_name
    from Orders o
     join Payment p on o.cust_id = p.cust_id join customers c on c.cust_id=p.cust_id
    order by o.ord_id;
end;


exec Customerorderhistory 501
--reading data from tables

select * from books
select * from customers
select * from payment
select * from inventory
select * from orders
select * from orderitems
--admin inventory------------------

create procedure admin_inventory(
			@email varchar(100),
			@password varchar(20),
			@book_id int ,
			@quantity int
)
as
begin
	if (select count(*) from admin where email_id = @email and password=@password) = 1
	begin
		if(select count(*) from books where book_id = @book_id) = 1
			begin
				update inventory set stocklevel_available+=@quantity where book_id=@book_id
			end
		else
			begin
				Print 'Please insert book through  insert_into_books procedure'
			end
	end
	else
		begin
			print ' No user exists with given credential'
		end
end





SELECT * FROM CUSTOMERS

select * from books


exec sp_rename 'dbo.Books.book_category','category';

