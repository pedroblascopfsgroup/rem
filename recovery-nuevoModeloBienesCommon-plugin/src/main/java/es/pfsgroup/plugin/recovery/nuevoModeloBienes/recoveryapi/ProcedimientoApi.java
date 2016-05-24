package es.pfsgroup.plugin.recovery.nuevoModeloBienes.recoveryapi;

import java.util.ArrayList;
import java.util.List;

import es.capgemini.pfs.bien.model.Bien;
import es.capgemini.pfs.bien.model.ProcedimientoBien;
import es.capgemini.pfs.externa.ExternaBusinessOperation;
import es.pfsgroup.commons.utils.api.BusinessOperationDefinition;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.procedimiento.Dto.DtoNotarios;

public interface ProcedimientoApi {

	public static String BO_PRC_NMB_GET_SOLVENCIAS_DE_UN_PROCEDIMIENTO = "nuevoModeloBienes.recoveryapi.getSolvenciasDeUnProcedimiento";
	public static String BO_PRC_NMB_GET_GARANTIAS_DE_UN_PROCEDIMIENTO = "nuevoModeloBienes.recoveryapi.getGarantiasDeUnProcedimiento";
	public static String BO_PRC_MGR_GET_BIENES_DE_PROCEDIMIENTOS = "nuevoModeloBienes.procedimientoManager.getBienesDeUnProcedimiento";


	/**
     * Recupera los bienes a embargar del procedimiento recivido.
     * @param id Long
     * @return Bien
     */
    @BusinessOperationDefinition(ExternaBusinessOperation.BO_PRC_MGR_GET_BIENES_DE_UN_PROCEDIMIENTO)
    public List<Bien> getBienesDeUnProcedimiento(Long id);

	/**
     * Recupera los bienes a embargar de los procedimientos recibidos
     * @param id Long
     * @return Bien
     */
    @BusinessOperationDefinition(BO_PRC_MGR_GET_BIENES_DE_PROCEDIMIENTOS)
    public List<ProcedimientoBien> getBienesDeProcedimientos(List<Long> id);

    
    @BusinessOperationDefinition("NMBProcedimientoManager.getNotarios")
    public ArrayList<DtoNotarios> getNotarios();
    
    /**
     * Devuelve los bienes de las personas (Solvencias)
     * @param idProcedimiento
     * @return
     */
	@BusinessOperationDefinition(BO_PRC_NMB_GET_SOLVENCIAS_DE_UN_PROCEDIMIENTO)
	public List<Bien> getSolvenciasDeUnProcedimiento(Long idProcedimiento);


	/**
	 * Devuelve los bienes de los contratos (Garantias)
	 * @param idProcedimiento
	 * @return
	 */
	@BusinessOperationDefinition(BO_PRC_NMB_GET_GARANTIAS_DE_UN_PROCEDIMIENTO)
	public List<Bien> getGarantiasDeUnProcedimiento(Long idProcedimiento);
    
	public Boolean validarDatosAdjudicacionTerceroBien(Long idProcedimiento);
	
	public Boolean comprobarSiEntidadAdjudicatariaEnBienEsEntidad(Long idProcedimiento);
}
