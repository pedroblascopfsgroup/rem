package es.pfsgroup.plugin.rem.model;

import java.util.Date;
import java.util.List;

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
   	private String subcartera;
   	private Long idSubpartidaPresupuestaria;
   	private String identificadorUnico;
   	private Long numeroPrimerGastoSerie;
   	private Date fechaRecPropiedad;
	private Date fechaRecGestoria;
	private Date fechaRecHaya;
   	private Boolean gastoRefacturable;
   	private List<String> gastoRefacturadoGrid;
   	private Boolean bloquearDestinatario;
   	private Boolean tieneGastosRefacturables;
   	private Boolean bloquearEdicionFechasRecepcion;
   	private String estadoEmisor;
	private Boolean estadoModificarLineasDetalleGasto;
	private Boolean isGastoRefacturadoPorOtroGasto;
	private Boolean isGastoRefacturadoPadre;
	private Boolean tieneTrabajos;
	private Boolean lineasNoDeTrabajos;
   	private String suplidosVinculadosCod;
   	private String facturaPrincipalSuplido;
   	private Boolean visibleSuplidos;
   	private String numeroContratoAlquiler;
   	private Boolean solicitudPagoUrgente;
	private Boolean subrogado;
	
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
	public String getIdentificadorUnico() {
		return identificadorUnico;
	}
	public void setIdentificadorUnico(String identificadorUnico) {
		this.identificadorUnico = identificadorUnico;
	}
	public Long getNumeroPrimerGastoSerie() {
		return numeroPrimerGastoSerie;
	}
	public void setNumeroPrimerGastoSerie(Long numeroPrimerGastoSerie) {
		this.numeroPrimerGastoSerie = numeroPrimerGastoSerie;
	}
	public Date getFechaRecPropiedad() {
		return fechaRecPropiedad;
	}
	public void setFechaRecPropiedad(Date fechaRecPropiedad) {
		this.fechaRecPropiedad = fechaRecPropiedad;
	}
	public Date getFechaRecGestoria() {
		return fechaRecGestoria;
	}
	public void setFechaRecGestoria(Date fechaRecGestoria) {
		this.fechaRecGestoria = fechaRecGestoria;
	}
	public Date getFechaRecHaya() {
		return fechaRecHaya;
	}
	public void setFechaRecHaya(Date fechaRecHaya) {
		this.fechaRecHaya = fechaRecHaya;
	}
	public List<String> getGastoRefacturadoGrid() {
		return gastoRefacturadoGrid;
	}
	public void setGastoRefacturadoGrid(List<String> gastoRefacturadoGrid) {
		this.gastoRefacturadoGrid = gastoRefacturadoGrid;
	}
	public Boolean getGastoRefacturable() {
		return gastoRefacturable;
	}
	public void setGastoRefacturable(Boolean gastoRefacturable) {
		this.gastoRefacturable = gastoRefacturable;
	}
	public Boolean getBloquearDestinatario() {
		return bloquearDestinatario;
	}
	public void setBloquearDestinatario(Boolean bloquearDestinatario) {
		this.bloquearDestinatario = bloquearDestinatario;
	}
	public Boolean getTieneGastosRefacturables() {
		return tieneGastosRefacturables;
	}
	public void setTieneGastosRefacturables(Boolean tieneGastosRefacturables) {
		this.tieneGastosRefacturables = tieneGastosRefacturables;
	}

	public Boolean getBloquearEdicionFechasRecepcion() {
		return bloquearEdicionFechasRecepcion;
	}
	public void setBloquearEdicionFechasRecepcion(Boolean bloquearEdicionFechasRecepcion) {
		this.bloquearEdicionFechasRecepcion = bloquearEdicionFechasRecepcion;
	}

	public String getEstadoEmisor() {
		return estadoEmisor;
	}
	public void setEstadoEmisor(String estadoEmisor) {
		this.estadoEmisor = estadoEmisor;
	}
	public String getSubcartera() {
		return subcartera;
	}
	public void setSubcartera(String subcartera) {
		this.subcartera = subcartera;
	}
	public Long getIdSubpartidaPresupuestaria() {
		return idSubpartidaPresupuestaria;
	}
	public void setIdSubpartidaPresupuestaria(Long idSubpartidaPresupuestaria) {
		this.idSubpartidaPresupuestaria = idSubpartidaPresupuestaria;
	}
	public Boolean getEstadoModificarLineasDetalleGasto() {
		return estadoModificarLineasDetalleGasto;
	}
	public void setEstadoModificarLineasDetalleGasto(Boolean estadoModificarLineasDetalleGasto) {
		this.estadoModificarLineasDetalleGasto = estadoModificarLineasDetalleGasto;
	}
	public Boolean getIsGastoRefacturadoPorOtroGasto() {
		return isGastoRefacturadoPorOtroGasto;
	}
	public void setIsGastoRefacturadoPorOtroGasto(Boolean isGastoRefacturadoPorOtroGasto) {
		this.isGastoRefacturadoPorOtroGasto = isGastoRefacturadoPorOtroGasto;
	}
	public Boolean getIsGastoRefacturadoPadre() {
		return isGastoRefacturadoPadre;
	}
	public void setIsGastoRefacturadoPadre(Boolean isGastoRefacturadoPadre) {
		this.isGastoRefacturadoPadre = isGastoRefacturadoPadre;
	}
	public Boolean getTieneTrabajos() {
		return tieneTrabajos;
	}
	public void setTieneTrabajos(Boolean tieneTrabajos) {
		this.tieneTrabajos = tieneTrabajos;
	}
	public Boolean getLineasNoDeTrabajos() {
		return lineasNoDeTrabajos;
	}
	public void setLineasNoDeTrabajos(Boolean lineasNoDeTrabajos) {
		this.lineasNoDeTrabajos = lineasNoDeTrabajos;
	}
	
	public String getSuplidosVinculadosCod() {
		return suplidosVinculadosCod;
	}
	public void setSuplidosVinculadosCod(String suplidosVinculadosCod) {
		this.suplidosVinculadosCod = suplidosVinculadosCod;
	}
	public String getFacturaPrincipalSuplido() {
		return facturaPrincipalSuplido;
	}
	public void setFacturaPrincipalSuplido(String facturaPrincipalSuplido) {
		this.facturaPrincipalSuplido = facturaPrincipalSuplido;
	}
	public Boolean getVisibleSuplidos() {
		return visibleSuplidos;
	}
	public void setVisibleSuplidos(Boolean visibleSuplidos) {
		this.visibleSuplidos = visibleSuplidos;
	}
	
	public String getNumeroContratoAlquiler() {
		return numeroContratoAlquiler;
	}
	
	public void setNumeroContratoAlquiler(String numeroContratoAlquiler) {
		this.numeroContratoAlquiler = numeroContratoAlquiler;
	}

	public Boolean getSolicitudPagoUrgente() {
		return solicitudPagoUrgente;
	}
	public void setSolicitudPagoUrgente(Boolean solicitudPagoUrgente) {
		this.solicitudPagoUrgente = solicitudPagoUrgente;
	}
	public Boolean getSubrogado() {
		return subrogado;
	}
	public void setSubrogado(Boolean subrogado) {
		this.subrogado = subrogado;
	}
	
}
