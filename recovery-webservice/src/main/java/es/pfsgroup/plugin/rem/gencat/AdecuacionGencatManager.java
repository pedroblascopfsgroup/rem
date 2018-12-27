package es.pfsgroup.plugin.rem.gencat;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import es.capgemini.pfs.dao.AbstractEntityDao;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.plugin.rem.api.AdecuacionGencatApi;
import es.pfsgroup.plugin.rem.model.AdecuacionGencat;
import es.pfsgroup.plugin.rem.model.ComunicacionGencat;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoComunicacionGencat;

@Service("adecuacionencatManager")
public class AdecuacionGencatManager extends AbstractEntityDao<AdecuacionGencat, Long> implements AdecuacionGencatApi {
	
	@Autowired
	private GenericABMDao genericDao;
		
	@Override
	public AdecuacionGencat getByIdActivo(Long idActivo) {
		
		Long idComunicacionGencat = null;
		AdecuacionGencat adecuacionGencat = null;
		
		Filter filtroEstadoTramite = genericDao.createFilter(FilterType.EQUALS, "estadoComunicacion.codigo", DDEstadoComunicacionGencat.COD_CREADO);
		Filter filtroIdActivo = genericDao.createFilter(FilterType.EQUALS, "activo.id", idActivo);
		Filter filtroBorradoComunicacion = genericDao.createFilter(FilterType.EQUALS, "auditoria.borrado", false);
		
		ComunicacionGencat comunicacionGencat = genericDao.get(ComunicacionGencat.class, filtroEstadoTramite, filtroIdActivo, filtroBorradoComunicacion);
		
		if(!Checks.esNulo(comunicacionGencat)) {
			idComunicacionGencat = comunicacionGencat.getId();
		}
		
		if(!Checks.esNulo(idComunicacionGencat)) {
			Filter filtroIdAdecuacion = genericDao.createFilter(FilterType.EQUALS, "comunicacion.id", idComunicacionGencat);
			Filter filtroBorradoAdecuacion = genericDao.createFilter(FilterType.EQUALS, "auditoria.borrado", false);
			
			adecuacionGencat = genericDao.get(AdecuacionGencat.class, filtroIdAdecuacion, filtroBorradoAdecuacion);
		}
		
		return adecuacionGencat;
	}

}
