-----------------------------------------------------------------------------------------------------------------------------------------------------------
-----------------------------This code is to create the base data for qlik for the engaged callers work ---------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------------------------

-----------------------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------Initial base data build----------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------------------------

-- collating all engaged callers as per CRM segmentation with appropriate info including
-- meter type, payment method, overall conplaint count, vulnerable flag, product info, number of sites, segment sub categories
drop table freq_caller_base purge;
create table freq_caller_base pctfree 0 compress as 
(
SELECT    c.ice_customer_id
,         c.premise_id
,         c.customer_tenure_band
,         c.residential_segment
,         s.subengaged
,         c.age_band_actual
,         case when c.css_registered = 'Y' then 'Y' else 'N' end as css_registered 
,         c.calls_l12m
,         c.complaints_l12m
,         case when c.vulnerable = 'Y' then 'Y' else 'N' end as vulnerable 
,         case when c.fuel_holding = 'E' then 'SE'
               when c.fuel_holding = 'G' then 'SG'
               when c.fuel_holding = 'EG' then 'DF' else null end as fuel_type
,         case when c.fuel_holding = 'EG' and c.elec_financial_account_ref = c.gas_financial_account_ref then 'OneBill'
               when c.fuel_holding = 'EG' and c.elec_financial_account_ref != c.gas_financial_account_ref then 'Seperate'
                 else null end as DF_BILL_TYPE
,         c.num_premises
,         c.smart_flag
,         c.current_balance
,         case when c.fuel_holding = 'E' then c.elec_payment_method
               when c.fuel_holding = 'G' then c.gas_payment_method
               when c.fuel_holding = 'EG' and c.elec_payment_method = c.gas_payment_method then c.elec_payment_method
               when c.fuel_holding = 'EG' and c.elec_payment_method != c.gas_payment_method then 'Mixed' end as payment_method
,         c.elec_payment_method
,         c.elec_payment_method_group
,         c.gas_payment_method
,         c.gas_payment_method_group
,         c.postcode
,         c.property_residence_type
,         c.property_occupancy_type
,         c.property_build_year_band
,         c.mosaic_type_desc
,         c.mosaic_group_desc
,         c.mos_digital_group
,         c.mosaic_age_band
,         c.hh_income_band
,         c.postcode_mosaic_group
,         c.postcode_digital_group
,         c.css_login_l12m
,         c.app_login_l12m
,         c.ivr_calls_l12m
,         c.ivr_complete
,         c.nps_eon
,         c.heartbeat_l12m
,         c.customer_journey
,         c.number_of_households_l5y
,         c.number_of_occupants_l5y
,         c.marketing_consent_mail
,         c.marketing_consent_email
,         c.marketing_consent_phone
,         c.marketing_consent_sms
,         c.eligible_for_email
,         c.eligible_for_dm
,         c.eligible_for_sms
,         c.warm_home_disc
,         c.acquisition_method
,         c.acquisition_channel
,         c.months_to_renew
,         c.previous_supplier
,         c.engagement_segmentation
,         c.num_elec_accounts
,         c.num_gas_accounts
,         c.elec_account_reference
,         c.elec_base_id
,         c.elec_prod_type
,         c.elec_product_group
,         c.elec_product_subgroup
,         c.elec_product_description
,         c.elec_financial_account_ref
,         c.elec_billing_freq
,         c.mpan
,         c.elec_annual_consumption
,         c.gas_account_reference
,         c.gas_base_id
,         c.gas_prod_type
,         c.gas_product_group
,         c.gas_product_subgroup
,         c.gas_product_description
,         c.gas_financial_account_ref
,         c.gas_billing_freq
,         c.mpr
,         c.gas_annual_consumption
from      CAM_SCRATCH.DO_NOT_DROP_INSIGHT_DEC20 c
left join l7771.nov2020segment s
on        c.ice_customer_id = s.ice_customer_id
where     c.residential_segment = 'Engaged Callers'
)
;
------------------------------------------------ bringing in total complaint volumnes -------------------------------------------------------------------
create table closed_comps_vol compress pctfree 0  as
(
select   count (distinct c.complaint_id) as volume_closed_complaints
,        a.ice_customer_id
from     freq_caller_base  a
join     aml_t_complaints_created c
on       c.ice_customer_id = a.ice_customer_id
where    c.closed_date is not null
group by a.ice_customer_id
)
;
create table open_complaints compress pctfree 0 as
(
select   count (distinct c.complaint_id) as volume_open_complaints
,        a.ice_customer_id
from     freq_caller_base  a
join     aml_t_complaints_created c
on       c.ice_customer_id = a.ice_customer_id
where    c.closed_date is null
group by a.ice_customer_id
)
;
create table ombds_complaints compress pctfree 0 as
(
select   count (distinct c.complaint_id) as volume_ombds_complaints
,        a.ice_customer_id
from     freq_caller_base  a
join     aml_t_complaints_created c
on       c.ice_customer_id = a.ice_customer_id
where    c.ombudsman_complaint_indicator = 'Y'
group by a.ice_customer_id
)
;
------------------------------------------------------- adding complaint volumes to base data ---------------------------------------------------------
create table freq_caller_base_w_comp pctfree 0 compress as 
(
SELECT    c.ice_customer_id
,         c.premise_id
,         c.customer_tenure_band
,         c.residential_segment
,         c.subengaged
,         c.age_band_actual
,         c.css_registered 
,         c.calls_l12m
,         c.complaints_l12m
,         cc.volume_closed_complaints as closed_complaints_total_vol
,         oc.volume_open_complaints as open_complaints_total_vol
,         ombc.volume_ombds_complaints as ombds_complaints_total_vol
,         c.vulnerable 
,         c.fuel_type
,         c.df_bill_type
,         c.num_premises
,         c.smart_flag
,         c.current_balance
,         c.payment_method
,         c.elec_payment_method
,         c.elec_payment_method_group
,         c.gas_payment_method
,         c.gas_payment_method_group
,         c.postcode
,         c.property_residence_type
,         c.property_occupancy_type
,         c.property_build_year_band
,         c.mosaic_type_desc
,         c.mosaic_group_desc
,         c.mos_digital_group
,         c.mosaic_age_band
,         c.hh_income_band
,         c.postcode_mosaic_group
,         c.postcode_digital_group
,         c.css_login_l12m
,         c.app_login_l12m
,         c.ivr_calls_l12m
,         c.ivr_complete
,         c.nps_eon
,         c.heartbeat_l12m
,         c.customer_journey
,         c.number_of_households_l5y
,         c.number_of_occupants_l5y
,         c.marketing_consent_mail
,         c.marketing_consent_email
,         c.marketing_consent_phone
,         c.marketing_consent_sms
,         c.eligible_for_email
,         c.eligible_for_dm
,         c.eligible_for_sms
,         c.warm_home_disc
,         c.acquisition_method
,         c.acquisition_channel
,         c.months_to_renew
,         c.previous_supplier
,         c.engagement_segmentation
,         c.num_elec_accounts
,         c.num_gas_accounts
,         c.elec_account_reference
,         c.elec_base_id
,         c.elec_prod_type
,         c.elec_product_group
,         c.elec_product_subgroup
,         c.elec_product_description
,         c.elec_financial_account_ref
,         c.elec_billing_freq
,         c.mpan
,         c.elec_annual_consumption
,         c.gas_account_reference
,         c.gas_base_id
,         c.gas_prod_type
,         c.gas_product_group
,         c.gas_product_subgroup
,         c.gas_product_description
,         c.gas_financial_account_ref
,         c.gas_billing_freq
,         c.mpr
,         c.gas_annual_consumption
from      freq_caller_base c
left join closed_comps_vol cc
on        c.ice_customer_id = cc.ice_customer_id
left join open_complaints oc 
on        c.ice_customer_id = oc.ice_customer_id
left join ombds_complaints ombc
on        c.ice_customer_id = ombc.ice_customer_id
)
;
-- clean up
drop table a39843.freq_caller_base purge;
drop table a39843.closed_comps_vol purge;
drop table a39843.open_complaints purge;
drop table a39843.ombds_complaints purge;
select *
from freq_caller_base_w_comp
;
------------------------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------Vulnerability------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------- pulling vulnerability details and groupings Y/N ---------------------------------------------------------

