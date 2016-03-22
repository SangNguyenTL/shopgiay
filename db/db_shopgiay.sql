create database db_ShoesShop
go

use db_ShoesShop
go

-- tao bang --
create table tb_user (
	userID int identity(1,1) primary key,
	fullName nvarchar(70) not null,
	email varchar(50) not null,
	phone varchar(11) not null,
	[address] nvarchar(200) not null,
	role bit not null,
	passW varchar(15),
);
go


create table tb_Brand (
	brandName varchar(50) primary key,
	logo varchar(250) null,
	brandDS nvarchar(4000) null
);
go


create table tb_product (
	productID int identity(1,1) primary key,
	proName Nvarchar(100) not null,
	price int check(Price > 10000 and Price < 9999999) not null,
	inventory bit default 1  not null,
	prodescrible nvarchar(2000) null,
	dateEntry datetime default(getdate()) not null,
	newArrival bit default 1 not null,
	[image] varchar(600) not null,
	brandName varchar(50) foreign key references tb_Brand(BrandName)
);
go



create table tb_feedBack (
	feedId int identity(1,1) primary key,
	fullName nvarchar(50) not null,
	email Nvarchar(70) not null,
	content nvarchar(500) not null,
	datePost datetime default(getdate()),
	subject nvarchar(50) not null,
	[status] bit default 0 null
);
go

create table tb_basket (
	userID int foreign key references tb_user(userID),
	productID int foreign key references tb_Product(productID),
	quantity int not null,
	primary key(userID,productID)
);
go

create table tb_order (
	orderID int identity(1,1) primary key,
	[status] bit default 0 not null,
	dateOrder datetime default(getdate()),
	nameRecipient nvarchar(70) not null,
	addressRecipient nvarchar(200) not null,
	phoneRecipient varchar(11) not null,
	emailRecipient varchar(50) not null,
	totalPrice int check(TotalPrice > 0 )  not null,
	detail ntext not null,
	noitice nvarchar(500) null,
	userID int  foreign key references tb_User(userID)
);
go

create table tb_comment (
	cm_ID int identity(1,1) primary key,
	cmContent nvarchar(300) not null,
	datePost datetime default(getdate()),
	userID int foreign key references tb_User(userID),
	proID int foreign key references tb_Product(productID),
	parentId int foreign key references tb_Comment(cm_ID) null
);
go

-- insert data --
insert tb_user values
('admin','admin@gmail.com','0909999888',N'Lâm Đồng',1,123456),
('Than Thi Hoang Thuy','hoangthuy@gmail.com','0909999999',N'Nhơn Trạch có bò sữa',0,123456), 
('Nguyen Nhat Sang','nhatsang@gmail.com','0909999888',N'Bảo Lộc có trà',0,123456),
(N'Cao Quang Tú','quangtu@gmail.com','0909999888',N'Bình Thuận có cá',0,123456)

go

