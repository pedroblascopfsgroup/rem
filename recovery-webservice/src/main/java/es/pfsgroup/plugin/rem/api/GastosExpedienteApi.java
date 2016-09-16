package es.pfsgroup.plugin.rem.api;

import java.util.List;

import es.pfsgroup.plugin.rem.model.GastosExpediente;
import es.pfsgroup.plugin.rem.rest.dto.ComisionDto;

public interface GastosExpedienteApi {
	
	
	/**
     * Devuelve una GastosExpediente por id.
     * @param id del GastosExpediente a consultar
     * @return GastosExpediente
     */
    public GastosExpediente findOne(Long id);
    
    
    /**
	 * Devuelve una lista de errores encontrados en los parámetros de entrada de las peticiones POST.
	 * @param ComisionDto con los parametros de entrada
	 * @return List<String> 
	 */
    public List<String> validateComisionPostRequestData(ComisionDto comisionDto);
    
    /**
     * Actualiza un GastosExpediente a partir de la información pasada por parámetro.
     * @param comisionDto con la información del GastosExpediente a actualizar
     * @param jsonFields estructura de parámetros a actualizar. Si no vienen, no hay que actualizar. Si vienen y están a null, hay que seterlos a null
     * @return List<String> con la lista de errores detectados
     */
    public List<String> updateAceptacionGasto(GastosExpediente gasto, ComisionDto comisionDto, Object jsonFields);
    
	

}
