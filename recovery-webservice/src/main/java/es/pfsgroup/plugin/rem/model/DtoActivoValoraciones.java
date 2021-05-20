package es.pfsgroup.plugin.rem.model;

import java.util.Date;

import es.capgemini.devon.dto.WebDto;

/**
 * Dto para la pestaña cabecera de la ficha de Activo
 * @author Benjamín Guerrero
 *
 */
public class DtoActivoValoraciones extends WebDto{

	private static final long serialVersionUID = 0L;

	private String numeroActivo;    
	
	private String importeAdjudicacion;
	private String valorAdquisicion;
    
	private String vnc;
	private String valorReferencia;
	private String precioTransferencia;
	private String valorAsesoramientoLiquidativo;
	private String vacbe;
	private String costeAdquisicion;
	private String deudaBruta;
	private String valorRazonable;
	
	private String fsvVenta;
	private String fsvRenta;
	
	private String fsvVentaOrigen;
	private String fsvRentaOrigen;
	
	private String valorEstimadoVenta;
	private String valorEstimadoRenta; 
	
	private String valorLegalVpo;
	private String valorCatastralSuelo;
	private String valorCatastralConstruccion;
	
    private String importeValorTasacion; 
    private Date fechaValorTasacion; 
    private String tipoTasacionDescripcion; 
    
    private Integer bloqueoPrecio;
    private Date bloqueoPrecioFechaIni;
    private String gestorBloqueoPrecio;
    
    private Boolean incluidoBolsaPreciar;
    
    private Boolean incluidoBolsaRepreciar;
    
    private Boolean vpo = false;
    
    private Date fechaVentaHaya;
    private String liquidez;
    
    private Boolean precioVentaNegociable;
    private Boolean precioAlquilerNegociable;    
    private Boolean campanyaPrecioVentaNegociable;
    private Boolean campanyaPrecioAlquilerNegociable;
	
	public String getNumeroActivo() {
		return numeroActivo;
	}
	public void setNumeroActivo(String numeroActivo) {
		this.numeroActivo = numeroActivo;
	}

	public String getImporteAdjudicacion() {
		return importeAdjudicacion;
	}
	public void setImporteAdjudicacion(String importeAdjudicacion) {
		this.importeAdjudicacion = importeAdjudicacion;
	}
	public String getValorAdquisicion() {
		return valorAdquisicion;
	}
	public void setValorAdquisicion(String valorAdquisicion) {
		this.valorAdquisicion = valorAdquisicion;
	}
	public String getImporteValorTasacion() {
		return importeValorTasacion;
	}
	public void setImporteValorTasacion(String importeValorTasacion) {
		this.importeValorTasacion = importeValorTasacion;
	}
	public String getTipoTasacionDescripcion() {
		return tipoTasacionDescripcion;
	}
	public void setTipoTasacionDescripcion(String tipoTasacionDescripcion) {
		this.tipoTasacionDescripcion = tipoTasacionDescripcion;
	}
	public Date getFechaValorTasacion() {
		return fechaValorTasacion;
	}
	public void setFechaValorTasacion(Date fechaValorTasacion) {
		this.fechaValorTasacion = fechaValorTasacion;
	}
	public Integer getBloqueoPrecio() {
		return bloqueoPrecio;
	}
	public void setBloqueoPrecio(Integer bloqueoPrecio) {
		this.bloqueoPrecio = bloqueoPrecio;
	}
	public Date getBloqueoPrecioFechaIni() {
		return bloqueoPrecioFechaIni;
	}
	public void setBloqueoPrecioFechaIni(Date bloqueoPrecioFechaIni) {
		this.bloqueoPrecioFechaIni = bloqueoPrecioFechaIni;
	}
	public String getGestorBloqueoPrecio() {
		return gestorBloqueoPrecio;
	}
	public void setGestorBloqueoPrecio(String gestorBloqueoPrecio) {
		this.gestorBloqueoPrecio = gestorBloqueoPrecio;
	}
	public String getValorLegalVpo() {
		return valorLegalVpo;
	}
	public void setValorLegalVpo(String valorLegalVpo) {
		this.valorLegalVpo = valorLegalVpo;
	}
	public String getValorCatastralSuelo() {
		return valorCatastralSuelo;
	}
	public void setValorCatastralSuelo(String valorCatastralSuelo) {
		this.valorCatastralSuelo = valorCatastralSuelo;
	}
	public String getValorCatastralConstruccion() {
		return valorCatastralConstruccion;
	}
	public void setValorCatastralConstruccion(String valorCatastralConstruccion) {
		this.valorCatastralConstruccion = valorCatastralConstruccion;
	}
	public String getFsvVenta() {
		return fsvVenta;
	}
	public void setFsvVenta(String fsvVenta) {
		this.fsvVenta = fsvVenta;
	}
	public String getFsvRenta() {
		return fsvRenta;
	}
	public void setFsvRenta(String fsvRenta) {
		this.fsvRenta = fsvRenta;
	}
	public String getValorEstimadoVenta() {
		return valorEstimadoVenta;
	}
	public void setValorEstimadoVenta(String valorEstimadoVenta) {
		this.valorEstimadoVenta = valorEstimadoVenta;
	}

