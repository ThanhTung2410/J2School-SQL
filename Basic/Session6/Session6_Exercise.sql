create database storeManagement
use storeManagement

create table customer(
id int identity,
name nvarchar(50) not null,
dateOfBirth date not null,
gender bit default 1 not null,
phoneNumber varchar(15) not null,
CONSTRAINT CK_valid_name CHECK (len(name) >= 2),
CONSTRAINT CK_valid_phone_number CHECK (len(phoneNumber) = 10),
PRIMARY KEY(id)
)

create table category(
id int identity,
name nvarchar(50) not null,
PRIMARY KEY(id)
)

create table product (
id int identity,
name nvarchar(50) not null,
idCategory int not null,
FOREIGN KEY(idCategory) REFERENCES category(id),
PRIMARY KEY(id)
)

create table invoice (
id int identity,
idCustomer int not null,
FOREIGN KEY(idCustomer) REFERENCES customer(id),
dateCreate date not null,
PRIMARY KEY(id)
)

create table invoiceDetail (
idInvoice int not null,
idCustomer int not null,
FOREIGN KEY (idInvoice) REFERENCES invoice(id),
FOREIGN KEY (idCustomer) REFERENCES customer(id),
quantity int not null,
price float not null 
)