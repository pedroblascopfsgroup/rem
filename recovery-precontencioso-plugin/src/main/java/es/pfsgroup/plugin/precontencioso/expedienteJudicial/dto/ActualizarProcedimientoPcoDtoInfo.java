package es.pfsgroup.plugin.precontencioso.expedienteJudicial.dto;

import java.math.BigDecimal;

public interface ActualizarProcedimientoPcoDtoInfo {
	
	public static final String ESTIMACION = "estimacion";
	public static final String ID = "id";
	public static final String PLAZORECUPERACION = "plazoRecuperacion";
	public static final String PRINCIPAL="principal";
	public static final String TIPORECLAMACION="tipoReclamacion";
	public static final String COD_TIPO_PLAZA = "tipoPlaza";
	public static final String ID_TIPO_JUZGADO = "tipoJuzgado";
	public static final String NUM_EXP_EXTERNO = "numExpExterno";
	

	/**
	 * Id del procedimiento
	 * @return
	 */
	Long getId();
	
	/**
	 * Id del tipo de reclamacion
	 * @return
	 */
	Long getTipoReclamacion();
	
	/**
	 * Salde de recuperacion del procedimiento
	 * @return
	 */
	BigDecimal getPrincipal();
	
	/**
	 * Porcentaje de recuperacion del procedimiento
	 * @return
	 */
	Integer getEstimacion();
	
	/**
	 * Plazo de recuperaci�n del procedimiento
	 * @return
	 */
	Integer getPlazoRecuperacion();
	
	/**
	 * C�digo del tipo de plaza
	 * @return
	 */
	String getTipoPlaza();
	
	/**
	 * Id del tipo de juzgado
	 * @return
	 */
	Long getTipoJuzgado();
	
	String getNumeroAutos();
	
	String getNumExpExterno();

}
