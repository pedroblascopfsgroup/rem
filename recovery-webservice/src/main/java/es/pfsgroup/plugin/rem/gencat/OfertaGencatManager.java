package es.pfsgroup.plugin.rem.gencat;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import es.capgemini.pfs.dao.AbstractEntityDao;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.plugin.rem.api.OfertaGencatApi;
import es.pfsgroup.plugin.rem.model.OfertaGencat;

@Service("ofertaGencatManager")
public class OfertaGencatManager extends AbstractEntityDao<OfertaGencat, Long> implements OfertaGencatApi {
	
	@Autowired
	private GenericABMDao genericDao;
		
	@Override
	public OfertaGencat getOfertaByIdComunicacionGencat(Long idComunicacionGencat) {
				
		Filter filtroIdAdecuacion = genericDao.createFilter(FilterType.EQUALS, "comunicacion.id", idComunicacionGencat);
		Filter filtroBorradoAdecuacion = genericDao.createFilter(FilterType.EQUALS, "auditoria.borrado", false);
		
		if(!Checks.esNulo(idComunicacionGencat)) {
			List<OfertaGencat> ofertaGencatList = genericDao.getList(OfertaGencat.class, filtroIdAdecuacion, filtroBorradoAdecuacion);
			
			if(!Checks.estaVacio(ofertaGencatList)) {
				return ofertaGencatList.get(0);
			} else {
				return null;
			}
			
						
		} else {
			return null;
		}
	
	}

}
