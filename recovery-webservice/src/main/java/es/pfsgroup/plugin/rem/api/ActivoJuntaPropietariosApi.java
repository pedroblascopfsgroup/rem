package es.pfsgroup.plugin.rem.api;

import es.capgemini.devon.files.FileItem;
import es.capgemini.devon.files.WebFileItem;
import es.pfsgroup.commons.utils.api.BusinessOperationDefinition;
import es.pfsgroup.framework.paradise.utils.DtoPage;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.ActivoJuntaPropietarios;
import es.pfsgroup.plugin.rem.model.DtoActivoJuntaPropietarios;
import es.pfsgroup.plugin.rem.model.DtoAdjunto;
import es.pfsgroup.plugin.rem.rest.dto.ActivoDto;

public interface ActivoJuntaPropietariosApi {

	public ActivoJuntaPropietarios findOne(Long id);
	
	public DtoPage getListJuntas(DtoActivoJuntaPropietarios dtoActivoJuntaPropietarios);
	
	/**
	 * Devuelve el dto de la tab que se le pasa;
	 * @param id
	 * @param tab
	 * @return
	 */
	public Object getTabJunta(Long id, String tab);
	
	public String managerName();

	//@BusinessOperationDefinition("activoJuntaPropietariosManager.getFileItemAdjunto")
	public FileItem getFileItemAdjunto(DtoAdjunto dtoAdjunto);
	
	public String uploadDocumento(WebFileItem webFileItem, ActivoJuntaPropietarios activoJuntaEntrada, String matricula) throws Exception;

	public boolean deleteAdjunto(DtoAdjunto dtoAdjunto);
	
	public ActivoDto getActivosJuntasVista(Long idJunta);

}
