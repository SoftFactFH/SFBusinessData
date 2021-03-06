USE [master]
GO
/****** Objekt:  Database [bdsdemo]    Skriptdatum: 03/30/2018 02:43:17 ******/
CREATE DATABASE [bdsdemo] ON  PRIMARY 
( NAME = N'bdsdemo', FILENAME = N'c:\Program Files (x86)\Microsoft SQL Server\MSSQL.1\MSSQL\DATA\bdsdemo.mdf' , SIZE = 3072KB , MAXSIZE = UNLIMITED, FILEGROWTH = 1024KB )
 LOG ON 
( NAME = N'bdsdemo_log', FILENAME = N'c:\Program Files (x86)\Microsoft SQL Server\MSSQL.1\MSSQL\DATA\bdsdemo_log.ldf' , SIZE = 1024KB , MAXSIZE = 2048GB , FILEGROWTH = 10%)
GO
EXEC dbo.sp_dbcmptlevel @dbname=N'bdsdemo', @new_cmptlevel=90
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [bdsdemo].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [bdsdemo] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [bdsdemo] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [bdsdemo] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [bdsdemo] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [bdsdemo] SET ARITHABORT OFF 
GO
ALTER DATABASE [bdsdemo] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [bdsdemo] SET AUTO_CREATE_STATISTICS ON 
GO
ALTER DATABASE [bdsdemo] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [bdsdemo] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [bdsdemo] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [bdsdemo] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [bdsdemo] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [bdsdemo] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [bdsdemo] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [bdsdemo] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [bdsdemo] SET  ENABLE_BROKER 
GO
ALTER DATABASE [bdsdemo] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [bdsdemo] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [bdsdemo] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [bdsdemo] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [bdsdemo] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [bdsdemo] SET  READ_WRITE 
GO
ALTER DATABASE [bdsdemo] SET RECOVERY SIMPLE 
GO
ALTER DATABASE [bdsdemo] SET  MULTI_USER 
GO
ALTER DATABASE [bdsdemo] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [bdsdemo] SET DB_CHAINING OFF
GO
USE [bdsdemo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[bdsarticle](
	[bdsarticleid] [int] IDENTITY(1,1) NOT NULL,
	[bdsarticledesc] [varchar](50) NOT NULL,
	[bdsarticleprice] [decimal](8, 2) NOT NULL,
 CONSTRAINT [PK_bdsarticle] PRIMARY KEY CLUSTERED 
(
	[bdsarticleid] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
CREATE TABLE [dbo].[bdscstmr](
	[bdscstmrid] [int] IDENTITY(1,1) NOT NULL,
	[bdscstmrname] [varchar](80) NOT NULL,
	[bdscstmrfirstname] [varchar](80) NULL,
	[bdscstmrdateofbirth] [datetime] NULL,
	[bdscstmrpostcode] [varchar](5) NULL,
	[bdscstmrcity] [varchar](50) NULL,
	[bdscstmrstreet] [varchar](50) NULL,
	[bdscstmrtypeid] [int] NULL,
	[bdscstmrnotice] [text] NULL,
	[bdscstmrimage] [image] NULL,
	[bdscstmrimageext] [varchar](10) NULL,
 CONSTRAINT [PK_bdscstmr] PRIMARY KEY CLUSTERED 
(
	[bdscstmrid] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
CREATE TABLE [dbo].[bdscstmrorder](
	[bdscstmrorderid] [int] IDENTITY(1,1) NOT NULL,
	[bdscstmrordercstmrid] [int] NOT NULL,
	[bdscstmrorderdate] [datetime] NOT NULL,
 CONSTRAINT [PK_bdscstmrorder] PRIMARY KEY CLUSTERED 
(
	[bdscstmrorderid] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
CREATE TABLE [dbo].[bdscstmrorderpos](
	[bdscstmrorderposid] [int] IDENTITY(1,1) NOT NULL,
	[bdscstmrorderposorderid] [int] NOT NULL,
	[bdscstmrorderposquantity] [int] NOT NULL,
	[bdscstmrorderposartid] [int] NOT NULL,
 CONSTRAINT [PK_bdscstmrorderpos] PRIMARY KEY CLUSTERED 
(
	[bdscstmrorderposid] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
CREATE TABLE [dbo].[bdscstmrtype](
	[bdscstmrtypeid] [int] NOT NULL,
	[bdscstmrtypedesc] [varchar](30) NOT NULL,
 CONSTRAINT [PK_bdscstmrtype] PRIMARY KEY CLUSTERED 
(
	[bdscstmrtypeid] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF 

INSERT INTO [bdsdemo].[dbo].[bdscstmrtype]
           ([bdscstmrtypeid]
           ,[bdscstmrtypedesc])
     VALUES
           (1
           ,'Supplier');
INSERT INTO [bdsdemo].[dbo].[bdscstmrtype]
           ([bdscstmrtypeid]
           ,[bdscstmrtypedesc])
     VALUES
           (2
           ,'Customer');