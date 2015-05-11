package es.capgemini.pfs.plazoTareasDefault;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.pfs.core.api.plazoTareasDefault.PlazoTareasDefaultApi;
import es.capgemini.pfs.plazoTareasDefault.dao.EXTPlazoTareasDefaultDao;
import es.capgemini.pfs.tareaNotificacion.model.PlazoTareasDefault;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;

@Component
public class EXTPlazoTareasDefaultManager implements PlazoTareasDefaultApi {

	@Autowired
	GenericABMDao genericdDao;
	
	@Autowired
	EXTPlazoTareasDefaultDao plazoDefaultDao;
	
	@Override
	@BusinessOperation(BO_CORE_PLAZOS_BUSCAR_POR_NOMBRE)
	public PlazoTareasDefault buscarPlazoPorDescripcion(String descripcion) {
		PlazoTareasDefault plazo = null;
		/*
		Filter filtroDescripcion= genericdDao.createFilter(FilterType.EQUALS, "descripcion", descripcion);
		Filter filtroBorrado = genericdDao.createFilter(FilterType.EQUALS, "auditori.borrado", false);
		
		plazo= genericdDao.get(PlazoTareasDefault.class, filtroDescripcion,filtroBorrado);
		*/
		plazo = plazoDefaultDao.buscaPlazoPorDescripcion(descripcion);
		return plazo;
		
	}

}
