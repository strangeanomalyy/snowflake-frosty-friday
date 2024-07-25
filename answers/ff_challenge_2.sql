-- https://frostyfriday.org/blog/2022/07/15/week-2-intermediate/

create or replace stage frosty_friday.challenges.frosty_friday_snowflake_stage; 

create or replace file format frosty_friday.challenges.parquet
    type = PARQUET;

use database frosty_friday;
use schema challenges;

select $1 as variant, metadata$filename as filename from '@frosty_friday_snowflake_stage' (file_format=> 'parquet');

select concat(expression, ' as ', column_name, ',') 
    from table (
        infer_schema(
            location => '@frosty_friday_snowflake_stage',
            file_format => 'parquet')
        );

create or replace table frosty_friday.challenges.challenge_2 as (
    select 
        $1:employee_id::NUMBER(38, 0) as employee_id,
        $1:first_name::TEXT as first_name,
        $1:last_name::TEXT as last_name,
        $1:email::TEXT as email,
        $1:street_num::NUMBER(38, 0) as street_num,
        $1:street_name::TEXT as street_name,
        $1:city::TEXT as city,
        $1:postcode::TEXT as postcode,
        $1:country::TEXT as country,
        $1:country_code::TEXT as country_code,
        $1:time_zone::TEXT as time_zone,
        $1:payroll_iban::TEXT as payroll_iban,
        $1:dept::TEXT as dept,
        $1:job_title::TEXT as job_title,
        $1:education::TEXT as education,
        $1:title::TEXT as title,
        $1:suffix::TEXT as suffix,
        metadata$filename as filename 
    from '@frosty_friday_snowflake_stage' 
    (file_format=> 'parquet')
);

create or replace temporary view challenge_2_temp_view as (
    select
        employee_id,
        dept,
        job_title
    from challenge_2
);

create or replace stream challenge_2_stream on view challenge_2_temp_view; 

select * from challenge_2_stream;

update challenge_2 set country = 'Japan' where employee_id = 8;
update challenge_2 set last_name = 'Forester' where employee_id = 22;
update challenge_2 set dept = 'Marketing' where employee_id = 25;
update challenge_2 set title = 'Ms' where employee_id = 32;
update challenge_2 set job_title = 'Senior Financial Analyst' where employee_id = 68;

select * from challenge_2_stream;
