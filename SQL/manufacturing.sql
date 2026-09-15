create database manufacturing_db;
use manufacturing_db;
select database();
select 'plants' as table_name, count(*) as row_count from plants
union all
select 'production_lines', count(*) from production_lines
union all
select 'products', count(*) from products
union all
select 'shifts', count(*) from shifts
union all
select 'production_records', count(*) from production_records
union all
select 'downtime_records', count(*) from downtime_records
union all
select 'defect_records', count(*) from defect_records
union all
select 'maintenance_records', count(*) from maintenance_records;

select
    count(*) as total_records,
    count(distinct production_id) as unique_production_ids
from production_records;

select
    count(*) as total_records,
    count(distinct production_id) as production_ids
from downtime_records;

select
    count(*) as total_records,
    count(distinct production_id) as production_ids
from defect_records;

select
    count(*) as total_records,
    count(distinct line_id) as total_lines,
    count(distinct plant_id) as total_plants
from maintenance_records;

## insight 1: How much production was planned vs actually produced across the entire manufacturing operation?
select
    sum(planned_quantity) as total_planned,
    sum(actual_quantity) as total_actual,
    sum(scrap_quantity) as total_scrap
from production_records;

## insight 2:  Overall production achievement
select round(sum(actual_quantity) / sum(planned_quantity) * 100, 2) as production_achievement from production_records;

## insight 3: What percentage of actual production ended up as scrap?
select round(sum(scrap_quantity) / sum(actual_quantity) * 100, 2) as scrap_rate from production_records;

## insight 4: Which plant is performing best and which plant is struggling?
select plant_id, sum(planned_quantity) as total_planned, sum(actual_quantity) as total_actual, 
round(sum(actual_quantity) / sum(planned_quantity) * 100, 2) as achievement_rate, sum(scrap_quantity) as total_scrap
from production_records
group by plant_id
order by achievement_rate desc;

## insight 5: Which production lines are driving this?
select
    line_id,
    sum(planned_quantity) as total_planned,
    sum(actual_quantity) as total_actual,
    round(sum(actual_quantity) / sum(planned_quantity) * 100, 2) as achievement_rate,
    sum(scrap_quantity) as total_scrap
from production_records
group by line_id
order by achievement_rate asc;

## Which plant does each production line belong to, and how does each line perform within its plant?
select
    p.plant_name,
    pl.line_id,
    round(sum(pr.actual_quantity) / sum(pr.planned_quantity) * 100, 2) as achievement_rate,
    sum(pr.scrap_quantity) as total_scrap
from production_records pr
join production_lines pl
    on pr.line_id = pl.line_id
join plants p
    on pl.plant_id = p.plant_id
group by p.plant_name, pl.line_id
order by achievement_rate asc;

## How much downtime is each plant experiencing?
with plant_downtime as (
    select
        pl.plant_id,
        sum(dr.downtime_minutes) as total_downtime_minutes,
        count(*) as downtime_events
    from downtime_records dr
    join production_records pr
        on dr.production_id = pr.production_id
    join production_lines pl
        on pr.line_id = pl.line_id
    group by pl.plant_id
)
select
    p.plant_name,
    pd.total_downtime_minutes,
    pd.downtime_events
from plant_downtime pd
join plants p
    on pd.plant_id = p.plant_id
order by pd.total_downtime_minutes desc;

## Downtime reasons by Plant
select
    p.plant_name,
    dr.downtime_reason,
    count(*) as downtime_events,
    sum(dr.downtime_minutes) as total_downtime_minutes
from downtime_records dr
join production_records pr
    on dr.production_id = pr.production_id
join production_lines pl
    on pr.line_id = pl.line_id
join plants p
    on pl.plant_id = p.plant_id
group by
    p.plant_name,
    dr.downtime_reason
order by
    p.plant_name,
    total_downtime_minutes desc;
    
