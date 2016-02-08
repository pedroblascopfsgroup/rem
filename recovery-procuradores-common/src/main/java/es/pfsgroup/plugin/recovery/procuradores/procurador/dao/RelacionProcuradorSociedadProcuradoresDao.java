package es.pfsgroup.plugin.recovery.procuradores.procurador.dao;

import java.util.List;

import es.capgemini.pfs.dao.AbstractDao;
import es.pfsgroup.plugin.recovery.procuradores.categorias.model.RelacionCategorias;
import es.pfsgroup.plugin.recovery.procuradores.procurador.model.Procurador;
import es.pfsgroup.plugin.recovery.procuradores.procurador.model.RelacionProcuradorSociedadProcuradores;
import es.pfsgroup.plugin.recovery.procuradores.sociedadProcuradores.model.SociedadProcuradores;


/**
 * Dao de la clase {@link RelacionCategorias}
 * 
 * @author carlos gil
 *
 */
public interface RelacionProcuradorSociedadProcuradoresDao extends AbstractDao<RelacionProcuradorSociedadProcuradores, Long>{

	/**
	 * Obtiene un RelacionProcuradorSociedadProcuradores de {@link Procurador}.
	 * @param idProcurador.
	 * @return lista de {@link RelacionProcuradorSociedadProcuradores}.
	 */
	public List<RelacionProcuradorSociedadProcuradores> getRelacionProcuradorSociedadProcuradoresDelProcurador(Long idProcurador);
	
	/**
	 * Obtiene un RelacionProcuradorSociedadProcuradores de {@link SociedadProcuradores}.
	 * @param idSociedad.
	 * @return lista de {@link RelacionProcuradorSociedadProcuradores}.
	 */
	public List<RelacionProcuradorSociedadProcuradores> getRelacionProcuradorSociedadProcuradoresDeLaSociedad(Long idSociedad, String nombreProcurador);
	
	
	/**
	 * Obtiene un RelacionProcuradorSociedadProcuradores de {@link SociedadProcuradores}.
	 * @param dto.
	 * @return lista de {@link RelacionProcuradorSociedadProcuradores}.
	 */
	public RelacionProcuradorSociedadProcuradores getRelacionProcuradorSociedadProcuradores(Long idProcurador, Long idSociedad);
	
	
	
}

