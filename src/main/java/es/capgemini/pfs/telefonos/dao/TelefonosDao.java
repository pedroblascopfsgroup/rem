package es.capgemini.pfs.telefonos.dao;

import es.capgemini.pfs.dao.AbstractDao;
import es.capgemini.pfs.telefonos.model.Telefono;

public interface TelefonosDao extends AbstractDao<Telefono, Long> {
	/**
	 * Reorganiza todas las prioridades a partir de la prioridad indicada 
	 * sumandole uno al resto de prioridades excepto la pasada por el id del Telefono
	 * 
	 * @param idCliente	   = Cliente que se actualizar�
	 * @param idTelefono   = idTelefono que no se actualizar�
	 * @param prioridad    = Prioridad nueva
	 * @param prioridadAnt = prioridad anterior
	 */
	public void reorganizaPrioridades(Long IdCliente, Long idTelefono, int prioridad, int prioridadAnt);
	
	/**
	 * Obtiene la �ltima prioridad de los tel�fonos del cliente
	 * @param idCliente
	 * @return
	 */
	public Integer getMaxPrioridad(Long idCliente);
}
