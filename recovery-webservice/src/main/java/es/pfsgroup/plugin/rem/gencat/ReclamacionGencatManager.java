package es.pfsgroup.plugin.rem.gencat;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import es.capgemini.pfs.dao.AbstractEntityDao;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.plugin.rem.api.ReclamacionGencatApi;
import es.pfsgroup.plugin.rem.model.ReclamacionGencat;

@Service("reclamacionGencatManager")
public class ReclamacionGencatManager extends AbstractEntityDao<ReclamacionGencat, Long> implements ReclamacionGencatApi {
	
	@Autowired
	private GenericABMDao genericDao;
		
	@Override
	public ReclamacionGencat getReclamacionByIdComunicacionGencat(Long idComunicacionGencat) {
				
		Filter filtroIdReclamacion = genericDao.createFilter(FilterType.EQUALS, "comunicacion.id", idComunicacionGencat);
		Filter filtroBorradoReclamacion = genericDao.createFilter(FilterType.EQUALS, "auditoria.borrado", false);
		
		if(!Checks.esNulo(idComunicacionGencat)) {
			List<ReclamacionGencat> reclamacionGencatList = genericDao.getList(ReclamacionGencat.class, filtroIdReclamacion, filtroBorradoReclamacion);
			
			if(!Checks.estaVacio(reclamacionGencatList)) {
				return reclamacionGencatList.get(0);
			} else {
				return null;
			}
			
						
		} else {
			return null;
		}
	
	}

}
