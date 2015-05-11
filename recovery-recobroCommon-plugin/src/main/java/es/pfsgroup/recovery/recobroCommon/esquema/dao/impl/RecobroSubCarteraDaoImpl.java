package es.pfsgroup.recovery.recobroCommon.esquema.dao.impl;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

import org.springframework.stereotype.Repository;

import com.sun.org.apache.bcel.internal.generic.CPInstruction;

import es.capgemini.pfs.dao.AbstractEntityDao;
import es.pfsgroup.commons.utils.DateFormat;
import es.pfsgroup.recovery.recobroCommon.esquema.dao.api.RecobroSubCarteraDao;
import es.pfsgroup.recovery.recobroCommon.esquema.model.RecobroEsquema;
import es.pfsgroup.recovery.recobroCommon.esquema.model.RecobroSubCartera;

@Repository("RecobroSubCarteraDao")
public class RecobroSubCarteraDaoImpl extends AbstractEntityDao<RecobroSubCartera, Long> implements RecobroSubCarteraDao{

	@SuppressWarnings("unchecked")
	public List<RecobroSubCartera> getSubCarteraByItinerario(Long idItinerario){
		
		List<RecobroSubCartera> list =  null;
		
        String hsql = "select distinct sc from RecobroSubCartera sc ";
        hsql += " where sc.itinerarioMetasVolantes.id = " + idItinerario;

        list = getHibernateTemplate().find(hsql);

        return list;
        
	}

	@Override
	public RecobroSubCartera getSubcarteraPorNombreYEsquema(
			RecobroEsquema esquema, RecobroSubCartera subcarteraOriginal) {
		
		String hsql = "select distinct sc from RecobroSubCartera sc, RecobroCarteraEsquema ca, RecobroEsquema eq ";
		hsql += " WHERE sc.auditoria.borrado = 0 AND " +
				"       ca.auditoria.borrado = 0 AND " +
				"		ca.id = sc.carteraEsquema.id AND " +
				"		eq.id = ca.esquema.id AND "	+
				"       eq.auditoria.borrado = 0 AND " +
				"       eq.id = " + esquema.getId() + " AND " +
				"       sc.nombre = '" + subcarteraOriginal.getNombre() +"' ";
		
		List<RecobroSubCartera> ret = getHibernateTemplate().find(hsql.toString());
		
		return ret.size() == 0 ? null : ret.get(0);
        
	}
}
