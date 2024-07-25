-- https://frostyfriday.org/blog/2022/07/15/week-3-basic/

create or replace stage frosty_friday.challenges.frosty_friday_challenge_3_stage
    url = 's3://frostyfridaychallenges/challenge_3/';

ls '@frosty_friday_challenge_3_stage';

create or replace table frosty_friday.challenges.challenge_3_keywords as (
select $1 as keyword, $2 as added_by, $3 as nonsense from '@frosty_friday_challenge_3_stage/keywords.csv' where keyword != 'keyword'
);

select * from frosty_friday.challenges.challenge_3_keywords;

create or replace file format csv
    type = CSV
    skip_header = 1;

create or replace table frosty_friday.challenges.challenge_3 as (
with keywords as (
    select keyword from frosty_friday.challenges.challenge_3_keywords
),

files as (
    select $1,$2,$3,$4,$5, metadata$filename as filename from '@frosty_friday_challenge_3_stage' (file_format => 'csv')
),

join_keywords as (
    select * from files f
    join keywords k
    on contains(filename, k.keyword)
),

count_rows as (
    select
        filename,
        count(*) as number_of_rows
    from join_keywords
    group by all
)

select * from count_rows);

select * from frosty_friday.challenges.challenge_3;
