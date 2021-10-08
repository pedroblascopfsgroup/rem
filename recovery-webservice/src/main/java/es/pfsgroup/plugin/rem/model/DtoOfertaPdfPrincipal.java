package es.pfsgroup.plugin.rem.model;

import java.util.Date;
import es.capgemini.devon.dto.WebDto;
import java.util.List;


/**
 * Dto para rellenar el pdf de Propuesta Aprobacion Oferta
 * @author Sergio Gomez
 *
 */
public class DtoOfertaPdfPrincipal extends WebDto {

	private static final long serialVersionUID = 0L;

	//Antecedentes
	private Date fechaActual;
	private String direccionInmueble;
	private String poblacionInmueble;
	private String provinciaInmueble;
	private String procedenciaInmueble;
	private String sociedad;
	private String ur;
	private String fincaRegistral;
	private String tipoInmueble;
	private String situacionComercial;
	private String situacionPosesoria;
	private String situacionJuridica;
	private String vpo;
	private Date fechaDacionCesionAdj;
	private Double importeDacionCesionAj;
	private Double valorContableBruto;
	private Double valorContableNeto;
	private Double importePrecioVenta;
	private Double importeValoracMercadoActual;
	private Date importeValoracMercadoActualFecha;
	private Double importeValoracMercado;
	private Date importeValoracMercadoFecha;
	private Double importeValoracMercadoAntigua;
	private Date importeValoracMercadoAntiguaFecha;
	private Boolean notificarFrob;
	
	//Acciones comerciales
	private String canalesComercializacion;
	private Long interesados;
	
	//Propuesta
	private String numOferta;
	private Double importePropuesta;
	private Boolean campanya;
	private Boolean familiarCaixa;
	private Boolean multiestrella;
	private Boolean antiguoDeudor;
	private Boolean compraApiFamiliar;
	private String compradorUnoNif;
	private String compradorUnoNombre;
	private String compradorDosNif;
	private String compradorDosNombre;
	private String api;
	