create table vuln_base_3 compress pctfree 0 parallel 16 as
(
select     distinct(b.ice_customer_id)   
,          count (distinct v.vulnerability_id) as no_vulnerabilities
from       freq_caller_base_w_comp b
left join  aml_t_vulnerability v
on         b.ice_customer_id = v.ice_customer_id
and        v.dw_to_date >= sysdate
group by   b.ice_customer_id

)
;
create table vuln_base_4 compress pctfree 0 parallel 16 as
(
select     b.ice_customer_id
,          b.no_vulnerabilities
,         case when v.ice_customer_id is not null then 'Y' else 'N' end as Age_vuln
,         row_number () over (partition by b.ice_customer_id order by b.ice_customer_id) rn
from      vuln_base_3 b
left join aml_t_vulnerability v
on        b.ice_customer_id = v.ice_customer_id
and       v.dw_to_date >= sysdate
and       v.vulnerability_id in ('36','35','54','40','2')
)
;
drop table vuln_base_3 purge;

create table vuln_base_5 compress pctfree 0 parallel 16 as
(
select     b.ice_customer_id
,          b.no_vulnerabilities
,          b.Age_vuln
,         case when v.ice_customer_id is not null then 'Y' else 'N' end as Financial_vuln
,         row_number () over (partition by b.ice_customer_id order by b.ice_customer_id) rn
from      vuln_base_4 b
left join aml_t_vulnerability v
on        b.ice_customer_id = v.ice_customer_id
and       v.dw_to_date >= sysdate
and       v.vulnerability_id in ('49','51','48','46','47','66','41','52','53')
where     b.rn = '1'
)
;
drop table vuln_base_4 purge;
create table vuln_base_6 compress pctfree 0 parallel 16 as
(
select     b.ice_customer_id
,          b.no_vulnerabilities
,         b.Age_vuln
,         b.Financial_vuln
,         case when v.ice_customer_id is not null then 'Y' else 'N' end as health_Physical_vuln
,         row_number () over (partition by b.ice_customer_id order by b.ice_customer_id) rn
from      vuln_base_5 b
left join aml_t_vulnerability v
on        b.ice_customer_id = v.ice_customer_id
and       v.dw_to_date >= sysdate
and       v.vulnerability_id in ('69','70','20','55','1','17','19','18','28','29','27','57','21','58','60','59','25','26','24','22','23','11','10','12','13','14','33','30')
where     b.rn = '1'
)
;
drop table vuln_base_5 purge;
create table vuln_base_7 compress pctfree 0 parallel 16 as
(
select     b.ice_customer_id
,          b.no_vulnerabilities
,         b.Age_vuln
,         b.Financial_vuln
,         b.health_Physical_vuln
,         case when v.ice_customer_id is not null then 'Y' else 'N' end as Mental_Health_vuln
,         row_number () over (partition by b.ice_customer_id order by b.ice_customer_id) rn
from      vuln_base_6 b
left join aml_t_vulnerability v
on        b.ice_customer_id = v.ice_customer_id
and       v.dw_to_date >= sysdate
and       v.vulnerability_id in ('39','32','34','16','15')
where     b.rn = '1'
)
;
drop table vuln_base_6 purge;
create table vuln_base_8 compress pctfree 0 parallel 16 as
(
select     b.ice_customer_id
,          b.no_vulnerabilities
,         b.Age_vuln
,         b.Financial_vuln
,         b.health_Physical_vuln
,         b.Mental_Health_vuln
,         case when v.ice_customer_id is not null then 'Y' else 'N' end as Health_Sensory_vuln
,         row_number () over (partition by b.ice_customer_id order by b.ice_customer_id) rn
from      vuln_base_7 b
left join aml_t_vulnerability v
on        b.ice_customer_id = v.ice_customer_id
and       v.dw_to_date >= sysdate
and       v.vulnerability_id in ('7','8','5','6','9','4','67','3','68')
where     b.rn = '1'
)
;
drop table vuln_base_7 purge;
;
create table vuln_base_9 compress pctfree 0 parallel 16 as
(
select     b.ice_customer_id
,          b.no_vulnerabilities
,         b.Age_vuln
,         b.Financial_vuln
,         b.health_Physical_vuln
,         b.Mental_Health_vuln
,         b.Health_Sensory_vuln
,         case when v.ice_customer_id is not null  then 'Y' else 'N' end as Life_Event_vuln
,         row_number () over (partition by b.ice_customer_id order by b.ice_customer_id) rn
from      vuln_base_8 b
left join aml_t_vulnerability v
on        b.ice_customer_id = v.ice_customer_id
and       v.dw_to_date >= sysdate
and       v.vulnerability_id in ('62','63','38','42','31','37','43','56','61','44','45')
where     b.rn = '1'
)
;
drop table vuln_base_8 purge;
drop table freq_caller_vuln purge;
create table freq_caller_vuln compress pctfree 0 parallel 16 as
(
select *
from vuln_base_9
where rn = '1'
)
;
drop table vuln_base_9 purge;
select * 
from freq_caller_vuln
;
--------------------------- vulnerable heirarchy groups for 1 or more vulnerabilities - remove double counting----------------------------------------------
CREATE TABLE VULN_GROUPS COMPRESS PCTFREE 0 PARALLEL 16 as
(
Select     f.ice_customer_id
,          case when f.age_vuln = 'Y' and f.financial_vuln = 'Y' and f.health_physical_vuln = 'Y' and f.mental_health_vuln = 'Y' and f.health_sensory_vuln = 'Y' and f.life_event_vuln = 'Y' then '6A'
                when f.age_vuln = 'Y' and f.financial_vuln = 'Y' and f.health_physical_vuln = 'Y' and f.mental_health_vuln = 'Y' and f.health_sensory_vuln = 'Y' and f.life_event_vuln = 'N' then '5A'
                when f.age_vuln = 'Y' and f.financial_vuln = 'Y' and f.health_physical_vuln = 'Y' and f.mental_health_vuln = 'Y' and f.health_sensory_vuln = 'N' and f.life_event_vuln = 'Y' then '5B'
                when f.age_vuln = 'Y' and f.financial_vuln = 'Y' and f.health_physical_vuln = 'Y' and f.mental_health_vuln = 'N' and f.health_sensory_vuln = 'Y' and f.life_event_vuln = 'Y' then '5C'
                when f.age_vuln = 'Y' and f.financial_vuln = 'Y' and f.health_physical_vuln = 'N' and f.mental_health_vuln = 'Y' and f.health_sensory_vuln = 'Y' and f.life_event_vuln = 'Y' then '5D'
                when f.age_vuln = 'Y' and f.financial_vuln = 'N' and f.health_physical_vuln = 'Y' and f.mental_health_vuln = 'Y' and f.health_sensory_vuln = 'Y' and f.life_event_vuln = 'Y' then '5E'
                when f.age_vuln = 'N' and f.financial_vuln = 'Y' and f.health_physical_vuln = 'Y' and f.mental_health_vuln = 'Y' and f.health_sensory_vuln = 'Y' and f.life_event_vuln = 'Y' then '5F'
                when f.age_vuln = 'Y' and f.financial_vuln = 'Y' and f.health_physical_vuln = 'Y' and f.mental_health_vuln = 'Y' and f.health_sensory_vuln = 'N' and f.life_event_vuln = 'N' then '4A'
                when f.age_vuln = 'Y' and f.financial_vuln = 'Y' and f.health_physical_vuln = 'Y' and f.mental_health_vuln = 'N' and f.health_sensory_vuln = 'Y' and f.life_event_vuln = 'N' then '4B'
                when f.age_vuln = 'Y' and f.financial_vuln = 'Y' and f.health_physical_vuln = 'N' and f.mental_health_vuln = 'Y' and f.health_sensory_vuln = 'Y' and f.life_event_vuln = 'N' then '4C'
                when f.age_vuln = 'Y' and f.financial_vuln = 'N' and f.health_physical_vuln = 'Y' and f.mental_health_vuln = 'Y' and f.health_sensory_vuln = 'Y' and f.life_event_vuln = 'N' then '4D'
                when f.age_vuln = 'N' and f.financial_vuln = 'Y' and f.health_physical_vuln = 'Y' and f.mental_health_vuln = 'Y' and f.health_sensory_vuln = 'Y' and f.life_event_vuln = 'N' then '4E'
                when f.age_vuln = 'Y' and f.financial_vuln = 'Y' and f.health_physical_vuln = 'Y' and f.mental_health_vuln = 'N' and f.health_sensory_vuln = 'N' and f.life_event_vuln = 'Y' then '4F'
                when f.age_vuln = 'Y' and f.financial_vuln = 'Y' and f.health_physical_vuln = 'N' and f.mental_health_vuln = 'Y' and f.health_sensory_vuln = 'N' and f.life_event_vuln = 'Y' then '4G'
                when f.age_vuln = 'Y' and f.financial_vuln = 'N' and f.health_physical_vuln = 'Y' and f.mental_health_vuln = 'Y' and f.health_sensory_vuln = 'N' and f.life_event_vuln = 'Y' then '4H'
                when f.age_vuln = 'N' and f.financial_vuln = 'Y' and f.health_physical_vuln = 'Y' and f.mental_health_vuln = 'Y' and f.health_sensory_vuln = 'N' and f.life_event_vuln = 'Y' then '4I'
                when f.age_vuln = 'Y' and f.financial_vuln = 'Y' and f.health_physical_vuln = 'N' and f.mental_health_vuln = 'N' and f.health_sensory_vuln = 'Y' and f.life_event_vuln = 'Y' then '4J'
                when f.age_vuln = 'Y' and f.financial_vuln = 'N' and f.health_physical_vuln = 'Y' and f.mental_health_vuln = 'N' and f.health_sensory_vuln = 'Y' and f.life_event_vuln = 'Y' then '4K'
                when f.age_vuln = 'N' and f.financial_vuln = 'Y' and f.health_physical_vuln = 'Y' and f.mental_health_vuln = 'N' and f.health_sensory_vuln = 'Y' and f.life_event_vuln = 'Y' then '4L'
                when f.age_vuln = 'Y' and f.financial_vuln = 'N' and f.health_physical_vuln = 'N' and f.mental_health_vuln = 'Y' and f.health_sensory_vuln = 'Y' and f.life_event_vuln = 'Y' then '4M'
                when f.age_vuln = 'N' and f.financial_vuln = 'Y' and f.health_physical_vuln = 'N' and f.mental_health_vuln = 'Y' and f.health_sensory_vuln = 'Y' and f.life_event_vuln = 'Y' then '4N'
                when f.age_vuln = 'N' and f.financial_vuln = 'N' and f.health_physical_vuln = 'Y' and f.mental_health_vuln = 'Y' and f.health_sensory_vuln = 'Y' and f.life_event_vuln = 'Y' then '4O'
                when f.age_vuln = 'Y' and f.financial_vuln = 'Y' and f.health_physical_vuln = 'Y' and f.mental_health_vuln = 'N' and f.health_sensory_vuln = 'N' and f.life_event_vuln = 'N' then '3A'
                when f.age_vuln = 'Y' and f.financial_vuln = 'Y' and f.health_physical_vuln = 'N' and f.mental_health_vuln = 'Y' and f.health_sensory_vuln = 'N' and f.life_event_vuln = 'N' then '3B'
                when f.age_vuln = 'Y' and f.financial_vuln = 'N' and f.health_physical_vuln = 'Y' and f.mental_health_vuln = 'Y' and f.health_sensory_vuln = 'N' and f.life_event_vuln = 'N' then '3C'
                when f.age_vuln = 'N' and f.financial_vuln = 'Y' and f.health_physical_vuln = 'Y' and f.mental_health_vuln = 'Y' and f.health_sensory_vuln = 'N' and f.life_event_vuln = 'N' then '3D'
                when f.age_vuln = 'Y' and f.financial_vuln = 'Y' and f.health_physical_vuln = 'N' and f.mental_health_vuln = 'N' and f.health_sensory_vuln = 'Y' and f.life_event_vuln = 'N' then '3E'
                when f.age_vuln = 'Y' and f.financial_vuln = 'N' and f.health_physical_vuln = 'Y' and f.mental_health_vuln = 'N' and f.health_sensory_vuln = 'Y' and f.life_event_vuln = 'N' then '3F'
                when f.age_vuln = 'N' and f.financial_vuln = 'Y' and f.health_physical_vuln = 'Y' and f.mental_health_vuln = 'N' and f.health_sensory_vuln = 'Y' and f.life_event_vuln = 'N' then '3G'
                when f.age_vuln = 'Y' and f.financial_vuln = 'N' and f.health_physical_vuln = 'N' and f.mental_health_vuln = 'Y' and f.health_sensory_vuln = 'Y' and f.life_event_vuln = 'N' then '3H'
                when f.age_vuln = 'N' and f.financial_vuln = 'Y' and f.health_physical_vuln = 'N' and f.mental_health_vuln = 'Y' and f.health_sensory_vuln = 'Y' and f.life_event_vuln = 'N' then '3I'
                when f.age_vuln = 'N' and f.financial_vuln = 'N' and f.health_physical_vuln = 'Y' and f.mental_health_vuln = 'Y' and f.health_sensory_vuln = 'Y' and f.life_event_vuln = 'N' then '3J'
                when f.age_vuln = 'Y' and f.financial_vuln = 'Y' and f.health_physical_vuln = 'N' and f.mental_health_vuln = 'N' and f.health_sensory_vuln = 'N' and f.life_event_vuln = 'Y' then '3K'
                when f.age_vuln = 'Y' and f.financial_vuln = 'N' and f.health_physical_vuln = 'Y' and f.mental_health_vuln = 'N' and f.health_sensory_vuln = 'N' and f.life_event_vuln = 'Y' then '3L'
                when f.age_vuln = 'N' and f.financial_vuln = 'Y' and f.health_physical_vuln = 'Y' and f.mental_health_vuln = 'N' and f.health_sensory_vuln = 'N' and f.life_event_vuln = 'Y' then '3M'
                when f.age_vuln = 'Y' and f.financial_vuln = 'N' and f.health_physical_vuln = 'N' and f.mental_health_vuln = 'Y' and f.health_sensory_vuln = 'N' and f.life_event_vuln = 'Y' then '3N'
                when f.age_vuln = 'N' and f.financial_vuln = 'Y' and f.health_physical_vuln = 'N' and f.mental_health_vuln = 'Y' and f.health_sensory_vuln = 'N' and f.life_event_vuln = 'Y' then '3O'
                when f.age_vuln = 'N' and f.financial_vuln = 'N' and f.health_physical_vuln = 'Y' and f.mental_health_vuln = 'Y' and f.health_sensory_vuln = 'N' and f.life_event_vuln = 'Y' then '3P'
                when f.age_vuln = 'Y' and f.financial_vuln = 'N' and f.health_physical_vuln = 'N' and f.mental_health_vuln = 'N' and f.health_sensory_vuln = 'Y' and f.life_event_vuln = 'Y' then '3Q'
                when f.age_vuln = 'N' and f.financial_vuln = 'Y' and f.health_physical_vuln = 'N' and f.mental_health_vuln = 'N' and f.health_sensory_vuln = 'Y' and f.life_event_vuln = 'Y' then '3R'
                when f.age_vuln = 'N' and f.financial_vuln = 'N' and f.health_physical_vuln = 'Y' and f.mental_health_vuln = 'N' and f.health_sensory_vuln = 'Y' and f.life_event_vuln = 'Y' then '3S'
                when f.age_vuln = 'N' and f.financial_vuln = 'N' and f.health_physical_vuln = 'N' and f.mental_health_vuln = 'Y' and f.health_sensory_vuln = 'Y' and f.life_event_vuln = 'Y' then '3T'
                when f.age_vuln = 'Y' and f.financial_vuln = 'Y' and f.health_physical_vuln = 'N' and f.mental_health_vuln = 'N' and f.health_sensory_vuln = 'N' and f.life_event_vuln = 'N' then '2A'
                when f.age_vuln = 'Y' and f.financial_vuln = 'N' and f.health_physical_vuln = 'Y' and f.mental_health_vuln = 'N' and f.health_sensory_vuln = 'N' and f.life_event_vuln = 'N' then '2B'
                when f.age_vuln = 'N' and f.financial_vuln = 'Y' and f.health_physical_vuln = 'Y' and f.mental_health_vuln = 'N' and f.health_sensory_vuln = 'N' and f.life_event_vuln = 'N' then '2C'
                when f.age_vuln = 'Y' and f.financial_vuln = 'N' and f.health_physical_vuln = 'N' and f.mental_health_vuln = 'Y' and f.health_sensory_vuln = 'N' and f.life_event_vuln = 'N' then '2D'
                when f.age_vuln = 'N' and f.financial_vuln = 'Y' and f.health_physical_vuln = 'N' and f.mental_health_vuln = 'Y' and f.health_sensory_vuln = 'N' and f.life_event_vuln = 'N' then '2E'
                when f.age_vuln = 'N' and f.financial_vuln = 'N' and f.health_physical_vuln = 'Y' and f.mental_health_vuln = 'Y' and f.health_sensory_vuln = 'N' and f.life_event_vuln = 'N' then '2F'
                when f.age_vuln = 'Y' and f.financial_vuln = 'N' and f.health_physical_vuln = 'N' and f.mental_health_vuln = 'N' and f.health_sensory_vuln = 'Y' and f.life_event_vuln = 'N' then '2G'
                when f.age_vuln = 'N' and f.financial_vuln = 'Y' and f.health_physical_vuln = 'N' and f.mental_health_vuln = 'N' and f.health_sensory_vuln = 'Y' and f.life_event_vuln = 'N' then '2H'
                when f.age_vuln = 'N' and f.financial_vuln = 'N' and f.health_physical_vuln = 'Y' and f.mental_health_vuln = 'N' and f.health_sensory_vuln = 'Y' and f.life_event_vuln = 'N' then '2I'
                when f.age_vuln = 'N' and f.financial_vuln = 'N' and f.health_physical_vuln = 'N' and f.mental_health_vuln = 'Y' and f.health_sensory_vuln = 'Y' and f.life_event_vuln = 'N' then '2J'
                when f.age_vuln = 'Y' and f.financial_vuln = 'N' and f.health_physical_vuln = 'N' and f.mental_health_vuln = 'N' and f.health_sensory_vuln = 'N' and f.life_event_vuln = 'Y' then '2K'
                when f.age_vuln = 'N' and f.financial_vuln = 'Y' and f.health_physical_vuln = 'N' and f.mental_health_vuln = 'N' and f.health_sensory_vuln = 'N' and f.life_event_vuln = 'Y' then '2L'
                when f.age_vuln = 'N' and f.financial_vuln = 'N' and f.health_physical_vuln = 'Y' and f.mental_health_vuln = 'N' and f.health_sensory_vuln = 'N' and f.life_event_vuln = 'Y' then '2M'
                when f.age_vuln = 'N' and f.financial_vuln = 'N' and f.health_physical_vuln = 'N' and f.mental_health_vuln = 'Y' and f.health_sensory_vuln = 'N' and f.life_event_vuln = 'Y' then '2N'
                when f.age_vuln = 'N' and f.financial_vuln = 'N' and f.health_physical_vuln = 'N' and f.mental_health_vuln = 'N' and f.health_sensory_vuln = 'Y' and f.life_event_vuln = 'Y' then '2O'
                when f.age_vuln = 'Y' and f.financial_vuln = 'N' and f.health_physical_vuln = 'N' and f.mental_health_vuln = 'N' and f.health_sensory_vuln = 'N' and f.life_event_vuln = 'N' then '1A'
                when f.age_vuln = 'N' and f.financial_vuln = 'Y' and f.health_physical_vuln = 'N' and f.mental_health_vuln = 'N' and f.health_sensory_vuln = 'N' and f.life_event_vuln = 'N' then '1B'
                when f.age_vuln = 'N' and f.financial_vuln = 'N' and f.health_physical_vuln = 'Y' and f.mental_health_vuln = 'N' and f.health_sensory_vuln = 'N' and f.life_event_vuln = 'N' then '1C'
                when f.age_vuln = 'N' and f.financial_vuln = 'N' and f.health_physical_vuln = 'N' and f.mental_health_vuln = 'Y' and f.health_sensory_vuln = 'N' and f.life_event_vuln = 'N' then '1D'
                when f.age_vuln = 'N' and f.financial_vuln = 'N' and f.health_physical_vuln = 'N' and f.mental_health_vuln = 'N' and f.health_sensory_vuln = 'Y' and f.life_event_vuln = 'N' then '1E'
                when f.age_vuln = 'N' and f.financial_vuln = 'N' and f.health_physical_vuln = 'N' and f.mental_health_vuln = 'N' and f.health_sensory_vuln = 'N' and f.life_event_vuln = 'Y' then '1F'
                  else null end as vuln_group
from       freq_caller_vuln f
)
;
create table freq_caller_vuln_groups pctfree 0 parallel 16 compress as
(
select     b.ice_customer_id
,          b.no_vulnerabilities
,          b.Age_vuln
,          b.Financial_vuln
,          b.health_Physical_vuln
,          b.Mental_Health_vuln
,          b.Health_Sensory_vuln
,          b.Life_Event_vuln
,          v.vuln_group
from       freq_caller_vuln b
left join  vuln_groups v
on         b.ice_customer_id = v.ice_customer_id
);
select *
from freq_caller_vuln_groups
;
-- clean up
drop table freq_caller_vuln purge;
drop table vuln_groups;
-- creating dim for group codes created
create table dnd_dim_freq_caller_vuln_group
(
       vuln_groups_inc varchar2 (500)
,      vuln_group_code varchar2 (2)
)
pctfree 0 compress parallel 16
;
-- upload from csv in frequent callers\works\vuln_group_dim using text importer

