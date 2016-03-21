package es.pfsgroup.plugin.recovery.mejoras.acuerdos;

import java.util.Date;
import java.util.List;
import java.util.Map;

import org.springframework.transaction.annotation.Transactional;

import es.capgemini.pfs.acuerdo.dto.DtoAcuerdo;
import es.capgemini.pfs.acuerdo.model.DDSubTipoAcuerdo;
import es.capgemini.pfs.acuerdo.model.DDTipoAcuerdo;
import es.capgemini.pfs.bien.model.Bien;
import es.capgemini.pfs.contrato.model.Contrato;
import es.capgemini.pfs.contrato.model.DDTipoProducto;
import es.capgemini.pfs.despachoExterno.model.DDTipoDespachoExterno;
import es.capgemini.pfs.termino.dto.ListadoTerminosAcuerdoDto;
import es.capgemini.pfs.termino.model.TerminoAcuerdo;
import es.capgemini.pfs.termino.model.TerminoBien;
import es.capgemini.pfs.termino.model.TerminoContrato;
import es.capgemini.pfs.termino.model.TerminoOperaciones;
import es.pfsgroup.commons.utils.api.BusinessOperationDefinition;
import es.pfsgroup.recovery.ext.impl.acuerdo.model.ACDAcuerdoDerivaciones;
import es.pfsgroup.recovery.ext.impl.acuerdo.model.EXTAcuerdo;

public interface MEJAcuerdoApi {
	
	
    
	public static final String BO_ACUERDO_MGR_RECHAZAR_ACUERDO_MOTIVO = "mejacuerdo.rechazaAcuerdoMotivo";
	public static final String BO_EXT_ACUERDO_MGR_GUARDAR_ACUERDO = "mejacuerdo.guardarAcuerdo";
	public static final String BO_ACUERDO_MGR_GET_LISTADO_CONTRATOS_ACUERDO_ASUNTO = "mejacuerdo.obtenerListadoContratosAcuerdoByAsuId";
	public static final String BO_ACUERDO_MGR_GET_LISTADO_TERMINOS_ACUERDO_ASUNTO = "mejacuerdo.obtenerListadoTerminosAcuerdoByAcuId";	
	public static final String BO_ACUERDO_MGR_GET_LISTADO_TIPO_ACUERDO = "mejacuerdo.getListTipoAcuerdo";	
	public static final String BO_ACUERDO_MGR_GET_LISTADO_SUB_TIPO_ACUERDO = "mejacuerdo.getListSubTipoAcuerdo";	
	public static final String BO_ACUERDO_MGR_GET_LISTADO_TIPO_PRODUCTO = "mejacuerdo.getListTipoProducto";		
	public static final String BO_ACUERDO_MGR_SAVE_TERMINO_ACUERDO = "mejacuerdo.saveTerminoAcuerdo";	
	public static final String BO_ACUERDO_MGR_SAVE_TERMINO_CONTRATO = "mejacuerdo.saveTerminoContrato";	
	public static final String BO_ACUERDO_MGR_SAVE_TERMINO_BIEN = "mejacuerdo.saveTerminoBien";	
	public static final String BO_ACUERDO_MGR_GET_LISTADO_BIENES_ASUNTO = "mejacuerdo.obtenerListadoBienesAcuerdoByAsuId";	
	public static final String BO_ACUERDO_MGR_GET_LISTADO_BIENES_TERMINO = "mejacuerdo.obtenerListadoBienesAcuerdoByTeaId";	
	public static final String BO_ACUERDO_MGR_DELETE_TERMINO_ACUERDO = "mejacuerdo.deleteTerminoAcuerdo";
	public static final String BO_ACUERDO_MGR_DELETE_VALORES_TERMINO = "mejacuerdo.deleteAllValoresTermino";
	public static final String BO_ACUERDO_MGR_DELETE_TERMINO_CONTRATO = "mejacuerdo.deleteTerminoContrato";	
	public static final String BO_ACUERDO_MGR_DELETE_TERMINO_BIEN = "mejacuerdo.deleteTerminoBien";	
	public static final String BO_ACUERDO_MGR_DELETE_TERMINO_OPERACIONES = "mejacuerdo.deleteTerminoOperaciones";		
	public static final String BO_ACUERDO_MGR_GET_TERMINO_ACUERDO = "mejacuerdo.getTerminoAcuerdo";	
	public static final String BO_ACUERDO_MGR_GET_TIPOS_DESPACHO_ACUERDO_ASUNTO = "mejacuerdo.getTiposDespachoAcuerdoAsunto";
	public static final String BO_ACUERDO_MGR_GET_PUEDE_EDITAR_ACUERDO_ASUNTO = "mejacuerdo.puedeEditar";
	public static final String BO_ACUERDO_MGR_TIPO_GESTOR_PROPONENTE_ACUERDO_ASUNTO = "mejacuerdo.esProponenteAcuerdoAsunto";
	public static final String BO_ACUERDO_MGR_TIPO_GESTOR_VALIDADOR_ACUERDO_ASUNTO = "mejacuerdo.esValidadorAcuerdoAsunto";
	public static final String BO_ACUERDO_MGR_TIPO_GESTOR_DECISOR_ACUERDO_ASUNTO = "mejacuerdo.esDecisorAcuerdoAsunto";
	public static final String BO_ACUERDO_MGR_CONTINUAR_ACUERDO = "mejacuerdo.continuarAcuerdo";
	public static final String BO_ACUERDO_MGR_ACUERDO_CERRAR = "mejacuerdo.cerrarAcuerdo";
	public static final String BO_ACUERDO_MGR_GET_VALIDACION_TRAMITE_CORRESPONDIENTE = "mejacuerdo.validacionTramiteCorrespondiente";
	public static final String BO_ACUERDO_MGR_GUARDAR_ESTADO_GESTION = "mejacuerdo.guardarEstadoGestion";
	public static final String BO_ACUERDO_MGR_GET_FECHA_PASE_MORA = "mejacuerdo.getFechaPaseMora";
	
    
	/**
     * Pasa un acuerdo a estado Rechazado con motivo.
     * @param idAcuerdo el id del acuerdo a rechazar
     */
	@BusinessOperationDefinition(BO_ACUERDO_MGR_RECHAZAR_ACUERDO_MOTIVO)
    @Transactional(readOnly = false)
    public void rechazarAcuerdoMotivo(Long idAcuerdo, Long idMotivo, String observaciones);
    
