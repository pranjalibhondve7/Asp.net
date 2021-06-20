

CREATE TABLE [dbo].[OrderMst](
	[OID] [int] IDENTITY(1,1) NOT NULL,
	[Email] [nvarchar](50) NULL,
	[PName] [nvarchar](50) NULL,
	[Price] [float] NULL,
	[Qnt] [int] NULL,
	[TotalPrice] [float] NULL,
	[Image] [nvarchar](500) NULL,
	[Status] [int] NULL,
	[Edate] [datetime] NULL,
 CONSTRAINT [PK_OrderMst] PRIMARY KEY CLUSTERED 
(
	[OID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) 