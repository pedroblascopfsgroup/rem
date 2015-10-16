package es.capgemini.pfs.termino.dao.impl;

import java.util.List;

import org.springframework.stereotype.Repository;

import es.capgemini.pfs.dao.AbstractEntityDao;
import es.capgemini.pfs.termino.dao.CamposTerminoTipoAcuerdoDao;
import es.capgemini.pfs.termino.model.CamposTerminoTipoAcuerdo;
import es.pfsgroup.commons.utils.HQLBuilder;
import es.pfsgroup.commons.utils.HibernateQueryUtils;

/**
 * @author AMQ
 *
 */
@Repository("CamposTerminoTipoAcuerdoDao")
public class CamposTerminoTipoAcuerdoDaoImpl extends AbstractEntityDao<CamposTerminoTipoAcuerdo, Long> implements CamposTerminoTipoAcuerdoDao {

	@Override
	public List<CamposTerminoTipoAcuerdo> getCamposTerminosPorTipoAcuerdo(Long idTipoAcuerdo) {
		HQLBuilder hb = new HQLBuilder(" from CamposTerminoTipoAcuerdo campos ");		
		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "campos.tipoAcuerdo.id", idTipoAcuerdo);
		
		return HibernateQueryUtils.list(this, hb);
	}

 
}
