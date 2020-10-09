package es.pfsgroup.plugin.rem.model;

import java.math.BigDecimal;

import es.capgemini.devon.dto.WebDto;

public class DtoActivosFichaComercial extends WebDto {

	/**
	 * 
	 */
	private static final long serialVersionUID = -6773759852707822453L;
	
	
	Long idActivo;
	String numFincaRegistral;
	Boolean garaje;
	Boolean trastero;
	String numRegProp;
	String localidadRegProp;
	String numRefCatastral;
	String estadoFisicoActivo;
	String tipologia;
	String subtipologia;
	BigDecimal m2Edificable;
	String situacionComercial;
	String epa;
	String direccion;
	String codPostal;
	String municipio;
	String provincia;
	String sociedadTitular;
	Double precioComite;
	Double precioPublicacion;
	BigDecimal precioSueloEpa;
	Double tasacion;
	BigDecimal vnc;
	BigDecimal importeAdj;
	Double renta;
	Double oferta;
	BigDecimal eurosM2;
	BigDecimal comisionHaya;
	BigDecimal gastosPendientes;
	BigDecimal costesPendientes;
	BigDecimal costesLegales;
	BigDecimal ofertaNeta;
	String link;
	Long activoBbva;
	
	String tipoEntrada;
	String depuracionJuridica;
	String inscritoRegistro;
	String tituloPropiedad;
	String cargas;
	String posesion;
	String ocupado;
	String colectivo;
	
	
	
