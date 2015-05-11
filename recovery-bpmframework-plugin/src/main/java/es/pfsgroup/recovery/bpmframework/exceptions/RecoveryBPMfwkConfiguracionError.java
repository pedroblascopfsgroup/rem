package es.pfsgroup.recovery.bpmframework.exceptions;

import java.util.Map;

import es.pfsgroup.recovery.bpmframework.api.config.RecoveryBPMfwkCfgInputDto;

/**
 * Excepci�n que se lanza cuando no se encuentra la configuraci�n que indica qu�
 * hacer con algo que nos ha llegado en un Input
 * 
 * @author bruno
 * 
 */
public class RecoveryBPMfwkConfiguracionError extends RecoveryBPMfwkError {

	private static final long serialVersionUID = -7570371787500434440L;
    
    private Long idProcedimiento;
    
    private Map<String, Object> datosInput;
    
    private RecoveryBPMfwkCfgInputDto config;
    
    /**
     * Contructor de la excepci�n.
     * @param problema
     * @param msg Mensaje a mostrar
     * @param idProcedimiento id del Procedimiento
     * @param datosInput mapa con datos adicionales del input
     * @param config Objeto de configuraci�n. 
     */
    public RecoveryBPMfwkConfiguracionError(ProblemasConocidos problema, String msg, Long idProcedimiento, Map<String, Object> datosInput, RecoveryBPMfwkCfgInputDto config) {
		super(problema, msg);
		this.idProcedimiento = idProcedimiento;
		this.datosInput = datosInput;
		this.config = config;
	}    
    
	/**
	 * Constructor m�nimo.
	 * @param problema 
	 * @param msg Mensaje a mostrar
	 * 
	 */
	public RecoveryBPMfwkConfiguracionError(ProblemasConocidos problema, String msg) {
		super(problema, msg);
	}

	public Long getIdProcedimiento() {
		return idProcedimiento;
	}
	
	public Map<String, Object> getDatosInput() {
		return datosInput;
	}
	
	public RecoveryBPMfwkCfgInputDto getConfig() {
		return config;
	}
	
}
