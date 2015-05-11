package es.pfsgroup.recovery.recobroCommon.esquema.dao.impl;

import java.util.List;

import org.springframework.stereotype.Repository;

import es.capgemini.pfs.dao.AbstractEntityDao;
import es.pfsgroup.recovery.recobroCommon.esquema.dao.api.RecobroSubCarteraAgenciaDao;
import es.pfsgroup.recovery.recobroCommon.esquema.model.RecobroSubCartera;
import es.pfsgroup.recovery.recobroCommon.esquema.model.RecobroSubcarteraAgencia;

@Repository("RecobroSubCarteraAgenciaDao")
public class RecobroSubCarteraAgenciaDaoImpl extends AbstractEntityDao<RecobroSubcarteraAgencia, Long> implements RecobroSubCarteraAgenciaDao{

	@Override
	public RecobroSubcarteraAgencia getSubcarteraAgenciaPorAgenciaYSubCartera(
			RecobroSubCartera subCartera,RecobroSubcarteraAgencia subcarteraAgenciaOriginal) 
	{
				String hsql = "select distinct sca from RecobroSubcarteraAgencia sca, RecobroSubCartera sc ";
				hsql += " WHERE sca.subCartera.id = sc.id AND " +
						"		sca.auditoria.borrado = 0 AND " +
						"		sc.auditoria.borrado = 0 AND " +
						"		sc.id = " + subCartera.getId() + " AND " +
						"		sca.agencia.id = " + subcarteraAgenciaOriginal.getAgencia().getId();	
				
				List<RecobroSubcarteraAgencia> ret = getHibernateTemplate().find(hsql.toString());
		
		return ret.size() == 0 ? null : ret.get(0);
	}

}