	public Long getIdActivo() {
		return idActivo;
	}
	public void setIdActivo(Long idActivo) {
		this.idActivo = idActivo;
	}
	public String getNumFincaRegistral() {
		return numFincaRegistral;
	}
	public void setNumFincaRegistral(String numFincaRegistral) {
		this.numFincaRegistral = numFincaRegistral;
	}
	public Boolean getGaraje() {
		return garaje;
	}
	public void setGaraje(Boolean garaje) {
		this.garaje = garaje;
	}
	public Boolean getTrastero() {
		return trastero;
	}
	public void setTrastero(Boolean trastero) {
		this.trastero = trastero;
	}
	public String getNumRegProp() {
		return numRegProp;
	}
	public void setNumRegProp(String numRegProp) {
		this.numRegProp = numRegProp;
	}
	public String getLocalidadRegProp() {
		return localidadRegProp;
	}
	public void setLocalidadRegProp(String localidadRegProp) {
		this.localidadRegProp = localidadRegProp;
	}
	public String getNumRefCatastral() {
		return numRefCatastral;
	}
	public void setNumRefCatastral(String numRefCatastral) {
		this.numRefCatastral = numRefCatastral;
	}
	public String getEstadoFisicoActivo() {
		return estadoFisicoActivo;
	}
	public void setEstadoFisicoActivo(String estadoFisicoActivo) {
		this.estadoFisicoActivo = estadoFisicoActivo;
	}
	public String getTipologia() {
		return tipologia;
	}
	public void setTipologia(String tipologia) {
		this.tipologia = tipologia;
	}
	public String getSubtipologia() {
		return subtipologia;
	}
	public void setSubtipologia(String subtipologia) {
		this.subtipologia = subtipologia;
	}
	public BigDecimal getM2Edificable() {
		return m2Edificable;
	}
	public void setM2Edificable(BigDecimal m2Edificable) {
		this.m2Edificable = m2Edificable;
	}
	public String getSituacionComercial() {
		return situacionComercial;
	}
	public void setSituacionComercial(String situacionComercial) {
		this.situacionComercial = situacionComercial;
	}
	public String getEpa() {
		return epa;
	}
	public void setEpa(String epa) {
		this.epa = epa;
	}
	public String getDireccion() {
		return direccion;
	}
	public void setDireccion(String direccion) {
		this.direccion = direccion;
	}
	public String getCodPostal() {
		return codPostal;
	}
	public void setCodPostal(String codPostal) {
		this.codPostal = codPostal;
	}
	public String getMunicipio() {
		return municipio;
	}
	public void setMunicipio(String municipio) {
		this.municipio = municipio;
	}
	public String getProvincia() {
		return provincia;
	}
	public void setProvincia(String provincia) {
		this.provincia = provincia;
	}
	public String getSociedadTitular() {
		return sociedadTitular;
	}
	public void setSociedadTitular(String sociedadTitular) {
		this.sociedadTitular = sociedadTitular;
	}
	public Double getPrecioComite() {
		return precioComite;
	}
	public void setPrecioComite(Double precioComite) {
		this.precioComite = precioComite;
	}
	public Double getPrecioPublicacion() {
		return precioPublicacion;
	}
	public void setPrecioPublicacion(Double precioPublicacion) {
		this.precioPublicacion = precioPublicacion;
	}
	public BigDecimal getPrecioSueloEpa() {
		return precioSueloEpa;
	}
	public void setPrecioSueloEpa(BigDecimal precioSueloEpa) {
		this.precioSueloEpa = precioSueloEpa;
	}
	public Double getTasacion() {
		return tasacion;
	}
	public void setTasacion(Double tasacion) {
		this.tasacion = tasacion;
	}
	public BigDecimal getVnc() {
		return vnc;
	}
	public void setVnc(BigDecimal vnc) {
		this.vnc = vnc;
	}
	public BigDecimal getImporteAdj() {
		return importeAdj;
	}
	public void setImporteAdj(BigDecimal importeAdj) {
		this.importeAdj = importeAdj;
	}
	public Double getRenta() {
		return renta;
	}
	public void setRenta(Double renta) {
		this.renta = renta;
	}
	public Double getOferta() {
		return oferta;
	}
	public void setOferta(Double oferta) {
		this.oferta = oferta;
	}
	public BigDecimal getEurosM2() {
		return eurosM2;
	}
	public void setEurosM2(BigDecimal eurosM2) {
		this.eurosM2 = eurosM2;
	}
	public BigDecimal getComisionHaya() {
		return comisionHaya;
	}
	public void setComisionHaya(BigDecimal comisionHaya) {
		this.comisionHaya = comisionHaya;
	}
	public BigDecimal getGastosPendientes() {
		return gastosPendientes;
	}
	public void setGastosPendientes(BigDecimal gastosPendientes) {
		this.gastosPendientes = gastosPendientes;
	}
	public BigDecimal getCostesPendientes() {
		return costesPendientes;
	}
	public void setCostesPendientes(BigDecimal costesPendientes) {
		this.costesPendientes = costesPendientes;
	}
	public BigDecimal getCostesLegales() {
		return costesLegales;
	}
	public void setCostesLegales(BigDecimal costesLegales) {
		this.costesLegales = costesLegales;
	}
	public BigDecimal getOfertaNeta() {
		return ofertaNeta;
	}
	public void setOfertaNeta(BigDecimal ofertaNeta) {
		this.ofertaNeta = ofertaNeta;
	}
	public String getLink() {
		return link;
	}
	public void setLink(String link) {
		this.link = link;
	}
	public Long getActivoBbva() {
		return activoBbva;
	}
	public void setActivoBbva(Long activoBbva) {
		this.activoBbva = activoBbva;
	}
	public String getTipoEntrada() {
		return tipoEntrada;
	}
	public void setTipoEntrada(String tipoEntrada) {
		this.tipoEntrada = tipoEntrada;
	}
	public String getDepuracionJuridica() {
		return depuracionJuridica;
	}
	public void setDepuracionJuridica(String depuracionJuridica) {
		this.depuracionJuridica = depuracionJuridica;
	}
	public String getInscritoRegistro() {
		return inscritoRegistro;
	}
	public void setInscritoRegistro(String inscritoRegistro) {
		this.inscritoRegistro = inscritoRegistro;
	}
	public String getTituloPropiedad() {
		return tituloPropiedad;
	}
	public void setTituloPropiedad(String tituloPropiedad) {
		this.tituloPropiedad = tituloPropiedad;
	}
	public String getCargas() {
		return cargas;
	}
	public void setCargas(String cargas) {
		this.cargas = cargas;
	}
	public String getPosesion() {
		return posesion;
	}
	public void setPosesion(String posesion) {
		this.posesion = posesion;
	}
	public String getOcupado() {
		return ocupado;
	}
	public void setOcupado(String ocupado) {
		this.ocupado = ocupado;
	}
	public String getColectivo() {
		return colectivo;
	}
	public void setColectivo(String colectivo) {
		this.colectivo = colectivo;
	}
	
	
	
	

}
