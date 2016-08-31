package es.pfsgroup.plugin.rem.propuestaprecios.dao.impl;

import java.util.List;

import org.springframework.stereotype.Repository;

import es.capgemini.pfs.dao.AbstractEntityDao;
import es.pfsgroup.commons.utils.HQLBuilder;
import es.pfsgroup.commons.utils.HibernateQueryUtils;
import es.pfsgroup.plugin.rem.propuestaprecios.dao.VNumActivosTipoPrecioDao;
import es.pfsgroup.plugin.rem.model.VBusquedaNumActivosTipoPrecio;

@Repository("VNumActivosTipoPrecioDao")
public class VNumActivosTipoPrecioDaoImpl extends AbstractEntityDao<VBusquedaNumActivosTipoPrecio, String> implements VNumActivosTipoPrecioDao {

	@Override
	public List<VBusquedaNumActivosTipoPrecio> getNumActivosByTipoPrecioAndCartera() {
		
		HQLBuilder hb = new HQLBuilder(" from VBusquedaNumActivosTipoPrecio vna");
		
		return HibernateQueryUtils.list(this, hb);
	}
}
