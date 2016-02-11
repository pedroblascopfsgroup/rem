package es.pfsgroup.plugin.recovery.procuradores.procurador.dao;

import java.util.List;

import es.capgemini.pfs.dao.AbstractDao;
import es.pfsgroup.plugin.recovery.procuradores.categorias.model.RelacionCategorias;
import es.pfsgroup.plugin.recovery.procuradores.procurador.model.RelacionProcuradorProcedimiento;


/**
 * Dao de la clase {@link RelacionCategorias}
 * 
 * @author carlos gil
 *
 */
public interface RelacionProcuradorProcedimientoDao extends AbstractDao<RelacionProcuradorProcedimiento, Long>{

	/**
	 * Obtiene un procurador de {@link RelacionProcuradorProcedimiento}.
	 * @param idProcedimiento.
	 * @return lista de {@link RelacionCategorias}.
	 */
	public List<RelacionProcuradorProcedimiento> getProcuradorProcedimiento(Long idProcedimiento);
	
	
	
}