-------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------ pulling call data for 2020 ---------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------------------------
with base as
(
select    b.ice_customer_id
,         cll.interaction_id
,         cll.call_date
,         cll.call_direction
,         cll.call_start_date_time
,         cll.total_talk_seconds
,         cll.total_hold_seconds
,         cll.total_acw_seconds
,         cll.call_end_date_time
,         cll.nice_cr_found_flag
,         cll.nice_cr_connid
,         cll.user_id
,         row_number () over(partition by b.ice_customer_id, cll.interaction_id order by cll.call_date) rn
from      a39843.freq_callers_overall b
left join AML_T_CCP_CALL_TO_ACCOUNT cll
on        b.ice_customer_id = cll.ice_customer_id
and       cll.call_date >= '01 Jan 2020'
and       cll.call_date <= '31 Dec 2020'

)
select    *
from      base
where     rn = '1'
and       nice_cr_found_flag = 'Y'
;

-- adding in call info volumes
create table call_stg compress pctfree 0 parallel 16 as
(
select    count (distinct cll.interaction_id) as call_vol
,         cll.ice_customer_id
from      aml_t_ccp_call_to_account cll
where     cll.ice_customer_id in (select ice_customer_id from freq_caller_base_w_comp)
and       cll.call_date >= '01 JAN 2020'
and       cll.call_date <= '31 Dec 2020'
and       cll.call_direction = 'In' 
group by  cll.ice_customer_id
)
;
-- adding in call detail
create table freq_caller_call_detail compress pctfree 0 parallel 16 as
(
select    interaction_id 
,         ice_customer_id
,         call_date
,         call_direction
,         call_start_date_time
,         total_talk_seconds
,         total_hold_seconds
,         total_acw_seconds
,         call_end_date_time
,         nice_cr_found_flag
,         nice_cr_connid
,         user_id
,         row_number () over(partition by ice_customer_id order by call_start_date_time) call_sequence
from 
(
select    distinct cll.interaction_id 
,         b.ice_customer_id
,         cll.call_date
,         cll.call_direction
,         cll.call_start_date_time
,         cll.total_talk_seconds
,         cll.total_hold_seconds
,         cll.total_acw_seconds
,         cll.call_end_date_time
,         cll.nice_cr_found_flag
,         cll.nice_cr_connid
,         cll.user_id
,         row_number () over(partition by b.ice_customer_id, cll.interaction_id order by cll.call_date) rn
from      a39843.freq_caller_base_w_comp b
left join AML_T_CCP_CALL_TO_ACCOUNT cll
on        b.ice_customer_id = cll.ice_customer_id
and       cll.call_date >= '01 Jan 2020'
and       cll.call_date <= '31 Dec 2020'
and       cll.call_direction = 'In'
)
where rn = '1'
)
;
-- adding in call topics