    @BusinessOperationDefinition(BO_EXT_ACUERDO_MGR_GUARDAR_ACUERDO)
    @Transactional(readOnly = false) 
    public Long guardarAcuerdo(DtoAcuerdo dto);
    
    @BusinessOperationDefinition(BO_ACUERDO_MGR_GET_LISTADO_CONTRATOS_ACUERDO_ASUNTO)
    public List<Contrato> obtenerListadoContratosAcuerdoByAsuId(Long idAsunto) ;
    
	public List<TerminoAcuerdo> getTerminosAcuerdo(Long idAcuerdo);
	
	public List<TerminoContrato> getTerminoAcuerdoContratos(Long idTermino);

	public List<TerminoBien> getTerminoAcuerdoBienes(Long idTermino);
	
    @BusinessOperationDefinition(BO_ACUERDO_MGR_GET_LISTADO_TERMINOS_ACUERDO_ASUNTO)
    public List<ListadoTerminosAcuerdoDto> obtenerListadoTerminosAcuerdoByAcuId(Long idAcuerdo) ;   
    
	@BusinessOperationDefinition(BO_ACUERDO_MGR_GET_LISTADO_TIPO_ACUERDO)
	public List<DDTipoAcuerdo> getListTipoAcuerdo(String ambito);   
	
	@BusinessOperationDefinition(BO_ACUERDO_MGR_GET_LISTADO_SUB_TIPO_ACUERDO)
	public List<DDSubTipoAcuerdo> getListSubTipoAcuerdo(); 
	
	@BusinessOperationDefinition(BO_ACUERDO_MGR_GET_LISTADO_TIPO_PRODUCTO)
	public List<DDTipoProducto> getListTipoProducto();    	
	
	
	@BusinessOperationDefinition(BO_ACUERDO_MGR_SAVE_TERMINO_ACUERDO)
	@Transactional(readOnly = false)
	public TerminoAcuerdo saveTerminoAcuerdo(TerminoAcuerdo ta);    
	
	@BusinessOperationDefinition(BO_ACUERDO_MGR_SAVE_TERMINO_CONTRATO)
	@Transactional(readOnly = false)
	public void saveTerminoContrato(TerminoContrato tc);    
	
