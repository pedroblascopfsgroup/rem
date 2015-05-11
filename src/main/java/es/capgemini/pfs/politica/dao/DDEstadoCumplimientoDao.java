package es.capgemini.pfs.politica.dao;

import es.capgemini.pfs.dao.AbstractDao;
import es.capgemini.pfs.politica.model.DDEstadoCumplimiento;

/**
 * Interfaz para acceso a datos del DDEestadoCumplimiento.
 * @author pamuller
 *
 */
public interface DDEstadoCumplimientoDao extends AbstractDao<DDEstadoCumplimiento,Long>{

	/**
	 * Devuelve el DDEstadoCumplimiento correspondiente a ese código.
	 * @param codigo el codigo del estado de cumplimiento
	 * @return el estado de cumplimiento
	 */
	DDEstadoCumplimiento buscarPorCodigo(String codigo);

}
