USE [TaskManager]
GO
/****** Object:  StoredProcedure [dbo].[GET_DASHBOARD_COUNT]    Script Date: 9/8/2019 2:44:20 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[GET_DASHBOARD_COUNT]
	-- Add the parameters for the stored procedure here
	@EMP_ID int,
	@ROLE varchar(10)
AS
BEGIN
declare @TODAY_OD_TASK int
declare @TOTAL_TASK int
declare @TOTAL_OPEN_TASK int
declare @NOT_STARTED int
declare @IN_PROGRESS int
declare @WAITING_FOR_INPUT int
declare @COMPLETED int
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	if @ROLE = 'emp'
	begin
		set @TODAY_OD_TASK = (select count(*) as Total from TASK_MASTER where ASSIGN_TO=@EMP_ID and convert(date,due_date)<convert(date,getdate()) and IS_CLOSED='0')
		set @TOTAL_TASK = (select count(*) as Total from TASK_MASTER where ASSIGN_TO=@EMP_ID)
		set @TOTAL_OPEN_TASK = (select count(*) as Total from TASK_MASTER where ASSIGN_TO=@EMP_ID and IS_CLOSED='0')
		set @NOT_STARTED = (select count(*) as Total from TASK_MASTER where ASSIGN_TO=@EMP_ID and STATUS='Not Started')
		set @IN_PROGRESS = (select count(*) as Total from TASK_MASTER where ASSIGN_TO=@EMP_ID and STATUS='In Progress')
		set @WAITING_FOR_INPUT = (select count(*) as Total from TASK_MASTER where ASSIGN_TO=@EMP_ID and STATUS='Waiting for input')
		set @COMPLETED = (select count(*) as Total from TASK_MASTER where ASSIGN_TO=@EMP_ID and STATUS='Completed')
	end
	else
	begin
		set @TODAY_OD_TASK = (select count(*) as Total from TASK_MASTER where TASK_OWNER!=ASSIGN_TO AND convert(date,due_date)<convert(date,getdate()) and IS_CLOSED='0')
		set @TOTAL_TASK = (select count(*) as Total from TASK_MASTER WHERE TASK_OWNER!=ASSIGN_TO )
		set @TOTAL_OPEN_TASK = (select count(*) as Total from TASK_MASTER where TASK_OWNER!=ASSIGN_TO AND IS_CLOSED='0')
		set @NOT_STARTED = (select count(*) as Total from TASK_MASTER where TASK_OWNER!=ASSIGN_TO AND STATUS='Not Started')
		set @IN_PROGRESS = (select count(*) as Total from TASK_MASTER where TASK_OWNER!=ASSIGN_TO AND STATUS='In Progress')
		set @WAITING_FOR_INPUT = (select count(*) as Total from TASK_MASTER where TASK_OWNER!=ASSIGN_TO AND STATUS='Waiting for input')
		set @COMPLETED = (select count(*) as Total from TASK_MASTER where TASK_OWNER!=ASSIGN_TO AND STATUS='Completed')
	end
select @TODAY_OD_TASK as TODAY_OVERDUE_TASK,
		@TOTAL_TASK as TOTAL_TASK,
		@TOTAL_OPEN_TASK as TOTAL_OPEN_TASK,
		@NOT_STARTED as NOT_STARTED,
		@IN_PROGRESS as IN_PROGRESS,
		@WAITING_FOR_INPUT as WAITING_FOR_INPUT,
		@COMPLETED as COMPLETED

END
