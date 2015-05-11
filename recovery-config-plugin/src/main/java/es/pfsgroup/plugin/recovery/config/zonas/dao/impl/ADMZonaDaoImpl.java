package es.pfsgroup.plugin.recovery.config.zonas.dao.impl;

import java.util.List;

import org.springframework.stereotype.Repository;

import es.capgemini.pfs.dao.AbstractEntityDao;
import es.capgemini.pfs.zona.model.DDZona;
import es.pfsgroup.commons.utils.HQLBuilder;
import es.pfsgroup.commons.utils.HibernateQueryUtils;
import es.pfsgroup.plugin.recovery.config.zonas.dao.ADMZonaDao;

@Repository("ADMZonaDao")
public class ADMZonaDaoImpl extends AbstractEntityDao<DDZona, Long> implements ADMZonaDao {

	@Override
	public List<DDZona> getByNivel(Long idNivel) {
		HQLBuilder b = new HQLBuilder("from DDZona z");
		HQLBuilder.addFiltroIgualQue(b, "z.nivel.id", idNivel);
		return HibernateQueryUtils.list(this, b);
	}

}
