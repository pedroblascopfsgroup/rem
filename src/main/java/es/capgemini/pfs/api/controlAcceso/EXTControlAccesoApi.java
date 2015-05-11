package es.capgemini.pfs.api.controlAcceso;

import org.springframework.transaction.annotation.Transactional;

import es.pfsgroup.commons.utils.api.BusinessOperationDefinition;

public interface EXTControlAccesoApi {
	
	String BO_CORE_CONTROL_ACCESO_CREAR_REGISTRO = "core.controlAcceso.registrarAcceso";

	/**
	 * crea un nuevo registro en la tabla CAU_CONTROL_ACCESO_USUARIOS, insertando el usuario logado
	 * Si el usuario ya ha accedido ese día a la herramienta y ya está registrado no se creará una nueva
	 * entrada en la tabla
	 */
	@BusinessOperationDefinition(BO_CORE_CONTROL_ACCESO_CREAR_REGISTRO)
	@Transactional(readOnly=false)
	public void registrarAccesoDeUsuario();

}
