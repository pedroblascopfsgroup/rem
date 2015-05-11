package es.pfsgroup.plugin.recovery.cambiosMasivosAsunto;

import java.util.List;

import es.capgemini.pfs.multigestor.model.EXTDDTipoGestor;

/**
 * Clase en la que se mantiene la configuraci�n del plugin. Este objeto se
 * istancia y configura en
 * classpath:optionalConfiguration/ac-plugin-cambiosMasivosAsunto-config.xml
 * 
 * @author bruno
 * 
 */
public class CambiosMasivosAsuntoPluginConfig {

	/**
	 * Nombre del campo del {@link EXTDDTipoGestor} que actua como c�digo. Si se
	 * realiza alg�n filtrado ser� por este campo
	 */
	public static final String COD_TIPO_GESTOR = "codigo";
	
	private boolean filtrarTiposGestor;
	private List<String> tiposGestorValidos;
	
	public void setFiltrarTiposGestor(boolean filtrarTiposGestor) {
		this.filtrarTiposGestor = filtrarTiposGestor;
	}

	public void setTiposGestorValidos(List<String> tiposGestorValidos) {
		this.tiposGestorValidos = tiposGestorValidos;
	}

	

	/**
	 * Indica si se deben filtrar los Tipos de Gestor v�lidos
	 * @return
	 */
	public boolean isFiltrarTiposGestor() {
		return this.filtrarTiposGestor;
	}

	/**
	 * Lista de Tipos de Gestor v�lidos si realizamos el filtro
	 * @return
	 */
	public List<String> getTiposGestorValidos() {
		return this.tiposGestorValidos;
	}

}
