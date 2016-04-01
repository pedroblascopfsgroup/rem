package es.capgemini.pfs.core.api.expediente;

import java.util.List;

import es.capgemini.pfs.asunto.dto.ExtAdjuntoGenericoDto;
import es.capgemini.pfs.core.api.asunto.AdjuntoDto;
import es.capgemini.pfs.expediente.model.Expediente;
import es.capgemini.pfs.oficina.model.Oficina;
import es.pfsgroup.commons.utils.api.BusinessOperationDefinition;

public interface EXTExpedientesApi {
	
	String BO_CORE_EXPEDIENTE_ADJUNTOSCONTRATOS_EXP = "core.expediente.getAdjuntosContratoExp";
	String BO_CORE_EXPEDIENTE_ADJUNTOSPERSONA_EXP = "core.expediente.getAjuntosPersonasExp";
	String BO_CORE_EXPEDIENTE_ADJUNTOSMAPEADOS = "core.expediente.getAjuntosMapeados";
	String BO_CORE_EXPEDIENTE_OBTENER_OFICINAS_EXP = "core.expediente.getOficinasExpediente";
	String BO_CORE_EXPEDIENTE_CAMBIAR_OFICINA_EXP = "core.expediente.cambiarOficinaExpediente";
	
	/**
	 * 
	 * @param id del expediente
	 * @return lista ordenada por fecha de subida de todos los adjuntos de los contratos del expediente
	 */
	@BusinessOperationDefinition(BO_CORE_EXPEDIENTE_ADJUNTOSCONTRATOS_EXP)
	public List<ExtAdjuntoGenericoDto> getAdjuntosContratoExp(Long id);
	
	/**
	 * 
	 * @param id del expediente
	 * @return lista ordenada por fecha de subida de todos los adjuntos de los contratos del expediente
	 */
	@BusinessOperationDefinition(BO_CORE_EXPEDIENTE_ADJUNTOSPERSONA_EXP)
	public List<ExtAdjuntoGenericoDto> getAdjuntosPersonasExp(Long id);
	
	
	@BusinessOperationDefinition(BO_CORE_EXPEDIENTE_ADJUNTOSMAPEADOS)
	public List<? extends AdjuntoDto> getAdjuntosConBorradoExp(Long id);
	    

	/**
	 * 
	 * @param id del expediente
	 * @return lista de todas las oficinas del expediente
	 */
	@BusinessOperationDefinition(BO_CORE_EXPEDIENTE_OBTENER_OFICINAS_EXP)
	public List<Oficina> getoficinasExpediente(Long id);
	
	/**
	 * 
	 * @param id del expediente
	 * @return lista de todas las oficinas del expediente
	 */
	@BusinessOperationDefinition(BO_CORE_EXPEDIENTE_CAMBIAR_OFICINA_EXP)
	public void cambiarOficinaExpediente(Long idExpediente,Long idOficina);
	
	/**
	 * 
	 * @param id del expediente
	 * @return Expediente a partir del id
	 */
	public Expediente getExpediente(Long id);

}
