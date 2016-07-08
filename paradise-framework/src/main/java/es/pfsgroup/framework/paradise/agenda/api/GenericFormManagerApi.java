package es.pfsgroup.framework.paradise.agenda.api;

import es.capgemini.pfs.web.genericForm.DtoGenericForm;
import es.capgemini.pfs.web.genericForm.GenericForm;

public interface GenericFormManagerApi {
	/**
	 * Obtiene un formulario dinamico a partir del id de una tarea Externa
	 *
	 * @param id
	 * @return GenericForm
	 */
	public GenericForm getForm(Long id);

	/**
	 * Guarda los valores de la pantalla genérica en bbdd
	 *
	 * @param dto
	 */
	public void save(DtoGenericForm dto);

}