## Which Plant 02 production line has the highest machine-breakdown downtime?
select
    pl.line_id,
    sum(dr.downtime_minutes) as machine_breakdown_minutes,
    count(*) as breakdown_events
from downtime_records dr
join production_records pr
    on dr.production_id = pr.production_id
join production_lines pl
    on pr.line_id = pl.line_id
where pl.plant_id = 'P02'
  and dr.downtime_reason = 'Machine Breakdown'
group by pl.line_id
order by machine_breakdown_minutes desc;

## combine performance + downtime
with line_performance as (
    select
        pl.line_id,
        sum(pr.planned_quantity) as total_planned,
        sum(pr.actual_quantity) as total_actual,
        round(
            sum(pr.actual_quantity) / sum(pr.planned_quantity) * 100,
            2
        ) as achievement_rate
    from production_records pr
    join production_lines pl
        on pr.line_id = pl.line_id
    where pl.plant_id = 'P02'
    group by pl.line_id
),
line_downtime as (
    select
        pl.line_id,
        sum(dr.downtime_minutes) as total_downtime_minutes,
        count(*) as downtime_events
    from downtime_records dr
    join production_records pr
        on dr.production_id = pr.production_id
    join production_lines pl
        on pr.line_id = pl.line_id
    where pl.plant_id = 'P02'
    group by pl.line_id
)
select
    lp.line_id,
    lp.total_planned,
    lp.total_actual,
    lp.achievement_rate,
    ld.total_downtime_minutes,
    ld.downtime_events
from line_performance lp
join line_downtime ld
    on lp.line_id = ld.line_id
order by lp.achievement_rate asc;

## Are certain products contributing to Plant 02's poor production achievement?

select
    p.product_name,
    sum(pr.planned_quantity) as total_planned,
    sum(pr.actual_quantity) as total_actual,
    round(
        sum(pr.actual_quantity) / sum(pr.planned_quantity) * 100,
        2
    ) as achievement_rate,
    sum(pr.scrap_quantity) as total_scrap
from production_records pr
join products p
    on pr.product_id = p.product_id
join production_lines pl
    on pr.line_id = pl.line_id
where pl.plant_id = 'P02'
group by p.product_name
order by achievement_rate asc;

## Shift analysis
## Does production performance vary significantly across shifts at Plant 02?
select
    s.shift_name,
    sum(pr.planned_quantity) as total_planned,
    sum(pr.actual_quantity) as total_actual,
    round(
        sum(pr.actual_quantity) / sum(pr.planned_quantity) * 100,
        2
    ) as achievement_rate,
    sum(pr.scrap_quantity) as total_scrap
from production_records pr
join shifts s
    on pr.shift_id = s.shift_id
join production_lines pl
    on pr.line_id = pl.line_id
where pl.plant_id = 'P02'
group by s.shift_name
order by achievement_rate asc;

## Downtime by shift
select
    s.shift_name,
    sum(dr.downtime_minutes) as total_downtime_minutes,
    count(*) as downtime_events
from downtime_records dr
join production_records pr
    on dr.production_id = pr.production_id
join shifts s
    on pr.shift_id = s.shift_id
join production_lines pl
    on pr.line_id = pl.line_id
where pl.plant_id = 'P02'
group by s.shift_name
order by total_downtime_minutes desc;

## Shift quality performance
select
    s.shift_name,
    sum(dr.defect_quantity) as total_defects,
    count(*) as defect_records
from defect_records dr
join production_records pr
    on dr.production_id = pr.production_id
join shifts s
    on pr.shift_id = s.shift_id
join production_lines pl
    on pr.line_id = pl.line_id
where pl.plant_id = 'P02'
group by s.shift_name
order by total_defects desc;

## Defect rate by shift
select
    s.shift_name,
    sum(pr.actual_quantity) as total_actual,
    sum(dr.defect_quantity) as total_defects,
    round(
        sum(dr.defect_quantity) / sum(pr.actual_quantity) * 100,
        2
    ) as defect_rate
