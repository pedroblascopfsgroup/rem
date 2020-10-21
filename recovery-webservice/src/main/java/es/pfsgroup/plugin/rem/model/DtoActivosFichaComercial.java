package es.pfsgroup.plugin.rem.model;

import es.capgemini.devon.dto.WebDto;

public class DtoActivosFichaComercial extends WebDto {

	/**
	 * 
	 */
	private static final long serialVersionUID = -6773759852707822453L;
	
	
	Long idActivo;
	String numFincaRegistral;
	String garaje;
	String trastero;
	String numRegProp;
	String localidadRegProp;
	String numRefCatastral;
	String estadoFisicoActivo;
	String tipologia;
	String subtipologia;
	Double m2Edificable;
	String situacionComercial;
	String epa;
	String direccion;
	String codPostal;
	String municipio;
	String provincia;
	String sociedadTitular;
	Double precioComite;
	Double precioPublicacion;
	Double precioSueloEpa;
	Double tasacion;
	Double vnc;
	Double importeAdj;
	Double renta;
	Double oferta;
	Double eurosM2;
	Double comisionHaya;
	Double gastosPendientes;
	Double costesPendientes;
	Double costesLegales;
	Double ofertaNeta;
	String link;
	String activoBbva;
	
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
	public String getGaraje() {
		return garaje;
	}
	public void setGaraje(String garaje) {
		this.garaje = garaje;
	}
	public String getTrastero() {
		return trastero;
	}
	public void setTrastero(String trastero) {
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
	public Double getM2Edificable() {
		return m2Edificable;
	}
	public void setM2Edificable(Double m2Edificable) {
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
	public Double getPrecioSueloEpa() {
		return precioSueloEpa;
	}
	public void setPrecioSueloEpa(Double precioSueloEpa) {
		this.precioSueloEpa = precioSueloEpa;
	}
	public Double getTasacion() {
		return tasacion;
	}
	public void setTasacion(Double tasacion) {
		this.tasacion = tasacion;
	}
	public Double getVnc() {
		return vnc;
	}
	public void setVnc(Double vnc) {
		this.vnc = vnc;
	}
	public Double getImporteAdj() {
		return importeAdj;
	}
	public void setImporteAdj(Double importeAdj) {
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
	public Double getEurosM2() {
		return eurosM2;
	}
	public void setEurosM2(Double eurosM2) {
		this.eurosM2 = eurosM2;
	}
	public Double getComisionHaya() {
		return comisionHaya;
	}
	public void setComisionHaya(Double comisionHaya) {
		this.comisionHaya = comisionHaya;
	}
	public Double getGastosPendientes() {
		return gastosPendientes;
	}
	public void setGastosPendientes(Double gastosPendientes) {
		this.gastosPendientes = gastosPendientes;
	}
	public Double getCostesPendientes() {
		return costesPendientes;
	}
	public void setCostesPendientes(Double costesPendientes) {
		this.costesPendientes = costesPendientes;
	}
	public Double getCostesLegales() {
		return costesLegales;
	}
	public void setCostesLegales(Double costesLegales) {
		this.costesLegales = costesLegales;
	}
	public Double getOfertaNeta() {
		return ofertaNeta;
	}
	public void setOfertaNeta(Double ofertaNeta) {
		this.ofertaNeta = ofertaNeta;
	}
	public String getLink() {
		return link;
	}
	public void setLink(String link) {
		this.link = link;
	}
	public String getActivoBbva() {
		return activoBbva;
	}
	public void setActivoBbva(String activoBbva) {
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
