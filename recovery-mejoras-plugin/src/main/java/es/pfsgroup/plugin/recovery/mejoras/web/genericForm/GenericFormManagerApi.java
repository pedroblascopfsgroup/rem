package es.pfsgroup.plugin.recovery.mejoras.web.genericForm;

import es.capgemini.pfs.web.genericForm.GenericForm;
import es.pfsgroup.commons.utils.api.BusinessOperationDefinition;

public interface GenericFormManagerApi {

	public static final String GET_GENERIC_FORM = "genericFormManager.get";
	public static final String GET_GENERIC_FORM_READ_ONLY = "genericFormManager.getReadOnly";
	
	/**
     * Obtiene un formulario dinamico a partir del id de una tarea Externa
     *
     * @param id
     * @return GenericForm
     */
    @BusinessOperationDefinition(GET_GENERIC_FORM)
    public GenericForm get(Long id);

	/**
     * Obtiene un formulario dinamico en SÓLO LECTURA a partir del id de una tarea Externa
     *
     * @param id
     * @return GenericForm
     */
    @BusinessOperationDefinition(GET_GENERIC_FORM_READ_ONLY)
    public GenericForm getReadOnly(Long id);

}
