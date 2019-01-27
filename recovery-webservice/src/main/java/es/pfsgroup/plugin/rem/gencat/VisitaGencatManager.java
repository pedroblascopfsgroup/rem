package es.pfsgroup.plugin.rem.gencat;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import es.capgemini.pfs.dao.AbstractEntityDao;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.plugin.rem.api.VisitaGencatApi;
import es.pfsgroup.plugin.rem.model.VisitaGencat;

@Service("visitaGencatManager")
public class VisitaGencatManager extends AbstractEntityDao<VisitaGencat, Long> implements VisitaGencatApi {
	
	@Autowired
	private GenericABMDao genericDao;
		
	@Override
	public VisitaGencat getVisitaByIdComunicacionGencat(Long idComunicacionGencat) {
				
		Filter filtroIdVisita = genericDao.createFilter(FilterType.EQUALS, "comunicacion.id", idComunicacionGencat);
		Filter filtroBorradoVisita = genericDao.createFilter(FilterType.EQUALS, "auditoria.borrado", false);
		
		if(!Checks.esNulo(idComunicacionGencat)) {
			List<VisitaGencat> visitaGencatList = genericDao.getList(VisitaGencat.class, filtroIdVisita, filtroBorradoVisita);
			
			if(!Checks.estaVacio(visitaGencatList)) {
				return visitaGencatList.get(0);
			} else {
				return null;
			}
			
						
		} else {
			return null;
		}
	
	}

}
