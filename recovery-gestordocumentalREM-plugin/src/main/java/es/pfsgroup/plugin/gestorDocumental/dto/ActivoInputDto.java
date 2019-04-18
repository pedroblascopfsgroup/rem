package es.pfsgroup.plugin.gestorDocumental.dto;

import java.io.Serializable;

public class ActivoInputDto implements Serializable{
	/**
	 * 
	 */
	private static final long serialVersionUID = -2487916137157826445L;
	public static final String ID_ACTIVO_HAYA			= 	"ID_ACTIVO_HAYA";
	public static final String ID_HAYA_ACTIVO_MATRIZ  	= 	"id_activo_haya";
	public static final String ID_REM_ACTIVO_MATRIZ 	= 	"id_activo_origen_padre";
	public static final String ID_CLIENTE_ACTIVO_MATRIZ =	"id_cliente";
	public static final String ID_REM_UNIDAD_ALQUILABLE = 	"id_activo_origen_nuevo";
	public static final String FC_ALTA 					= 	"fecha_operacion";
	public static final String UNIDAD_ALQUILABLE 		= 	"id_tipo_activo";
	public static final String REM 						= 	"id_origen";
	public static final String FLAGMULTIPLICIDAD		= 	"flagMultiplicidad";
	public static final String MOTIVO_OPERACION			= 	"id_motivo_operacion";
	public static final String CLASE_ACTIVO 			= 	"clase_activo";
	public static final String ACTIVO_CLIENTE 			= 	"id_activo_cliente";
	public static final String ACTIVO_ORIGEN_REDS		= 	"id_activo_origen_reds";
	public static final String ACTIVO_ORIGEN_COLS		= 	"id_activo_origen_cols";
	public static final String EVENTO_ALTA_ACTIVOS		= 	"ALTA_ACTIVO";
	public static final String FORMATO_STRING 			= 	"String";
	//--AM
	private String idActivoMatriz;
	private String numRemActivoMatriz;
	private String idCliente;
	
	//--UA
	private String idUnidadAlquilable;
	private String fechaOperacion;
	//--Informacion estatica
	private String tipoActivo; //UNIDAD ALQUILABLE
	private String origen; //REM
	private String flagMultiplicidad;//1
	private String motivoOperacion; //14
	private String claseActivo; // NULL
	private String idActivoCliente;//NULL
	private String idActivoOrigenReds;//NULL
	private String idActivoOrigenCols;//NULL
	
	
	//--Evento
	private String event;
	
	
	public String getIdActivoMatriz() {
		return idActivoMatriz;
	}
	public void setIdActivoMatriz(String idActivoMatriz) {
		this.idActivoMatriz = idActivoMatriz;
	}
	public String getNumRemActivoMatriz() {
		return numRemActivoMatriz;
	}
	public void setNumRemActivoMatriz(String numRemActivoMatriz) {
		this.numRemActivoMatriz = numRemActivoMatriz;
	}
	public String getIdCliente() {
		return idCliente;
	}
	public void setIdCliente(String idCliente) {
		this.idCliente = idCliente;
	}
	public String getIdUnidadAlquilable() {
		return idUnidadAlquilable;
	}
	public void setIdUnidadAlquilable(String idUnidadAlquilable) {
		this.idUnidadAlquilable = idUnidadAlquilable;
	}
	public String getFechaOperacion() {
		return fechaOperacion;
	}
	public void setFechaOperacion(String fechaOperacion) {
		this.fechaOperacion = fechaOperacion;
	}
	public String getTipoActivo() {
		return tipoActivo;
	}
	public void setTipoActivo(String tipoActivo) {
		this.tipoActivo = tipoActivo;
	}
	public String getOrigen() {
		return origen;
	}
	public void setOrigen(String idOrigen) {
		this.origen = idOrigen;
	}
	public String getFlagMultiplicidad() {
		return flagMultiplicidad;
	}
	public void setFlagMultiplicidad(String flagMultiplicidad) {
		this.flagMultiplicidad = flagMultiplicidad;
	}
	public String getMotivoOperacion() {
		return motivoOperacion;
	}
	public void setMotivoOperacion(String motivoOperacion) {
		this.motivoOperacion = motivoOperacion;
	}
	public String getClaseActivo() {
		return claseActivo;
	}
	public void setClaseActivo(String claseActivo) {
		this.claseActivo = claseActivo;
	}
	public String getIdActivoCliente() {
		return idActivoCliente;
	}
	public void setIdActivoCliente(String idActivoCliente) {
		this.idActivoCliente = idActivoCliente;
	}
	public String getIdActivoOrigenReds() {
		return idActivoOrigenReds;
	}
	public void setIdActivoOrigenReds(String idActivoOrigenReds) {
		this.idActivoOrigenReds = idActivoOrigenReds;
	}
	public String getIdActivoOrigenCols() {
		return idActivoOrigenCols;
	}
	public void setIdActivoOrigenCols(String idActivoOrigenCols) {
		this.idActivoOrigenCols = idActivoOrigenCols;
	}
	public String getEvent() {
		return event;
	}
	public void setEvent(String event) {
		this.event = event;
	}
}
