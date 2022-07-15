CREATE TABLE lop(
ma INT,
ten VARCHAR(50),
PRIMARY KEY(ma)
)

insert into lop
values (1,'LT')

CREATE TABLE sinh_vien(
ma INT,
ho VARCHAR(50),
ten VARCHAR(50),
ma_lop int,
foreign key (ma_lop) references lop(ma),
PRIMARY KEY(ma)
)

insert into sinh_vien
values (1,'Long','Nguyen',1)

create nonclustered index index_ten
on sinh_vien(ten)

drop view view_ho_ten_sinh_vien
create view view_ho_ten_sinh_vien
as
select ho,ten from sinh_vien

select * from view_ho_ten_sinh_vien

create view sinh_vien_kem_lop
as
select 
sinh_vien.*,
lop.ten as ten_lop
from sinh_vien
join lop on lop.ma = sinh_vien.ma_lop

select * from sinh_vien_kem_lop