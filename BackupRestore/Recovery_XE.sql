use AdventureWorks2016
go

create table t12345
(c1 int identity not null primary key nonclustered,
c2 nvarchar(4000))
go
--change the growth size for log file to 1MB
--insert several rows to trigger auto-grow of log and multiple vlfs
insert t12345 values (REPLICATE(N'a', 4000))
go 40000
 
CREATE
EVENT
SESSION [recovery_trace] ON
SERVER

ADD
EVENT sqlserver.database_recovery_progress_report(SET collect_database_name=(1)),
ADD
EVENT sqlserver.database_recovery_times,
ADD
EVENT sqlserver.database_recovery_trace
ADD
TARGET package0.event_file(SET
filename=N'recovery_trace')
WITH (MAX_MEMORY=4096 KB,EVENT_RETENTION_MODE=ALLOW_SINGLE_EVENT_LOSS,MAX_DISPATCH_LATENCY=3 SECONDS,MAX_EVENT_SIZE=0 KB,MEMORY_PARTITION_MODE=NONE,TRACK_CAUSALITY=OFF,STARTUP_STATE=ON)
GO
