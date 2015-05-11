package es.pfsgroup.recovery.recobroCommon.metasVolantes.dao.impl;

import java.util.List;

import org.springframework.stereotype.Repository;

import es.capgemini.pfs.dao.AbstractEntityDao;
import es.pfsgroup.commons.utils.HQLBuilder;
import es.pfsgroup.commons.utils.HibernateQueryUtils;
import es.pfsgroup.recovery.recobroCommon.metasVolantes.dao.api.RecobroTipoMetaVolanteDao;
import es.pfsgroup.recovery.recobroCommon.metasVolantes.model.RecobroDDTipoMetaVolante;

/**
 * Clase de acceso a base de datos para la clase RecobroDDTipoMetaVolante
 * @author vanesa
 *
 */
@Repository("RecobroTipoMetaVolanteDao")
public class RecobroTipoMetaVolanteDaoImpl extends AbstractEntityDao<RecobroDDTipoMetaVolante, Long> implements RecobroTipoMetaVolanteDao{

	
	public List<RecobroDDTipoMetaVolante> getMetasVolantes(){
		
		HQLBuilder hb = new HQLBuilder("select distinct tipoMeta from RecobroDDTipoMetaVolante tipoMeta");
		hb.appendWhere("tipoMeta.auditoria.borrado = 0");
		
		return (List<RecobroDDTipoMetaVolante>) HibernateQueryUtils.list(this, hb);
		
	}

}
