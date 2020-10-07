package es.pfsgroup.plugin.rem.model;

import java.util.Date;

import es.capgemini.devon.dto.WebDto;

/**
 * Dto para el filtro de Visitas
 * @author Luis Caballero
 *
 */
public class DtoExcelFichaComercial extends WebDto {

	private static final long serialVersionUID = 0L;

	private Long numOferta;
	private Long numActivo;
	private Long numAgrupacion;
	private String estadoOferta;
	private Long numExpediente;
	private Date fechaAlta;
	private String direccionComercial;
	private String comite;
	private String linkHaya;
	private Date fechaActualOferta;
	private Date fechaSeisMesesOferta;
	private Date fechaDoceMesesOferta;
	private Date fechaDieciochoMesesOferta;
	private Double precioComiteActual;
	private Double precioComiteSeisMesesOferta;
	private Double precioComiteDoceMesesOferta;
	private Double precioComiteDieciochoMesesOferta;
	private Double precioWeb;
	private Double tasacion;
	private Double importeAdjuducacion;
	private Double rentaMensual;
	private Double totalSuperficie;
	private Double comisionHayaDivarian;
	private Double gastosPendientes;
	private Double costesLegales;
	private Date fechaUltimoPrecioAprobado;
	private Integer dtoComite;
	private Integer visitas;
	private Integer leads;
	private Integer totalOfertas;
	private String publicado;
	private Date fechaPublicado;
	private Integer mesesEnVenta;
	private Integer diasPublicado;
	private Double diasPVP;
	private String nombreYApellidosOfertante;
	private String dniOfertante;
	private String nombreYApellidosComercial;
	private Long telefonoComercial;
	private String correoComercial;
	private String nombreYApellidosPrescriptor;
	private Long telefonoPrescriptor;
	private String correoPrescriptor;
	
	
	public Long getNumOferta() {
		return numOferta;
	}
	public void setNumOferta(Long numOferta) {
		this.numOferta = numOferta;
	}
	public Long getNumActivo() {
		return numActivo;
	}
	public void setNumActivo(Long numActivo) {
		this.numActivo = numActivo;
	}
	public Long getNumAgrupacion() {
		return numAgrupacion;
	}
	public void setNumAgrupacion(Long numAgrupacion) {
		this.numAgrupacion = numAgrupacion;
	}
	public String getEstadoOferta() {
		return estadoOferta;
	}
	public void setEstadoOferta(String estadoOferta) {
		this.estadoOferta = estadoOferta;
	}

