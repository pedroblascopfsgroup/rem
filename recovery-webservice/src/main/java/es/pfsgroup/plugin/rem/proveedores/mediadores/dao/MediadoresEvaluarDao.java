package es.pfsgroup.plugin.rem.proveedores.mediadores.dao;

import es.capgemini.devon.pagination.Page;
import es.capgemini.pfs.dao.AbstractDao;
import es.pfsgroup.plugin.rem.model.DtoMediadorEvaluaFilter;
import es.pfsgroup.plugin.rem.model.VListMediadoresEvaluar;

public interface MediadoresEvaluarDao extends AbstractDao<VListMediadoresEvaluar, Long>{

	/**
	 * Obtiene la lista de mediadores paginada para un grid
	 * @param dto
	 * @return
	 */
	public Page getListMediadoresEvaluar(DtoMediadorEvaluaFilter dto);
	
	/**
	 * Inicia el proceso masivo de evaluacion de proveedores
	 * Escribe las calificaciones vigentes copiando las propuestas
	 * Escribe si es TOP copiando el TOP propuesto
	 * Elimina los datos de calificaciones y TOP propuestos
	 * @return
	 */
	public Boolean evaluarMediadoresConPropuestas();
	
}
