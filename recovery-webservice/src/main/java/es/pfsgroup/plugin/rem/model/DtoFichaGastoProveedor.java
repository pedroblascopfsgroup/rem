package es.pfsgroup.plugin.rem.model;

import java.util.Date;

import es.capgemini.devon.dto.WebDto;


/**
 * Dto que gestiona la informacion de un gasto.
 *  
 * @author Luis Caballero
 *
 */
public class DtoFichaGastoProveedor extends WebDto {
	
	
  
	/**
	 * 
	 */
	private static final long serialVersionUID = 3574353502838449106L;
	

	private Long idGasto;
	private Long numGastoHaya;
	private Long numGastoGestoria;
	private String referenciaEmisor;
	private String tipoGastoCodigo;
	private String subtipoGastoCodigo;
	private String tipoGastoDescripcion;
	private String subtipoGastoDescripcion;
	private String nifEmisor;
	private String buscadorNifEmisor;
	private String buscadorNifPropietario;
	private String nombreEmisor;
	private Long idEmisor;
	private String destinatario;
	private String propietario;
	private Date fechaEmision;
	private String periodicidad;
	private String concepto;
	private String nifPropietario;
	private String nombrePropietario;
	private String codigoEmisor;
	private String destinatarioGastoCodigo;
	private Boolean autorizado;
	private Boolean rechazado;
	private Boolean asignadoATrabajos;
	private Boolean asignadoAActivos;
	private String estadoGastoCodigo;
	private String estadoGastoDescripcion;
	private Boolean esGastoEditable;
	private Boolean esGastoAgrupado;
	private Long buscadorCodigoProveedorRem;
	private Long codigoProveedorRem;
   	private String tipoOperacionCodigo;
   	private String tipoOperacionDescripcion;
   	private String numGastoDestinatario;
   	private Long numGastoAbonado;
   	private Long idGastoAbonado; 
   	private Boolean gastoSinActivos;
   	private Boolean enviado;
   	private Double importeTotal;
   	private String nombreGestoria;
   	private String codigoImpuestoIndirecto;
   	private String cartera;
	
	public Long getIdGasto() {
		return idGasto;
	}
	public void setIdGasto(Long idGasto) {
		this.idGasto = idGasto;
	}
	public Long getNumGastoHaya() {
		return numGastoHaya;
	}
	public void setNumGastoHaya(Long numGastoHaya) {
		this.numGastoHaya = numGastoHaya;
	}
	public Long getNumGastoGestoria() {
		return numGastoGestoria;
	}
	public void setNumGastoGestoria(Long numGastoGestoria) {
		this.numGastoGestoria = numGastoGestoria;
	}
	public String getReferenciaEmisor() {
		return referenciaEmisor;
	}
	public void setReferenciaEmisor(String referenciaEmisor) {
		this.referenciaEmisor = referenciaEmisor;
	}

