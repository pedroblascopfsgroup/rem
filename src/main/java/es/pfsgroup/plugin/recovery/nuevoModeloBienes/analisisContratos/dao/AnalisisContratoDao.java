package es.pfsgroup.plugin.recovery.nuevoModeloBienes.analisisContratos.dao;

import es.capgemini.devon.pagination.Page;
import es.capgemini.pfs.dao.AbstractDao;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.analisisContratos.dto.AnalisisContratosWebDto;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.analisisContratos.model.AnalisisContratos;

public interface AnalisisContratoDao extends AbstractDao<AnalisisContratos, Long>{
	
	/* Nombre que le damos al NMBbien buscado en la HQL */
	public static final String NAME_OF_ENTITY_NMB = "nmb";
		
	Page getListadoAnalisisContratos(AnalisisContratosWebDto dto);

	
}