	public String getValorReferencia() {
		return valorReferencia;
	}
	public void setValorReferencia(String valorReferencia) {
		this.valorReferencia = valorReferencia;
	}
	public String getValorAsesoramientoLiquidativo() {
		return valorAsesoramientoLiquidativo;
	}
	public void setValorAsesoramientoLiquidativo(
			String valorAsesoramientoLiquidativo) {
		this.valorAsesoramientoLiquidativo = valorAsesoramientoLiquidativo;
	}
	public String getVnc() {
		return vnc;
	}
	public void setVnc(String vnc) {
		this.vnc = vnc;
	}
	public String getPrecioTransferencia() {
		return precioTransferencia;
	}
	public void setPrecioTransferencia(String precioTransferencia) {
		this.precioTransferencia = precioTransferencia;
	}
	public String getVacbe() {
		return vacbe;
	}
	public void setVacbe(String vacbe) {
		this.vacbe = vacbe;
	}
	public String getCosteAdquisicion() {
		return costeAdquisicion;
	}
	public void setCosteAdquisicion(String costeAdquisicion) {
		this.costeAdquisicion = costeAdquisicion;
	}
	public String getDeudaBruta() {
		return deudaBruta;
	}
	public void setDeudaBruta(String deudaBruta) {
		this.deudaBruta = deudaBruta;
	}
	public String getValorRazonable() {
		return valorRazonable;
	}
	public void setValorRazonable(String valorRazonable) {
		this.valorRazonable = valorRazonable;
	}
	public String getValorEstimadoRenta() {
		return valorEstimadoRenta;
	}
	public void setValorEstimadoRenta(String valorEstimadoRenta) {
		this.valorEstimadoRenta = valorEstimadoRenta;
	}
	public Boolean getVpo() {
		return vpo;
	}
	public void setVpo(Boolean vpo) {
		this.vpo = vpo;
	}
	public Boolean getIncluidoBolsaRepreciar() {
		return incluidoBolsaRepreciar;
	}
	public void setIncluidoBolsaRepreciar(Boolean incluidoBolsaRepreciar) {
		this.incluidoBolsaRepreciar = incluidoBolsaRepreciar;
	}
	public Boolean getIncluidoBolsaPreciar() {
		return incluidoBolsaPreciar;
	}
	public void setIncluidoBolsaPreciar(Boolean incluidoBolsaPreciar) {
		this.incluidoBolsaPreciar = incluidoBolsaPreciar;
	}
	public Date getFechaVentaHaya() {
		return fechaVentaHaya;
	}
	public void setFechaVentaHaya(Date fechaVentaHaya) {
		this.fechaVentaHaya = fechaVentaHaya;
	}
	public String getLiquidez() {
		return liquidez;
	}
	public void setLiquidez(String liquidez) {
		this.liquidez = liquidez;
	}
	public String getFsvVentaOrigen() {
		return fsvVentaOrigen;
	}
	public void setFsvVentaOrigen(String fsvVentaOrigen) {
		this.fsvVentaOrigen = fsvVentaOrigen;
	}
	public String getFsvRentaOrigen() {
		return fsvRentaOrigen;
	}
	public void setFsvRentaOrigen(String fsvRentaOrigen) {
		this.fsvRentaOrigen = fsvRentaOrigen;
	}
	public Boolean getPrecioVentaNegociable() {
		return precioVentaNegociable;
	}
	public void setPrecioVentaNegociable(Boolean precioVentaNegociable) {
		this.precioVentaNegociable = precioVentaNegociable;
	}
	public Boolean getPrecioAlquilerNegociable() {
		return precioAlquilerNegociable;
	}
	public void setPrecioAlquilerNegociable(Boolean precioAlquilerNegociable) {
		this.precioAlquilerNegociable = precioAlquilerNegociable;
	}
	public Boolean getCampanyaPrecioVentaNegociable() {
		return campanyaPrecioVentaNegociable;
	}
	public void setCampanyaPrecioVentaNegociable(Boolean campanyaPrecioVentaNegociable) {
		this.campanyaPrecioVentaNegociable = campanyaPrecioVentaNegociable;
	}
	public Boolean getCampanyaPrecioAlquilerNegociable() {
		return campanyaPrecioAlquilerNegociable;
	}
	public void setCampanyaPrecioAlquilerNegociable(Boolean campanyaPrecioAlquilerNegociable) {
		this.campanyaPrecioAlquilerNegociable = campanyaPrecioAlquilerNegociable;
	}
	
	

}