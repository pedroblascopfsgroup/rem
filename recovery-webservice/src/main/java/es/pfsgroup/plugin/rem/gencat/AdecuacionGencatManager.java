package es.pfsgroup.plugin.rem.gencat;

import java.util.List;

import org.hibernate.Criteria;
import org.hibernate.criterion.Restrictions;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import es.capgemini.pfs.dao.AbstractEntityDao;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.commons.utils.hibernate.HibernateUtils;
import es.pfsgroup.plugin.rem.api.AdecuacionGencatApi;
import es.pfsgroup.plugin.rem.model.AdecuacionGencat;
import es.pfsgroup.plugin.rem.model.ComunicacionGencat;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoComunicacionGencat;

@Service("adecuacionGencatManager")
public class AdecuacionGencatManager extends AbstractEntityDao<AdecuacionGencat, Long> implements AdecuacionGencatApi {
	
	@Autowired
	private GenericABMDao genericDao;
		
	@Override
	public AdecuacionGencat getAdecuacionByIdActivo(Long idActivo) {
				
		Long idComunicacionGencat = null;
		AdecuacionGencat adecuacionGencat = null;
		
		Filter filtroEstadoTramite = genericDao.createFilter(FilterType.EQUALS, "estadoComunicacion.codigo", DDEstadoComunicacionGencat.COD_CREADO);
		Filter filtroIdActivo = genericDao.createFilter(FilterType.EQUALS, "activo.id", idActivo);
		Filter filtroBorradoComunicacion = genericDao.createFilter(FilterType.EQUALS, "auditoria.borrado", false);
		
		ComunicacionGencat comunicacionGencat = genericDao.getList(ComunicacionGencat.class, filtroEstadoTramite, filtroIdActivo, filtroBorradoComunicacion).get(0);
		
		if(!Checks.esNulo(comunicacionGencat)) {
			idComunicacionGencat = comunicacionGencat.getId();
		}
		
		if(!Checks.esNulo(idComunicacionGencat)) {
			Filter filtroIdAdecuacion = genericDao.createFilter(FilterType.EQUALS, "comunicacion.id", idComunicacionGencat);
			Filter filtroBorradoAdecuacion = genericDao.createFilter(FilterType.EQUALS, "auditoria.borrado", false);
			
			adecuacionGencat = genericDao.getList(AdecuacionGencat.class, filtroIdAdecuacion, filtroBorradoAdecuacion).get(0);
		}
		
		return adecuacionGencat;
	}
	
	@Override
	public AdecuacionGencat getAdecuacionByIdComunicacion (Long idComunicacionGencat) {
		
		Filter filtroIdAdecuacion = genericDao.createFilter(FilterType.EQUALS, "comunicacion.id", idComunicacionGencat);
		Filter filtroBorradoAdecuacion = genericDao.createFilter(FilterType.EQUALS, "auditoria.borrado", false);
		
		if(!Checks.esNulo(idComunicacionGencat)) {
			List<AdecuacionGencat> lista =  genericDao.getList(AdecuacionGencat.class, filtroIdAdecuacion, filtroBorradoAdecuacion);
			if (!Checks.estaVacio(lista)) {
				return genericDao.getList(AdecuacionGencat.class, filtroIdAdecuacion, filtroBorradoAdecuacion).get(0);	
			} else {
				return null;
			}
					
		} else {			
			return null;
		}
	}

}
