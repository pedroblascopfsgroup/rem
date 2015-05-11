package es.pfsgroup.recovery.panelcontrol.letrados.vistas.columnaTareaExp.dao;

import java.util.List;

import es.pfsgroup.recovery.panelcontrol.letrados.vistas.columnaTareaExp.model.PCColumnaTareaExp;

public interface PCColumnaTareaExpDao {
	
	/**
	 * 
	 */
	public List<PCColumnaTareaExp> getColumns(String tipo);

	/**
	 * Devuelve el numero total de columnas que tendrá el record del store de datos
	 * @param tipo TAR/EXP (asuntos o expedientes)
	 * @return
	 */
	public Integer getNumeroColumns(String tipo);

	
}
