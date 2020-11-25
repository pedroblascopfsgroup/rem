package es.pfsgroup.plugin.rem.model;

import java.math.BigDecimal;
import java.util.Date;
import java.util.List;

import es.capgemini.devon.dto.WebDto;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.plugin.rem.model.dd.DDTipoActivo;

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
	private String provincia;
	private String Localidad;
	private String codigoPostal;
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
	private Double precioWebActual;
	private Double precioWebSeisMesesOferta;
	private Double precioWebDoceMesesOferta;
	private Double precioWebDieciochoMesesOferta;
	private Double tasacionActual;
	private Double tasacionSeisMesesOferta;
	private Double tasacionDoceMesesOferta;
	private Double tasacionDieciochoMesesOferta;
	private BigDecimal importeAdjuducacion;
	private Double rentaMensual;
	private BigDecimal totalSuperficie;
	private Double comisionHayaDivarian;
	private Double gastosPendientes;
	private Double costesLegales;
	private Date fechaUltimoPrecioAprobado;
	private Double dtoComite;
	private Integer visitas;
	private String leads;
	private Integer totalOfertas;
	private Double totalOferta;
	private Double totalOfertaNeta;
	private String publicado;
	private Date fechaPublicado;
	private Integer mesesEnVenta;
	private Integer diasPublicado;
	private Double diasPVP;
	private String nombreYApellidosOfertante;
	private String dniOfertante;
	private String nombreYApellidosComercial;
	private String telefonoComercial;
	private String correoComercial;
	private String nombreYApellidosPrescriptor;
	private Long telefonoPrescriptor;
	private String correoPrescriptor;
	private List <DtoActivosFichaComercial> listaActivosFichaComercial;
	private List <DtoHcoComercialFichaComercial> listaHistoricoOfertas;
	private List <DtoListFichaAutorizacion> listaFichaAutorizacion;	
	private Integer nroViviendas;
	private Integer nroPisos;
	private Integer nroOtros;
	private Integer nroGaraje;
	private Double ofertaViviendas;
	private Double ofertaPisos;
	private Double ofertaOtros;
	private Double ofertaGaraje;
	private Double pvpComiteViviendas;
	private Double pvpComitePisos;
	private Double pvpComiteOtros;
	private Double pvpComiteGaraje;
	private Integer nroTotal;
	private Double ofertaTotal;
	private Double pvpComiteTotal;		
	
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
	public Double getPrecioWebActual() {
		return precioWebActual;
	}
	public void setPrecioWebActual(Double precioWebActual) {
		this.precioWebActual = precioWebActual;
	}
	public Double getTasacionActual() {
		return tasacionActual;
	}
	public void setTasacionActual(Double tasacionActual) {
		this.tasacionActual = tasacionActual;
	}
	public BigDecimal getImporteAdjuducacion() {
		return importeAdjuducacion;
	}
	public void setImporteAdjuducacion(BigDecimal importeAdjuducacion) {
		this.importeAdjuducacion = importeAdjuducacion;
	}
	public Double getRentaMensual() {
		return rentaMensual;
	}
	public void setRentaMensual(Double rentaMensual) {
		this.rentaMensual = rentaMensual;
	}
	public BigDecimal getTotalSuperficie() {
		return totalSuperficie;
	}
	public void setTotalSuperficie(BigDecimal totalSuperficie) {
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
	public Double getDtoComite() {
		return dtoComite;
	}
	public void setDtoComite(Double dtoComite) {
		this.dtoComite = dtoComite;
	}
	public Integer getVisitas() {
		return visitas;
	}
	public void setVisitas(Integer visitas) {
		this.visitas = visitas;
	}
	public String getLeads() {
		return leads;
	}
	public void setLeads(String leads) {
		this.leads = leads;
	}
	public Integer getTotalOfertas() {
		return totalOfertas;
	}
	public void setTotalOfertas(Integer totalOfertas) {
		this.totalOfertas = totalOfertas;
	}
	public Double getTotalOferta() {
		return totalOferta;
	}
	public void setTotalOferta(Double totalOferta) {
		this.totalOferta = totalOferta;
	}
	public Double getTotalOfertaNeta() {
		return totalOfertaNeta;
	}
	public void setTotalOfertaNeta(Double totalOfertaNeta) {
		this.totalOfertaNeta = totalOfertaNeta;
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
	public String getTelefonoComercial() {
		return telefonoComercial;
	}
	public void setTelefonoComercial(String telefonoComercial) {
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

	public String getProvincia() {
		return provincia;
	}
	public void setProvincia(String provincia) {
		this.provincia = provincia;
	}
	public String getLocalidad() {
		return Localidad;
	}
	public void setLocalidad(String localidad) {
		Localidad = localidad;
	}
	public String getCodigoPostal() {
		return codigoPostal;
	}
	public void setCodigoPostal(String codigoPostal) {
		this.codigoPostal = codigoPostal;
	}
	public Double getPrecioWebSeisMesesOferta() {
		return precioWebSeisMesesOferta;
	}
	public void setPrecioWebSeisMesesOferta(Double precioWebSeisMesesOferta) {
		this.precioWebSeisMesesOferta = precioWebSeisMesesOferta;
	}
	public Double getPrecioWebDoceMesesOferta() {
		return precioWebDoceMesesOferta;
	}
	public void setPrecioWebDoceMesesOferta(Double precioWebDoceMesesOferta) {
		this.precioWebDoceMesesOferta = precioWebDoceMesesOferta;
	}
	public Double getPrecioWebDieciochoMesesOferta() {
		return precioWebDieciochoMesesOferta;
	}
	public void setPrecioWebDieciochoMesesOferta(Double precioWebDieciochoMesesOferta) {
		this.precioWebDieciochoMesesOferta = precioWebDieciochoMesesOferta;
	}
	public Double getTasacionSeisMesesOferta() {
		return tasacionSeisMesesOferta;
	}
	public void setTasacionSeisMesesOferta(Double tasacionSeisMesesOferta) {
		this.tasacionSeisMesesOferta = tasacionSeisMesesOferta;
	}
	public Double getTasacionDoceMesesOferta() {
		return tasacionDoceMesesOferta;
	}
	public void setTasacionDoceMesesOferta(Double tasacionDoceMesesOferta) {
		this.tasacionDoceMesesOferta = tasacionDoceMesesOferta;
	}
	public Double getTasacionDieciochoMesesOferta() {
		return tasacionDieciochoMesesOferta;
	}
	public void setTasacionDieciochoMesesOferta(Double tasacionDieciochoMesesOferta) {
		this.tasacionDieciochoMesesOferta = tasacionDieciochoMesesOferta;
	}

	public List <DtoActivosFichaComercial> getListaActivosFichaComercial() {
		return listaActivosFichaComercial;
	}
	public void setListaActivosFichaComercial(List <DtoActivosFichaComercial> listaActivosFichaComercial) {
		this.listaActivosFichaComercial = listaActivosFichaComercial;
	}
	public List<DtoHcoComercialFichaComercial> getListaHistoricoOfertas() {
		return listaHistoricoOfertas;
	}
	public void setListaHistoricoOfertas(List<DtoHcoComercialFichaComercial> listaHistoricoOfertas) {
		this.listaHistoricoOfertas = listaHistoricoOfertas;
	}
	public List <DtoListFichaAutorizacion> getListaFichaAutorizacion() {
		return listaFichaAutorizacion;
	}
	public void setListaFichaAutorizacion(List <DtoListFichaAutorizacion> listaFichaAutorizacion) {
		this.listaFichaAutorizacion = listaFichaAutorizacion;
	}
	public Integer getNroViviendas() {
		return nroViviendas;
	}
	public void setNroViviendas(Integer nroViviendas) {
		this.nroViviendas = nroViviendas;
	}
	public Integer getNroPisos() {
		return nroPisos;
	}
	public void setNroPisos(Integer nroPisos) {
		this.nroPisos = nroPisos;
	}
	public Integer getNroOtros() {
		return nroOtros;
	}
	public void setNroOtros(Integer nroOtros) {
		this.nroOtros = nroOtros;
	}
	public Integer getNroGaraje() {
		return nroGaraje;
	}
	public void setNroGaraje(Integer nroGaraje) {
		this.nroGaraje = nroGaraje;
	}
	public Double getOfertaViviendas() {
		return ofertaViviendas;
	}
	public void setOfertaViviendas(Double ofertaViviendas) {
		this.ofertaViviendas = ofertaViviendas;
	}
	public Double getOfertaPisos() {
		return ofertaPisos;
	}
	public void setOfertaPisos(Double ofertaPisos) {
		this.ofertaPisos = ofertaPisos;
	}
	public Double getOfertaOtros() {
		return ofertaOtros;
	}
	public void setOfertaOtros(Double ofertaOtros) {
		this.ofertaOtros = ofertaOtros;
	}
	public Double getOfertaGaraje() {
		return ofertaGaraje;
	}
	public void setOfertaGaraje(Double ofertaGaraje) {
		this.ofertaGaraje = ofertaGaraje;
	}
	public Double getPvpComiteViviendas() {
		return pvpComiteViviendas;
	}
	public void setPvpComiteViviendas(Double pvpComiteViviendas) {
		this.pvpComiteViviendas = pvpComiteViviendas;
	}
	public Double getPvpComitePisos() {
		return pvpComitePisos;
	}
	public void setPvpComitePisos(Double pvpComitePisos) {
		this.pvpComitePisos = pvpComitePisos;
	}
	public Double getPvpComiteOtros() {
		return pvpComiteOtros;
	}
	public void setPvpComiteOtros(Double pvpComiteOtros) {
		this.pvpComiteOtros = pvpComiteOtros;
	}
	public Double getPvpComiteGaraje() {
		return pvpComiteGaraje;
	}
	public void setPvpComiteGaraje(Double pvpComiteGaraje) {
		this.pvpComiteGaraje = pvpComiteGaraje;
	}
	public Integer getNroTotal() {
		return nroTotal;
	}
	public void setNroTotal(Integer nroTotal) {
		this.nroTotal = nroTotal;
	}
	public Double getOfertaTotal() {
		return ofertaTotal;
	}
	public void setOfertaTotal(Double ofertaTotal) {
		this.ofertaTotal = ofertaTotal;
	}
	public Double getPvpComiteTotal() {
		return pvpComiteTotal;
	}
	public void setPvpComiteTotal(Double pvpComiteTotal) {
		this.pvpComiteTotal = pvpComiteTotal;
	}
}