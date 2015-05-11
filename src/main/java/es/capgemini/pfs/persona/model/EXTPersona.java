package es.capgemini.pfs.persona.model;

import javax.persistence.Entity;

@Entity
public class EXTPersona  extends Persona{

	/**
	 * 
	 */
	private static final long serialVersionUID = -6687797034862802091L;
	
	// MOVIDA TODA LA FUNCIONALIDAD AL PROYECTO REC-COMMON
	
	
	 
	
//	 @Formula (value= " (select COALESCE ( "+
//			 		  " (select case when count(p.per_id)>0 then 'Fallidos de asuntos en concurso' else null end "+
//			 		  " FROM PER_PERSONAS p , PRC_PER prc , PRC_PROCEDIMIENTOS pro, ASU_ASUNTOS asu "+
//			 		  "  where p.per_id = prc.per_id and prc.prc_id = pro.prc_id and pro.asu_id = asu.asu_id "+
//			 		  " and p.dd_efc_id in (108,101,106)  and pro.dd_tac_id = 3 and p.per_id = per.per_id ),"+
//			 		  
//			 		  " (select case when count(p.per_id) > 0 then 'Concurso' else null end "+
//			 		  "  	FROM PER_PERSONAS p , PRC_PER prc , PRC_PROCEDIMIENTOS pro "+
//			 		 "   	where p.per_id = prc.per_id and prc.prc_id = pro.prc_id and pro.dd_tac_id = 3 and p.per_id = per.per_id), "+
//			 		 
//			 		 " ( select case when count(p.per_id) > 0 then 'Fallidos de asuntos en litigio no Concurso' else null end "+
//			 		 " 		FROM PER_PERSONAS p , PRC_PER prc , PRC_PROCEDIMIENTOS pro, ASU_ASUNTOS asu  "+
//			 		 " where p.per_id = prc.per_id and prc.prc_id = pro.prc_id and pro.asu_id = asu.asu_id  "+
//			 		 " and p.dd_efc_id in (108,101,106)  and p.per_id = per.per_id  and p.per_id  not in (SELECT per.per_id "+
//			 		 																				" from PRC_PER per,PRC_PROCEDIMIENTOS pro "+
//			 		 																				" where   per.prc_id = pro.prc_id and pro.dd_tac_id = 3  )), " +
//			 		 
//					" ( select case when count(p.per_id) > 0 then 'Litigio no concursal' else null end "+
//			 		 " 		FROM PER_PERSONAS p , PRC_PER prc , PRC_PROCEDIMIENTOS pro, ASU_ASUNTOS asu  "+
//			 		 " where p.per_id = prc.per_id and prc.prc_id = pro.prc_id and pro.asu_id = asu.asu_id and p.dd_efc_id not in (108,101,106) "+
//			 		 "  and p.per_id = per.per_id  and p.per_id  not in (SELECT per.per_id "+
//																	" from PRC_PER per,PRC_PROCEDIMIENTOS pro "+
//																	" where   per.prc_id = pro.prc_id and (pro.dd_tac_id = 3 or pro.dd_tpo_id = 643)  )), " +
//					
//					" ( SELECT case when count(p.per_id) > 0 then 'Dudoso no litigio' else null end " +
//					"  FROM PER_PERSONAS p where p.dd_efc_id  in (103,107) and p.per_id not in (select prc.per_id FROM PRC_PER prc , PRC_PROCEDIMIENTOS pro, ASU_ASUNTOS asu " +
//					" where prc.prc_id = pro.prc_id and pro.asu_id = asu.asu_id)),"+																	
//			 		 																				
//	 			" '') from PER_PERSONAS per where per.per_id = PER_ID )")
//	private String situacionFinancieraPersona;
	
	
	

}