	@BusinessOperationDefinition(BO_ACUERDO_MGR_SAVE_TERMINO_BIEN)
	@Transactional(readOnly = false)
	public void saveTerminoBien(TerminoBien tb); 	

	@BusinessOperationDefinition(BO_ACUERDO_MGR_GET_LISTADO_BIENES_ASUNTO)
	public List<Bien> obtenerListadoBienesAcuerdoByAsuId(Long idAsunto);   
	
	@BusinessOperationDefinition(BO_ACUERDO_MGR_GET_LISTADO_BIENES_TERMINO)
	public List<Bien> obtenerListadoBienesAcuerdoByTeaId(Long idTermino); 

	@BusinessOperationDefinition(BO_ACUERDO_MGR_DELETE_TERMINO_ACUERDO)
	@Transactional(readOnly = false)
	public void deleteTerminoAcuerdo(TerminoAcuerdo ta);    
	
	@BusinessOperationDefinition(BO_ACUERDO_MGR_DELETE_VALORES_TERMINO)
	@Transactional(readOnly = false)	
    public void deleteAllValoresTermino(TerminoAcuerdo ta);
	
	@Transactional(readOnly = false)
	public void saveAllValoresTermino(TerminoAcuerdo ta);
	
	@BusinessOperationDefinition(BO_ACUERDO_MGR_DELETE_TERMINO_CONTRATO)
	@Transactional(readOnly = false)
	public void deleteTerminoContrato(TerminoContrato tc); 
	
	@BusinessOperationDefinition(BO_ACUERDO_MGR_DELETE_TERMINO_BIEN)
	@Transactional(readOnly = false)
	public void deleteTerminoBien(TerminoBien tb); 	
	
	@BusinessOperationDefinition(BO_ACUERDO_MGR_DELETE_TERMINO_OPERACIONES)
	@Transactional(readOnly = false)
	public void deleteTerminoOperaciones(TerminoOperaciones to); 	
	
	@BusinessOperationDefinition(BO_ACUERDO_MGR_GET_TERMINO_ACUERDO)
	public TerminoAcuerdo getTerminoAcuerdo(Long idTermino);  
	
	@BusinessOperationDefinition(BO_ACUERDO_MGR_GET_TIPOS_DESPACHO_ACUERDO_ASUNTO)
	public Map<String, DDTipoDespachoExterno> getTiposDespachoAcuerdoAsunto(Long idTipoGestorProponente);
	
	@BusinessOperationDefinition(BO_ACUERDO_MGR_GET_PUEDE_EDITAR_ACUERDO_ASUNTO)
	public boolean puedeEditar(Long idAcuerdo);
	
	@BusinessOperationDefinition(BO_ACUERDO_MGR_TIPO_GESTOR_PROPONENTE_ACUERDO_ASUNTO)
	public boolean esProponenteAcuerdoAsunto(Long idTipoGestorAsunto);
	
	@BusinessOperationDefinition(BO_ACUERDO_MGR_TIPO_GESTOR_VALIDADOR_ACUERDO_ASUNTO)
	public boolean esValidadorAcuerdoAsunto(Long idTipoGestorAsunto);
	
	@BusinessOperationDefinition(BO_ACUERDO_MGR_TIPO_GESTOR_DECISOR_ACUERDO_ASUNTO)
	public boolean esDecisorAcuerdoAsunto(Long idTipoGestorAsunto);
	
	@BusinessOperationDefinition(BO_ACUERDO_MGR_CONTINUAR_ACUERDO)
	public void continuarAcuerdo(Long id);
	
	@BusinessOperationDefinition(BO_ACUERDO_MGR_ACUERDO_CERRAR)
	public void cerrarAcuerdo(Long id);
	
	@BusinessOperationDefinition(BO_ACUERDO_MGR_GET_VALIDACION_TRAMITE_CORRESPONDIENTE)
	public List<ACDAcuerdoDerivaciones> getValidacionTramiteCorrespondiente(EXTAcuerdo acuerdo, boolean soloTramitesSinIniciar);

	@BusinessOperationDefinition(BO_ACUERDO_MGR_GUARDAR_ESTADO_GESTION)
	public void guardarEstadoGestion(Long idTermino, Long nuevoEstadoGestion);
	
	@BusinessOperationDefinition(BO_ACUERDO_MGR_GET_FECHA_PASE_MORA)
	public String getFechaPaseMora(Long idContrato);

}
