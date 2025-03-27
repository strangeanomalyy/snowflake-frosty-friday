-- https://frostyfriday.org/blog/2022/07/15/week-5-basic/

create or replace function frosty_friday.answers.timesthree(value number) 
returns number
as 
$$

value*3

$$;


select timesthree(9)
