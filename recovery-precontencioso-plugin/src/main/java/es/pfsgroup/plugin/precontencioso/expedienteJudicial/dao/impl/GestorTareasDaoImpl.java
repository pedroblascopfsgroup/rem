package es.pfsgroup.plugin.precontencioso.expedienteJudicial.dao.impl;

import java.io.Serializable;
import java.math.BigDecimal;
import java.util.List;

import org.hibernate.Hibernate;
import org.hibernate.SQLQuery;
import org.hibernate.Session;
import org.hibernate.type.Type;
import org.springframework.dao.EmptyResultDataAccessException;
import org.springframework.stereotype.Repository;

import es.capgemini.pfs.dao.AbstractEntityDao;
import es.capgemini.pfs.procesosJudiciales.model.TareaExterna;
import es.pfsgroup.plugin.precontencioso.expedienteJudicial.dao.GestorTareasDao;

@Repository("GestorTareasDao")
public class GestorTareasDaoImpl extends AbstractEntityDao<Serializable, Long>
		implements GestorTareasDao {

	private static final String CONSULTA_BPMPROCESS = " select t from TareaExterna t where t.tareaPadre.procedimiento.processBPM = ? ";

	@Override
	public Long getTokenId(Long idProcessBPM) {
		List<?> result = getHibernateTemplate().find(CONSULTA_BPMPROCESS,
				idProcessBPM);
		if (result.size() > 0) {
			return ((TareaExterna) result.get(0)).getTokenIdBpm();
		}
		return null;
	}

	@Override
	public boolean evaluaCondicion(Long idProc, String condicion) {
		
		boolean resultado=false;
		
		try {
			Object[] args = new Object[] { idProc };
			Type[] argsTypes = new Type[] { Hibernate.LONG };
			BigDecimal cuenta = (BigDecimal) getSession()
					.createSQLQuery(condicion)
					.setParameters(args, argsTypes).uniqueResult();
			resultado = (cuenta.intValue() > 0);
		} catch (EmptyResultDataAccessException e) {
			logger.error("evaluaCondicion: " + e);
			e.printStackTrace();
		}
		
		return resultado;
	}

	@Override
	public String obtenerSubtipoTarea(String codigoTarea) {
		
		String resultado = "";
		try {
			resultado = (String) getSession().createSQLQuery("SELECT DD_STA_CODIGO FROM ${master.schema}.dd_sta_subtipo_tarea_base STA " + 
					"INNER JOIN tap_tarea_procedimiento TAP ON TAP.DD_STA_ID=STA.DD_STA_ID WHERE TAP_CODIGO='" + codigoTarea + "'").uniqueResult();
		} catch (EmptyResultDataAccessException e) {
			e.printStackTrace();
		}
		
		return resultado;

	}
	
	@Override
	public Long getNodeByCodTapAndIdProcesDefinition(Long idProcesDefinition, String codTap){
		String sql ="SELECT ID_ FROM ${master.schema}.JBPM_NODE WHERE PROCESSDEFINITION_ = "+idProcesDefinition+" AND NAME_ ='"+codTap+"'";
		SQLQuery sqlQuery = getSessionFactory().getCurrentSession().createSQLQuery(sql);
		Object idNode = sqlQuery.uniqueResult();
		return Long.valueOf(idNode.toString());
	}
	
	@Override
	public void updateNodeToken(Long idToken, Long idNode){
        String sql = "UPDATE ${master.schema}.JBPM_TOKEN SET NODE_ = " + idNode + " WHERE ID_ = " + idToken;
        Session sesion = getSession();
        sesion.createSQLQuery(sql).executeUpdate();
	}
	
	@Override
	public Long getProcesDefinition(Long processinstance){
		String sql ="SELECT PROCESSDEFINITION_ FROM ${master.schema}.JBPM_PROCESSINSTANCE WHERE ID_ = "+processinstance;
		SQLQuery sqlQuery = getSessionFactory().getCurrentSession().createSQLQuery(sql);
		Object idNode = sqlQuery.uniqueResult();
		return Long.valueOf(idNode.toString());
	}
}
