package es.pfsgroup.plugin.recovery.coreextension.api;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;

import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.devon.pagination.Page;
import es.capgemini.pfs.asunto.model.Asunto;
import es.capgemini.pfs.despachoExterno.model.DDTipoDespachoExterno;
import es.capgemini.pfs.despachoExterno.model.DespachoExterno;
import es.capgemini.pfs.despachoExterno.model.GestorDespacho;
import es.capgemini.pfs.multigestor.model.EXTDDTipoGestor;
import es.capgemini.pfs.multigestor.model.EXTGestorAdicionalAsunto;
import es.capgemini.pfs.multigestor.model.EXTGestorAdicionalAsuntoHistorico;
import es.capgemini.pfs.procesosJudiciales.model.TipoProcedimiento;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.api.BusinessOperationDefinition;

//FIXME Hay que eliminar esta clase o renombrarla
// No a�adir nueva funcionalidad
public interface coreextensionApi {

	String GET_LIST_TIPO_GESTOR = "plugin.recovery.coreextension.api.getList";
	String GET_LIST_TIPO_GESTOR_DESPACHO = "plugin.recovery.coreextension.api.getListTipoGestor";
	String GET_STRING_TIPOS_GESTOR_DESPACHO = "plugin.recovery.coreextension.api.getStringTiposGestor";
	String GET_LIST_TIPO_GESTOR_ADICIONAL = "plugin.recovery.coreextension.api.getListTipoGestorAdicional";
	String GET_LIST_TIPO_DESPACHO = "plugin.recovery.coreextension.api.getListDespacho";
	String GET_LIST_ALL_TIPO_DESPACHO = "plugin.recovery.coreextension.api.getListAllDespachos";	
	String GET_LIST_USUARIOS = "plugin.recovery.coreextension.api.getListUsuariosData";
	String GET_LIST_ALL_USUARIOS = "plugin.recovery.coreextension.api.getListAllUsuariosData";
	String GET_LIST_ALL_USUARIOS_POR_DEFECTO = "plugin.recovery.coreextension.api.getListAllUsuariosPorDefectoData";
	String GET_LIST_USUARIOS_PAGINATED = "plugin.recovery.coreextension.api.getListUsuariosPaginatedData";
	String GET_LIST_HISTORICO_GESTORES_ADICIONALES = "plugin.recovery.coreextension.api.getListGestorAdicionalAsuntoHistoricosData";
	String SAVE_GESTOR = "plugin.recovery.coreextension.api.insertarGestor";
	String SAVE_GESTOR_ADICIONAL_ASUNTO = "plugin.recovery.coreextension.api.insertarGestorAdicionalAsunto";
	String REMOVE_GESTOR = "plugin.recovery.coreextension.api.removeGestor";
	String GET_LIST_TIPO_PROCEDIMIENTO_POR_TIPO_ACTUACION = "plugin.recovery.coreextension.api.getListTipoProcedimientoPorTipoActuacion";
	String GET_LIST_TIPO_PROCEDIMIENTO_MENOS_TIPO_ACTUACION = "plugin.recovery.coreextension.api.getListTipoProcedimientoMenosTipoActuacion";
	
