package es.pfsgroup.plugin.gestorDocumental.dto;

import java.io.Serializable;

public class MaestroActivosInputDto implements Serializable{
	/**
	 * 
	 */
	private static final long serialVersionUID = 2823595677614817775L;
	//--Dynamic Vars
	//--AM Data
	public static final String ID_HAYA_ACTIVO_MATRIZ = "ID_HAYA_ACTIVO_MATRIZ";
	public static final String ID_REM_ACTIVO_MATRIZ = "ID_REM_ACTIVO_MATRIZ";
	public static final String ID_CLIENTE_ACTIVO_MATRIZ = "ID_CLIENTE_ACTIVO_MATRIZ";
	//UA Data
	public static final String ID_REM_UNIDAD_ALQUILABLE = "ID_REM_UNIDAD_ALQUILABLE";
	public static final String FC_ALTA = "FC_ALTA";
	//--Statics Vars
	public static final String ID_TIPO_ACTIVO = "ID_TIPO_ACTIVO";
	public static final String ID_ORIGEN = "ID_ORIGEN";
	public static final String FLAGMULTIPLICIDAD = "FLAGMULTIPLICIDAD";
	public static final String ID_MOTIVO_OPERACION = "ID_MOTIVO_OPERACION";
	public static final String CLASE_ACTIVO = "CLASE_ACTIVO";
	public static final String ID_ACTIVO_CLIENTE = "ID_ACTIVO_CLIENTE";
	public static final String ID_ACTIVO_ORIGEN_REDS = "ID_ACTIVO_ORIGEN_REDS";
	public static final String ID_ACTIVO_ORIGEN_COLS = "ID_ACTIVO_ORIGEN_COLS";
	
	
	
	private Long actIdActivoMatriz;
	private Long numActivoMatriz;
	private Long idClienteActivoMatriz;
	private Long actIdUnidadAlquilable;
	private String fechaAlta;
	private String event;
	
	
	public Long getActIdActivoMatriz() {
		return actIdActivoMatriz;
	}
	public void setActIdActivoMatriz(Long actIdActivoMatriz) {
		this.actIdActivoMatriz = actIdActivoMatriz;
	}
	
	
	public Long getNumActivoMatriz() {
		return numActivoMatriz;
	}
	public void setNumActivoMatriz(Long numActivoMatriz) {
		this.numActivoMatriz = numActivoMatriz;
	}
	
	
	public Long getIdClienteActivoMatriz() {
		return idClienteActivoMatriz;
	}
	public void setIdClienteActivoMatriz(Long idClienteActivoMatriz) {
		this.idClienteActivoMatriz = idClienteActivoMatriz;
	}
	
	
	public Long getActIdUnidadAlquilable() {
		return actIdUnidadAlquilable;
	}
	public void setActIdUnidadAlquilable(Long actIdUnidadAlquilable) {
		this.actIdUnidadAlquilable = actIdUnidadAlquilable;
	}
	
	
	public String getFechaAlta() {
		return fechaAlta;
	}
	public void setFechaAlta(String fechaAlta) {
		this.fechaAlta = fechaAlta;
	}
	
	
	public String getEvent() {
		return event;
	}
	public void setEvent(String event) {
		this.event = event;
	}
	
	
}