	public Long getNumExpediente() {
		return numExpediente;
	}
	public void setNumExpediente(Long numExpediente) {
		this.numExpediente = numExpediente;
	}
	public Date getFechaAlta() {
		return fechaAlta;
	}
	public void setFechaAlta(Date fechaAlta) {
		this.fechaAlta = fechaAlta;
	}
	public String getDireccionComercial() {
		return direccionComercial;
	}
	public void setDireccionComercial(String direccionComercial) {
		this.direccionComercial = direccionComercial;
	}
	public String getComite() {
		return comite;
	}
	public void setComite(String comite) {
		this.comite = comite;
	}
	public String getLinkHaya() {
		return linkHaya;
	}
	public void setLinkHaya(String linkHaya) {
		this.linkHaya = linkHaya;
	}
	public Date getFechaActualOferta() {
		return fechaActualOferta;
	}
	public void setFechaActualOferta(Date fechaActualOferta) {
		this.fechaActualOferta = fechaActualOferta;
	}
	public Date getFechaSeisMesesOferta() {
		return fechaSeisMesesOferta;
	}
	public void setFechaSeisMesesOferta(Date fechaSeisMesesOferta) {
		this.fechaSeisMesesOferta = fechaSeisMesesOferta;
	}
	public Date getFechaDoceMesesOferta() {
		return fechaDoceMesesOferta;
	}
	public void setFechaDoceMesesOferta(Date fechaDoceMesesOferta) {
		this.fechaDoceMesesOferta = fechaDoceMesesOferta;
	}
	public Date getFechaDieciochoMesesOferta() {
		return fechaDieciochoMesesOferta;
	}
	public void setFechaDieciochoMesesOferta(Date fechaDieciochoMesesOferta) {
		this.fechaDieciochoMesesOferta = fechaDieciochoMesesOferta;
	}
	public Double getPrecioComiteActual() {
		return precioComiteActual;
	}
	public void setPrecioComiteActual(Double precioComiteActual) {
		this.precioComiteActual = precioComiteActual;
	}
	public Double getPrecioComiteSeisMesesOferta() {
		return precioComiteSeisMesesOferta;
	}
	public void setPrecioComiteSeisMesesOferta(Double precioComiteSeisMesesOferta) {
		this.precioComiteSeisMesesOferta = precioComiteSeisMesesOferta;
	}
	public Double getPrecioComiteDoceMesesOferta() {
		return precioComiteDoceMesesOferta;
	}
	public void setPrecioComiteDoceMesesOferta(Double precioComiteDoceMesesOferta) {
		this.precioComiteDoceMesesOferta = precioComiteDoceMesesOferta;
	}
	public Double getPrecioComiteDieciochoMesesOferta() {
		return precioComiteDieciochoMesesOferta;
	}
	public void setPrecioComiteDieciochoMesesOferta(Double precioComiteDieciochoMesesOferta) {
		this.precioComiteDieciochoMesesOferta = precioComiteDieciochoMesesOferta;
	}
	public Double getPrecioWeb() {
		return precioWeb;
	}
	public void setPrecioWeb(Double precioWeb) {
		this.precioWeb = precioWeb;
	}
	public Double getTasacion() {
		return tasacion;
	}
	public void setTasacion(Double tasacion) {
		this.tasacion = tasacion;
	}
	public Double getImporteAdjuducacion() {
		return importeAdjuducacion;
	}
	public void setImporteAdjuducacion(Double importeAdjuducacion) {
		this.importeAdjuducacion = importeAdjuducacion;
	}
	public Double getRentaMensual() {
		return rentaMensual;
	}
	public void setRentaMensual(Double rentaMensual) {
		this.rentaMensual = rentaMensual;
	}
	public Double getTotalSuperficie() {
		return totalSuperficie;
	}
	public void setTotalSuperficie(Double totalSuperficie) {
		this.totalSuperficie = totalSuperficie;
	}
	public Double getComisionHayaDivarian() {
		return comisionHayaDivarian;
	}
	public void setComisionHayaDivarian(Double comisionHayaDivarian) {
		this.comisionHayaDivarian = comisionHayaDivarian;
	}
	public Double getGastosPendientes() {
		return gastosPendientes;
	}
	public void setGastosPendientes(Double gastosPendientes) {
		this.gastosPendientes = gastosPendientes;
	}
	public Double getCostesLegales() {
		return costesLegales;
	}
	public void setCostesLegales(Double costesLegales) {
		this.costesLegales = costesLegales;
	}
	public Date getFechaUltimoPrecioAprobado() {
		return fechaUltimoPrecioAprobado;
	}
	public void setFechaUltimoPrecioAprobado(Date fechaUltimoPrecioAprobado) {
		this.fechaUltimoPrecioAprobado = fechaUltimoPrecioAprobado;
	}
	public Integer getDtoComite() {
		return dtoComite;
	}
	public void setDtoComite(Integer dtoComite) {
		this.dtoComite = dtoComite;
	}
	public Integer getVisitas() {
		return visitas;
	}
	public void setVisitas(Integer visitas) {
		this.visitas = visitas;
	}
	public Integer getLeads() {
		return leads;
	}
	public void setLeads(Integer leads) {
		this.leads = leads;
	}
	public Integer getTotalOfertas() {
		return totalOfertas;
	}
	public void setTotalOfertas(Integer totalOfertas) {
		this.totalOfertas = totalOfertas;
	}
	public String getPublicado() {
		return publicado;
	}
	public void setPublicado(String publicado) {
		this.publicado = publicado;
	}
	public Date getFechaPublicado() {
		return fechaPublicado;
	}
	public void setFechaPublicado(Date fechaPublicado) {
		this.fechaPublicado = fechaPublicado;
	}
	public Integer getMesesEnVenta() {
		return mesesEnVenta;
	}
	public void setMesesEnVenta(Integer mesesEnVenta) {
		this.mesesEnVenta = mesesEnVenta;
	}
	public Integer getDiasPublicado() {
		return diasPublicado;
	}
	public void setDiasPublicado(Integer diasPublicado) {
		this.diasPublicado = diasPublicado;
	}
	public Double getDiasPVP() {
		return diasPVP;
	}
	public void setDiasPVP(Double diasPVP) {
		this.diasPVP = diasPVP;
	}
	public String getNombreYApellidosOfertante() {
		return nombreYApellidosOfertante;
	}
	public void setNombreYApellidosOfertante(String nombreYApellidosOfertante) {
		this.nombreYApellidosOfertante = nombreYApellidosOfertante;
	}
	public String getDniOfertante() {
		return dniOfertante;
	}
	public void setDniOfertante(String dniOfertante) {
		this.dniOfertante = dniOfertante;
	}
	public String getNombreYApellidosComercial() {
		return nombreYApellidosComercial;
	}
	public void setNombreYApellidosComercial(String nombreYApellidosComercial) {
		this.nombreYApellidosComercial = nombreYApellidosComercial;
	}
	public Long getTelefonoComercial() {
		return telefonoComercial;
	}
	public void setTelefonoComercial(Long telefonoComercial) {
		this.telefonoComercial = telefonoComercial;
	}
	public String getCorreoComercial() {
		return correoComercial;
	}
	public void setCorreoComercial(String correoComercial) {
		this.correoComercial = correoComercial;
	}
	public String getNombreYApellidosPrescriptor() {
		return nombreYApellidosPrescriptor;
	}
	public void setNombreYApellidosPrescriptor(String nombreYApellidosPrescriptor) {
		this.nombreYApellidosPrescriptor = nombreYApellidosPrescriptor;
	}
	public Long getTelefonoPrescriptor() {
		return telefonoPrescriptor;
	}
	public void setTelefonoPrescriptor(Long telefonoPrescriptor) {
		this.telefonoPrescriptor = telefonoPrescriptor;
	}
	public String getCorreoPrescriptor() {
		return correoPrescriptor;
	}
	public void setCorreoPrescriptor(String correoPrescriptor) {
		this.correoPrescriptor = correoPrescriptor;
	}
	
	

	
}