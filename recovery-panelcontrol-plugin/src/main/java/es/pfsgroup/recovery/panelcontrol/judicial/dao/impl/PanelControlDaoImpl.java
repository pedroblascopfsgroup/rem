package es.pfsgroup.recovery.panelcontrol.judicial.dao.impl;

import java.util.ArrayList;
import java.util.List;

import org.hibernate.Hibernate;
import org.hibernate.SQLQuery;
import org.hibernate.transform.Transformers;
import org.springframework.stereotype.Repository;

import es.capgemini.pfs.dao.AbstractEntityDao;
import es.capgemini.pfs.movimiento.model.Movimiento;
import es.capgemini.pfs.zona.model.DDZona;
import es.pfsgroup.recovery.panelcontrol.judicial.dao.PanelControlDao;
import es.pfsgroup.recovery.panelcontrol.judicial.dto.DtoPanelControl;

@Repository
public class PanelControlDaoImpl extends AbstractEntityDao<Movimiento, Long>  implements PanelControlDao{



	private List<String> obtenerCodigosZona(List<DDZona> zonas){
		List<String> lista = new ArrayList<String>();
		
		for(DDZona zona:zonas){
			lista.add(zona.getCodigo());
		}
		return lista;
	}
	
	/****
	 * Obtiene los datos de total de clientes, contratos, contratos irregulares y saldos.
	 * Se realiza una native query porque las subconsultas en la clausula from no estan permitidas en hibernate
	 * 
	 * */
	@SuppressWarnings("unchecked")
	public List<DtoPanelControl> getListaCompleta(Long nivel, Long id,List<DDZona> zonas){
		
		List<String> listaCodigosZona = obtenerCodigosZona(zonas);
		
		String subQueryClientes = crearSubQueryNumClientes(nivel, id,listaCodigosZona);
		String subQuerySaldos = crearSubQueryTotalSaldo(nivel,id,listaCodigosZona);
		String subQueryContratos = crearSubQueryNumContratos(nivel, id,listaCodigosZona);
		String subQueryContratosIrregulares = crearSubQueryNumContratosIrregulares(nivel, id,listaCodigosZona);
		String subQuerySaldoDanyado = crearSubQuerySaldoDanyado(nivel, id, listaCodigosZona);
		
		String queryString="select clientes.ofiCodigo as ofiCodigo ,clientes.zon_cod as cod, clientes.zon_id as id,clientes.zon_descripcion as nivel,  clientes.suma as clientes, contratos.suma  as contratosTotal, contratosI.suma as contratosIrregulares, saldos.sumaSaldoVencido  as saldoVencido, saldos.sumaSaldoNoVencido as saldoNoVencido,saldoDA.suma as saldoNoVencidoDanyado  from "
							+subQueryClientes+","+subQuerySaldos+","+subQueryContratos+","+subQueryContratosIrregulares+","+subQuerySaldoDanyado;
		queryString += " where clientes.zon_id = contratos.zon_id and clientes.zon_Id = contratosI.zon_id and clientes.zon_Id = saldos.zon_Id and clientes.zon_id = saldoDA.zonId ";
	
		queryString += " order by nivel asc";
		
		SQLQuery sqlQuery = getHibernateTemplate().getSessionFactory().getCurrentSession().createSQLQuery(queryString);
		sqlQuery.addScalar("ofiCodigo",Hibernate.STRING);
		sqlQuery.addScalar("id",Hibernate.LONG);
		sqlQuery.addScalar("cod",Hibernate.STRING);
		sqlQuery.addScalar("nivel",Hibernate.STRING);
		sqlQuery.addScalar("clientes",Hibernate.INTEGER);
		sqlQuery.addScalar("contratosTotal",Hibernate.INTEGER);
		sqlQuery.addScalar("contratosIrregulares",Hibernate.INTEGER);
		sqlQuery.addScalar("saldoVencido",Hibernate.FLOAT);
		sqlQuery.addScalar("saldoNoVencido",Hibernate.FLOAT);
		sqlQuery.addScalar("saldoNoVencidoDanyado",Hibernate.FLOAT);
		sqlQuery.setResultTransformer(Transformers.aliasToBean(DtoPanelControl.class));
		
		List<DtoPanelControl> lista = sqlQuery.list();
		return lista;
		
	}
	