create table freq_caller_call_topics pctfree 0 parallel 16 compress as
(
select distinct (m.parent_track_num)
,      m.call_date
,      m.primary_ice_id
,      case when m.T1 >= 0.25 then 1 else 0 end as T1
,      case when m.T2 >= 0.25 then 1 else 0 end as T2
,      case when m.T3 >= 0.25 then 1 else 0 end as T3
,      case when m.T4 >= 0.25 then 1 else 0 end as T4
,      case when m.T5 >= 0.25 then 1 else 0 end as T5
,      case when m.T6 >= 0.25 then 1 else 0 end as T6
,      case when m.T7 >= 0.25 then 1 else 0 end as T7
,      case when m.T8 >= 0.25 then 1 else 0 end as T8
,      case when m.T9 >= 0.25 then 1 else 0 end as T9
,      case when m.T10 >= 0.25 then 1 else 0 end as T10
,      case when m.T11 >= 0.25 then 1 else 0 end as T11
,      case when m.T12 >= 0.25 then 1 else 0 end as T12
,      case when m.T13 >= 0.25 then 1 else 0 end as T13
,      case when m.T14 >= 0.25 then 1 else 0 end as T14
,      case when m.T15 >= 0.25 then 1 else 0 end as T15
,      case when m.T16 >= 0.25 then 1 else 0 end as T16
,      case when m.T17 >= 0.25 then 1 else 0 end as T17
,      case when m.T18 >= 0.25 then 1 else 0 end as T18
,      case when m.T19 >= 0.25 then 1 else 0 end as T19
,      case when m.T20 >= 0.25 then 1 else 0 end as T20
,      case when m.T21 >= 0.25 then 1 else 0 end as T21
,      case when m.T22 >= 0.25 then 1 else 0 end as T22
,      case when m.T23 >= 0.25 then 1 else 0 end as T23 
from   m46834.new_all_res_model m
join   freq_caller_call_detail b 
on     b.ice_customer_id = m.primary_ice_id
and    b.call_date = m.call_date
and    b.interaction_id = m.parent_track_num
)
;
create table dnd_freq_caller_call_detail compress pctfree 0 parallel 16 as
(
select    d.interaction_id 
,         d.ice_customer_id
,         d.call_date
,         d.call_direction
,         d.call_start_date_time
,         d.total_talk_seconds
,         d.total_hold_seconds
,         d.total_acw_seconds
,         d.call_end_date_time
,         d.nice_cr_found_flag
,         d.nice_cr_connid
,         d.user_id
,         d.call_sequence
,         t.t1
,         t.t2
,         t.t3
,         t.t4
,         t.t5
,         t.t6
,         t.t7
,         t.t8
,         t.t9
,         t.t10
,         t.t11
,         T.T12
,         t.t13
,         t.t14
,         t.t15
,         t.t16
,         t.t17
,         t.t18
,         t.t19
,         t.t20
,         t.t21
,         t.t22
,         t.t23
from      freq_caller_call_detail d
left join freq_caller_call_topics t
on        d.interaction_id = t.parent_track_num
and       d.ice_customer_id = t.primary_ice_id
)
;
drop table freq_caller_call_detail purge;
drop table freq_caller_call_topics purge;
-----------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------bringing together base with vulnerability and call --------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------------------------