from defect_records dr
join production_records pr
    on dr.production_id = pr.production_id
join shifts s
    on pr.shift_id = s.shift_id
join production_lines pl
    on pr.line_id = pl.line_id
where pl.plant_id = 'P02'
group by s.shift_name
order by defect_rate desc;

## Are Night-shift production records themselves showing lower output relative to their planned quantity across individual lines?
select
    pl.line_id,
    sum(pr.planned_quantity) as total_planned,
    sum(pr.actual_quantity) as total_actual,
    round(
        sum(pr.actual_quantity) / sum(pr.planned_quantity) * 100,
        2
    ) as achievement_rate
from production_records pr
join production_lines pl
    on pr.line_id = pl.line_id
join shifts s
    on pr.shift_id = s.shift_id
where pl.plant_id = 'P02'
  and s.shift_name = 'Night'
group by pl.line_id
order by achievement_rate asc;

## Night shift product mix
select
    p.product_name,
    sum(pr.planned_quantity) as planned,
    sum(pr.actual_quantity) as actual,
    round(sum(pr.actual_quantity) / sum(pr.planned_quantity) * 100, 2) as achievement
from production_records pr
join products p on pr.product_id = p.product_id
join production_lines pl on pr.line_id = pl.line_id
join shifts s on pr.shift_id = s.shift_id
where pl.plant_id = 'P02'
  and s.shift_name = 'Night'
group by p.product_name
order by achievement;

SELECT
    SUM(planned_quantity) AS total_planned,
    SUM(actual_quantity) AS total_actual,
    SUM(scrap_quantity) AS total_scrap,
    ROUND(SUM(actual_quantity) / SUM(planned_quantity) * 100, 2) AS production_achievement,
    ROUND(SUM(scrap_quantity) / SUM(actual_quantity) * 100, 2) AS scrap_rate
FROM production_records;

SELECT
    plant_id,
    SUM(planned_quantity) AS total_planned,
    SUM(actual_quantity) AS total_actual,
    ROUND(SUM(actual_quantity) / SUM(planned_quantity) * 100, 2) AS achievement_rate,
    SUM(scrap_quantity) AS total_scrap
FROM production_records
GROUP BY plant_id
ORDER BY achievement_rate DESC;

SELECT
    line_id,
    SUM(planned_quantity) AS total_planned,
    SUM(actual_quantity) AS total_actual,
    ROUND(SUM(actual_quantity) / SUM(planned_quantity) * 100, 2) AS achievement_rate,
    SUM(scrap_quantity) AS total_scrap
FROM production_records
GROUP BY line_id
ORDER BY achievement_rate ASC;

WITH plant_downtime AS (
    SELECT
        pl.plant_id,
        SUM(dr.downtime_minutes) AS total_downtime_minutes,
        COUNT(*) AS downtime_events
    FROM downtime_records dr
    JOIN production_records pr
        ON dr.production_id = pr.production_id
    JOIN production_lines pl
        ON pr.line_id = pl.line_id
    GROUP BY pl.plant_id
)
SELECT
    p.plant_name,
    pd.total_downtime_minutes,
    pd.downtime_events
FROM plant_downtime pd
JOIN plants p
    ON pd.plant_id = p.plant_id
ORDER BY pd.total_downtime_minutes DESC;

SELECT
    p.plant_name,
    dr.downtime_reason,
    COUNT(*) AS downtime_events,
    SUM(dr.downtime_minutes) AS total_downtime_minutes
FROM downtime_records dr
JOIN production_records pr ON dr.production_id = pr.production_id
JOIN production_lines pl ON pr.line_id = pl.line_id
JOIN plants p ON pl.plant_id = p.plant_id
GROUP BY p.plant_name, dr.downtime_reason
ORDER BY p.plant_name, total_downtime_minutes DESC;
