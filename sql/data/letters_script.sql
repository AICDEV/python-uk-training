--wcmon table is just a simple table with week numbers on one side and the monday of the week connected to it.
--this is part of a larger script that pulls more sets of data to make a complete dashboard
--it is ran each week and added to an excel wrokbook where a pivot table is made from the data to present to the business
--letters 
create table Letters as
select qq.full_date,
       qq.outcome_code,
       qq.letter_reference,
       qq.TRACKING_TYPE,
       count(qq.thread_id) as vol,
       'Letters' as TaskType
  from (select wc.full_date,
               a.outcome_code,
               a.outcome_reference,
               b.thread_id,
               b.cw_start_date,
               c.description       as TRACKING_TYPE,
               d.description       as TRACKING_SUBTYPE,
               e.description,
               e.letter_reference
          from ice1.cats_outcome          a,
               ice1.cats_threads_history  b,
               ice1.cats_tracking_type    c,
               ice1.cats_tracking_subtype d,
               ice1.letter_tbl            e,
               c23454.wcmon                      wc
         where a.outcome_type_id = '2'
           and a.outcome_code = b.previous_outcome  
           and  b.cw_start_date >= wc.full_date
           and b.cw_start_date <= wc.full_date + 6
           and wc.full_date = &week_num
           and a.tracking_type = c.tracking_type
           and a.tracking_type = d.tracking_type
           and a.tracking_subtype = d.tracking_subtype
           and a.outcome_reference = e.letter_id
           and e.active_flag = 'Y'
        union all
        select 
               wc.full_date,
               a.outcome_code,
               a.outcome_reference,
               b.thread_id,
               b.cw_start_date,
               c.description       as TRACKING_TYPE,
               d.description       as TRACKING_SUBTYPE,
               e.description,
               e.letter_reference
          from ice1.cats_outcome          a,
               ice2.cats_threads_history  b,
               ice2.cats_tracking_type    c,
               ice2.cats_tracking_subtype d,
               ice2.letter_tbl            e,
               c23454.wcmon                      wc
         where a.outcome_type_id = '2'
           and a.outcome_code = b.previous_outcome
           and  b.cw_start_date >= wc.full_date
           and b.cw_start_date <= wc.full_date + 6
           and wc.full_date = &week_num
           and a.tracking_type = c.tracking_type
           and a.tracking_type = d.tracking_type
           and a.tracking_subtype = d.tracking_subtype
           and a.outcome_reference = e.letter_id
           and e.active_flag = 'Y') qq
group by qq.full_date,
          qq.outcome_code,
          qq.letter_reference,
          qq.TRACKING_TYPE;
          
select * from Letters;
          
drop table Letters purge;          
