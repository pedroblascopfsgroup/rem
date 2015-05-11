package es.pfsgroup.plugin.recovery.mejoras.users;

import java.util.List;

import es.capgemini.devon.web.DynamicElement;
import es.capgemini.pfs.users.dto.DtoUsuario;
import es.pfsgroup.commons.utils.api.BusinessOperationDefinition;

public interface MEJUsuarioApi {
	
	public static final String MEJ_MGR_DATOSUSUARIO_BUTTONS_RIGHT = "plugin.mejoras.web.public.buttons.right";
	public static final String MEJ_MGR_DATOSUSUARIO_BUTTONS_LEFT = "plugin.mejoras.web.public.buttons.left";

	@BusinessOperationDefinition(MEJ_MGR_DATOSUSUARIO_BUTTONS_RIGHT)
	List<DynamicElement> getButtonsDatosUsuarioRight();
	
	@BusinessOperationDefinition(MEJ_MGR_DATOSUSUARIO_BUTTONS_LEFT)
	List<DynamicElement> getButtonsDatosUsuarioLeft();

	public void guardarUsuarioInterno(DtoUsuario dto);
	
}