insert tb_brand values
('NIKE','images/LOGO/NIKE.jpg',N'Nike, Inc. (phát âm như Nai-ki) (NYSE: NKE) là nhà cung cấp quần áo và dụng cụ thể thao thương mại công cộng lớn có trụ sở tại Hoa Kỳ. Đầu não của công ty đặt tại Beaverton, gần vùng đô thị Portland của Oregon. Công ty này là nhà cung cấp giày và áo quần thể thao hàng đầu trên thế giới[2] và là nhà sản xuất dụng cụ thể thao lớn với tổng doanh thu hơn 18,6 tỷ đô la Mỹ trong năm tài chính 2008 (kết thúc tháng ngày 31 tháng 5 năm 2008). Tính đến năm 2008, công ty này có hơn 30.000 nhân viên trên khắp thế giới. Nike và Precision Castparts là các công ty duy nhất có trong danh sách Fortune 500 có trụ sở tại bang Oregon, theo The Oregonian.

Công ty được thành lập vào ngày 25 tháng 1 năm 1964 với tên Blue Ribbon Sports nhờ bàn tay Bill Bowerman và Philip Knight, và chính thức có tên Nike, Inc. vào năm 1978. Công ty này lấy tên theo Nike (tiếng Hy Lạp Νίκη phát âm: [níːkɛː]), nữ thần chiến thắng của Hy Lạp. Nike quảng bá sản phẩm dưới nhãn hiệu này cũng như các nhãn hiệu Nike Golf, Nike Pro, Nike+, Air Jordan, Nike Skateboarding và các công ty con bao gồm Cole Haan, Hurley International, Umbro và Converse. Nike cũng sở hữu Bauer Hockey (sau này đổi tên thành Nike Bauer) vào khoảng năm 1995 đến 2008[3]. Ngoài sản xuất áo quần và dụng cụ thể thao, công ty còn điều hành các cửa hàng bán lẻ với tên Niketown. Nike tài trợ cho rất nhiều vận động viên và câu lạc bộ thể thao nổi tiếng trên khắp thế giới, với thương hiệu rất dễ nhận biết là "Just do it" và biểu trưng Swoosh.'),
('ADIDAS','images/LOGO/ADI.jpg',N'Adidas ltd AG (ISIN: DE0005003404) là một nhà sản xuất dụng cụ thể thao của Đức, một thành viên của Adidas Group, bao gồm cả công ty dụng cụ thể thao Reebok, công ty golf Taylormade, công ty sản xuất bóng golf Maxfli và Adidas golf. Adidas là nhà sản xuất dụng cụ thể thao lớn thứ hai trên thế giới. Công ty được đặt theo tên của người sáng lập,, Adolf (Adi) Dassler, năm 1948. Dassler đã sản xuất giày từ năm 1920 tại Herzogenaurach, gần Nürnberg, với sự giúp đỡ của người anh trai Rudolf Dassler, người mà sau đó đã thành lập công ty giày Puma. Công ty Adidas được đăng ký nhãn hiệu là adidas AG vào ngày 18 tháng 8 1949. Những thiết kế quần áo và giày của công ty biểu tượng cho ba sọc kẻ chéo song song, họa tiết tương tự đã được đưa vào logo chính thức của công ty. Tài sản của công ty năm 2005 ước tính khoảng 6,6 tỷ Euro (khoảng 8,4 tỷ USD). Tài sản năm 2006 ước tính 10.084 tỷ Euro (13.625 tỷ USD). Những sản phẩm chăm sóc cá nhân và nước hoa của công ty được sản xuất bởi Coty, Inc. dưới bản quyền toàn cầu.'),
('PUMA','images/LOGO/PUMA.png',N'Puma SE (thưong hiệu chính thức là PUMA) là một công ty đa quốc gia lớn của Đức chuyên sản xuất giày và các dụng cụ thể thao khác có trụ sở tại Herzogenaurach, Bavaria, Đức. Công ty được thành lập năm 1924 bởi Adolf và Rudolf Dassler với tên gọi ban đầu Gebrüder Dassler Schuhfabrik. Quan hệ giữa hai anh em họ rạn nứt và cuối cùng hai người quyết định tách ra vào năm 1948, tạo ra hai thực thể riêng biệt, Adidas và Puma. Cả hai công ty hiện nay đều có trụ sở đóng tại Herzogenaurach, Đức.

Puma sản xuất giày đá bóng và đã bảo trợ cho khá nhiều cầu thủ, gồm có Pelé, Eusébio, Johan Cruijff, Enzo Francescoli, Diego Maradona, Lothar Matthäus, Kenny Dalglish, Didier Deschamps, Robert Pires, Radamel Falcao, Sergio Agüero, Cesc Fàbregas, Marco Reus, và Gianluigi Buffon. Puma cũng là nhà tài trợ của vận động viên điền kinh Jamaica Usain Bolt. Ở Mỹ, công ty nổi tiếng với sản phẩm giày bóng rổ Puma Clyde được ra mắt năm 1968, thương hiệu này được mang tên của ngôi sao bóng rổ Walter "Clyde" Frazier của đội New York Knicks.

Sau khi tách ra làm ăn riêng, Rudolf Dassler ban đầu đăng ký tên công ty mới thành lập là Ruda nhưng sau đó đổi thành Puma[3]. Logo đầu tiên của Puma là hình một con thú nhảy qua chữ D. Cùng với tên công ty, biểu trưng này được đăng ký vào năm 1948.

Công ty bán ra thị trường dòng sản phẩm giày và quần áo thể thao được thiết kế bởi Lamine Kouyate, Amy Garbers và những người khác. Từ 1996, Puma đã mở rộng hoạt động sang thị trường Mỹ. Từ 2007, Puma SE trở thành một phần của tập đoàn sản xuất hàng xa xỉ Pháp Kering.'),
('VANS','images/LOGO/van.jpg',N'Vào ngày 16 Tháng 3 năm 1966, tại 704 East Broadway ở Anaheim, California, Mỹ, anh em Paul Van Doren và James Van Doren, Gordon Lee, và Serge D Elia đã mở cửa hàng đầu tiên Vans dưới tên The Van Doren Công ty cao su. [3 ] Paul Van Doren và D Elia sở hữu phần lớn các công ty, trong khi James Van Doren và Lee từng sở hữu một cổ phần 10 phần trăm. Các doanh nghiệp sản xuất giày và bán trực tiếp cho công chúng. Vào cái buổi sáng đầu tiên, mười hai khách hàng mua Vans deck giày, mà bây giờ được gọi là "Authentic". Công ty này hiển thị ba phong cách của giày, trong đó có giá giữa Mỹ $ 2,49 và $ 4,99, nhưng trong ngày khai mạc, công ty đã chỉ sản xuất mô hình hiển thị mà không cần bất kỳ hàng tồn kho sẵn sàng để bán, các hộp lưu trữ giá là thực sự trống rỗng. [4]

Tuy nhiên, mười hai khách hàng lựa chọn màu sắc và phong cách mà họ mong muốn, và được yêu cầu trở lại sau vào buổi chiều để đón mua hàng của họ. Paul Van Doren và Lee sau đó vội vã đến nhà máy để sản xuất những đôi giày được lựa chọn. Khi khách hàng quay trở lại vào buổi chiều để chọn lên giày của họ, Paul Van Doren và Lee nhận ra rằng họ đã quên để duy trì dự trữ tiền mặt để cung cấp thay đổi cho khách hàng. Do đó, các khách hàng đã đưa ra những đôi giày và yêu cầu trở lại vào ngày hôm sau với khoản thanh toán của họ. Tất cả mười hai của các khách hàng quay trở lại vào ngày hôm sau để trả cho các hạng mục của họ. [4]

Năm 1988, Paul Van Doren bán công ty Vans để công ty ngân hàng McCown De Leeuw & Co cho 74,4 triệu US $. Trong năm 1989, nhiều nhà sản xuất hàng giả giày Vans đã bắt giữ các quan chức Mỹ và Mexico và ra lệnh phải ngừng sản xuất. [4]

Năm 2004 Vans công bố sẽ được sáp nhập vào Bắc Carolina dựa Corporation VF. [5]

Vào tháng Tám năm 2013, nhóm skateboard Vans quay video, và đội ngũ lái Geoff Rowley giải thích trong một cuộc phỏng vấn rằng video sẽ đại diện cho một nhóm các tay đua Vans biết ơn trở về sự hỗ trợ mà họ nhận được từ các thương hiệu giày đến nay. [6] Skateboard nhà làm phim Greg Hunt, người đã từng làm việc trên Alien Workshop video Mindfield, tự chịu trách nhiệm cho các video và đây là dự án đầu tiên mà Hunt đã được trao toàn quyền sáng tạo hơn. '),
('CONVERSE','images/LOGO/converse.jpg',N'Converse là thương hiệu của một công ty chuyên sản xuất giày thể thao và là một công ty con của hãng Nike nổi tiếng.[2] Công ty từng sản suất ra đôi giày bóng rổ đầu tiên trên thế giới vào năm 1908, hãng đã lấy giày bóng rổ làm sản phẩm chủ lực trong số rất nhiều sản phẩm phục vụ thể thao. Ở Mỹ, sở hữu 1 đôi giày vải Converse All Star được xem là một biểu tượng văn hóa tinh thần Mỹ như là thức ăn nhanh McDonalds, ô tô Ford, nước ngọt Coca-Cola.');
go



insert tb_Product values
--Converse--
('Converse Chuck Taylor All Start',1700000,1,N'Chuck Taylor All Start',default,1,'images/product-details/con37dodam.png','CONVERSE'),
('Converse Chuck II',1700000,1,N'Converse Chuck II là dòng sản phẩm mới của Converse',default,1,'images/product-details/con1.png','CONVERSE'),
('Converse Camo',1500000,0,N'Đây là dòng sản phẩm mang phong cách mới',default,1,'images/product-details/con2.png','CONVERSE'),
('Converse Classic',950000,1,N'Classic được coi là sản phẩm được ưa chuộng nhất',1,default,'images/product-details/con16.png','CONVERSE'),
('Converse Chuck Taylor All Start Dainy',950000,0,N'Là dòng sản phẩm với thiết kể lạ mắt',0,default,'images/product-details/con32trang.png','CONVERSE'),
--Nike
('Nike Huarache',2990000,0,N'Nike Huarache',default,1,'images/product-details/nike1.jpg','NIKE'),
('Nike Huarache Ultra',3000000,1,N'Dòng sản phẩm nâng cấp của Nike Huarache',default,1,'images/product-details/nike11.jpg','NIKE'),
('Nike Air Zoom',2800000,1,N'Nike Air Zoom',default,1,'images/product-details/nikeairzoom140.jpg','NIKE'),
('Nike Roshe Run',3100000,1,N'Dòng sản phẩm mang êm chân',default,0,'images/product-details/nike8.jpg','NIKE'),
('Nike Huarache Color',2990000,0,'Sản phẩm đẹp, bắt kịp xu hướng',default,1,'images/product-details/nike3.jpg','NIKE'),
--Adidas
('Adidas Tubular',2600000,1,N'Sản phẩm đẹp,bán chạy',default,0,'images/product-details/tubular4.jpg','ADIDAS'),
('NMD RUNNER',3990000,0,N'Adidas NMD Runner',default,1,'images/product-details/NMD-RUNNER.jpg','ADIDAS'),
('Adidas Tubular Green',2600000,1,N'Sản phẩm với họa tiết mới mẻ',default,1,'images/product-details/tubulargreen.jpg','ADIDAS'),
('Adidas COUR VANTAGE',2200000,0,N'Adidas Color',default,1,'images/product-details/COUR-VANTAGE.jpg','ADIDAS'),
('Adidas Hoops Vulc Mid',2600000,1,N'Sản phẩm đẹp,bán chạy',default,1,'images/product-details/hoopsvulcmid2.jpg','ADIDAS'),
--Puma--
('Puma R698 MATTE&SHINE',1600000,1,N'Puma Matte and Shine',default,1,'images/product-details/R698-MATTE&SHINE-80.jpg','PUMA'),
('R698 MESH NEOPRENE',1600000,0,N'Puma R698 MESH NEOPRENE',default,0,'images/product-details/R698-MESH-NEOPRENE-80.jpg','PUMA'),
('Puma R698-SUEDE',1600000,1,N'Puma R698 SUEDE',default,1,'images/product-details/R698-SUEDE-80.jpg','PUMA'),
('Puma R698-WINTER-MID',2200000,1,N'Puma Matte and Shine',default,0,'images/product-details/R698-WINTER-MID-95.jpg','PUMA'),
('ARIL-BASIC-SPORTS',2300000,1,N'ARIL-BASIC-SPORTS',default,1,'images/product-details/ARIL-BASIC-SPORTS-75-1.jpg','PUMA'),
--Vans--
('VANS 50TH AUTHENTIC',1100000,0,N'Thiết kế bắt mắc',default,0,'images/product-details/50TH-AUTHENTIC-60.jpg','VANS'),
('VANS 50TH ERA 59 ',1200000,1,N'50TH-ERA-59',default,0,'images/product-details/50TH-ERA-59-55.jpg','VANS'),
('VANS 50TH-OLD-SKOOL',1400000,1,N'50TH-OLD-SKOOL',default,0,'images/product-details/50TH-OLD-SKOOL-65.jpg','VANS'),
('VANS 50TH SK8 HI REISSUE',1700000,0,N'Thiết kế bắt mắc',default,0,'images/product-details/50TH-SK8-HI-REISSUE-70.jpg','VANS'),
('VANS LATE-NIGHT-AUTHENTIC',1100000,1,N'Sản phẩm mới',default,1,'images/product-details/LATE-NIGHT-AUTHENTIC-55-3.jpg','VANS');
go
