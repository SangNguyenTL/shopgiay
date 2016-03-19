create database db_ShoesShop
go

use db_ShoesShop
go

-- tao bang --
create table tb_User (
	UserID int identity(1,1) primary key,
	FullName nvarchar(50) not null,
	Email varchar(50) not null,
	Phone varchar(11) not null,
	[Address] nvarchar(200) not null,
	Role bit not null,
);
go

create table tb_Brand (
	BrandName varchar(50) primary key,
	Logo varchar(250) null,
	BrandDS nvarchar(500) null
);
go

create table tb_Product (
	ProductID int identity(1,1) primary key,
	ProName varchar(100) not null,
	Price int check(Price > 0 and Price < 5000000) not null,
	Inventory bit default 1  not null,
	ProDesrible nvarchar(500) null,
	DateEntry datetime default(getdate()) not null,
	NewArrival bit default 1 not null,
	[Image] varchar(600) not null,
	BrandName varchar(50) foreign key references tb_Brand(BrandName)
);
go

create table tb_FeedBack (
	FeedID int identity(1,1) primary key,
	FullName nvarchar(50) not null,
	Email varchar(70) not null,
	Content nvarchar(500) not null,
	DatePost datetime default(getdate()),
	Subject nvarchar(50) not null,
	[Status] bit default 0 null
);
go

create table tb_Basket (
	UserID int foreign key references tb_User(UserID),
	ProductID int foreign key references tb_Product(ProductID),
	Quantity int check(Quantity>0)  not null,
	primary key(UserID,ProductID)
);
go

create table tb_Order (
	OrderID int identity(1,1) primary key,
	[Status] bit default 0 not null,
	DateOrder datetime default(getdate()),
	NameRecipient nvarchar(70) not null,
	AddressRecipient nvarchar(150) not null,
	PhoneRecipient varchar(12) not null,
	EmailRecipient varchar(50) not null,
	TotalPrice int check(TotalPrice > 0 )  not null,
	Detail ntext not null,
	Note nvarchar(500) null,
	UserID int  foreign key references tb_User(UserID)
);
go

create tb_Comment (
	ComID int identity(1,1) primary key,
	Content nvarchar(300) not null,
	DatePost datetime default(getdate()),
	DateReply datetime null,
	UserID int foreign key references tb_User(UserID),
	ProductID int foreign key references tb_Product(ProductID),
	ParentID foreign key not null
);
go

-- insert data --