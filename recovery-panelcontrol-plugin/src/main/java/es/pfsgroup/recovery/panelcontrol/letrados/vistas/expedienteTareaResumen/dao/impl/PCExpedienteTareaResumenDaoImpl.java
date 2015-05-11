package es.pfsgroup.recovery.panelcontrol.letrados.vistas.expedienteTareaResumen.dao.impl;


import java.util.List;

import org.hibernate.SQLQuery;
import org.springframework.stereotype.Repository;
import es.capgemini.pfs.dao.AbstractEntityDao;
import es.pfsgroup.commons.utils.HQLBuilder;
import es.pfsgroup.commons.utils.HibernateQueryUtils;
import es.pfsgroup.recovery.panelcontrol.letrados.dto.DtoPanelControlFiltros;
import es.pfsgroup.recovery.panelcontrol.letrados.vistas.expedienteTareaResumen.dao.PCExpedienteTareaResumenDao;
import es.pfsgroup.recovery.panelcontrol.letrados.vistas.expedienteTareaResumen.model.PCExpedienteTareaResumen;

@Repository
public class PCExpedienteTareaResumenDaoImpl extends AbstractEntityDao<PCExpedienteTareaResumen, String> implements PCExpedienteTareaResumenDao {

	/**
	 * Recupera las tareas de los letrados a través de la vista resumen
	 * param id del letrado (US_USERNAME)
	 * resturn List<PCExpedienteTareaResumen>
	 */
	@Override
	public List<PCExpedienteTareaResumen>  buscaTareasPendientesLetradosPanelControl(String idLetrado) {
		
		HQLBuilder b = new HQLBuilder("from PCExpedienteTareaResumen tar");
		b.appendWhere(" tar.id like '"+ idLetrado +"'");
	
		return HibernateQueryUtils.list(this, b);
	}

	
	@Override
	public Long getNumeroExpedientes(String cod) {
		StringBuffer query = new StringBuffer();
		query.append(" select sum(tar.expediente) from PCExpedienteTareaResumen tar where  ");

		query.append(" tar.codigo like '"+cod+"%'");
		
		Long total = new Long(0);
		try{
			total = (Long)getSession().createQuery(query.toString()).uniqueResult();
		}
		catch(Exception e){
		}
		
		if(total==null){
			total=Long.parseLong("0");
		}
		return total;
	}
	
	@Override
	public Float getImporteExpedientes(String cod) {
		StringBuffer query = new StringBuffer();
		query.append(" select sum(tar.saldo) from PCExpedienteTareaResumen tar where  ");
		
		query.append(" tar.codigo like '"+cod+"%'");
		Float importe = new Float(0);
		try{
			importe = ((Double)getSession().createQuery(query.toString()).uniqueResult()).floatValue();
		}
		catch(Exception e){
		}
		return importe;
	}
	
	@Override
	public Long totalTareasPendientes(String cod,int rango) {
			StringBuffer query = new StringBuffer();
	        switch (rango) {
	        case 1:
	        	query.append(" select sum(tar.num_tv) from PCExpedienteTareaResumen tar where  ");
	            break;
	        case 2:
	        	query.append(" select sum(tar.num_pm) from PCExpedienteTareaResumen tar where  ");
	            break;
	        case 3:
	        	query.append(" select sum(tar.num_ps) from PCExpedienteTareaResumen tar where  ");
	            break;
	        case 4:
	        	query.append(" select sum(tar.num_ph) from PCExpedienteTareaResumen tar where  ");
	            break;
	        case 5:
	        	query.append(" select sum(tar.num_pmm) from PCExpedienteTareaResumen tar where  ");
	            break;
	        case 6:
	        	query.append(" select sum(tar.num_pa) from PCExpedienteTareaResumen tar where  ");
	            break;
	        case 9:
	        	query.append(" select sum(tar.num_fh) from PCExpedienteTareaResumen tar where  ");
	            break;
	        case 10:
	        	query.append(" select sum(tar.num_fs) from PCExpedienteTareaResumen tar where  ");
	            break;
	        case 11:
	        	query.append(" select sum(tar.num_fm) from PCExpedienteTareaResumen tar where  ");
	            break;
	        case 12:
	        	query.append(" select sum(tar.num_fa) from PCExpedienteTareaResumen tar where  ");
	            break;
	        case 13:
	        	query.append(" select sum(tar.num_tf) from PCExpedienteTareaResumen tar where  ");
	            break;    
	        case 14:
	        	query.append(" select sum(tar.num_vs) from PCExpedienteTareaResumen tar where  ");
	            break;
	  
	        case 15:
	        	query.append(" select sum(tar.num_v1m) from PCExpedienteTareaResumen tar where  ");
	            break;
	        case 16:
	        	query.append(" select sum(tar.num_v2m) from PCExpedienteTareaResumen tar where  ");
	            break;
	        case 17:
	        	query.append(" select sum(tar.num_v3m) from PCExpedienteTareaResumen tar where  ");
	            break;
	        case 18:
	        	query.append(" select sum(tar.num_v4m) from PCExpedienteTareaResumen tar where  ");
	            break;
	        case 19:
	        	query.append(" select sum(tar.num_v5m) from PCExpedienteTareaResumen tar where  ");
	            break;
	        case 20:
	        	query.append(" select sum(tar.num_v6m) from PCExpedienteTareaResumen tar where  ");
	            break;
	        case 21:
	        	query.append(" select sum(tar.num_vm6m) from PCExpedienteTareaResumen tar where  ");
	            break;
	        case 22:
	        	query.append(" select sum(tar.num_p2m) from PCExpedienteTareaResumen tar where  ");
	            break;    
	        case 23:
	        	query.append(" select sum(tar.num_p3m) from PCExpedienteTareaResumen tar where  ");
	            break; 
	        case 24:
	        	query.append(" select sum(tar.num_p4m) from PCExpedienteTareaResumen tar where  ");
	            break; 
	        case 25:
	        	query.append(" select sum(tar.num_p5m) from PCExpedienteTareaResumen tar where  ");
	            break; 
	        case 26:
	        	query.append(" select sum(tar.num_p6m) from PCExpedienteTareaResumen tar where  ");
	            break;     
	        default:
	            break;
	        }
			
			query.append(" tar.codigo like '"+cod+"%' ");
			
			Long total = new Long(0);
			try{
				total = (Long)getSession().createQuery(query.toString()).uniqueResult();
			}
			catch(Exception e){
			}
			
			if(total==null){
				total=Long.parseLong("0");
			}
			return total;
		}
	@Override
	public String getFechaRefresco(){
		
		String queryString="SELECT TO_CHAR(LAST_REFRESH_DATE,'DD/MM/YYYY HH:SS') FROM ALL_MVIEWS WHERE MVIEW_NAME = 'V_PC_COT_EXP_TAR_RESUMEN'";

		SQLQuery sqlQuery = getHibernateTemplate().getSessionFactory().getCurrentSession().createSQLQuery(queryString);
		
		String fechaRefresco = (String) sqlQuery.uniqueResult();
		return fechaRefresco;
		
	}
	
}