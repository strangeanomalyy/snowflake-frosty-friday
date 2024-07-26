-- https://frostyfriday.org/blog/2022/07/15/week-4-hard/

create or replace file format json
    type = 'JSON'
    strip_outer_array = True;

create or replace stage challenge_4_stage
    file_format = json;

select * from table(
    infer_schema(
        location => '@ff_data/challenge_4',
        file_format => 'json'
    )
);

create or replace table challenge_4 as (
    select
        $1 as v, 
        metadata$filename as filename
    from '@ff_data/challenge_4'
);

select * from challenge_4;

create or replace table challenge_4_flattened as (
    select
        row_number() over (order by m.value:"Birth", m.value:"Start of Reign") as id,
        row_number() over (partition by h.value:"House", v:Era order by h.index) as inter_house_id,
        v:Era::string as era,
        h.value:"House"::string as house,
        m.value:"Name"::string as name,
        m.value:"Nickname"[0]::string as nickname_1,
        m.value:"Nickname"[1]::string as nickname_2,
        m.value:"Nickname"[2]::string as nickname_3,
        m.value:"Birth"::date as birth,
        m.value:"Place of Birth"::string as place_of_birth,
        m.value:"Start of Reign"::date as start_of_reign,
        m.value:"Consort\/Queen Consort"[0]::string as consort_queen_consort_1,
        m.value:"Consort\/Queen Consort"[1]::string as consort_queen_consort_2,
        m.value:"Consort\/Queen Consort"[2]::string as consort_queen_consort_3,
        m.value:"End of Reign"::date as end_of_reign,
        m.value:"Duration"::string as duration,
        m.value:"Death"::date as death,
        m.value:"Age at Time of Death"::string as age_at_time_of_death_years,
        m.value:"Place of Death"::string as place_of_death,
        m.value:"Burial Place"::string as burial_place
    from challenge_4 c,
    lateral flatten(input => c.v, path=>'Houses') h,
    lateral flatten(input => h.value:Monarchs) m
);

select * from challenge_4_flattened order by id;
