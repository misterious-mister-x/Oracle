COLUMN path FORMAT a40
COLUMN name FORMAT a15
COLUMN "Disk Name" FORMAT a20
COLUMN failgroup FORMAT a15

SELECT    group_number, disk_number, failgroup,name "Disk Name", mount_status, path
FROM      v$asm_disk
ORDER BY  failgroup, name, path;

SELECT    dg.name "Disk Group Name",
          TO_CHAR(NVL(dg.total_mb,0)) "Total MB",
          TO_CHAR(NVL(dg.free_mb, 0)) "Free MB",
          type "Type",
          TO_CHAR(NVL(dg.usable_file_mb, 0)) "Usable Free MB",
          TO_CHAR(NVL(dg.required_mirror_free_mb, 0)) "ReqMirrorFree",
          DECODE(type, 'EXTERN', 1, 'NORMAL', 2, 'HIGH', 3, 1) redundancy_factor, 100 - (dg.free_mb/dg.total_mb*100) "percentUsed"
FROM      v$asm_diskgroup_stat dg
WHERE     state = 'MOUNTED';
