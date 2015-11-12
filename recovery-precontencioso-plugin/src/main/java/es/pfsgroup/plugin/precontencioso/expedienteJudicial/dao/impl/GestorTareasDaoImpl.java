package es.pfsgroup.plugin.precontencioso.expedienteJudicial.dao.impl;

import java.io.Serializable;
import java.math.BigDecimal;
import java.util.List;

import org.hibernate.Hibernate;
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

}