	public String getNifEmisor() {
		return nifEmisor;
	}
	public void setNifEmisor(String nifEmisor) {
		this.nifEmisor = nifEmisor;
	}
	public String getBuscadorNifEmisor() {
		return buscadorNifEmisor;
	}
	public void setBuscadorNifEmisor(String buscadorNifEmisor) {
		this.buscadorNifEmisor = buscadorNifEmisor;
	}
	public String getNombreEmisor() {
		return nombreEmisor;
	}
	public void setNombreEmisor(String nombreEmisor) {
		this.nombreEmisor = nombreEmisor;
	}
	public Long getIdEmisor() {
		return idEmisor;
	}
	public void setIdEmisor(Long idEmisor) {
		this.idEmisor = idEmisor;
	}
	public String getDestinatario() {
		return destinatario;
	}
	public void setDestinatario(String destinatario) {
		this.destinatario = destinatario;
	}
	public String getPropietario() {
		return propietario;
	}
	public void setPropietario(String propietario) {
		this.propietario = propietario;
	}
	public Date getFechaEmision() {
		return fechaEmision;
	}
	public void setFechaEmision(Date fechaEmision) {
		this.fechaEmision = fechaEmision;
	}
	public String getPeriodicidad() {
		return periodicidad;
	}
	public void setPeriodicidad(String periodicidad) {
		this.periodicidad = periodicidad;
	}
	public String getConcepto() {
		return concepto;
	}
	public void setConcepto(String concepto) {
		this.concepto = concepto;
	}
	public String getNifPropietario() {
		return nifPropietario;
	}
	public void setNifPropietario(String nifPropietario) {
		this.nifPropietario = nifPropietario;
	}
	public String getNombrePropietario() {
		return nombrePropietario;
	}
	public void setNombrePropietario(String nombrePropietario) {
		this.nombrePropietario = nombrePropietario;
	}
	public String getCodigoEmisor() {
		return codigoEmisor;
	}
	public void setCodigoEmisor(String codigoEmisor) {
		this.codigoEmisor = codigoEmisor;
	}
	public String getBuscadorNifPropietario() {
		return buscadorNifPropietario;
	}
	public void setBuscadorNifPropietario(String buscadorNifPropietario) {
		this.buscadorNifPropietario = buscadorNifPropietario;
	}
	public String getTipoGastoCodigo() {
		return tipoGastoCodigo;
	}
	public void setTipoGastoCodigo(String tipoGastoCodigo) {
		this.tipoGastoCodigo = tipoGastoCodigo;
	}
	public String getSubtipoGastoCodigo() {
		return subtipoGastoCodigo;
	}
	public void setSubtipoGastoCodigo(String subtipoGastoCodigo) {
		this.subtipoGastoCodigo = subtipoGastoCodigo;
	}
	public String getTipoGastoDescripcion() {
		return tipoGastoDescripcion;
	}
	public void setTipoGastoDescripcion(String tipoGastoDescripcion) {
		this.tipoGastoDescripcion = tipoGastoDescripcion;
	}
	public String getSubtipoGastoDescripcion() {
		return subtipoGastoDescripcion;
	}
	public void setSubtipoGastoDescripcion(String subtipoGastoDescripcion) {
		this.subtipoGastoDescripcion = subtipoGastoDescripcion;
	}
	public String getDestinatarioGastoCodigo() {
		return destinatarioGastoCodigo;
	}
	public void setDestinatarioGastoCodigo(String destinatarioGastoCodigo) {
		this.destinatarioGastoCodigo = destinatarioGastoCodigo;
	}
	public void setAutorizado(Boolean autorizado) {
		this.autorizado = autorizado;
		
	}
   	public Boolean getAutorizado() {
   		return this.autorizado;
   	}
	public void setRechazado(Boolean rechazado) {
		this.rechazado = rechazado;
		
	}
   	public Boolean getRechazado() {
   		return this.rechazado;
   	}
	public Boolean getAsignadoATrabajos() {
		return asignadoATrabajos;
	}
	public void setAsignadoATrabajos(Boolean asignadoATrabajos) {
		this.asignadoATrabajos = asignadoATrabajos;
	}
	public Boolean getAsignadoAActivos() {
		return asignadoAActivos;
	}
	public void setAsignadoAActivos(Boolean asignadoAActivos) {
		this.asignadoAActivos = asignadoAActivos;
	}
	public String getEstadoGastoCodigo() {
		return estadoGastoCodigo;
	}
	public void setEstadoGastoCodigo(String estadoGastoCodigo) {
		this.estadoGastoCodigo = estadoGastoCodigo;
	}
	public String getEstadoGastoDescripcion() {
		return estadoGastoDescripcion;
	}
	public void setEstadoGastoDescripcion(String estadoGastoDescripcion) {
		this.estadoGastoDescripcion = estadoGastoDescripcion;
	}
	public Boolean getEsGastoEditable() {
		return esGastoEditable;
	}
	public void setEsGastoEditable(Boolean esGastoEditable) {
		this.esGastoEditable = esGastoEditable;
	}
	public Boolean getEsGastoAgrupado() {
		return esGastoAgrupado;
	}
	public void setEsGastoAgrupado(Boolean esGastoAgrupado) {
		this.esGastoAgrupado = esGastoAgrupado;
	}
	public Long getBuscadorCodigoProveedorRem() {
		return buscadorCodigoProveedorRem;
	}
	public void setBuscadorCodigoProveedorRem(Long buscadorCodigoProveedorRem) {
		this.buscadorCodigoProveedorRem = buscadorCodigoProveedorRem;
	}
	public Long getCodigoProveedorRem() {
		return codigoProveedorRem;
	}
	public void setCodigoProveedorRem(Long codigoProveedorRem) {
		this.codigoProveedorRem = codigoProveedorRem;
	}
	public String getTipoOperacionCodigo() {
		return tipoOperacionCodigo;
	}
	public void setTipoOperacionCodigo(String tipoOperacionCodigo) {
		this.tipoOperacionCodigo = tipoOperacionCodigo;
	}
	public String getTipoOperacionDescripcion() {
		return tipoOperacionDescripcion;
	}
	public void setTipoOperacionDescripcion(String tipoOperacionDescripcion) {
		this.tipoOperacionDescripcion = tipoOperacionDescripcion;
	}
	public String getNumGastoDestinatario() {
		return numGastoDestinatario;
	}
	public void setNumGastoDestinatario(String numGastoDestinatario) {
		this.numGastoDestinatario = numGastoDestinatario;
	}
	public Long getNumGastoAbonado() {
		return numGastoAbonado;
	}
	public void setNumGastoAbonado(Long numGastoAbonado) {
		this.numGastoAbonado = numGastoAbonado;
	}
	public Long getIdGastoAbonado() {
		return idGastoAbonado;
	}
	public void setIdGastoAbonado(Long idGastoAbonado) {
		this.idGastoAbonado = idGastoAbonado;
	}
	public Boolean getGastoSinActivos() {
		return gastoSinActivos;
	}
	public void setGastoSinActivos(Boolean gastoSinActivos) {
		this.gastoSinActivos = gastoSinActivos;
	}
	public Boolean getEnviado() {
		return enviado;
	}
	public void setEnviado(Boolean enviado) {
		this.enviado = enviado;
	}
	public Double getImporteTotal() {
		return importeTotal;
	}
	public void setImporteTotal(Double importeTotal) {
		this.importeTotal = importeTotal;
	}
	public String getNombreGestoria() {
		return nombreGestoria;
	}
	public void setNombreGestoria(String nombreGestoria) {
		this.nombreGestoria = nombreGestoria;
	}
	public String getCodigoImpuestoIndirecto() {
		return codigoImpuestoIndirecto;
	}
	public void setCodigoImpuestoIndirecto(String codigoImpuestoIndirecto) {
		this.codigoImpuestoIndirecto = codigoImpuestoIndirecto;
	}
	public String getCartera() {
		return cartera;
	}
	public void setCartera(String cartera) {
		this.cartera = cartera;
	}
	
}
