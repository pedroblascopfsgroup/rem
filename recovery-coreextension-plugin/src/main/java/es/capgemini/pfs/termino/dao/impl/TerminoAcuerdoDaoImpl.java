package es.capgemini.pfs.termino.dao.impl;

import java.util.List;

import org.springframework.stereotype.Repository;

import es.capgemini.pfs.dao.AbstractEntityDao;
import es.capgemini.pfs.termino.dao.TerminoAcuerdoDao;
import es.capgemini.pfs.termino.model.TerminoAcuerdo;
import es.pfsgroup.commons.utils.HQLBuilder;
import es.pfsgroup.commons.utils.HibernateQueryUtils;

/**
 * @author AMQ
 *
 */
@Repository("TerminoAcuerdoDao")
public class TerminoAcuerdoDaoImpl extends AbstractEntityDao<TerminoAcuerdo, Long> implements TerminoAcuerdoDao {

	@Override
	public List<TerminoAcuerdo> buscarTerminosPorTipo(Long idAcuerdo,String  codigoTipoAcuerdo) {
		
		HQLBuilder hb = new HQLBuilder(" from TerminoAcuerdo termino ");		
		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "termino.acuerdo.id", idAcuerdo);
		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "termino.tipoAcuerdo.codigo", codigoTipoAcuerdo);
		
		return HibernateQueryUtils.list(this, hb);
	}

 
}