create table dnd_freq_caller_overview pctfree 0 compress parallel 16 as
(
SELECT    to_char(c.ice_customer_id)
,         c.premise_id
,         c.customer_tenure_band
,         c.residential_segment
,         c.subengaged
,         c.age_band_actual
,         c.css_registered 
,         c.calls_l12m
,         cll.call_vol as calls_ans_by_advisor
,         c.complaints_l12m
,         c.closed_complaints_total_vol
,         c.open_complaints_total_vol
,         c.ombds_complaints_total_vol
,         c.vulnerable 
,         v.vuln_group
,         v.no_vulnerabilities
,         v.age_vuln
,         v.financial_vuln
,         v.health_physical_vuln
,         v.health_sensory_vuln
,         v.life_event_vuln
,         v.mental_health_vuln
,         c.fuel_type
,         c.df_bill_type
,         c.num_premises
,         c.smart_flag
,         c.current_balance
,         c.payment_method
,         c.elec_payment_method
,         c.elec_payment_method_group
,         c.gas_payment_method
,         c.gas_payment_method_group
,         c.postcode
,         c.property_residence_type
,         c.property_occupancy_type
,         c.property_build_year_band
,         c.mosaic_type_desc
,         c.mosaic_group_desc
,         c.mos_digital_group
,         c.mosaic_age_band
,         c.hh_income_band
,         c.postcode_mosaic_group
,         c.postcode_digital_group
,         c.css_login_l12m
,         c.app_login_l12m
,         c.ivr_calls_l12m
,         c.ivr_complete
,         c.nps_eon
,         c.heartbeat_l12m
,         c.customer_journey
,         c.number_of_households_l5y
,         c.number_of_occupants_l5y
,         c.marketing_consent_mail
,         c.marketing_consent_email
,         c.marketing_consent_phone
,         c.marketing_consent_sms
,         c.eligible_for_email
,         c.eligible_for_dm
,         c.eligible_for_sms
,         c.warm_home_disc
,         c.acquisition_method
,         c.acquisition_channel
,         c.months_to_renew
,         c.previous_supplier
,         c.engagement_segmentation
,         c.num_elec_accounts
,         c.num_gas_accounts
,         c.elec_account_reference
,         c.elec_base_id
,         c.elec_prod_type
,         c.elec_product_group
,         c.elec_product_subgroup
,         c.elec_product_description
,         c.elec_financial_account_ref
,         c.elec_billing_freq
,         c.mpan
,         c.elec_annual_consumption
,         c.gas_account_reference
,         c.gas_base_id
,         c.gas_prod_type
,         c.gas_product_group
,         c.gas_product_subgroup
,         c.gas_product_description
,         c.gas_financial_account_ref
,         c.gas_billing_freq
,         c.mpr
,         c.gas_annual_consumption
from      freq_caller_base_w_comp c
left join freq_caller_vuln_groups v
on        c.ice_customer_id = v.ice_customer_id
left join call_stg cll
on        c.ice_customer_id = cll.ice_customer_id
)
;
-- clean up
drop table call_stg purge;
drop table freq_caller_base_w_comp purge;
drop table freq_caller_vuln_groups purge;
------------------------------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------Additional data - QNSB, task volumes, collect journey------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------
create table tmp_qnsb_vol compress as
(
SELECT    count(distinct a.activity_id) no_qnsb_payments
,         a.ice_customer_id
from      AML_T_QNSB_AREA_DATA a
where     a.ice_customer_id in (select ice_customer_id from dnd_freq_caller_overview)
and       a.date_requested >= '01 Jan 2020'
and       a.date_requested <= '31 Dec 2020'
group by  a.ice_customer_id
)
;
drop table tmp_qnsb_detail purge;
create table tmp_qnsb_detail compress as
(
SELECT    distinct a.activity_id
,         a.date_requested
,         a.gross_amount
,         a.ex_gratia_description
,         b.ice_customer_id
from      dnd_freq_caller_overview b
join      AML_T_QNSB_AREA_DATA a
on        b.ice_customer_id = a.ice_customer_id
where     /*a.ice_customer_id in (select ice_customer_id from dnd_freq_caller_overview)
and     */  a.date_requested >= '01 Jan 2020'
and       a.date_requested <= '31 Dec 2020'
--and       a.dw_to_date >= sysdate
)
;
create table temp_collect pctfree 0 compress as
(
select count (distinct c.state_entry_date)as times_entered_collect
,      c.ice_customer_id
from ae_aml.aml_t_cf_mi_collect_journey c
where c.previous_state_code = 'ENTERED COLLECT'
and c.ice_customer_id in (select ice_customer_id from dnd_freq_caller_overview)
and c.state_entry_date between '01 jan 2020' and '31 Dec 2020'
group by c.ice_customer_id
)
;
create table tmp_task_volumes compress pctfree 0 as
(
select count (distinct task_list_id) vol_open_tasklists
,      count (distinct task_id) vol_live_tasks
,      ice_customer_id
from   cds_v_task
where  ice_customer_id in (select ice_customer_id from dnd_freq_caller_overview)
and    Complete_flag = 'N'
group by ice_customer_id
)
;
drop table tmp_task_detail purge;
create table tmp_task_detail compress pctfree 0 parallel 16 as
(
select min(t.task_creation_date) as earliest_task_date
,      t.task_list_id
,      a.ice_customer_id
,      d.task_list_name
,      d.can_bulkclose_flag
from   dnd_freq_caller_overview a
join   cds_v_task t
on     a.ice_customer_id = t.ice_customer_id
join   dim_t_task_list d
on     t.task_list_id = d.task_list_id
and    d.dw_to_date >= sysdate 
where  t.Complete_flag = 'N'
group by t.task_list_id
,      a.ice_customer_id
,      d.task_list_name
,      d.can_bulkclose_flag
)
;
drop table dnd_freq_caller_addi_info purge;
create table dnd_freq_caller_addi_info compress pctfree 0 parallel 16 as
(
select    d.ice_customer_id
,         a.no_qnsb_payments
,         b.times_entered_collect
,         c.vol_open_tasks
from      dnd_freq_caller_overview d
left join tmp_qnsb_vol a
on        a.ice_customer_id = d.ice_customer_id
left join temp_collect b
on        d.ice_customer_id = b.ice_customer_id
left join tmp_task_volumes c
on        d.ice_customer_id = c.ice_customer_id
)
;
drop table tmp_qnsb_vol purge;
drop table temp_collect purge;
drop table tmp_task_volumes purge;
------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------ output tables ---------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------

