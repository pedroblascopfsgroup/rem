package es.pfsgroup.plugin.rem.model;

import java.util.Date;
import java.util.List;

/**
 * Dto para el tab de patrimonio
 * @author Ivan Rubio
 *
 */
public class DtoActivoPatrimonio extends DtoTabActivo {

	/**
	 * 
	 */
	private static final long serialVersionUID = -7429602301888781560L;

	private String idPatrimonio;
	private String idActivo;
	private String codigoAdecuacion;
	private String descripcionAdecuacion;
	private String descripcionAdecuacionLarga;
	private Boolean checkPerimetroAlquiler;
	private Boolean chkPerimetroAlquiler;
	private Boolean chkSubrogado;
	private String tipoAlquilerCodigo;
	private String tipoAlquilerDescripcion;
	private String comboRentaAntigua;

	private String tipoInquilino;
	private String tipoInquilinoDescripcion;
	private String estadoAlquiler;
	private String estadoAlquilerDescripcion;
	private int ocupacion;
	private int conTitulo;
	
	private String pazSocial;
	private Boolean isCarteraCerberusDivarian;
	private Boolean isCarteraCerberusDivarianOBBVA;
	
	private List<?> activosPropagables;
	private String cesionUso;
	private String cesionUsoDescripcion;
	private String tramiteAlquilerSocial;
	//Grid historico adecuaciones patrimonio activo
	private Date fechaInicioAdecuacion;
	private Date fechaFinAdecuacion;
	private Date fechaInicioPerimetroAlquiler;
	private Date fechaFinPerimetroAlquiler;
	private Boolean isCarteraTitulizada;
	private String acuerdoPago;
	private String moroso;
	private String activoPromoEstrategico;
	private Double precioCompra;
	private Boolean altaPrimaOpcionCompra;
	private Boolean renunciaDerechoTanteo;
	private Boolean isCarteraCajamar;
	private Boolean isCarteraLiberbank;
	
