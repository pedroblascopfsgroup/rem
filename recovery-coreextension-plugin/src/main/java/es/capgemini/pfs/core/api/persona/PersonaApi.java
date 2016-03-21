package es.capgemini.pfs.core.api.persona;

import java.util.List;

import es.capgemini.devon.pagination.Page;
import es.capgemini.pfs.bien.model.Bien;
import es.capgemini.pfs.core.api.asunto.AdjuntoDto;
import es.capgemini.pfs.estadoFinanciero.model.DDSituacionEstadoFinanciero;
import es.capgemini.pfs.persona.dto.DtoUmbral;
import es.capgemini.pfs.persona.dto.EXTDtoBuscarClientes;
import es.capgemini.pfs.persona.model.Persona;
import es.capgemini.pfs.primaria.PrimariaBusinessOperation;
import es.pfsgroup.commons.utils.api.BusinessOperationDefinition;

public interface PersonaApi {
	
	String BO_CORE_PERSONA_ADJUNTOSMAPEADOS = "plugin.coreextension.persona.getAdjuntosPersonaMapeado";
	String BO_CORE_PERSONA_FINDCLIENTES_PROV_SOLVENCIA = "plugin.coreextension.persona.findClientesProveedorSolvencia";
	String BO_CORE_PERSONA_FINDCLIENTES_PROV_SOLVENCIA_EXCEL = "plugin.coreextension.persona.findClientesProveedorSolvenciaExcel";
//	String BO_CORE_PERSONA_CREAR_ADJUNTOS_AMPLIADOS = "plugin.coreextension.persona.crearAdjuntoPersonaAmpliado";
	String BO_CORE_PERSONA_GET_BY_COD_CLIENTE_ENTIDAD = "plugin.coreextension.persona.getPersonaByCodClienteEntidad";
	String BO_CORE_CLIENTES_ACTUACION_CURSO_GET_FSR = "personaManager.getAccionFSRByIdPersona";

	
	@BusinessOperationDefinition(PrimariaBusinessOperation.BO_PER_MGR_UPDATE_UMBRAL)
    public void updateUmbral(DtoUmbral dtoUmbral);

	/**
     * Recupera los bienes de la persona recivida.
     * @param id Long
     * @return Bien
     */
    @BusinessOperationDefinition(PrimariaBusinessOperation.BO_PER_MGR_GET_BIENES)
    public List<Bien> getBienes(Long id);
    
    /**
     * obtiene una persona.
     * @param id id
     * @return persona
     */
    @BusinessOperationDefinition(PrimariaBusinessOperation.BO_PER_MGR_GET)
    public Persona get(Long id);
    
    
    @BusinessOperationDefinition(BO_CORE_PERSONA_ADJUNTOSMAPEADOS)
    public List<? extends AdjuntoDto> getAdjuntosPersonaConBorrado(Long id);
    
    /**
     * Obtiene los clientes que puede ver un usuario con el perfil de proveedor de solvencia
     * @param clientes dto clientes
     * @return Pagina de personas
     */
    @BusinessOperationDefinition(BO_CORE_PERSONA_FINDCLIENTES_PROV_SOLVENCIA)
    public Page findClientesProveedorSolvenciaPaginated(EXTDtoBuscarClientes clientes);
    
    /**
     * Obtiene los clientes que puede ver un usuario con el perfil de proveedor de solvencia
     * @param clientes dto clientes
     * @return Pagina de personas
     */
    @BusinessOperationDefinition(BO_CORE_PERSONA_FINDCLIENTES_PROV_SOLVENCIA_EXCEL)
    public List<Persona> findClientesProveedorSolvenciaExcel(EXTDtoBuscarClientes clientes);
//    @BusinessOperationDefinition(BO_CORE_PERSONA_CREAR_ADJUNTOS_AMPLIADOS)
//    @Transactional(readOnly = false)
//    public String crearAdjuntoPersonaAmpliado(WebFileItem uploadForm);
    
    @BusinessOperationDefinition("getEstadosFinancieros")
    public List<DDSituacionEstadoFinanciero> getEstadosFinancieros();
    /**
     * obtiene la cantidad de vencidos de una persona.
     * @return cantidad de vencidos
     */    
    @BusinessOperationDefinition(PrimariaBusinessOperation.BO_PER_MGR_OBTENER_CANTIDAD_VENCIDOS_USUARIO)
    public Long obtenerCantidadDeVencidosUsuario();
    
    /**
     * obtiene la cantidad de vencidos de una persona.
     * @return cantidad de vencidos
     */
    @BusinessOperationDefinition(PrimariaBusinessOperation.BO_PER_MGR_OBTENER_CANTIDAD_SEG_SISTEMATICO_USUARIO)
    public Long obtenerCantidadDeSeguimientoSistematicoUsuario();
    
    /**
     * obtiene la cantidad de vencidos de una persona.
     * @return cantidad de vencidos
     */
    @BusinessOperationDefinition(PrimariaBusinessOperation.BO_PER_MGR_OBTENER_CANTIDAD_SEG_SINTOMATICO_USUARIO)
    public Long obtenerCantidadDeSeguimientoSintomaticoUsuario();

    
    /**
     * obtiene la persona por su codigo de cliente entidad
     * @param codClienteEntidad
     * @return persona
     */
    @BusinessOperationDefinition(BO_CORE_PERSONA_GET_BY_COD_CLIENTE_ENTIDAD)
    public Persona getPersonaByCodClienteEntidad (Long codClienteEntidad);
    
    /**

     * obtiene las personas por su DNI
     * @param dni
     * @return List<persona>
     */
    public List<Persona> getPersonasByDni(String dni);

    /**
     * 
     * @param idPersona
     * @return booleano de accion FSR
     */
    @BusinessOperationDefinition(BO_CORE_CLIENTES_ACTUACION_CURSO_GET_FSR)
    public Boolean getAccionFSRByIdPersona(Long idPersona);

}