	String GET_LIST_TIPO_DESPACHO_DE_USUARIO = "plugin.recovery.coreextension.api.getListDespachosDeUsuario";
	String GET_LIST_TIPO_GESTOR_DE_USUARIO = "plugin.recovery.coreextension.api.getLisTipoGestorDeUsuario";
	String GET_LIST_TIPO_PROCEDIMIENTO_BY_PROPIEDAD_ASUNTO = "plugin.recovery.coreextension.api.getListTipoProcedimientoByPropiedadAsunto";
	String GET_LIST_USUARIOS_DEFECTO_PAGINATED = "plugin.recovery.coreextension.api.getListUsuariosDefectoPaginatedData";
	String GET_LIST_TIPO_GESTOR_ADICIONAL_POR_ASUNTO= "plugin.recovery.coreextension.api.getListTipoGestorAdicionalPorAsunto";
	String GET_USUARIO_GESTOR_OFICINA_EXPEDIENTE= "plugin.recovery.coreextension.api.getUsuarioGestorOficinaExpedienteGestorDeuda";
	String GET_LIST_PERFILES_GESTORES_ESPECIALES= "plugin.recovery.coreextension.api.getListPerfilesGestoresEspeciales";
	String GET_SUPERVISOR_GESTOR_ADICIONAL_POR_CODIGO_ENTIDAD= "plugin.recovery.coreextension.api.getSupervisorPorAsuntoEntidad";
	String GET_TIPO_GESTOR_SUPERVISOR_POR_CODIGO_ENTIDAD= "plugin.recovery.coreextension.api.getTipoGestorSupervisorPorAsuntoEntidad";
	String GET_DESPACHO_SUPERVISOR_POR_CODIGO_ENTIDAD= "plugin.recovery.coreextension.api.getDespachoSupervisorPorAsuntoEntidad";

	
	@BusinessOperationDefinition(GET_LIST_TIPO_GESTOR)
	List<EXTDDTipoGestor> getList(String ugCodigo);
	
	/**
	 * Funci�n de negocio que devuelve el listado de tipos de gestores del asunto. 
	 * Ordenado por descripci�n.
	 * 
	 * @return Lista de {@link EXTDDTipoGestor}
	 */
	@BusinessOperationDefinition(GET_LIST_TIPO_GESTOR_ADICIONAL)
	List<EXTDDTipoGestor> getListTipoGestorAdicional();

	/**
	 * Funci�n de negocio que devuelve el listado de despachos para un tipo de gestor dado.
	 * Ordenado por el campo despacho.
	 * 
	 * @param idTipoGestor id del tipo de gestor. {@link EXTDDTipoGestor}
	 * @return Lista de despachos. {@link DespachoExterno}
	 */
	@BusinessOperationDefinition(GET_LIST_TIPO_DESPACHO)
	List<DespachoExterno> getListDespachos(Long idTipoGestor);
	
	/**
	 * Funci�n de negocio que devuelve el listado de despachos para un tipo de gestor dado.
	 * Ordenado por el campo despacho.
	 * 
	 * @param idTipoGestor id del tipo de gestor. {@link EXTDDTipoGestor}
	 * @return Lista de despachos. {@link DespachoExterno}
	 */
	@BusinessOperationDefinition(GET_LIST_ALL_TIPO_DESPACHO)
	List<DespachoExterno> getListAllDespachos(Long idTipoGestor, Boolean incluirBorrados);
	
	
	@BusinessOperationDefinition(GET_LIST_PERFILES_GESTORES_ESPECIALES)
	HashMap<String,Set<String>> getListPerfilesGestoresEspeciales(String codigoEntidadUsuario);
	
	@BusinessOperationDefinition(GET_LIST_TIPO_GESTOR_ADICIONAL_POR_ASUNTO)
	List<EXTDDTipoGestor> getListTipoGestorAdicionalPorAsunto(String idTipoAsunto);
	
	@BusinessOperationDefinition(GET_SUPERVISOR_GESTOR_ADICIONAL_POR_CODIGO_ENTIDAD)
	Usuario getSupervisorPorAsuntoEntidad(String codigoEntidadUsuario, String idTipoAsunto);
	
	@BusinessOperationDefinition(GET_TIPO_GESTOR_SUPERVISOR_POR_CODIGO_ENTIDAD)
	EXTDDTipoGestor getTipoGestorSupervisorPorAsuntoEntidad(String codigoEntidadUsuario, String idTipoAsunto);
	
	@BusinessOperationDefinition(GET_DESPACHO_SUPERVISOR_POR_CODIGO_ENTIDAD)
	DespachoExterno getDespachoSupervisorPorAsuntoEntidad(String codigoEntidadUsuario, String idTipoAsunto);
	
