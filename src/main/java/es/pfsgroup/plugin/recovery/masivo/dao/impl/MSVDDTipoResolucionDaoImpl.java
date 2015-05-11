package es.pfsgroup.plugin.recovery.masivo.dao.impl;

import java.util.List;

import org.springframework.stereotype.Repository;

import es.capgemini.pfs.dao.AbstractEntityDao;
import es.pfsgroup.commons.utils.HQLBuilder;
import es.pfsgroup.commons.utils.HibernateQueryUtils;
import es.pfsgroup.plugin.recovery.masivo.dao.MSVDDTipoResolucionDao;
import es.pfsgroup.plugin.recovery.masivo.model.MSVDDTipoResolucion;




@Repository("MSVDDTipoResolucionDao")
public class MSVDDTipoResolucionDaoImpl extends AbstractEntityDao<MSVDDTipoResolucion, Long> implements MSVDDTipoResolucionDao{
	
	@Override
	public List<MSVDDTipoResolucion> dameTiposEspeciales(String prefijoResEspeciales){
		HQLBuilder hb = new HQLBuilder(" from MSVDDTipoResolucion tipo ");		
		HQLBuilder.addFiltroLikeSiNotNull(hb, "tipo.codigo", prefijoResEspeciales);
		
		return HibernateQueryUtils.list(this, hb);
	}
	
	
	@Override
	public boolean esTipoEspecial(Long idTipo, String prefijoResEspeciales){
		HQLBuilder hb = new HQLBuilder(" from MSVDDTipoResolucion tipo ");
		HQLBuilder.addFiltroLikeSiNotNull(hb, "tipo.id", idTipo);
		MSVDDTipoResolucion tipoResolucion = HibernateQueryUtils.uniqueResult(this,hb);
		
		return tipoResolucion.getCodigo().contains(prefijoResEspeciales);
	}

}