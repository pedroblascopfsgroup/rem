package es.pfsgroup.plugin.rem.api;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import es.pfsgroup.plugin.rem.model.GastosExpediente;
import es.pfsgroup.plugin.rem.rest.dto.ComisionDto;
import net.sf.json.JSONObject;

public interface GastosExpedienteApi {
	
	
	/**
     * Devuelve una GastosExpediente por id.
     * @param id del GastosExpediente a consultar
     * @return GastosExpediente
     */
    public GastosExpediente findOne(Long id);
    
    /**
	 * Devuelve una lista de GastosExpediente aplicando el filtro que recibe.
	 * @param ComisionDto con los parametros de filtro
	 * @return List<GastosExpediente> 
	 */
	public List<GastosExpediente> getListaGastosExpediente(ComisionDto ComisionDto);
	
    /**
     * Actualiza un GastosExpediente a partir de la información pasada por parámetro.
     * @param comisionDto con la información del GastosExpediente a actualizar
     * @param jsonFields estructura de parámetros a actualizar. Si no vienen, no hay que actualizar. Si vienen y están a null, hay que seterlos a null
     * @return List<String> con la lista de errores detectados
     */
    public void updateAceptacionGasto(GastosExpediente gasto, ComisionDto comisionDto, Object jsonFields);
    
    /**
     * Actualiza una lista de GastosExpediente a partir de la información pasada por parámetro.
     * @param listaComisionDto
     * @param jsonFields
     */
    public ArrayList<Map<String, Object>> updateAceptacionesGasto(List<ComisionDto> listaComisionDto, JSONObject jsonFields);
    
	

}