	//Ofertas recibidas
	private List<DtoDatosOfertaPdf> listadoOfertas;		
	//Notas
	private String notas;
	
	
	public Date getFechaActual() {
		return fechaActual;
	}
	public void setFechaActual(Date fechaActual) {
		this.fechaActual = fechaActual;
	}
	public String getDireccionInmueble() {
		return direccionInmueble;
	}
	public void setDireccionInmueble(String direccionInmueble) {
		this.direccionInmueble = direccionInmueble;
	}
	public String getProcedenciaInmueble() {
		return procedenciaInmueble;
	}
	public void setProcedenciaInmueble(String procedenciaInmueble) {
		this.procedenciaInmueble = procedenciaInmueble;
	}
	public String getSociedad() {
		return sociedad;
	}
	public void setSociedad(String sociedad) {
		this.sociedad = sociedad;
	}
	public String getUr() {
		return ur;
	}
	public void setUr(String ur) {
		this.ur = ur;
	}
	public String getFincaRegistral() {
		return fincaRegistral;
	}
	public void setFincaRegistral(String fincaRegistral) {
		this.fincaRegistral = fincaRegistral;
	}
	public String getTipoInmueble() {
		return tipoInmueble;
	}
	public void setTipoInmueble(String tipoInmueble) {
		this.tipoInmueble = tipoInmueble;
	}
	public String getSituacionComercial() {
		return situacionComercial;
	}
	public void setSituacionComercial(String situacionComercial) {
		this.situacionComercial = situacionComercial;
	}
	public String getSituacionPosesoria() {
		return situacionPosesoria;
	}
	public void setSituacionPosesoria(String situacionPosesoria) {
		this.situacionPosesoria = situacionPosesoria;
	}
	public String getSituacionJuridica() {
		return situacionJuridica;
	}
	public void setSituacionJuridica(String situacionJuridica) {
		this.situacionJuridica = situacionJuridica;
	}
	public String getVpo() {
		return vpo;
	}
	public void setVpo(String vpo) {
		this.vpo = vpo;
	}
	public Date getFechaDacionCesionAdj() {
		return fechaDacionCesionAdj;
	}
	public void setFechaDacionCesionAdj(Date fechaDacionCesionAdj) {
		this.fechaDacionCesionAdj = fechaDacionCesionAdj;
	}
	public Double getImporteDacionCesionAj() {
		return importeDacionCesionAj;
	}
	public void setImporteDacionCesionAj(Double importeDacionCesionAj) {
		this.importeDacionCesionAj = importeDacionCesionAj;
	}
	public Double getValorContableBruto() {
		return valorContableBruto;
	}
	public void setValorContableBruto(Double valorContableBruto) {
		this.valorContableBruto = valorContableBruto;
	}
	public Double getValorContableNeto() {
		return valorContableNeto;
	}
	public void setValorContableNeto(Double valorContableNeto) {
		this.valorContableNeto = valorContableNeto;
	}
	public Double getImportePrecioVenta() {
		return importePrecioVenta;
	}
	public void setImportePrecioVenta(Double importePrecioVenta) {
		this.importePrecioVenta = importePrecioVenta;
	}
	public Double getImporteValoracMercadoActual() {
		return importeValoracMercadoActual;
	}
	public void setImporteValoracMercadoActual(Double importeValoracMercadoActual) {
		this.importeValoracMercadoActual = importeValoracMercadoActual;
	}
	public Date getImporteValoracMercadoActualFecha() {
		return importeValoracMercadoActualFecha;
	}
	public void setImporteValoracMercadoActualFecha(Date importeValoracMercadoActualFecha) {
		this.importeValoracMercadoActualFecha = importeValoracMercadoActualFecha;
	}
	public Double getImporteValoracMercado() {
		return importeValoracMercado;
	}
	public void setImporteValoracMercado(Double importeValoracMercado) {
		this.importeValoracMercado = importeValoracMercado;
	}
	public Date getImporteValoracMercadoFecha() {
		return importeValoracMercadoFecha;
	}
	public void setImporteValoracMercadoFecha(Date importeValoracMercadoFecha) {
		this.importeValoracMercadoFecha = importeValoracMercadoFecha;
	}
	public Double getImporteValoracMercadoAntigua() {
		return importeValoracMercadoAntigua;
	}
	public void setImporteValoracMercadoAntigua(Double importeValoracMercadoAntigua) {
		this.importeValoracMercadoAntigua = importeValoracMercadoAntigua;
	}
	public Date getImporteValoracMercadoAntiguaFecha() {
		return importeValoracMercadoAntiguaFecha;
	}
	public void setImporteValoracMercadoAntiguaFecha(Date importeValoracMercadoAntiguaFecha) {
		this.importeValoracMercadoAntiguaFecha = importeValoracMercadoAntiguaFecha;
	}
	public Boolean getNotificarFrob() {
		return notificarFrob;
	}
	public void setNotificarFrob(Boolean notificarFrob) {
		this.notificarFrob = notificarFrob;
	}
	public String getCanalesComercializacion() {
		return canalesComercializacion;
	}
	public void setCanalesComercializacion(String canalesComercializacion) {
		this.canalesComercializacion = canalesComercializacion;
	}
	public Long getInteresados() {
		return interesados;
	}
	public void setInteresados(Long interesados) {
		this.interesados = interesados;
	}
	public String getNumOferta() {
		return numOferta;
	}
	public void setNumOferta(String numOferta) {
		this.numOferta = numOferta;
	}
	public Double getImportePropuesta() {
		return importePropuesta;
	}
	public void setImportePropuesta(Double importePropuesta) {
		this.importePropuesta = importePropuesta;
	}
	public Boolean getCampanya() {
		return campanya;
	}
	public void setCampanya(Boolean campanya) {
		this.campanya = campanya;
	}
	public Boolean getFamiliarCaixa() {
		return familiarCaixa;
	}
	public void setFamiliarCaixa(Boolean familiarCaixa) {
		this.familiarCaixa = familiarCaixa;
	}
	public Boolean getMultiestrella() {
		return multiestrella;
	}
	public void setMultiestrella(Boolean multiestrella) {
		this.multiestrella = multiestrella;
	}
	public Boolean getAntiguoDeudor() {
		return antiguoDeudor;
	}
	public void setAntiguoDeudor(Boolean antiguoDeudor) {
		this.antiguoDeudor = antiguoDeudor;
	}
	public Boolean getCompraApiFamiliar() {
		return compraApiFamiliar;
	}
	public void setCompraApiFamiliar(Boolean compraApiFamiliar) {
		this.compraApiFamiliar = compraApiFamiliar;
	}
	public String getCompradorUnoNif() {
		return compradorUnoNif;
	}
	public void setCompradorUnoNif(String compradorUnoNif) {
		this.compradorUnoNif = compradorUnoNif;
	}
	public String getCompradorUnoNombre() {
		return compradorUnoNombre;
	}
	public void setCompradorUnoNombre(String compradorUnoNombre) {
		this.compradorUnoNombre = compradorUnoNombre;
	}
	public String getCompradorDosNif() {
		return compradorDosNif;
	}
	public void setCompradorDosNif(String compradorDosNif) {
		this.compradorDosNif = compradorDosNif;
	}
	public String getCompradorDosNombre() {
		return compradorDosNombre;
	}
	public void setCompradorDosNombre(String compradorDosNombre) {
		this.compradorDosNombre = compradorDosNombre;
	}
	public String getApi() {
		return api;
	}
	public void setApi(String api) {
		this.api = api;
	}
	public List<DtoDatosOfertaPdf> getListadoOfertas() {
		return listadoOfertas;
	}
	public void setListadoOfertas(List<DtoDatosOfertaPdf> listadoOfertas) {
		this.listadoOfertas = listadoOfertas;
	}
	public String getNotas() {
		return notas;
	}
	public void setNotas(String notas) {
		this.notas = notas;
	}
	public String getPoblacionInmueble() {
		return poblacionInmueble;
	}
	public void setPoblacionInmueble(String poblacionInmueble) {
		this.poblacionInmueble = poblacionInmueble;
	}
	public String getProvinciaInmueble() {
		return provinciaInmueble;
	}
	public void setProvinciaInmueble(String provinciaInmueble) {
		this.provinciaInmueble = provinciaInmueble;
	}
	
	
	
	
	
	
	
}