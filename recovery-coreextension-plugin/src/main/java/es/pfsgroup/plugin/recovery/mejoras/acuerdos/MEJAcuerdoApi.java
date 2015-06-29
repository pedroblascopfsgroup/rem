package es.pfsgroup.plugin.recovery.mejoras.acuerdos;

import java.util.List;

import org.springframework.transaction.annotation.Transactional;

import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.pfs.acuerdo.dto.DtoAcuerdo;
import es.capgemini.pfs.acuerdo.model.DDTipoAcuerdo;
import es.capgemini.pfs.bien.model.Bien;
import es.capgemini.pfs.contrato.model.Contrato;
import es.capgemini.pfs.contrato.model.DDTipoProducto;
import es.capgemini.pfs.externa.ExternaBusinessOperation;
import es.capgemini.pfs.termino.dto.ListadoTerminosAcuerdoDto;
import es.capgemini.pfs.termino.model.TerminoAcuerdo;
import es.capgemini.pfs.termino.model.TerminoBien;
import es.capgemini.pfs.termino.model.TerminoContrato;
import es.pfsgroup.commons.utils.api.BusinessOperationDefinition;

public interface MEJAcuerdoApi {
	
	
    
	public static final String BO_ACUERDO_MGR_RECHAZAR_ACUERDO_MOTIVO = "mejacuerdo.rechazaAcuerdoMotivo";
	public static final String BO_EXT_ACUERDO_MGR_GUARDAR_ACUERDO = "mejacuerdo.guardarAcuerdo";
	public static final String BO_ACUERDO_MGR_GET_LISTADO_CONTRATOS_ACUERDO_ASUNTO = "mejacuerdo.obtenerListadoContratosAcuerdoByAsuId";
	public static final String BO_ACUERDO_MGR_GET_LISTADO_TERMINOS_ACUERDO_ASUNTO = "mejacuerdo.obtenerListadoTerminosAcuerdoByAcuId";	
	public static final String BO_ACUERDO_MGR_GET_LISTADO_TIPO_ACUERDO = "mejacuerdo.getListTipoAcuerdo";		
	public static final String BO_ACUERDO_MGR_GET_LISTADO_TIPO_PRODUCTO = "mejacuerdo.getListTipoProducto";		
	public static final String BO_ACUERDO_MGR_SAVE_TERMINO_ACUERDO = "mejacuerdo.saveTerminoAcuerdo";	
	public static final String BO_ACUERDO_MGR_SAVE_TERMINO_CONTRATO = "mejacuerdo.saveTerminoContrato";	
	public static final String BO_ACUERDO_MGR_SAVE_TERMINO_BIEN = "mejacuerdo.saveTerminoBien";	
	public static final String BO_ACUERDO_MGR_GET_LISTADO_BIENES_ASUNTO = "mejacuerdo.obtenerListadoBienesAcuerdoByAsuId";	
	public static final String BO_ACUERDO_MGR_GET_LISTADO_BIENES_TERMINO = "mejacuerdo.obtenerListadoBienesAcuerdoByTeaId";	
	public static final String BO_ACUERDO_MGR_DELETE_TERMINO_ACUERDO = "mejacuerdo.deleteTerminoAcuerdo";	
	public static final String BO_ACUERDO_MGR_DELETE_TERMINO_CONTRATO = "mejacuerdo.deleteTerminoContrato";	
	public static final String BO_ACUERDO_MGR_DELETE_TERMINO_BIEN = "mejacuerdo.deleteTerminoBien";		
	
    
	/**
     * Pasa un acuerdo a estado Rechazado con motivo.
     * @param idAcuerdo el id del acuerdo a rechazar
     */
	@BusinessOperationDefinition(BO_ACUERDO_MGR_RECHAZAR_ACUERDO_MOTIVO)
    @Transactional(readOnly = false)
    public void rechazarAcuerdoMotivo(Long idAcuerdo, String motivo);
    
    @BusinessOperationDefinition(BO_EXT_ACUERDO_MGR_GUARDAR_ACUERDO)
    @Transactional(readOnly = false) 
    public Long guardarAcuerdo(DtoAcuerdo dto);
    
    @BusinessOperationDefinition(BO_ACUERDO_MGR_GET_LISTADO_CONTRATOS_ACUERDO_ASUNTO)
    public List<Contrato> obtenerListadoContratosAcuerdoByAsuId(Long idAsunto) ;
    
    @BusinessOperationDefinition(BO_ACUERDO_MGR_GET_LISTADO_TERMINOS_ACUERDO_ASUNTO)
    public List<ListadoTerminosAcuerdoDto> obtenerListadoTerminosAcuerdoByAcuId(Long idAcuerdo) ;   
    
	@BusinessOperationDefinition(BO_ACUERDO_MGR_GET_LISTADO_TIPO_ACUERDO)
	public List<DDTipoAcuerdo> getListTipoAcuerdo();    
	
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
	
	@BusinessOperationDefinition(BO_ACUERDO_MGR_DELETE_TERMINO_CONTRATO)
	@Transactional(readOnly = false)
	public void deleteTerminoContrato(TerminoContrato tc); 
	
	@BusinessOperationDefinition(BO_ACUERDO_MGR_DELETE_TERMINO_BIEN)
	@Transactional(readOnly = false)
	public void deleteTerminoBien(TerminoBien tb); 	

}
