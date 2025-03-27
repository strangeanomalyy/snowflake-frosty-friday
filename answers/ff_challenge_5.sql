create or replace function frosty_friday.answers.timesthree(value number) 
returns number
as 
$$

value*3

$$;


select timesthree(9)
