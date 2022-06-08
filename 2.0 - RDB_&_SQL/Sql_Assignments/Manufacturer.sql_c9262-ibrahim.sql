CREATE DATABASE Manufacturer;

Use Manufacturer; --> Charlie nin Çikolota Fabrikasý
CREATE TABLE [Product].[Product](
	[prod_id] [int] PRIMARY KEY ,
	[prod_name] [nvarchar](50) ,
	quantity INT);

CREATE TABLE [Supplier].[Supplier](
	[supp_id] [int] PRIMARY KEY ,
	[supp_name] [nvarchar](50) ,
	[supp_location] [nvarchar](50),
	[supp_country] [nvarchar](50),
	[is_active] bit);

	CREATE TABLE [Component].[Component](
	[comp_id] [int] PRIMARY KEY ,
	[comp_name] [nvarchar](50) ,
	[description] [nvarchar](50),
	quantity_comp INT);

	CREATE TABLE [Product].[Prod_Comp](
	[prod_id] int ,
	[comp_id] int,
	quantity_comp int,
	PRIMARY KEY ([prod_id], [comp_id]));

	CREATE TABLE [Component].[Prod_Comp](
	[prod_id] int ,
	[comp_id] int,
	quantity_comp int,
	PRIMARY KEY ([prod_id], [comp_id]));

	CREATE TABLE [Supplier].[Comp_Supp](
	[supp_id] int ,
	[comp_id] int ,
	order_date date,
	quantity int,
	PRIMARY KEY ([supp_id], [comp_id])
	);

	CREATE TABLE [Component].[Comp_Supp](
	[supp_id] int ,
	[comp_id] int ,
	order_date date,
	quantity int,
	PRIMARY KEY ([supp_id], [comp_id])
	);

	ALTER TABLE Product.Prod_Comp ADD CONSTRAINT FK_product FOREIGN KEY (prod_id) REFERENCES Product.Product (prod_id)
ON UPDATE NO ACTION
ON DELETE CASCADE;

	ALTER TABLE Supplier.Comp_Supp ADD CONSTRAINT FK_supplier FOREIGN KEY (supp_id) REFERENCES Supplier.Supplier (supp_id)
ON UPDATE NO ACTION
ON DELETE CASCADE
TRUNCATE TABLE Supplier.Comp_Supp;

	ALTER TABLE Component.Prod_Comp ADD CONSTRAINT FK_component FOREIGN KEY (comp_id) REFERENCES Component.Component (comp_id)
ON UPDATE NO ACTION
ON DELETE CASCADE
TRUNCATE TABLE Component.Prod_Comp;

	ALTER TABLE Component.Comp_Supp ADD CONSTRAINT FK_component FOREIGN KEY (comp_id) REFERENCES Component.Component (comp_id)
ON UPDATE NO ACTION
ON DELETE CASCADE
TRUNCATE TABLE Component.Comp_Supp;