	/**
	 * Funci�n de negocio que devuelve el listado de usuarios para un tipo de despacho dado.
	 * Ordenado por {@link Usuario#getApellidoNombre()}
	 * 
	 * @param idTipoDespacho id del despacho. {@link DespachoExterno}
	 * @return Lista de usuarios. {@link Usuario}
	 */
	@BusinessOperationDefinition(GET_LIST_USUARIOS)
	List<Usuario> getListUsuariosData(long idTipoDespacho);
	
	/**
	 * Funci�n de negocio que devuelve el listado de usuarios para un tipo de despacho dado
	 * e incluyendo los borrados en función del valor de incluirBorrados.
	 * Ordenado por {@link Usuario#getApellidoNombre()}
	 * 
	 * @param idTipoDespacho id del despacho. {@link DespachoExterno}
	 * @param incluirBorrados true or false
	 * @return Lista de usuarios. {@link Usuario}
	 */
	@BusinessOperationDefinition(GET_LIST_ALL_USUARIOS)
	List<Usuario> getListAllUsuariosData(long idTipoDespacho, boolean incluirBorrados);
	
	/**
	 * Funci�n de negocio que devuelve el listado de usuarios para un tipo de despacho dado.
	 * Soporta paginaci�n y b�squeda.
	 * Ordenado por {@link Usuario#getApellidoNombre()}
	 * 
	 * @param usuarioDto dto con los par�metros de b�squeda y paginaci�n. {@link UsuarioDto}
	 * @return P�gina de usuarios obtenida.
	 */
	
	@BusinessOperationDefinition(GET_USUARIO_GESTOR_OFICINA_EXPEDIENTE)
	List<Usuario> getUsuarioGestorOficinaExpedienteGestorDeuda(long idExpediente, String codigoPerfil);
	/**
	 * Funci�n de negocio que devuelve el usuario para un expediente y un codigo de perfil.
	 * 
	 * @param idExpediente id del expediente
	 * @param codigoPerfil codigo del perfil
	 * @return Usuario
	 */
	
	
	
	@BusinessOperationDefinition(GET_LIST_USUARIOS_PAGINATED)
	Page getListUsuariosPaginatedData(UsuarioDto usuarioDto);
	
	/**
	 * Funci�n de negocio que devuelve el listado de usuarios para un tipo de despacho dado.
	 * Soporta paginaci�n y b�squeda.
	 * Ordenado por {@link GestorDespacho#getGestorPorDefecto()}
	 * @param usuarioDto dto con los par�metros de b�squeda y paginaci�n. {@link UsuarioDto}
	 * @return P�gina de usuarios obtenida.
	 */
	@BusinessOperationDefinition(GET_LIST_USUARIOS_DEFECTO_PAGINATED)
	Page getListUsuariosDefectoPaginatedData(UsuarioDto usuarioDto);

	@BusinessOperationDefinition(SAVE_GESTOR)
	void insertarGestor(Long idTipoGestor, Long idAsunto, Long idUsuario);

	/**
	 * Funci�n de negocio que inserta un gestor en la tabla de gestores adicionales, {@link EXTGestorAdicionalAsunto}
	 * Tambi�n se guada el hist�rico de cambios en {@link EXTGestorAdicionalAsuntoHistorico} 
	 * 
	 * @param idTipoGestor id del tipo de gestor, {@link EXTDDTipoGestor}
	 * @param idAsunto id del {@link Asunto}
	 * @param idUsuario id del {@link Usuario}
	 * @param idTipoDespacho id del tipo de despacho, {@link GestorDespacho}
	 * 
	 */
	@BusinessOperationDefinition(SAVE_GESTOR_ADICIONAL_ASUNTO)
	void insertarGestorAdicionalAsunto(Long idTipoGestor, Long idAsunto, Long idUsuario, Long idTipoDespacho) throws Exception;
	
