package es.capgemini.pfs.core.api.telefono.api;

import java.util.List;

import es.capgemini.pfs.persona.model.DDOrigenTelefono;
import es.capgemini.pfs.persona.model.DDTipoTelefono;
import es.capgemini.pfs.persona.model.PersonasTelefono;
import es.capgemini.pfs.telefonos.dto.AltaTelefonoDto;
import es.capgemini.pfs.telefonos.model.DDEstadoTelefono;
import es.capgemini.pfs.telefonos.model.DDMotivoTelefono;
import es.capgemini.pfs.telefonos.model.Telefono;
import es.pfsgroup.commons.utils.api.BusinessOperationDefinition;

public interface TelefonosApi {

	public static final String BO_COREEXTENSION_TELEFONOS_GET_TELEFONOSCLIENTE = "plugin.mejoras.telefonos.gettelefonoscliente";
	/*public static final String BO_COREEXTENSION_TELEFONOS_GET_ACTITUDES = "plugin.mejoras.telefonos.getactitudes";
	public static final String BO_COREEXTENSION_TELEFONOS_GET_APTITUDES = "plugin.mejoras.telefonos.getaptitudes";*/
	public static final String BO_COREEXTENSION_TELEFONOS_GET_ORIGENESTELEFONO = "plugin.mejoras.telefonos.getorigenestelefono";
	public static final String BO_COREEXTENSION_TELEFONOS_GET_MOTIVOSTELEFONO = "plugin.mejoras.telefonos.getmotivostelefono";
	public static final String BO_COREEXTENSION_TELEFONOS_GET_TIPOSTELEFONO = "plugin.mejoras.telefonos.gettipostelefono";
	public static final String BO_COREEXTENSION_TELEFONOS_GET_ESTADOSTELEFONO = "plugin.mejoras.telefonos.getestadostelefono";
	public static final String BO_COREEXTENSION_TELEFONOS_GUARDATELEFONO = "plugin.mejoras.telefonos.guardaTelefonoPersona";
	public static final String BO_COREEXTENSION_TELEFONOS_GETBYID = "plugin.mejoras.telefonos.getById";
	public static final String BO_COREEXTENSION_BUSCA_PERSONA_TELEFONO = "plugin.mejoras.telefonos.buscaPersonaTelefono";
	public static final String BO_COREEXTENSION_BORRA_TELEFONO = "plugin.mejoras.telefonos.borraTelefono";
		
	@BusinessOperationDefinition(BO_COREEXTENSION_TELEFONOS_GET_TELEFONOSCLIENTE)
	List<Telefono> getTelefonosCliente(Long idCliente);

	/*@BusinessOperationDefinition(BO_COREEXTENSION_TELEFONOS_GET_ACTITUDES)
	List<DDTipoAyudaActuacion> getActitudes();

	@BusinessOperationDefinition(BO_COREEXTENSION_TELEFONOS_GET_APTITUDES)
	List<DDCausaImpago> getAptitudes();
	*/
	@BusinessOperationDefinition(BO_COREEXTENSION_TELEFONOS_GET_ORIGENESTELEFONO)
	List<DDOrigenTelefono> getOrigenesTelefono();

	@BusinessOperationDefinition(BO_COREEXTENSION_TELEFONOS_GET_MOTIVOSTELEFONO)
	List<DDMotivoTelefono> getMotivosTelefono();

	@BusinessOperationDefinition(BO_COREEXTENSION_TELEFONOS_GET_TIPOSTELEFONO)
	List<DDTipoTelefono> getTiposTelefono();

	@BusinessOperationDefinition(BO_COREEXTENSION_TELEFONOS_GET_ESTADOSTELEFONO)
	List<DDEstadoTelefono> getEstadosTelefono();

	@BusinessOperationDefinition(BO_COREEXTENSION_TELEFONOS_GUARDATELEFONO)
	void guardaTelefonoCliente(AltaTelefonoDto dto);

	@BusinessOperationDefinition(BO_COREEXTENSION_TELEFONOS_GETBYID)
	Telefono get(Long idTelefono);
	
	@BusinessOperationDefinition(BO_COREEXTENSION_BUSCA_PERSONA_TELEFONO)
	PersonasTelefono buscaPersonaTelefono(Long idTelefono, Long codClienteEntidad);

	@BusinessOperationDefinition(BO_COREEXTENSION_BORRA_TELEFONO)
	void borraTelefono(Long idCliente, Long idTelefono);
	
}
