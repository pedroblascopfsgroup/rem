package es.pfsgroup.recovery.ext.api.asunto;

import es.capgemini.pfs.diccionarios.Dictionary;
import es.capgemini.pfs.multigestor.model.EXTDDTipoGestor;
import es.capgemini.pfs.users.domain.Usuario;

public interface EXTUsuarioRelacionadoInfo {
	
	String getIdCompuesto();
	/**
	 * Devuelve el Tipo de Gestor. �sto define el rol que va a desempe�ar el
	 * usuario en el Asunto.
	 * 
	 * @return
	 */
	Dictionary getTipoGestor();

	/**
	 * Devuelve el Usuario.
	 * 
	 * @return
	 */
	Usuario getUsuario();

}
