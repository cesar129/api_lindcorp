USE [QAGlamBrands_Audit]
GO
/****** Object:  Synonym [dbo].[CLASS]    Script Date: 27/08/2024 18:14:34 ******/
CREATE SYNONYM [dbo].[CLASS] FOR [QAGlamBrands_Repl].[dbo].[CLASS]
GO
/****** Object:  Synonym [dbo].[CUSTOMER]    Script Date: 27/08/2024 18:14:34 ******/
CREATE SYNONYM [dbo].[CUSTOMER] FOR [QAGlamBrands_Repl].[dbo].[CUSTOMER]
GO
/****** Object:  Synonym [dbo].[CUSTOMER_ADDRESS]    Script Date: 27/08/2024 18:14:34 ******/
CREATE SYNONYM [dbo].[CUSTOMER_ADDRESS] FOR [QAGlamBrands_Repl].[dbo].[CUSTOMER_ADDRESS]
GO
/****** Object:  Synonym [dbo].[DEPARTMENT]    Script Date: 27/08/2024 18:14:34 ******/
CREATE SYNONYM [dbo].[DEPARTMENT] FOR [QAGlamBrands_Repl].[dbo].[DEPARTMENT]
GO
/****** Object:  Synonym [dbo].[PRODUCT]    Script Date: 27/08/2024 18:14:34 ******/
CREATE SYNONYM [dbo].[PRODUCT] FOR [QAGlamBrands_Repl].[dbo].[PRODUCT]
GO
/****** Object:  Synonym [dbo].[PRODUCT_STYLE]    Script Date: 27/08/2024 18:14:34 ******/
CREATE SYNONYM [dbo].[PRODUCT_STYLE] FOR [QAGlamBrands_Repl].[dbo].[PRODUCT_STYLE]
GO
/****** Object:  Synonym [dbo].[RECEIPT]    Script Date: 27/08/2024 18:14:34 ******/
CREATE SYNONYM [dbo].[RECEIPT] FOR [QAGlamBrands_Repl].[dbo].[RECEIPT]
GO
/****** Object:  Synonym [dbo].[RECEIPT_LINE]    Script Date: 27/08/2024 18:14:34 ******/
CREATE SYNONYM [dbo].[RECEIPT_LINE] FOR [QAGlamBrands_Repl].[dbo].[RECEIPT_LINE]
GO
/****** Object:  Synonym [dbo].[RECEIPT_TENDER]    Script Date: 27/08/2024 18:14:34 ******/
CREATE SYNONYM [dbo].[RECEIPT_TENDER] FOR [QAGlamBrands_Repl].[dbo].[RECEIPT_TENDER]
GO
/****** Object:  Synonym [dbo].[STORE]    Script Date: 27/08/2024 18:14:34 ******/
CREATE SYNONYM [dbo].[STORE] FOR [QAGlamBrands_Repl].[dbo].[STORE]
GO
/****** Object:  Synonym [dbo].[STORE_REGION]    Script Date: 27/08/2024 18:14:34 ******/
CREATE SYNONYM [dbo].[STORE_REGION] FOR [QAGlamBrands_Repl].[dbo].[STORE_REGION]
GO
/****** Object:  Synonym [dbo].[SUBCLASS]    Script Date: 27/08/2024 18:14:34 ******/
CREATE SYNONYM [dbo].[SUBCLASS] FOR [QAGlamBrands_Repl].[dbo].[SUBCLASS]
GO
/****** Object:  Synonym [dbo].[ZIPCODE]    Script Date: 27/08/2024 18:14:34 ******/
CREATE SYNONYM [dbo].[ZIPCODE] FOR [QAGlamBrands_Repl].[dbo].[ZIPCODE]
GO
/****** Object:  Table [dbo].[Aplication]    Script Date: 27/08/2024 18:14:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Aplication](
	[AplicationCode] [int] IDENTITY(1,1) NOT NULL,
	[UserAplication] [varchar](50) NULL,
	[Password] [varchar](100) NULL,
	[Descripccion] [text] NULL,
	[RegisterDate] [datetime] NULL,
 CONSTRAINT [PK_Aplication] PRIMARY KEY CLUSTERED 
(
	[AplicationCode] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ZIPCODE_CONTROL]    Script Date: 27/08/2024 18:14:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ZIPCODE_CONTROL](
	[ZipCodeControlCode] [int] IDENTITY(1,1) NOT NULL,
	[AplicationCode] [int] NULL,
	[ZipCode] [varchar](10) NOT NULL,
	[City] [varchar](30) NOT NULL,
	[STATUS] [int] NOT NULL,
	[DESCRIPTION] [text] NULL,
	[RequestCode] [bigint] NOT NULL,
 CONSTRAINT [PK_ZIPCODE_CONTROL] PRIMARY KEY CLUSTERED 
(
	[ZipCodeControlCode] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  View [dbo].[VW_ZIPCODE]    Script Date: 27/08/2024 18:14:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[VW_ZIPCODE]
AS
SELECT        C1.ZipCode, C1.City, C1.State, C1.County, A.AplicationCode
FROM            dbo.ZIPCODE AS C1 CROSS JOIN
                         dbo.Aplication AS A LEFT OUTER JOIN
                         dbo.ZIPCODE_CONTROL AS C2 ON C1.ZipCode = C2.ZipCode AND C1.City = C2.City LEFT OUTER JOIN
                             (SELECT        MAX(ZipCodeControlCode) AS ZipCodeControlCode, ZipCode, City, STATUS, AplicationCode
                               FROM            dbo.ZIPCODE_CONTROL
                               WHERE        (STATUS IN (0, 1))
                               GROUP BY ZipCode, City, STATUS, AplicationCode) AS tmpmax ON C2.ZipCode = tmpmax.ZipCode AND C2.City = tmpmax.City AND A.AplicationCode = C2.AplicationCode
WHERE        (tmpmax.STATUS = - 1) OR
                         (tmpmax.STATUS IS NULL)
GO
/****** Object:  Table [dbo].[CLASS_CONTROL]    Script Date: 27/08/2024 18:14:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CLASS_CONTROL](
	[ClassControlCode] [int] IDENTITY(1,1) NOT NULL,
	[AplicationCode] [int] NULL,
	[ClassCode] [varchar](10) NOT NULL,
	[DeptCode] [varchar](10) NOT NULL,
	[STATUS] [int] NOT NULL,
	[DESCRIPTION] [text] NULL,
	[RequestCode] [bigint] NOT NULL,
 CONSTRAINT [PK__CLASS_CONTROL] PRIMARY KEY CLUSTERED 
(
	[ClassControlCode] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  View [dbo].[VW_CLASS]    Script Date: 27/08/2024 18:14:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[VW_CLASS]
AS
SELECT        C1.ClassCode, C1.DeptCode, C1.ClassName, A.AplicationCode
FROM            dbo.CLASS AS C1 CROSS JOIN
                         dbo.Aplication AS A LEFT OUTER JOIN
                         dbo.CLASS_CONTROL AS C2 ON C1.ClassCode = C2.ClassCode LEFT OUTER JOIN
                             (SELECT        MAX(ClassControlCode) AS ClassControlCode, ClassCode, STATUS, AplicationCode
                               FROM            dbo.CLASS_CONTROL
                               WHERE        (STATUS IN (0, 1))
                               GROUP BY ClassCode, STATUS, AplicationCode) AS tmpmax ON C2.ClassCode = tmpmax.ClassCode AND A.AplicationCode = C2.AplicationCode
WHERE        (tmpmax.STATUS = - 1) OR
                         (tmpmax.STATUS IS NULL)
GO
/****** Object:  Table [dbo].[CUSTOMER_CONTROL]    Script Date: 27/08/2024 18:14:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CUSTOMER_CONTROL](
	[CustomerControlCode] [int] IDENTITY(1,1) NOT NULL,
	[AplicationCode] [int] NULL,
	[CustomerNo] [int] NOT NULL,
	[STATUS] [int] NOT NULL,
	[DESCRIPTION] [text] NULL,
	[RequestCode] [bigint] NOT NULL,
 CONSTRAINT [PK__CUSTOMER_CONTROL] PRIMARY KEY CLUSTERED 
(
	[CustomerControlCode] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  View [dbo].[VW_CUSTOMER]    Script Date: 27/08/2024 18:14:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[VW_CUSTOMER]
AS
SELECT        C1.CustomerNo, C1.StoreNo, C1.StatusCode, C1.CustomerType, C1.FirstName, C1.LastName, C1.MaidenName, C1.CompanyName, C1.Email, C1.LicenseNumber, C1.Info1, C1.Phone1, A.AplicationCode
FROM            dbo.CUSTOMER AS C1 CROSS JOIN
                         dbo.Aplication AS A LEFT OUTER JOIN
                         dbo.CUSTOMER_CONTROL AS C2 ON C1.CustomerNo = C2.CustomerNo LEFT OUTER JOIN
                             (SELECT        MAX(CustomerControlCode) AS CustomerControlCode, CustomerNo, STATUS, AplicationCode
                               FROM            dbo.CUSTOMER_CONTROL
                               WHERE        (STATUS IN (0, 1))
                               GROUP BY CustomerNo, STATUS, AplicationCode) AS tmpmax ON C2.CustomerNo = tmpmax.CustomerNo AND A.AplicationCode = C2.AplicationCode
WHERE        (tmpmax.STATUS = - 1) OR
                         (tmpmax.STATUS IS NULL)
GO
/****** Object:  Table [dbo].[CUSTOMER_ADDRESS_CONTROL]    Script Date: 27/08/2024 18:14:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CUSTOMER_ADDRESS_CONTROL](
	[CustomerAddressControlCode] [int] IDENTITY(1,1) NOT NULL,
	[AplicationCode] [int] NULL,
	[CustomerNo] [int] NOT NULL,
	[AddressNo] [int] NOT NULL,
	[STATUS] [int] NOT NULL,
	[DESCRIPTION] [text] NULL,
	[RequestCode] [bigint] NOT NULL,
 CONSTRAINT [PK__CUSTOMER_ADDRESS_CONTROL] PRIMARY KEY CLUSTERED 
(
	[CustomerAddressControlCode] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  View [dbo].[VW_CUSTOMER_ADDRESS]    Script Date: 27/08/2024 18:14:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[VW_CUSTOMER_ADDRESS]
AS
SELECT        C1.CustomerNo, C1.AddressNo, C1.Address1, A.AplicationCode
FROM            dbo.CUSTOMER_ADDRESS AS C1 CROSS JOIN
                         dbo.Aplication AS A LEFT OUTER JOIN
                         dbo.CUSTOMER_ADDRESS_CONTROL AS C2 ON C1.CustomerNo = C2.CustomerNo AND C1.AddressNo = C2.AddressNo LEFT OUTER JOIN
                             (SELECT        MAX(CustomerAddressControlCode) AS CustomerAddressControlCode, CustomerNo, AddressNo, STATUS, AplicationCode
                               FROM            dbo.CUSTOMER_ADDRESS_CONTROL
                               WHERE        (STATUS IN (0, 1))
                               GROUP BY CustomerNo, AddressNo, STATUS, AplicationCode) AS tmpmax ON C2.AddressNo = tmpmax.AddressNo AND C2.CustomerNo = tmpmax.CustomerNo AND A.AplicationCode = C2.AplicationCode
WHERE        (tmpmax.STATUS = - 1) OR
                         (tmpmax.STATUS IS NULL)
GO
/****** Object:  Table [dbo].[DEPARTMENT_CONTROL]    Script Date: 27/08/2024 18:14:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DEPARTMENT_CONTROL](
	[DepartamentControlCode] [int] IDENTITY(1,1) NOT NULL,
	[AplicationCode] [int] NULL,
	[DeptCode] [varchar](10) NOT NULL,
	[STATUS] [int] NOT NULL,
	[DESCRIPTION] [text] NULL,
	[RequestCode] [bigint] NOT NULL,
 CONSTRAINT [PK__DEPARTMENT_CONTROL] PRIMARY KEY CLUSTERED 
(
	[DepartamentControlCode] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  View [dbo].[VW_DEPARTMENT]    Script Date: 27/08/2024 18:14:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[VW_DEPARTMENT]
AS
SELECT        C1.DeptCode, C1.DeptName, A.AplicationCode
FROM            dbo.DEPARTMENT AS C1 CROSS JOIN
                         dbo.Aplication AS A LEFT OUTER JOIN
                         dbo.DEPARTMENT_CONTROL AS C2 ON C1.DeptCode = C2.DeptCode LEFT OUTER JOIN
                             (SELECT        MAX(DepartamentControlCode) AS DepartamentControlCode, DeptCode, STATUS, AplicationCode
                               FROM            dbo.DEPARTMENT_CONTROL
                               WHERE        (STATUS IN (0, 1))
                               GROUP BY DeptCode, STATUS, AplicationCode) AS tmpmax ON C2.DeptCode = tmpmax.DeptCode AND A.AplicationCode = C2.AplicationCode
WHERE        (tmpmax.STATUS = - 1) OR
                         (tmpmax.STATUS IS NULL)
GO
/****** Object:  Table [dbo].[PRODUCT_CONTROL]    Script Date: 27/08/2024 18:14:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PRODUCT_CONTROL](
	[ProductControlCode] [int] IDENTITY(1,1) NOT NULL,
	[AplicationCode] [int] NULL,
	[SKU] [int] NOT NULL,
	[STATUS] [int] NOT NULL,
	[DESCRIPTION] [text] NULL,
	[RequestCode] [bigint] NOT NULL,
 CONSTRAINT [PK_PRODUCT_CONTROL] PRIMARY KEY CLUSTERED 
(
	[ProductControlCode] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  View [dbo].[VW_PRODUCT]    Script Date: 27/08/2024 18:14:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[VW_PRODUCT]
AS
SELECT        C1.SKU, C1.StatusCode, C1.ALU, C1.UPC, C1.NonInventory, C1.LastCost, C1.AvgCost, C1.CreationDate, C1.RetailPrice, C1.SKUWeight, A.AplicationCode
FROM            dbo.PRODUCT AS C1 CROSS JOIN
                         dbo.Aplication AS A LEFT OUTER JOIN
                         dbo.PRODUCT_CONTROL AS C2 ON C1.SKU = C2.SKU LEFT OUTER JOIN
                             (SELECT        MAX(ProductControlCode) AS ProductControlCode, SKU, STATUS, AplicationCode
                               FROM            dbo.PRODUCT_CONTROL
                               WHERE        (STATUS IN (0, 1))
                               GROUP BY SKU, STATUS, AplicationCode) AS tmpmax ON C2.SKU = tmpmax.SKU AND A.AplicationCode = C2.AplicationCode
WHERE        (tmpmax.STATUS = - 1) OR
                         (tmpmax.STATUS IS NULL)
GO
/****** Object:  Table [dbo].[PRODUCT_STYLE_CONTROL]    Script Date: 27/08/2024 18:14:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PRODUCT_STYLE_CONTROL](
	[ProductStyleControlCode] [int] IDENTITY(1,1) NOT NULL,
	[AplicationCode] [int] NULL,
	[StyleCode] [int] NOT NULL,
	[STATUS] [int] NOT NULL,
	[DESCRIPTION] [text] NULL,
	[RequestCode] [bigint] NOT NULL,
 CONSTRAINT [PK__PRODUCT_STYLE_CONTROL] PRIMARY KEY CLUSTERED 
(
	[ProductStyleControlCode] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  View [dbo].[VW_PRODUCT_STYLE]    Script Date: 27/08/2024 18:14:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[VW_PRODUCT_STYLE]
AS
SELECT        C1.StyleCode, C1.DeptCode, C1.BrandCode, C1.TypeCode, C1.StyleName, C1.SubClassCode, C1.ClassCode, C1.Desc1, C1.CaseQty, C1.PackQty, C1.Height, C1.Weight, A.AplicationCode
FROM            dbo.PRODUCT_STYLE AS C1 CROSS JOIN
                         dbo.Aplication AS A LEFT OUTER JOIN
                         dbo.PRODUCT_STYLE_CONTROL AS C2 ON C1.StyleCode = C2.StyleCode LEFT OUTER JOIN
                             (SELECT        MAX(ProductStyleControlCode) AS ProductStyleControlCode, StyleCode, STATUS, AplicationCode
                               FROM            dbo.PRODUCT_STYLE_CONTROL
                               WHERE        (STATUS IN (0, 1))
                               GROUP BY StyleCode, STATUS, AplicationCode) AS tmpmax ON C2.StyleCode = tmpmax.StyleCode AND A.AplicationCode = C2.AplicationCode
WHERE        (tmpmax.STATUS = - 1) OR
                         (tmpmax.STATUS IS NULL)
GO
/****** Object:  Table [dbo].[RECEIPT_CONTROL]    Script Date: 27/08/2024 18:14:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RECEIPT_CONTROL](
	[ReceiptControlCode] [int] IDENTITY(1,1) NOT NULL,
	[AplicationCode] [int] NULL,
	[StoreNo] [int] NOT NULL,
	[ReceiptId] [uniqueidentifier] ROWGUIDCOL  NOT NULL,
	[STATUS] [int] NOT NULL,
	[DESCRIPTION] [text] NULL,
	[RequestCode] [bigint] NOT NULL,
 CONSTRAINT [PK__RECEIPT_CONTROL] PRIMARY KEY NONCLUSTERED 
(
	[ReceiptControlCode] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  View [dbo].[VW_RECEIPT]    Script Date: 27/08/2024 18:14:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[VW_RECEIPT]
AS
SELECT        C1.StoreNo, C1.ReceiptId, C1.ReceiptNo, C1.SalesCode, C1.SalesDate, C1.StatusCode, C1.CustomerNo, C1.Flag1, C1.Flag2, C1.NoteField, C1.Cashier, C1.DocNumber, C1.SubTotal, C1.SubTotalWTax, C1.TaxPercent, 
                         C1.TaxTotal, C1.ShippingTotal, C1.PayTotal, C1.ReferenceId, A.AplicationCode
FROM            dbo.RECEIPT AS C1 CROSS JOIN
                         dbo.Aplication AS A LEFT OUTER JOIN
                         dbo.RECEIPT_CONTROL AS C2 ON C1.StoreNo = C2.StoreNo AND C1.ReceiptId = C2.ReceiptId LEFT OUTER JOIN
                             (SELECT        MAX(ReceiptControlCode) AS ReceiptControlCode, StoreNo, ReceiptId, STATUS, AplicationCode
                               FROM            dbo.RECEIPT_CONTROL
                               WHERE        (STATUS IN (0, 1))
                               GROUP BY StoreNo, ReceiptId, STATUS, AplicationCode) AS tmpmax ON C2.StoreNo = tmpmax.StoreNo AND C2.ReceiptId = tmpmax.ReceiptId AND A.AplicationCode = C2.AplicationCode
WHERE        (tmpmax.STATUS = - 1) OR
                         (tmpmax.STATUS IS NULL)
GO
/****** Object:  Table [dbo].[RECEIPT_LINE_CONTROL]    Script Date: 27/08/2024 18:14:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RECEIPT_LINE_CONTROL](
	[ReceiptLineControlCode] [int] IDENTITY(1,1) NOT NULL,
	[AplicationCode] [int] NULL,
	[StoreNo] [int] NOT NULL,
	[ReceiptId] [uniqueidentifier] NOT NULL,
	[LineId] [smallint] NOT NULL,
	[STATUS] [int] NOT NULL,
	[DESCRIPTION] [text] NULL,
	[RequestCode] [bigint] NOT NULL,
 CONSTRAINT [PK__RECEIPT_LINE_CONTROL] PRIMARY KEY NONCLUSTERED 
(
	[ReceiptLineControlCode] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  View [dbo].[VW_RECEIPT_LINE]    Script Date: 27/08/2024 18:14:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[VW_RECEIPT_LINE]
AS
SELECT        C1.StoreNo, C1.ReceiptId, C1.LineId, C1.SKU, C1.Qty, C1.ExtRetailPrice, C1.ExtCost, C1.AvgCost, C1.TaxAmount, C1.TaxPercent, C1.DiscAmount, C1.DiscPercent, C1.LineDescription, C1.RetailPriceWTax, C1.GlobalDiscPercent, 
                         C1.DummyItemType, C1.PromoId, A.AplicationCode
FROM            dbo.RECEIPT_LINE AS C1 CROSS JOIN
                         dbo.Aplication AS A LEFT OUTER JOIN
                         dbo.RECEIPT_LINE_CONTROL AS C2 ON C1.StoreNo = C2.StoreNo AND C1.ReceiptId = C2.ReceiptId AND C1.LineId = C2.LineId LEFT OUTER JOIN
                             (SELECT        MAX(ReceiptLineControlCode) AS ReceiptLineControlCode, StoreNo, ReceiptId, LineId, STATUS, AplicationCode
                               FROM            dbo.RECEIPT_LINE_CONTROL
                               WHERE        (STATUS IN (0, 1))
                               GROUP BY StoreNo, ReceiptId, LineId, STATUS, AplicationCode) AS tmpmax ON C2.StoreNo = tmpmax.StoreNo AND C2.ReceiptId = tmpmax.ReceiptId AND C2.LineId = tmpmax.LineId AND 
                         A.AplicationCode = C2.AplicationCode
WHERE        (tmpmax.STATUS = - 1) OR
                         (tmpmax.STATUS IS NULL)
GO
/****** Object:  Table [dbo].[RECEIPT_TENDER_CONTROL]    Script Date: 27/08/2024 18:14:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RECEIPT_TENDER_CONTROL](
	[ReceiptTenderControlCode] [int] IDENTITY(1,1) NOT NULL,
	[AplicationCode] [int] NULL,
	[StoreNo] [int] NOT NULL,
	[ReceiptId] [uniqueidentifier] NOT NULL,
	[LineId] [int] NOT NULL,
	[STATUS] [int] NOT NULL,
	[DESCRIPTION] [text] NULL,
	[RequestCode] [bigint] NOT NULL,
 CONSTRAINT [PK__RECEIPT_TENDER_CONTROL] PRIMARY KEY CLUSTERED 
(
	[ReceiptTenderControlCode] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  View [dbo].[VW_RECEIPT_TENDER]    Script Date: 27/08/2024 18:14:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[VW_RECEIPT_TENDER]
AS
SELECT        C1.StoreNo, C1.ReceiptId, C1.LineId, C1.CurrencyId, C1.TenderId, C1.TakeAmount, C1.GiveAmount, A.AplicationCode
FROM            dbo.RECEIPT_TENDER AS C1 CROSS JOIN
                         dbo.Aplication AS A LEFT OUTER JOIN
                         dbo.RECEIPT_TENDER_CONTROL AS C2 ON C1.StoreNo = C2.StoreNo AND C1.ReceiptId = C2.ReceiptId AND C1.LineId = C2.LineId LEFT OUTER JOIN
                             (SELECT        MAX(ReceiptTenderControlCode) AS ReceiptTenderControlCode, StoreNo, ReceiptId, LineId, STATUS, AplicationCode
                               FROM            dbo.RECEIPT_TENDER_CONTROL
                               WHERE        (STATUS IN (0, 1))
                               GROUP BY StoreNo, ReceiptId, LineId, STATUS, AplicationCode) AS tmpmax ON C2.StoreNo = tmpmax.StoreNo AND C2.ReceiptId = tmpmax.ReceiptId AND C2.LineId = tmpmax.LineId AND 
                         A.AplicationCode = C2.AplicationCode
WHERE        (tmpmax.STATUS = - 1) OR
                         (tmpmax.STATUS IS NULL)
GO
/****** Object:  Table [dbo].[STORE_CONTROL]    Script Date: 27/08/2024 18:14:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[STORE_CONTROL](
	[StoreControlCode] [int] IDENTITY(1,1) NOT NULL,
	[AplicationCode] [int] NULL,
	[StoreNo] [int] NOT NULL,
	[STATUS] [int] NOT NULL,
	[DESCRIPTION] [text] NULL,
	[RequestCode] [bigint] NOT NULL,
 CONSTRAINT [PK__STORE_CONTROL] PRIMARY KEY CLUSTERED 
(
	[StoreControlCode] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  View [dbo].[VW_STORE]    Script Date: 27/08/2024 18:14:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[VW_STORE]
AS
SELECT        C1.StoreNo, C1.StoreName, C1.Address1, C1.ZipCode, C1.Phone2, C1.OpenDate, C1.CloseDate, C1.Info5, C1.Info10, C1.SqFt, A.AplicationCode
FROM            dbo.STORE AS C1 CROSS JOIN
                         dbo.Aplication AS A LEFT OUTER JOIN
                         dbo.STORE_CONTROL AS C2 ON C1.StoreNo = C2.StoreNo LEFT OUTER JOIN
                             (SELECT        MAX(StoreControlCode) AS STOREControlCode, StoreNo, STATUS, AplicationCode
                               FROM            dbo.STORE_CONTROL
                               WHERE        (STATUS IN (0, 1))
                               GROUP BY StoreNo, STATUS, AplicationCode) AS tmpmax ON C2.StoreNo = tmpmax.StoreNo AND A.AplicationCode = C2.AplicationCode
WHERE        (tmpmax.STATUS = - 1) OR
                         (tmpmax.STATUS IS NULL)
GO
/****** Object:  Table [dbo].[STORE_REGION_CONTROL]    Script Date: 27/08/2024 18:14:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[STORE_REGION_CONTROL](
	[StoreRegionControlCode] [int] IDENTITY(1,1) NOT NULL,
	[AplicationCode] [int] NULL,
	[RegionCode] [varchar](10) NOT NULL,
	[STATUS] [int] NOT NULL,
	[DESCRIPTION] [text] NULL,
	[RequestCode] [bigint] NOT NULL,
 CONSTRAINT [PK_STORE_REGION_CONTROL] PRIMARY KEY CLUSTERED 
(
	[StoreRegionControlCode] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  View [dbo].[VW_STORE_REGION]    Script Date: 27/08/2024 18:14:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[VW_STORE_REGION]
AS
SELECT        C1.RegionCode, C1.RegionName, A.AplicationCode
FROM            dbo.STORE_REGION AS C1 CROSS JOIN
                         dbo.Aplication AS A LEFT OUTER JOIN
                         dbo.STORE_REGION_CONTROL AS C2 ON C1.RegionCode = C2.RegionCode LEFT OUTER JOIN
                             (SELECT        MAX(StoreRegionControlCode) AS StoreRegionControlCode, RegionCode, STATUS, AplicationCode
                               FROM            dbo.STORE_REGION_CONTROL
                               WHERE        (STATUS IN (0, 1))
                               GROUP BY RegionCode, STATUS, AplicationCode) AS tmpmax ON C2.RegionCode = tmpmax.RegionCode AND A.AplicationCode = C2.AplicationCode
WHERE        (tmpmax.STATUS = - 1) OR
                         (tmpmax.STATUS IS NULL)
GO
/****** Object:  Table [dbo].[SUBCLASS_CONTROL]    Script Date: 27/08/2024 18:14:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SUBCLASS_CONTROL](
	[SubClassControlCode] [int] IDENTITY(1,1) NOT NULL,
	[AplicationCode] [int] NULL,
	[SubClassCode] [varchar](10) NOT NULL,
	[ClassCode] [varchar](10) NOT NULL,
	[DeptCode] [varchar](10) NOT NULL,
	[STATUS] [int] NOT NULL,
	[DESCRIPTION] [text] NULL,
	[RequestCode] [bigint] NOT NULL,
 CONSTRAINT [PK__SUBCLASS_CONTROL] PRIMARY KEY CLUSTERED 
(
	[SubClassControlCode] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  View [dbo].[VW_SUBCLASS]    Script Date: 27/08/2024 18:14:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[VW_SUBCLASS]
AS
SELECT        C1.SubClassCode, C1.ClassCode, C1.DeptCode, C1.SubClassName, A.AplicationCode
FROM            dbo.SUBCLASS AS C1 CROSS JOIN
                         dbo.Aplication AS A LEFT OUTER JOIN
                         dbo.SUBCLASS_CONTROL AS C2 ON C1.SubClassCode = C2.SubClassCode AND C1.ClassCode = C2.ClassCode AND C1.DeptCode = C2.DeptCode LEFT OUTER JOIN
                             (SELECT        MAX(SubClassControlCode) AS SubClassControlCode, SubClassCode, ClassCode, DeptCode, STATUS, AplicationCode
                               FROM            dbo.SUBCLASS_CONTROL
                               WHERE        (STATUS IN (0, 1))
                               GROUP BY SubClassCode, ClassCode, DeptCode, STATUS, AplicationCode) AS tmpmax ON C2.SubClassCode = tmpmax.SubClassCode AND C2.ClassCode = tmpmax.ClassCode AND C2.DeptCode = tmpmax.DeptCode AND 
                         A.AplicationCode = C2.AplicationCode
WHERE        (tmpmax.STATUS = - 1) OR
                         (tmpmax.STATUS IS NULL)
GO
/****** Object:  Table [dbo].[MASTER_TABLE]    Script Date: 27/08/2024 18:14:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MASTER_TABLE](
	[masterCode] [int] IDENTITY(1,1) NOT NULL,
	[tableName] [varchar](100) NOT NULL,
	[status] [int] NOT NULL,
	[createdDate] [datetime] NULL,
 CONSTRAINT [MASTER_CONTROL_PK] PRIMARY KEY CLUSTERED 
(
	[masterCode] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[REQUEST]    Script Date: 27/08/2024 18:14:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[REQUEST](
	[RequestCode] [bigint] IDENTITY(1,1) NOT NULL,
	[Status] [int] NULL,
	[InitDate] [datetime] NULL,
	[EndDate] [datetime] NULL,
	[TotalRecords] [int] NULL,
	[userAplication] [varchar](50) NULL,
	[userName] [varchar](50) NULL,
	[responseTables] [nvarchar](max) NULL,
 CONSTRAINT [PK_REQUEST] PRIMARY KEY CLUSTERED 
(
	[RequestCode] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[REQUEST_DETAIL]    Script Date: 27/08/2024 18:14:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[REQUEST_DETAIL](
	[RequesDetailCode] [bigint] IDENTITY(1,1) NOT NULL,
	[RquestCode] [bigint] NULL,
	[Ip] [varchar](50) NULL,
	[UserAplication] [varchar](50) NULL,
	[Username] [varchar](50) NULL,
	[Method] [varchar](50) NULL,
	[Parameters] [nvarchar](max) NULL,
	[selects] [nvarchar](max) NULL,
	[front] [nvarchar](max) NULL,
	[status] [int] NULL,
	[RegDate] [datetime] NULL,
 CONSTRAINT [PK_REQUEST_DETAIL] PRIMARY KEY CLUSTERED 
(
	[RequesDetailCode] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[Aplication] ADD  DEFAULT (getdate()) FOR [RegisterDate]
GO
ALTER TABLE [dbo].[MASTER_TABLE] ADD  CONSTRAINT [DF__MASTER_CO__creat__5BE2A6F2]  DEFAULT (getdate()) FOR [createdDate]
GO
/****** Object:  StoredProcedure [dbo].[sp_send_data_json]    Script Date: 27/08/2024 18:14:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_send_data_json]
(
	@p_vJson		varchar(max)='{}',
	@p_appuser varchar(max)
)
AS BEGIN
	BEGIN TRY 

	DECLARE @pi_method varchar(100) ='';
	DECLARE @pi_userName varchar(50) ='';
	DECLARE @pi_parameters nvarchar(max) ='';
	DECLARE @pi_requestId int =0;
	DECLARE @p_AplicationCode int =(select top 1 [AplicationCode] from [dbo].[Aplication] where [UserAplication]=@p_appuser);
	DECLARE @index INT = 0;
	DECLARE @totalCount INT = 0;
	DECLARE @p_starDate datetime=getdate();

	select 
	@pi_method=method,
	@pi_userName=userName,
	@pi_requestId=requestId,
	@pi_parameters=parameters
	FROM OPENJSON(@p_vJson) WITH
	(
		method 			varchar(100),
		userName			varchar(50),
		requestId			int,
		parameters			nvarchar(max) '$.parameters' AS JSON
	);

	if(@pi_method='set_list')
	begin
		DECLARE @tableName NVARCHAR(100)='';
		DECLARE @selectColumns NVARCHAR(MAX)='';
		DECLARE @joinConditions NVARCHAR(MAX)='';
		DECLARE @sigla NVARCHAR(5)='';
		DECLARE @control int=0;

		DECLARE @selectQuery NVARCHAR(MAX)='';

		DECLARE @tableQuery NVARCHAR(MAX)='';

		DECLARE @selectFinal NVARCHAR(MAX)='';
		
		INSERT INTO [dbo].[REQUEST]
				(
				[Status]
			   ,[InitDate]
			   ,[userAplication]
			   ,[userName])
		 VALUES(
			   0
			   ,getdate()
			   ,@p_appuser
			   ,@pi_userName)
		SET @pi_requestId = SCOPE_IDENTITY();

		 SELECT id,tableName,selects,orders,joins,'T'+cast(orders as varchar) sigla
		INTO #jsonData
		FROM OPENJSON(@pi_parameters)WITH
	(
		id 					varchar(50),		
		tableName 			varchar(50),
		selects 			nvarchar(max) '$.selects' AS JSON,
		orders				int,
		joins 				nvarchar(max) '$.joins' AS JSON
	);

		set @index  =  (SELECT min(orders) FROM #jsonData);
		set @totalCount  = (SELECT max(orders) FROM #jsonData);

		WHILE @index <= @totalCount
			BEGIN
				SELECT @tableName='VW_'+tableName,@selectColumns=selects,@joinConditions=joins,@sigla=sigla from  #jsonData where orders=@index

				 set @selectQuery =@selectQuery+','+ STUFF((
					SELECT ',' + @sigla+'.'+value
					FROM OPENJSON(@selectColumns)
					FOR XML PATH(''), TYPE
				).value('.', 'NVARCHAR(MAX)'), 1, 1, '') ;

				if(@control=0)
				begin
					set @tableQuery=' from '+@tableName+' '+@sigla
					set @control=1;
				end
				else
				begin
					set @tableQuery=@tableQuery+' inner join '+@tableName+' '+@sigla+' on '+
						STUFF((
						SELECT 
							' and ' + CONCAT(
								@sigla,'.',JSON_VALUE(value, '$.parameter'), ' = ',(select sigla from #jsonData where tableName=JSON_VALUE(value, '$.target.tableName')),'.',JSON_VALUE(value, '$.target.parameter')
							)
						FROM OPENJSON(@joinConditions)
						FOR XML PATH (''), TYPE
					).value('.', 'NVARCHAR(MAX)'), 1, 4, '')+' and '+@sigla+'.AplicationCode='+CAST(@p_AplicationCode AS VARCHAR);

				end
				SET @index = @index + 1;
			
			END;
		 set @selectQuery=SUBSTRING(@selectQuery, 2, LEN(@selectQuery));
		set @selectFinal='select '+@selectQuery+@tableQuery+' where T1.AplicationCode='+CAST(@p_AplicationCode AS VARCHAR)

		DECLARE @jsonResult NVARCHAR(MAX);
		DECLARE @totalResult NVARCHAR(MAX);
			-- Step 2: Prepare the dynamic SQL statement
			DECLARE @sql NVARCHAR(MAX);
			SET @sql = N'SELECT @result = ('+@selectFinal+'  FOR JSON PATH )';
			EXEC sp_executesql @sql, N'@result NVARCHAR(MAX) OUTPUT', @result=@jsonResult OUTPUT;
			
			SET @sql = N'SELECT @total = ( select count(*) '+@tableQuery+' )';
			EXEC sp_executesql @sql, N'@total NVARCHAR(MAX) OUTPUT',  @total=@totalResult OUTPUT;



		 

			update [dbo].[REQUEST] set [EndDate]=getdate(),TotalRecords=@totalResult,[responseTables]=(STUFF((
					SELECT ',' + tableName
					FROM #jsonData
					FOR XML PATH(''), TYPE
				).value('.', 'NVARCHAR(MAX)'), 1, 1, '') )
			where [RequestCode]=@pi_requestId;
	

			INSERT INTO [dbo].[REQUEST_DETAIL]
           ([RquestCode]
           ,[Ip]
           ,[UserAplication]
           ,[Username]
           ,[Method]
           ,[Parameters]
           ,[selects]
           ,[front]
           ,[status]
           ,[RegDate])
		   values (@pi_requestId,'',@p_appuser,@pi_userName,@pi_method,@p_vJson,@selectQuery,@tableQuery,1,getdate());
		

		IF @totalResult>0
			BEGIN
			set @index  =  (SELECT min(orders) FROM #jsonData);

			DECLARE @controlTable  NVARCHAR(MAX)='';
			WHILE @index <= @totalCount
				BEGIN
					SELECT @tableName=tableName,@sigla=sigla from  #jsonData where orders=@index
					
					if (select count(*) from MASTER_TABLE where tableName = @tableName and status = 1) = 0
						begin
							set @controlTable ='insert into '+@tableName+'_CONTROL select distinct '+CAST(@p_AplicationCode AS VARCHAR)+','+(STUFF((
								SELECT ',' , @sigla+'.'+ku.column_name
								FROM QAGlamBrands_Repl.INFORMATION_SCHEMA.TABLE_CONSTRAINTS AS TC
								INNER JOIN QAGlamBrands_Repl.INFORMATION_SCHEMA.KEY_COLUMN_USAGE AS KU
								ON TC.CONSTRAINT_TYPE = 'PRIMARY KEY' AND TC.CONSTRAINT_NAME = KU.CONSTRAINT_NAME
								where ku.TABLE_NAME= @tableName
								FOR XML PATH(''), TYPE
							).value('.', 'NVARCHAR(MAX)'), 1, 1, '') )+ ',0,'''','+CAST(@pi_requestId AS VARCHAR)+' '++@tableQuery+' WHERE '+@sigla+'.AplicationCode='+CAST(@p_AplicationCode AS VARCHAR) ;
							
							EXEC sp_executesql @controlTable
							--select @controlTable
						end
					SET @index = @index + 1;
			
				END;
			END;


			select @pi_requestId 'requestId',@p_starDate 'start',getdate() 'end',1 'status',@totalResult 'totalRecords','Request completed successfully set list' 'message',@jsonResult 'data' into #resul

			select json_query((select * from #resul FOR JSON AUTO), '$[0]') as json

	end;
	else if(@pi_method='set_valid')
	begin
		DECLARE @validTableName NVARCHAR(100)='';
		DECLARE @validIds NVARCHAR(MAX)='';
		DECLARE @validMsg NVARCHAR(MAX)='';

		DECLARE @validUpdate NVARCHAR(MAX)='';

		SELECT  ROW_NUMBER() OVER(ORDER BY ids ASC) id,ids,tableName,msg
		INTO #jsonDelete
		FROM OPENJSON(@pi_parameters)WITH
		(
			tableName 			varchar(100),		
			ids 			    nvarchar(max) '$.ids' AS JSON,
			msg 				nvarchar(max)
		);



		SELECT ROW_NUMBER() OVER(ORDER BY value ASC) id,value tablename into #tableControl
		FROM STRING_SPLIT((select responseTables from REQUEST where RequestCode=@pi_requestId), ',') tab
		left join [MASTER_TABLE] con on tab.value=con.tableName where con.masterCode is null

		set @index  =  (SELECT min(id) FROM #tableControl);
		set @totalCount  = (SELECT max(id) FROM #tableControl);
		WHILE @index <= @totalCount
			BEGIN
				select @validTableName=tablename from #tableControl where id=@index
				
				SET @validUpdate='UPDATE '+@validTableName+'_CONTROL SET [STATUS]=1 WHERE [RequestCode]='+CAST(@pi_requestId AS VARCHAR); 
				EXEC sp_executesql @validUpdate
				
				SET @index = @index + 1;			
			END;

		set @index  =  (SELECT min(id) FROM #jsonDelete);
		set @totalCount  = (SELECT max(id) FROM #jsonDelete);
		WHILE @index <= @totalCount
			BEGIN
				select @validTableName=tableName,@validIds=ids,@validMsg=msg from #jsonDelete where id=@index
				
				set @validUpdate='UPDATE '+@validTableName+'_CONTROL SET STATUS=-1,DESCRIPTION='''+@validMsg+''' WHERE '
				
				SELECT  @validUpdate=@validUpdate+QUOTENAME(param) + N' = ''' + value + N''' AND '
					FROM OPENJSON(@validIds)
					WITH (
						param NVARCHAR(50),
						value NVARCHAR(50)
					);

				SET @validUpdate = LEFT(@validUpdate, LEN(@validUpdate) - 4);
			
			   EXEC sp_executesql @validUpdate
				SET @index = @index + 1;			
			END;
		
			INSERT INTO [dbo].[REQUEST_DETAIL]
           ([RquestCode]
           ,[Ip]
           ,[UserAplication]
           ,[Username]
           ,[Method]
           ,[Parameters]           
           ,[status]
           ,[RegDate])
		   values (@pi_requestId,'',@p_appuser,@pi_userName,@pi_method,@p_vJson,1,getdate());

		
			select @pi_requestId 'requestId',@p_starDate 'start',getdate() 'end',1 'status',@totalResult 'totalRecords','Request completed successfully set valid' 'message' into #resul2
		
			
			select json_query((select * from #resul2 FOR JSON AUTO), '$[0]') as json
	end;

	END TRY 
	BEGIN CATCH 
			select -1 as codigo,ERROR_MESSAGE() as msg into #error
			select json_query((select * from #error FOR JSON AUTO), '$[0]') as json
	END CATCH 	
END
GO
/****** Object:  StoredProcedure [dbo].[sp_validate_username]    Script Date: 27/08/2024 18:14:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_validate_username]
    @username VARCHAR(50)
AS
BEGIN
    select * from Aplication where UserAplication = @username;  
END;
GO
GO