	public Boolean getChkSubrogado() {
		return chkSubrogado;
	}
	public void setChkSubrogado(Boolean chkSubrogado) {
		this.chkSubrogado = chkSubrogado;
	}
	public String getTipoInquilino() {
		return tipoInquilino;
	}
	public void setTipoInquilino(String tipoInquilino) {
		this.tipoInquilino = tipoInquilino;
	}
	public String getTipoInquilinoDescripcion() {
		return tipoInquilinoDescripcion;
	}
	public void setTipoInquilinoDescripcion(String tipoInquilinoDescripcion) {
		this.tipoInquilinoDescripcion = tipoInquilinoDescripcion;
	}
	public String getEstadoAlquiler() {
		return estadoAlquiler;
	}
	public void setEstadoAlquiler(String estadoAlquiler) {
		this.estadoAlquiler = estadoAlquiler;
	}
	public String getEstadoAlquilerDescripcion() {
		return estadoAlquilerDescripcion;
	}
	public void setEstadoAlquilerDescripcion(String estadoAlquilerDescripcion) {
		this.estadoAlquilerDescripcion = estadoAlquilerDescripcion;
	}
	public int getOcupacion() {
		return ocupacion;
	}
	public void setOcupacion(int ocupacion) {
		this.ocupacion = ocupacion;
	}
	public int getConTitulo() {
		return conTitulo;
	}
	public void setConTitulo(int conTitulo) {
		this.conTitulo = conTitulo;
	}	
	public String getIdPatrimonio() {
		return idPatrimonio;
	}
	public void setIdPatrimonio(String idPatrimonio) {
		this.idPatrimonio = idPatrimonio;
	}
	public String getIdActivo() {
		return idActivo;
	}
	public void setIdActivo(String idActivo) {
		this.idActivo = idActivo;
	}	
	public Boolean getCheckPerimetroAlquiler() {
		return checkPerimetroAlquiler;
	}
	public void setCheckPerimetroAlquiler(Boolean checkPerimetroAlquiler) {
		this.checkPerimetroAlquiler = checkPerimetroAlquiler;
	}
	public Date getFechaInicioAdecuacion() {
		return fechaInicioAdecuacion;
	}
	public void setFechaInicioAdecuacion(Date fechaInicioAdecuacion) {
		this.fechaInicioAdecuacion = fechaInicioAdecuacion;
	}
	public Date getFechaFinAdecuacion() {
		return fechaFinAdecuacion;
	}
	public void setFechaFinAdecuacion(Date fechaFinAdecuacion) {
		this.fechaFinAdecuacion = fechaFinAdecuacion;
	}
	public Date getFechaInicioPerimetroAlquiler() {
		return fechaInicioPerimetroAlquiler;
	}
	public void setFechaInicioPerimetroAlquiler(Date fechaInicioPerimetroAlquiler) {
		this.fechaInicioPerimetroAlquiler = fechaInicioPerimetroAlquiler;
	}
	public Date getFechaFinPerimetroAlquiler() {
		return fechaFinPerimetroAlquiler;
	}
	public void setFechaFinPerimetroAlquiler(Date fechaFinPerimetroAlquiler) {
		this.fechaFinPerimetroAlquiler = fechaFinPerimetroAlquiler;
	}
	public String getCodigoAdecuacion() {
		return codigoAdecuacion;
	}
	public void setCodigoAdecuacion(String codigoAdecuacion) {
		this.codigoAdecuacion = codigoAdecuacion;
	}
	public String getDescripcionAdecuacion() {
		return descripcionAdecuacion;
	}
	public void setDescripcionAdecuacion(String descripcionAdecuacion) {
		this.descripcionAdecuacion = descripcionAdecuacion;
	}
	public String getDescripcionAdecuacionLarga() {
		return descripcionAdecuacionLarga;
	}
	public void setDescripcionAdecuacionLarga(String descripcionAdecuacionLarga) {
		this.descripcionAdecuacionLarga = descripcionAdecuacionLarga;
	}
	public Boolean getChkPerimetroAlquiler() {
		return chkPerimetroAlquiler;
	}
	public void setChkPerimetroAlquiler(Boolean chkPerimetroAlquiler) {
		this.chkPerimetroAlquiler = chkPerimetroAlquiler;
	}
	public String getTipoAlquilerCodigo() {
		return tipoAlquilerCodigo;
	}
	public void setTipoAlquilerCodigo(String tipoAlquilerCodigo) {
		this.tipoAlquilerCodigo = tipoAlquilerCodigo;
	}
	public String getTipoAlquilerDescripcion() {
		return tipoAlquilerDescripcion;
	}
	public void setTipoAlquilerDescripcion(String tipoAlquilerDescripcion) {
		this.tipoAlquilerDescripcion = tipoAlquilerDescripcion;
	}
	public String getComboRentaAntigua() {
		return comboRentaAntigua;
	}
	public void setComboRentaAntigua(String comboRentaAntigua) {
		this.comboRentaAntigua = comboRentaAntigua;
	}
	public List<?> getActivosPropagables() {
		return activosPropagables;
	}
	public void setActivosPropagables(List<?> activosPropagables) {
		this.activosPropagables = activosPropagables;
	}
	public String getCesionUso() {
		return cesionUso;
	}
	public void setCesionUso(String cesionUso) {
		this.cesionUso = cesionUso;
	}
	public String getCesionUsoDescripcion() {
		return cesionUsoDescripcion;
	}
	public void setCesionUsoDescripcion(String cesionUsoDescripcion) {
		this.cesionUsoDescripcion = cesionUsoDescripcion;
	}
	public String getTramiteAlquilerSocial() {
		return tramiteAlquilerSocial;
	}
	public void setTramiteAlquilerSocial(String tramiteAlquilerSocial) {
		this.tramiteAlquilerSocial = tramiteAlquilerSocial;
	}
	public String getPazSocial() {
		return pazSocial;
	}
	public void setPazSocial(String string) {
		this.pazSocial = string;
	}
	public Boolean getIsCarteraCerberusDivarian() {
		return isCarteraCerberusDivarian;
	}
	public void setIsCarteraCerberusDivarian(Boolean isCarteraCerberusDivarian) {
		this.isCarteraCerberusDivarian = isCarteraCerberusDivarian;
	}
	public Boolean getIsCarteraCerberusDivarianOBBVA() {
		return isCarteraCerberusDivarianOBBVA;
	}
	public void setIsCarteraCerberusDivarianOBBVA(Boolean isCarteraCerberusDivarianOBBVA) {
		this.isCarteraCerberusDivarianOBBVA = isCarteraCerberusDivarianOBBVA;
	}
	public Boolean getIsCarteraTitulizada() {
		return isCarteraTitulizada;
	}
	public void setIsCarteraTitulizada(Boolean isCarteraTitulizada) {
		this.isCarteraTitulizada = isCarteraTitulizada;
	}
	public String getAcuerdoPago() {
		return acuerdoPago;
	}
	public void setAcuerdoPago(String acuerdoPago) {
		this.acuerdoPago = acuerdoPago;
	}
	public String getMoroso() {
		return moroso;
	}
	public void setMoroso(String moroso) {
		this.moroso = moroso;
	}
	public String getActivoPromoEstrategico() {
		return activoPromoEstrategico;
	}
	public void setActivoPromoEstrategico(String activoPromoEstrategico) {
		this.activoPromoEstrategico = activoPromoEstrategico;
	}
	public Double getPrecioCompra() {
		return precioCompra;
	}
	public void setPrecioCompra(Double precioCompra) {
		this.precioCompra = precioCompra;
	}
	public Boolean getAltaPrimaOpcionCompra() {
		return altaPrimaOpcionCompra;
	}
	public void setAltaPrimaOpcionCompra(Boolean altaPrimaOpcionCompra) {
		this.altaPrimaOpcionCompra = altaPrimaOpcionCompra;
	}
	public Boolean getRenunciaDerechoTanteo() {
		return renunciaDerechoTanteo;
	}
	public void setRenunciaDerechoTanteo(Boolean renunciaDerechoTanteo) {
		this.renunciaDerechoTanteo = renunciaDerechoTanteo;
	}
	public Boolean getIsCarteraCajamar() {
		return isCarteraCajamar;
	}
	public void setIsCarteraCajamar(Boolean isCarteraCajamar) {
		this.isCarteraCajamar = isCarteraCajamar;
	}
	public Boolean getIsCarteraLiberbank() {
		return isCarteraLiberbank;
	}
	public void setIsCarteraLiberbank(Boolean isCarteraLiberbank) {
		this.isCarteraLiberbank = isCarteraLiberbank;
	}
    
}