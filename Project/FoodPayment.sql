CREATE TABLE [dbo].[PaymentMst](
	[PID] [int] IDENTITY(1,1) NOT NULL,
	[Email] [nvarchar](50) NULL,
	[Type] [nvarchar](50) NULL,
	[BankName] [nvarchar](50) NULL,
	[CardNo] [nvarchar](50) NULL,
	[CCV] [int] NULL,
	[Amount] [float] NULL,
	[Edate] [datetime] NULL,
 CONSTRAINT [PK_PaymentMst] PRIMARY KEY CLUSTERED 
(
	[PID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
)