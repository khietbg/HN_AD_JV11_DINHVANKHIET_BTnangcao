use QLBHDINHVANKHIET;
create table customer(
cId int primary key,
cName varchar(25) ,
cAge int 
);

create table product(
pId int primary key,
pName varchar(25) ,
pPrice int
);

create table `order`(
oId int primary key,
cId int,
foreign key(cId) references customer(cId),
oDate datetime ,
oTotalPrice int 
);

create table orderDetail(
oID int ,
foreign key(oId) references `order`(oId),
pId int,
foreign key(pId) references product(pId),
odQTY int
);

insert into customer(cID,cName, cAge) values
(1,"Minh Quân", 10),
(2,"Ngọc Oanh", 20),
(3,"Hồng HÀ", 50);

insert into `order`(oID,cId, oDate) values
(1,1,"2006-3-21"),
(2,2,"2006-3-23"),
(3,1,"2006-3-16");

insert into product(pID,pName, pPrice) values
(1,"Máy Giặt", 3),
(2,"Tủ Lạnh", 5),
(3,"Điều Hòa", 7),
(4,"Quạt", 1),
(5,"Bếp Điện", 2);

insert into orderDetail(oId, pId, odQTY) values
(1,1,3),
(1,3,7),
(1,4,2),
(2,1,1),
(3,1,8),
(2,5,4),
(2,3,3);

-- 2. Hiển thị các thông tin gồm oID, oDate, oPrice của tất cả các hóa đơn trong bảng Order,
--  danh sách phải sắp xếp theo thứ tự ngày tháng, hóa đơn mới hơn nằm trên như hình sau: [15]
select * from `Order`;
-- 3. Hiển thị tên và giá của các sản phẩm có giá cao nhất như sau: [20]
 select pName,pPrice from product where pPrice = (select max(pPrice) from product)
 
--  4. Hiển thị danh sách các khách hàng đã mua hàng, và danh sách sản phẩm được mua bởi các khách đó như sau:
 select c.cName,p.pName from Customer c join `Order` o on c.cID = o.cID join orderDetail od on o.oID = od.oID join product p on od.pID = p.pID;
 
 -- 5. Hiển thị tên những khách hàng không mua bất kỳ một sản phẩm nào như sau: [20]
 select c.cName from Customer c where c.cID not in (select cID from `Order`);
 
 -- 6. Hiển thị chi tiết của từng hóa đơnnhư sau
 select o.oID,o.oDate,od.odQTY,p.pName,p.pPrice from `Order` o join orderDetail od on o.oID = od.oID join product p on od.pID = p.pID;
 
 -- 7. Hiển thị mã hóa đơn, ngày bán và giá tiền của từng hóa đơn (giá một hóa đơn được tính bằng tổng giá bán của từng loại mặt hàng xuất hiện
 select o.oID,o.oDate,sum(od.odQTY*p.pPrice) as `total` from `Order` o join orderDetail od on o.oID = od.oID join product p on od.pID = p.pID group by o.oID;
-- Tạo một view tên là Sales để hiển thị tổng doanh thu của siêu thị như sau: [25]
 
create view Sales 
as
select sum(oo.total) as Sales from (select o.oID,o.oDate,sum(od.odQTY*p.pPrice) as `total` from `Order` o join orderDetail od on o.oID = od.oID join product p on od.pID = p.pID group by o.oID) oo;
select * from Sales;

--  9. Xóa tất cả các ràng buộc khóa ngoại, khóa chính của tất cả các bảng.
alter table `order`
drop foreign key order_ibfk_1;
alter table orderDetail
drop foreign key orderdetail_ibfk_1,
drop foreign key orderdetail_ibfk_2;

alter table Customer 
drop primary key;
alter table `Order` 
drop primary key;
alter table product 
drop primary key;
 
 -- 10.ạo một trigger tên là cusUpdate trên bảng Customer, sao cho khi sửa mã khách (cID) thì mã khách trong bảng Order cũng được sửa theo:

 CREATE TRIGGER cusUpdate
 After update on Customer
 for each row
 update `Order` set cId = new.cid where cID = old.cId;
 
 
 update Customer 
 set cid = 5 where cid = 2;
 
 
 
 -- 11.
-- Tạo một stored procedure tên là delProduct nhận vào 1 tham số là tên của một sản phẩm,
-- strored procedure này sẽ xóa sản phẩm có tên được truyên vào thông qua tham số, 
--  và các thông tin liên quan đến sản phẩm đó ở trong bảng OrderDetail: [25]

DELIMITER //
create procedure delProduct(in nameDel varchar(25))
begin
delete from product 
where pName = nameDel ;
delete from orderDetail 
where pid in (select pid from product where pName = nameDel);
end //
DELIMITER ;
call delProduct("Máy Giặt")