	private String crearSubQueryNumClientes(Long nivel, Long id,List<String> codigosZona){
		StringBuffer subQuery = new StringBuffer();

		subQuery.append(" ( select o.ofi_codigo as ofiCodigo, z.zon_cod, z.zon_id, z.zon_descripcion,sum(sub.cuenta) as suma ");
		subQuery.append(" from zon_zonificacion z, ofi_oficinas o, ");
		subQuery.append(" (select z.zon_cod as subCod, count(c.cli_id) as cuenta from zon_zonificacion z,cli_clientes c where z.ofi_id = c.ofi_id  group by z.zon_cod ) sub ");
        subQuery.append(" where z.niv_id = "+nivel+" and z.ofi_id = o.ofi_id and ");
       
        
        //FILTRAMOS POR ZONAS
		if(id != null && !id.equals(0L)){
			subQuery.append(" ( ");
        	for(String codZona:codigosZona){
        		subQuery.append(" (sub.subCod like '"+codZona+"%'  and z.zon_cod like  '"+codZona+"') or");
        	}
	        subQuery.deleteCharAt(subQuery.length() - 1);
	        subQuery.deleteCharAt(subQuery.length() - 1);	
	        
	        subQuery.append(" ) ");
		}
		else{
			subQuery.append(" ( ");
        	for(String codZona:codigosZona){
        		subQuery.append(" (sub.subCod like '"+codZona+"_%'  and z.zon_cod like  '"+codZona+"') or");
        	}
	        subQuery.deleteCharAt(subQuery.length() - 1);
	        subQuery.deleteCharAt(subQuery.length() - 1);	
	        
	        subQuery.append(" ) ");
		}
        
        subQuery.append(" group by o.ofi_codigo,z.zon_cod,z.zon_id,z.zon_descripcion  ");
        subQuery.append(" )  clientes ");
		return subQuery.toString();
	}
	private String crearSubQueryNumContratos(Long nivel, Long id,List<String> codigosZona){
		StringBuffer subQuery = new StringBuffer();
		
		subQuery.append(" (select zon_id, sum(subCont.contCont)  as suma ");
		subQuery.append(" from zon_zonificacion, ");
		subQuery.append(" (select z.zon_cod as subCod, count(c.cnt_id) as contCont from cnt_contratos c, zon_zonificacion z where c.OFI_ID = z.ofi_id  and c.borrado = 0 group by z.zon_cod) subCont ");
		subQuery.append(" where niv_id = "+nivel+" and ");
		 //FILTRAMOS POR ZONAS
        
		if(id != null && !id.equals(0L)){
			subQuery.append(" ( ");
        	for(String codZona:codigosZona){
        		subQuery.append(" (subCont.subCod like '"+codZona+"%'  and zon_cod like  '"+codZona+"') or");
        	}
	        subQuery.deleteCharAt(subQuery.length() - 1);
	        subQuery.deleteCharAt(subQuery.length() - 1);	
	        
	        subQuery.append(" ) ");
		}
		else{
			subQuery.append(" ( ");
        	for(String codZona:codigosZona){
        		subQuery.append(" (subCont.subCod like '"+codZona+"_%'  and zon_cod like  '"+codZona+"') or");
        	}
	        subQuery.deleteCharAt(subQuery.length() - 1);
	        subQuery.deleteCharAt(subQuery.length() - 1);	
	        
	        subQuery.append(" ) ");
		}
		
        
        subQuery.append(" group by zon_id  ");
        subQuery.append(" )  contratos ");
		    
		return subQuery.toString();
	}
	private String crearSubQueryNumContratosIrregulares(Long nivel, Long id,List<String> codigosZona){
		StringBuffer subQuery = new StringBuffer();
		subQuery.append(" (select zon_id,sum(subContI.contCont)  as suma ");
		subQuery.append(" from zon_zonificacion, ");
		subQuery.append(" (select  subSub.subCod as subCod, count(subSub.contCont)as contCont  from (select distinct z.zon_cod   as subCod,c.cnt_id as contCont from cnt_contratos c,mov_movimientos m, zon_zonificacion z    where   c.CNT_ID = m.cnt_id and c.CNT_FECHA_EXTRACCION = m.MOV_FECHA_EXTRACCION and m.MOV_POS_VIVA_VENCIDA <> 0 and c.ZON_ID = z.ZON_ID and c.borrado = 0 and m.borrado = 0)  subSub  group by subSub.subCod ) subContI ");
		subQuery.append(" where niv_id = "+nivel+" and ");
		//FILTRAMOS POR ZONAS
        
		if(id != null && !id.equals(0L)){
			subQuery.append(" ( ");
        	for(String codZona:codigosZona){
        		subQuery.append(" (subContI.subCod like '"+codZona+"%'  and zon_cod like  '"+codZona+"') or");
        	}
	        subQuery.deleteCharAt(subQuery.length() - 1);
	        subQuery.deleteCharAt(subQuery.length() - 1);	
	        
	        subQuery.append(" ) ");
		}
		else{
			subQuery.append(" ( ");
        	for(String codZona:codigosZona){
        		subQuery.append(" (subContI.subCod like '"+codZona+"_%'  and zon_cod like  '"+codZona+"') or");
        	}
	        subQuery.deleteCharAt(subQuery.length() - 1);
	        subQuery.deleteCharAt(subQuery.length() - 1);	
	        
	        subQuery.append(" ) ");
		}
        
        subQuery.append(" group by zon_id ");
        subQuery.append(" )  contratosI ");
		
		     
		return subQuery.toString();
	}
	private String crearSubQueryTotalSaldo(Long nivel, Long id,List<String> codigosZona){
		StringBuffer subQuery = new StringBuffer();
		
		subQuery.append("(select zon_id, sum(subSaldo.sumSaldoVencido)  as sumaSaldoVencido,sum(subSaldo.sumSaldoNoVencido)  as sumaSaldoNoVencido ");
		subQuery.append(" from zon_zonificacion, ");
		subQuery.append(" (select z.zon_cod as subCod , SUM(m.mov_pos_viva_vencida) as sumSaldoVencido,SUM(m.mov_pos_viva_no_vencida) as sumSaldoNoVencido from cnt_contratos c, zon_zonificacion z,mov_movimientos m where   c.ofi_id = z.ofi_id and m.CNT_ID = c.CNT_ID and m.MOV_FECHA_EXTRACCION = c.CNT_FECHA_EXTRACCION and c.borrado = 0 and m.borrado = 0 group by z.zon_cod)  subSaldo");
		subQuery.append(" where niv_id = "+nivel+" and ");
		//FILTRAMOS POR ZONAS
        
		if(id != null && !id.equals(0L)){
			subQuery.append(" ( ");
        	for(String codZona:codigosZona){
        		subQuery.append(" (subSaldo.subCod like '"+codZona+"%'  and zon_cod like  '"+codZona+"') or");
        	}
	        subQuery.deleteCharAt(subQuery.length() - 1);
	        subQuery.deleteCharAt(subQuery.length() - 1);	
	        
	        subQuery.append(" ) ");
		}
		else{
			subQuery.append(" ( ");
        	for(String codZona:codigosZona){
        		subQuery.append(" (subSaldo.subCod like '"+codZona+"_%'  and zon_cod like  '"+codZona+"') or");
        	}
	        subQuery.deleteCharAt(subQuery.length() - 1);
	        subQuery.deleteCharAt(subQuery.length() - 1);	
	        
	        subQuery.append(" ) ");
		}
		   
		subQuery.append(" group by zon_id) saldos ");
		return subQuery.toString();
	}

