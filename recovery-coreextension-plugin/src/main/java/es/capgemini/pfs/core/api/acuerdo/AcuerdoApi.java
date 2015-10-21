package es.capgemini.pfs.core.api.acuerdo;

import org.springframework.transaction.annotation.Transactional;

import es.capgemini.pfs.acuerdo.dto.DtoActuacionesAExplorar;
import es.capgemini.pfs.acuerdo.dto.DtoActuacionesRealizadasAcuerdo;
import es.capgemini.pfs.acuerdo.dto.DtoAcuerdo;
import es.capgemini.pfs.acuerdo.model.Acuerdo;
import es.capgemini.pfs.externa.ExternaBusinessOperation;
import es.pfsgroup.commons.utils.api.BusinessOperationDefinition;

public interface AcuerdoApi {
	static final String CODIGO_CIERRE_ACUERDO_ANUAL = "ANY";
	static final String CODIGO_CIERRE_ACUERDO_MENSUAL = "MES";
	static final String CODIGO_CIERRE_ACUERDO_SEMESTRAL = "SEI";
	static final String CODIGO_CIERRE_ACUERDO_TRIMESTRAL = "TRI";
	static final String CODIGO_CIERRE_ACUERDO_BIMESTRAL ="BI";
	static final String CODIGO_CIERRE_ACUERDO_SEMANAL = "SEM";
	static final String CODIGO_CIERRE_ACUERDO_UNICO ="UNI";
	static final String BO_CORE_ACUERDO_CERRAR = "core.acuerdo.borrar";
	static final String BO_CORE_CONTINUAR_ACUERDO = "core.acuerdo.continuar";
	static final String BO_CORE_ACUERDO_GUARDAR_CUMPLIMIENTO = "core.acuerdo.registrarCumplimiento";
	
	 /**
     * Guarda un acuerdo.
     * Si es nuevo lo da de alta, si no lo modifica.
     * @param dto el dto con los datos
     * @return el id del acuerdo.
     */
    @BusinessOperationDefinition(ExternaBusinessOperation.BO_ACUERDO_MGR_GUARDAR_ACUERDO)
    @Transactional(readOnly = false)
    public Long guardarAcuerdo(DtoAcuerdo dto) ;
    
    /**
     * Pasa un acuerdo a estado Vigente.
     * @param idAcuerdo el id del acuerdo a aceptar.
     */
    @BusinessOperationDefinition(ExternaBusinessOperation.BO_ACUERDO_MGR_ACEPTAR_ACUERDO)
    @Transactional(readOnly = false)
    public void aceptarAcuerdo(Long idAcuerdo);
    
    /**
     * @param id Long
     * @return Acuerdo
     */
    @BusinessOperationDefinition(ExternaBusinessOperation.BO_ACUERDO_MGR_GET_ACUERDO_BY_ID)
    public Acuerdo getAcuerdoById(Long id) ;
    
    /**
     * @param id Long
     * @return Acuerdo
     */
    @BusinessOperationDefinition(BO_CORE_ACUERDO_CERRAR)
    public void cerrarAcuerdo(Long id) ;
    
    @BusinessOperationDefinition(BO_CORE_CONTINUAR_ACUERDO)
    public void continuarAcuerdo(Long id);
    
    @BusinessOperationDefinition(BO_CORE_ACUERDO_GUARDAR_CUMPLIMIENTO)
    public void registraCumplimientoAcuerdo(CumplimientoAcuerdoDto dto);
    
    @BusinessOperationDefinition(ExternaBusinessOperation.BO_ACUERDO_MGR_FINALIZAR_ACUERDO)
	public void finalizarAcuerdo(Long idAcuerdo);

	@BusinessOperationDefinition(ExternaBusinessOperation.BO_ACUERDO_MGR_PROPONER_ACUERDO)
    void proponerAcuerdo(Long idAcuerdo);
    
	@BusinessOperationDefinition(ExternaBusinessOperation.BO_ACUERDO_MGR_CANCELAR_ACUERDO)
    void cancelarAcuerdo(Long idAcuerdo);
	
	@BusinessOperationDefinition(ExternaBusinessOperation.BO_ACUERDO_MGR_SAVE_ACTUACIONES_REALIZADAS_ACUERDO)
	void saveActuacionesRealizadasAcuerdo(DtoActuacionesRealizadasAcuerdo actuacionesRealizadasAcuerdo);
	
	@BusinessOperationDefinition(ExternaBusinessOperation.BO_ACUERDO_MGR_SAVE_ACTUACIONES_A_EXPLORAR_ACUERDO)
	void saveActuacionAExplorarAcuerdo(DtoActuacionesAExplorar dto);	
}
