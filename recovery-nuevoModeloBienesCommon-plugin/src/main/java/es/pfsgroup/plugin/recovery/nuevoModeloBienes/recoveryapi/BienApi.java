package es.pfsgroup.plugin.recovery.nuevoModeloBienes.recoveryapi;

import java.util.List;
import java.util.Map;

import es.capgemini.devon.pagination.Page;
import es.capgemini.devon.web.DynamicElement;
import es.capgemini.pfs.bien.model.Bien;
import es.capgemini.pfs.contrato.dto.BusquedaContratosDto;
import es.capgemini.pfs.direccion.model.DDTipoVia;
import es.capgemini.pfs.direccion.model.Localidad;
import es.capgemini.pfs.primaria.PrimariaBusinessOperation;
import es.capgemini.pfs.tareaNotificacion.model.TareaNotificacion;
import es.pfsgroup.commons.utils.api.BusinessOperationDefinition;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.adjudicacion.dto.DtoNMBBienAdjudicacion;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.bienes.DtoNMBBien;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.bienes.DtoRevisionSolvencia;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.bienes.NMBDtoBuscarClientes;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.model.DDCicCodigoIsoCirbeBKP;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.model.DDUnidadPoblacional;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.model.NMBBien;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.model.NMBBienCargas;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.procedimiento.Dto.BienProcedimientoDTO;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.procedimiento.Dto.DtoSubastaInstrucciones;

public interface BienApi {

	public static String BO_GET_BIENES_PERSONAS_CONTRATOS = "NMBbienManager.getBienesPersonasContratos";
	public static String BO_SET_BIENES_PERSONAS_CONTRATOS = "NMBbienManager.agregarBienes";
	public static String BO_DEL_BIENES_PERSONAS_CONTRATOS = "NMBbienManager.excluirBienes";
	public static String BO_BIENES_ASUNTO = "NMBbienManager.getBienesAsunto";
	public static String BO_BIENES_ASUNTO_PROCEDIMIENTO = "NMBbienManager.getBienesAsuntoTipoPocedimiento";
	public static String BO_BIENES_ASUNTO_PROCEDIMIENTOS = "NMBbienManager.getBienesAsuntoTiposPocedimientos";
	public static String BO_GET_TAREAS_BIEN_ASUNTO = "NMBbienManager.getTareasBienAsunto";
	public static String BO_BIEN_GET_INSTANCE_OF = "NMBbienManager.getInstanceOf"; 
	public static String BO_COMPROBAR_HITO_BIEN = "NMBbienManager.comprobarHitoBien";
	public static String BO_GET_TAREA_BIEN = "NMBbienManager.getTareaBien";
	public static String GET_LIST_LOCALIDADES = "NMBbienManager.getListLocalidades";
	public static String GET_LIST_UNIDADES_POBLACIONALES = "NMBbienManager.getListUnidadesPoblacionales";
	public static String GET_LIST_PAISES = "NMBbienManager.getListPaises";
	public static String GET_LIST_TIPOS_VIA = "NMBbienManager.getListTiposVia";
	public static String GET_BIEN_BY_ID = "NMBbienManager.getBienById";
	public static String GET_NUMEROS_ACTIVOS_BIENES = "NMBbienManager.getNumerosActivosBienes";
	
	/**
     * Recupera el Bien indicado.
     * @param id Long
     * @return Bien
     */
    @BusinessOperationDefinition(PrimariaBusinessOperation.BO_BIEN_MGR_GET)
    public Bien get(Long id);
    
    @BusinessOperationDefinition("NMBbienManager.createOrUpdateNMB")
    public NMBBien createOrUpdateNMB(DtoNMBBien dtoBien, Long idPersona);
    
    @BusinessOperationDefinition("NMBbienManager.saveParticipacionNMB")
    public void saveParticipacionNMB(float participacion, Long idBien, Long idPersona);
    
    @BusinessOperationDefinition("NMBbienManager.saveBienContrato")
    public void saveBienContrato(Long idContrato, Long idBien, String tipoBienContrato);
    
    @BusinessOperationDefinition("NMBbienManager.marcarBienAutomatico")
    public void marcarBienAutomatico (Long idBien);
    
    @BusinessOperationDefinition("NMBbienManager.getTabs")
    public List<DynamicElement> getTabs(long idBien);
    
    @BusinessOperationDefinition("NMBbienManager.getButtons")
	public List<DynamicElement> getButtons(long idBien);
    
    @BusinessOperationDefinition("NMBbienManager.getClientesPaginados")
	public Page getClientesPaginados(NMBDtoBuscarClientes dto);
    
    @BusinessOperationDefinition("NMBbienManager.getContratosPaginados")
	public Page getContratosPaginados(BusquedaContratosDto dto);    
    
    @BusinessOperationDefinition("NMBbienManager.saveInstruccionesNMB")
    public void saveInstruccionesNMB(DtoSubastaInstrucciones dtoInstrucciones);
    
    @BusinessOperationDefinition("plugin.clientes.marcarRevisionSolvencia")
    public void marcarRevisioinSolvencia(DtoRevisionSolvencia dto);
    
    @BusinessOperationDefinition("plugin.clientes.getGestorProveedorSolvencia")
    public String getGestorProveedorSolvencia(Long idPersona);
    