-- a39843.dnd_freq_caller_overview -- rolled up data for all inc vuln, complaint, call vols, chat vols, segmentation data etc
-- a39843.dnd_freq_caller_call_detail -- call detail data including call sequence and topics
-- a39843.dnd_dim_freq_caller_vuln_group -- gives deatils of which vuln groups are in which vuln group code 
-- a39843.dnd_freq_caller_addi_info -- adds in QNSB, Collect & Tasklist Volumes
-- a39843.tmp_qnsb_detail-- details of qnsb payments
-- a39843.tmp_task_detail-- details of live tasks

grant select on dnd_freq_caller_overview to ae_qlik, D22711;
commit;
grant select on dnd_freq_caller_call_detail to ae_qlik, D22711, C15128, D9892, J4006, J46697;
commit;
grant select on dnd_dim_freq_caller_vuln_group to ae_qlik, D22711, C15128, D9892, J4006, J46697;
commit;
grant select on dnd_freq_caller_addi_info to ae_qlik, D22711, C15128, D9892, J4006, J46697;
commit;
grant select on tmp_qnsb_detail to ae_qlik, D22711, C15128, D9892, J4006, J46697;
commit;
grant select on tmp_task_detail to ae_qlik, D22711, C15128, D9892, J4006, J46697;
commit;



