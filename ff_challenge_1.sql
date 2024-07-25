-- https://frostyfriday.org/blog/2022/07/14/week-1/

create or replace stage frosty_friday.public.frosty_friday_stage
 url = 's3://frostyfridaychallenges/challenge_1/';

ls '@frosty_friday_stage';

select $1, metadata$filename from '@frosty_friday_s3_stage';

use schema challenges;

create or replace table frosty_friday.challenges.challenge_1 as (
    select $1 as challenge_1_results, metadata$filename as filename from '@frosty_friday_s3_stage'
);

select * from frosty_friday.challenges.challenge_1;
