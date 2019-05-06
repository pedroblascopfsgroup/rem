package es.pfsgroup.plugin.rem.gencat;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import es.capgemini.pfs.dao.AbstractEntityDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.plugin.rem.api.NotificacionGencatApi;
import es.pfsgroup.plugin.rem.model.NotificacionGencat;

@Service("notificacionGencatManager")
public class NotificacionGencatManager extends AbstractEntityDao<NotificacionGencat, Long> implements NotificacionGencatApi {
	
	@Autowired
	private GenericABMDao genericDao;
		
	@Override
	public List<NotificacionGencat> getNotificacionByIdComunicacionGencat(Long idComunicacionGencat) {
				
		Filter filtroIdNotificacion = genericDao.createFilter(FilterType.EQUALS, "comunicacion.id", idComunicacionGencat);
		Filter filtroBorradoNotificacion = genericDao.createFilter(FilterType.EQUALS, "auditoria.borrado", false);
		
		List<NotificacionGencat> notificacionGencatList = genericDao.getList(NotificacionGencat.class, filtroIdNotificacion, filtroBorradoNotificacion);
		return notificacionGencatList;					
	}

}
