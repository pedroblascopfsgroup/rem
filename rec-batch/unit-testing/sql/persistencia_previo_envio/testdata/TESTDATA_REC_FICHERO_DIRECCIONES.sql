update dir_direcciones set dd_loc_id = mod(dir_id, 1000) +1
where dd_loc_id is null
  and dir_id in (select dir_id from dir_per where per_id in (select per_id from TMP_REC_EXP_AGE_MAR_GES));
  
  
update dir_direcciones set dd_tvi_id = mod(dir_id, 4) +1
where dd_tvi_id is null
  and dir_id in (select dir_id from dir_per where per_id in (select per_id from TMP_REC_EXP_AGE_MAR_GES));
  
commit;  