    @BusinessOperationDefinition("NMBbienManager.getCarga")
    public NMBBienCargas getCarga(Long idCarga);

    @BusinessOperationDefinition(BO_GET_BIENES_PERSONAS_CONTRATOS)
	public List<BienProcedimientoDTO> getBienesPersonasContratos(Long idProcedimiento, String accion, String numFinca, String numActivo);

    @BusinessOperationDefinition(BO_SET_BIENES_PERSONAS_CONTRATOS)
	void agregarBienes(Long idProcedimiento, String[] arrBien, String[] arrCodSolvencia);

    @BusinessOperationDefinition(BO_DEL_BIENES_PERSONAS_CONTRATOS)
	void excluirBienes(Long idProcedimiento, String[] arrBien);    
    
    /**
     * Devuelve los bienes de todos los procedimientos de un asunto
     * @param idAsunto
     * @return
     */
	@BusinessOperationDefinition(BO_BIENES_ASUNTO)
	List<Bien> getBienesAsunto(Long idAsunto);
	
	/**
	 * Devuelve los bienes y sus tareas del tipo de procedimiento que se pase por parámetro del asunto
	 * @param idAsunto Long
	 * @param tipoProcedimiento String
	 * @return
	 */
	@BusinessOperationDefinition(BO_BIENES_ASUNTO_PROCEDIMIENTO)
	List<DtoNMBBienAdjudicacion> getBienesAsuntoTipoPocedimiento(Long idAsunto,String tipoProcedimiento,Boolean conTareasActivas);

	/**
	 * Devuelve los bienes y sus tareas de los tipos de procedimiento que se pasen en el List por parámetro del asunto
	 * 
	 * @param idAsunto - El asunto
	 * @param tipoProcedimiento - List de tipos de procedimiento
	 * @param soloDeusuario - Solo devuelve bienes que tenga tareas del usuario logado
	 * @return
	 */
	@BusinessOperationDefinition(BO_BIENES_ASUNTO_PROCEDIMIENTOS)
	List<DtoNMBBienAdjudicacion> getBienesAsuntoTiposPocedimientos(Long idAsunto,List<String> tipoProcedimiento,Boolean soloDeUsuario);
	
	/**
	 * Devuelve un HashMap con las tareas en las que se encuentra el bien 
	 * @param idAsunto
	 * @param bien 
	 * @param tiposProcedimientos
	 * @param soloTareasUsuario - Indica que solo obtenga las tareas del usuario
	 * @return
	 */
	@BusinessOperationDefinition(BO_GET_TAREAS_BIEN_ASUNTO)
	Map<String,TareaNotificacion> getTareasBienAsunto(Long idAsunto, NMBBien bien, Map<String, String> tiposProcedimientos, Boolean soloTareasUsuario);
	
	/**
	 * Si el objeto es un NMBBien devuelve este objeto, sino null
	 * @param bien
	 * @return
	 */
	@BusinessOperationDefinition(BO_BIEN_GET_INSTANCE_OF)
	NMBBien getInstanceOf(Bien bien);
	
	/**
	 * Comprueba que los bienes pasados en el array están en ese asunto en la misma tarea
	 * @param idAsunto
	 * @param arrBien
	 * @param tipoProcedimiento
	 * @param soloTareasUsuario
	 * @return
	 */
	@BusinessOperationDefinition(BO_COMPROBAR_HITO_BIEN)
	public Boolean comprobarHitoBien(Long idAsunto, String[] arrBien, String tipoProcedimiento, Boolean soloTareasUsuario);
	
	/**
	 * Devuelve la tarea notificación del bien del asunto y tipo procedimiento
	 * @param idAsunto
	 * @param idBien
	 * @param tipoProcedimiento
	 * @param soloTareasUsuario
	 * @return
	 */
	@BusinessOperationDefinition(BO_GET_TAREA_BIEN)
	public TareaNotificacion getTareaNotificacionBien(Long idAsunto, Long idBien, String tipoProcedimiento, Boolean soloTareasUsuario);
	
	
	/**
	 * Devuelve las localidades de una provincia
	 * @param idProvincia
	 * @return
	 */
	@BusinessOperationDefinition(GET_LIST_LOCALIDADES)
	public List<Localidad> getListLocalidades(String codProvincia);
	
	/**
	 * Devuelve las unidades poblacionales de una localidad
	 * @param idLocalidad
	 * @return
	 */
	@BusinessOperationDefinition(GET_LIST_UNIDADES_POBLACIONALES)
	public List<DDUnidadPoblacional> getListUnidadesPoblacionales(String codLocalidad);
	
	@BusinessOperationDefinition(GET_LIST_PAISES)
	public List<DDCicCodigoIsoCirbeBKP> getListPaises();

	@BusinessOperationDefinition(GET_LIST_TIPOS_VIA)
	public List<DDTipoVia> getListTiposVia();

	@BusinessOperationDefinition(GET_BIEN_BY_ID)
	public Bien getBienById(Long id);
	
	@BusinessOperationDefinition(GET_NUMEROS_ACTIVOS_BIENES)
	public Map<String, String> getNumerosActivosBienes(final String[] arrBien);

}
