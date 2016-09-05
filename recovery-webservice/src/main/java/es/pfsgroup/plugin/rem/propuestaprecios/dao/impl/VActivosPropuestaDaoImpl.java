package es.pfsgroup.plugin.rem.propuestaprecios.dao.impl;

import org.springframework.stereotype.Repository;

import es.capgemini.devon.dto.WebDto;
import es.capgemini.devon.pagination.Page;
import es.capgemini.pfs.dao.AbstractEntityDao;
import es.pfsgroup.commons.utils.HQLBuilder;
import es.pfsgroup.commons.utils.HibernateQueryUtils;
import es.pfsgroup.plugin.rem.model.VBusquedaActivosPropuesta;
import es.pfsgroup.plugin.rem.propuestaprecios.dao.VActivosPropuestaDao;

@Repository("VActivosPropuestaDao")
public class VActivosPropuestaDaoImpl extends AbstractEntityDao<VBusquedaActivosPropuesta, Long> implements VActivosPropuestaDao {
	
	@Override
	public Page getListActivosByPropuestaPrecio(Long idPropuesta, WebDto webDto) {
		
		HQLBuilder hb = new HQLBuilder(" from VBusquedaActivosPropuesta vap");
		
		HQLBuilder.addFiltroIgualQue(hb, "vap.idPropuesta", idPropuesta.toString());
		
		return HibernateQueryUtils.page(this, hb, webDto);
	}
	    

}