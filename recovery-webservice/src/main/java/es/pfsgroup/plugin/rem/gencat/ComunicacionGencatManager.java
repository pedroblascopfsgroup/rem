package es.pfsgroup.plugin.rem.gencat;

import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import es.capgemini.pfs.dao.AbstractEntityDao;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.plugin.rem.api.ActivoApi;
import es.pfsgroup.plugin.rem.api.ComunicacionGencatApi;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.ComunicacionGencat;

@Service("comunicacionGencatManager")
public class ComunicacionGencatManager extends AbstractEntityDao<ComunicacionGencat, Long> implements ComunicacionGencatApi {
	
	@Autowired
	private GenericABMDao genericDao;
	
	@Autowired
	private ActivoApi activoApi;

	@Override
	public List<ComunicacionGencat> getByIdActivo(Long idActivo) {
		
		Filter filtroBorrado = genericDao.createFilter(FilterType.EQUALS, "auditoria.borrado", false);
		Filter filtroIdActivo = genericDao.createFilter(FilterType.EQUALS, "activo.id", idActivo);

		return genericDao.getList(ComunicacionGencat.class, filtroBorrado, filtroIdActivo);
		
	}

	@Override
	public List<ComunicacionGencat> getByNumActivoHaya(Long numActivoHaya) {
		
		Activo activo = activoApi.getByNumActivo(numActivoHaya);
		
		if (!Checks.esNulo(activo) && !Checks.esNulo(activo.getId())) {
			return this.getByIdActivo(activo.getId());		
		}
		
		return new ArrayList<ComunicacionGencat>();
	}

	@Override
	public List<ComunicacionGencat> getByIdActivoAndNif(Long idActivo, String nif) {
		
		Filter filtroBorrado = genericDao.createFilter(FilterType.EQUALS, "auditoria.borrado", false);
		Filter filtroIdActivo = genericDao.createFilter(FilterType.EQUALS, "activo.id", idActivo);
		Filter filtroNif = genericDao.createFilter(FilterType.EQUALS, "nuevoCompradorNif", nif);
		
		return genericDao.getList(ComunicacionGencat.class, filtroBorrado, filtroIdActivo, filtroNif);

	}

	@Override
	public List<ComunicacionGencat> getByNumActivoHayaAndNif(Long numActivoHaya, String nif) {

		Activo activo = activoApi.getByNumActivo(numActivoHaya);
		
		if (!Checks.esNulo(activo) && !Checks.esNulo(activo.getId())) {
			return this.getByIdActivoAndNif(activo.getId(), nif);		
		}
		
		return new ArrayList<ComunicacionGencat>();
	}

}