	@BusinessOperationDefinition(REMOVE_GESTOR)
	void removeGestor(Long idAsunto, Long idUsuario, String codTipoGestor);
	
	@BusinessOperationDefinition(GET_LIST_TIPO_PROCEDIMIENTO_POR_TIPO_ACTUACION)
	List<TipoProcedimiento> getListTipoProcedimientosPorTipoActuacion(String codigoActuacion);
	
	@BusinessOperationDefinition(GET_LIST_TIPO_PROCEDIMIENTO_MENOS_TIPO_ACTUACION)
	public List<TipoProcedimiento> getListTipoProcedimientosMenosTipoActuacion(String codigoActuacion);

	/**
	 * Funci�n de negocio que devuelve el listado de gestores de un asunto, as� como el hist�rico de cambios.
	 * En el listado primero aparece el gestor activo (con el campo fechaHasta nulo) y despu�s el hist�rico de cambios.
	 * Ordenado por tipo de gestor, fechaDesde.
	 *  
	 * @param idAsunto id del asunto
	 * @return Lista de gestores {@link EXTGestorAdicionalAsuntoHistorico}
	 */
	@BusinessOperationDefinition(GET_LIST_HISTORICO_GESTORES_ADICIONALES)
	List<EXTGestorAdicionalAsuntoHistorico> getListGestorAdicionalAsuntoHistoricosData(Long idAsunto);

	/**
	 * Devuelve los codigos del los tipos de gestor en un String separados por comas que pertenecen a un tipo de despacho dado
	 * @param valor id del tipo de despacho
	 * @return
	 */
	@BusinessOperationDefinition(GET_STRING_TIPOS_GESTOR_DESPACHO)
	String getTiposGestorDespacho(Long id);

	/**
	 * Devuelve una lista con los tipos de gestor que pertenecen al codigo de tipo de despacho dado
	 * @param codTipoDespacho
	 * @return
	 */
	@BusinessOperationDefinition(GET_LIST_TIPO_GESTOR_DESPACHO)
	List<EXTDDTipoGestor> getListDespacho(String codTipoDespacho);

	/**
	 * Funci�n de negocio que devuelve el listado de despachos para un tipo de gestor dado.
	 * Ordenado por el campo despacho.
	 * 
	 * @param idTipoGestor id del tipo de gestor. {@link EXTDDTipoGestor}
	 * @param idUsuario filtro para los que pertenecen al Usuario propietario
	 * @param adicional si es true añadirá los de tipo GEST
	 * @param procuradorAdicional si es true añadirá los de tipo PROC
	 * @return Lista de despachos. {@link DespachoExterno}
	 */
	@BusinessOperationDefinition(GET_LIST_TIPO_DESPACHO_DE_USUARIO)
	List<DespachoExterno> getListDespachosDeUsuario(Long idTipoGestor, Long idUsuario, boolean adicional, boolean procuradorAdicional);

	/**
	 * Devuelve una lista con los tipos de gestor que pertenecen al usuario determinado
	 * 
	 * @param idUsuario filtro para los que pertenecen al Usuario propietario
	 * @param adicional si es true añadirá los de tipo GEST
	 * @return
	 */
	@BusinessOperationDefinition(GET_LIST_TIPO_GESTOR_DE_USUARIO)
	List<EXTDDTipoGestor> getListTipoGestorDeUsuario(Long idUsuario, boolean adicional, boolean procuradorAdicional);

	@BusinessOperationDefinition(GET_LIST_TIPO_PROCEDIMIENTO_BY_PROPIEDAD_ASUNTO)
	List<TipoProcedimiento> getListTipoProcedimientosPorTipoActuacionByPropiedadAsunto(String codigoTipoAct, Long prcId);
	
	@BusinessOperationDefinition(GET_LIST_ALL_USUARIOS_POR_DEFECTO)
	List<Usuario> getListAllUsuariosPorDefectoData(long idTipoDespacho, boolean incluirBorrados);
	
}
