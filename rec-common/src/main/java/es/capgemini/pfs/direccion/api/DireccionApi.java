package es.capgemini.pfs.direccion.api;

import java.util.Collection;
import java.util.List;

import es.capgemini.pfs.direccion.model.DDTipoVia;
import es.capgemini.pfs.direccion.model.Localidad;
import es.capgemini.pfs.persona.model.Persona;
import es.pfsgroup.commons.utils.api.BusinessOperationDefinition;
import  es.capgemini.pfs.direccion.dto.DireccionAltaDto;

public interface DireccionApi {

	public static final String GET_LIST_LOCALIDADES = "es.capgemini.pfs.direccion.api.DireccionApi.getListLocalidades";
	public static final String GET_LIST_TIPOS_VIA = "es.capgemini.pfs.direccion.api.DireccionApi.getListTiposVia";
	public static final String GET_LIST_PERSONAS = "es.capgemini.pfs.direccion.api.DireccionApi.getPersonas";
	public static final String GUARDAR_DIRECCION = "es.capgemini.pfs.direccion.api.DireccionApi.guardarDireccion";

	@BusinessOperationDefinition(GET_LIST_LOCALIDADES)
	public List<Localidad> getListLocalidades(Long idProvincia);
	
	@BusinessOperationDefinition(GET_LIST_TIPOS_VIA)
	public List<DDTipoVia> getListTiposVia();
	
	/**
	 * Devuelve la lista de PERSONAS que concuerdan con la expresi�n pasada
	 * en el caso de llamarlo desde un asunto solo verá los clientes de ese asunto.
	 * (Puede incluir nombre y DNI
	 * @return boolean
	 */
	@BusinessOperationDefinition(GET_LIST_PERSONAS)
	public Collection<? extends Persona>  getPersonas(String query, Long idAsunto);

	/**
	 * Guarda una nueva direcci�n introducida de forma manual en Recovery
	 * @return String resultado de la operaci�n
	 */
	@BusinessOperationDefinition(GUARDAR_DIRECCION)
	public String guardarDireccion(DireccionAltaDto dto);

}