	private String crearSubQuerySaldoDanyado(Long nivel, Long id,List<String> codigosZona) {
		StringBuffer query = new StringBuffer();
		query.append(" (select zon_id as zonId, zon_cod as cod, sum(sub2.snv) as suma from zon_zonificacion, ( ");
		query.append("  select sub.id as id, sub.cod as cod, sub.cntId as cntId, sub.snv as snv, sub.sv as sv,sub.perId as perId, sum(sub.mpvv) as svc  from ( ");
		query.append(" select z.zon_id as id,z.zon_cod as cod,cnt.cnt_id as cntId , mov.mov_pos_viva_no_vencida snv, mov.mov_pos_viva_vencida sv, per.per_id as perId ");
		query.append("  , mov2.mov_pos_viva_vencida as mpvv,rank() over (partition by cnt.cnt_id order by cpe.cpe_id) as ranking  ");
		query.append("  from cnt_contratos cnt ");
		query.append(" join zon_zonificacion z on cnt.ofi_id = z.ofi_id ");
		
		
		//FILTRAMOS POR ZONAS
        query.append(" and ( ");
		if(id != null && !id.equals(0L)){
        	for(String codZona:codigosZona){
        		query.append(" z.zon_cod like '"+codZona+"%' or");
        	}
        	query.deleteCharAt(query.length() - 1);
        	query.deleteCharAt(query.length() - 1);	
	        
	        
		}
		else{
        	for(String codZona:codigosZona){
        		query.append(" z.zon_cod like '"+codZona+"_%' or");
        	}
        	query.deleteCharAt(query.length() - 1);
        	query.deleteCharAt(query.length() - 1);	
	        
		}
		query.append(" ) ");
		
		query.append(" join mov_movimientos mov on cnt.cnt_id = mov.cnt_id and cnt.cnt_fecha_extraccion = mov.mov_fecha_extraccion ");
		query.append(" join cpe_contratos_personas cpe on cnt.cnt_id = cpe.cnt_id and (cpe.dd_tin_id = 208 or cpe.dd_tin_id = 210)  ");
		query.append("  join per_personas per on cpe.per_id = per.per_id ");
		query.append(" join cpe_contratos_personas cpe2 on per.per_id = cpe2.per_id ");
		query.append(" join cnt_contratos cnt2 on cpe2.cnt_id = cnt2.cnt_id and cnt2.borrado = 0 ");
		query.append(" left join mov_movimientos mov2 on cnt2.cnt_id = mov2.cnt_id and cnt2.cnt_fecha_extraccion = mov2.mov_fecha_extraccion  and mov2.MOV_POS_VIVA_VENCIDA != 0 ");
		
    	
    	query.append(" where cnt.borrado = 0 and mov.MOV_POS_VIVA_VENCIDA = 0 ) sub");	
		query.append(" where sub.ranking = 1 ");
		query.append(" group by  id,cod,cntId, snv, sv, perId ) sub2 where svc !=0 ");
		
		query.append(" and ( ");
		if(id != null && !id.equals(0L)){
			for(String codZona:codigosZona){
	    		query.append(" (zon_cod like '"+codZona+"%' and sub2.cod like '"+codZona+"%' ) or") ;
	    	}
		}
		else{
			for(String codZona:codigosZona){
	    		query.append(" (zon_cod like '"+codZona+"%' and sub2.cod like '"+codZona+"_%' ) or") ;
	    	}
		}
			
    	query.deleteCharAt(query.length() - 1);
    	query.deleteCharAt(query.length() - 1);	
    	
    	query.append(" ) ");	
		
		query.append(" group by zon_id,zon_cod ) saldoDA");
		
		//System.out.println("subquery : "+query.toString());
		
		return query.toString();
	}
	

}
