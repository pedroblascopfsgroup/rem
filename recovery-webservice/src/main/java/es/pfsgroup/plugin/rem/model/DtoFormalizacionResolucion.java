package es.pfsgroup.plugin.rem.model;

import java.util.Date;

import es.capgemini.devon.dto.WebDto;


/**
 * Dto que gestiona la informacion de las resoluciones del expediente.
 *  
 * @author Luis Caballero
 *
 */
public class DtoFormalizacionResolucion extends WebDto {
	
	
  
	/**
	 * 
	 */
	private static final long serialVersionUID = 3574353502838449106L;
	

	private String id;
	private Long idFormalizacion;
	private Long idExpediente;
	private String nombreNotario;
	private String personaContacto;
	private String peticionario;
	private Date fechaPeticion;
	private Date fechaResolucion;
	private Date fechaPago;
	private String formaPago;
	private String gastosCargo;
	private String docIdentificativo;
	private String motivoResolucion;
	private Double importe;
	private Date fechaVenta;
	private String numProtocolo;
	private Boolean generacionHojaDatos;
	private Date fechaContabilizacion;
	
	private Date fechaFirmaContrato;
	private String numeroProtocoloCaixa;
	
	private Boolean ventaPlazos;
	private Boolean ventaCondicionSupensiva;
	private Boolean cesionRemate;
	private Boolean contratoPrivado;
	
	private Date fechaInicioCnt;
	private Date fechaFinCnt;
	private String llamadaRealizada;
	private Date fechaLlamada;
	private String burofaxEnviado;
	private Date fechaBurofax;
	
	private Boolean esSubrogacionEjecucionHipotecaria;
	
	
	public Long getIdFormalizacion() {
		return idFormalizacion;
	}
	public void setIdFormalizacion(Long idFormalizacion) {
		this.idFormalizacion = idFormalizacion;
	}
	public Long getIdExpediente() {
		return idExpediente;
	}
	public void setIdExpediente(Long idExpediente) {
		this.idExpediente = idExpediente;
	}
	public String getNombreNotario() {
		return nombreNotario;
	}
	public void setNombreNotario(String nombreNotario) {
		this.nombreNotario = nombreNotario;
	}
	public String getPersonaContacto() {
		return personaContacto;
	}
	public void setPersonaContacto(String personaContacto) {
		this.personaContacto = personaContacto;
	}
	public String getPeticionario() {
		return peticionario;
	}
	public void setPeticionario(String peticionario) {
		this.peticionario = peticionario;
	}
	public Date getFechaPeticion() {
		return fechaPeticion;
	}
	public void setFechaPeticion(Date fechaPeticion) {
		this.fechaPeticion = fechaPeticion;
	}
	public Date getFechaResolucion() {
		return fechaResolucion;
	}
	public void setFechaResolucion(Date fechaResolucion) {
		this.fechaResolucion = fechaResolucion;
	}
	public Date getFechaPago() {
		return fechaPago;
	}
	public void setFechaPago(Date fechaPago) {
		this.fechaPago = fechaPago;
	}
	public String getFormaPago() {
		return formaPago;
	}
	public void setFormaPago(String formaPago) {
		this.formaPago = formaPago;
	}
	public String getGastosCargo() {
		return gastosCargo;
	}
	public void setGastosCargo(String gastosCargo) {
		this.gastosCargo = gastosCargo;
	}
	public String getDocIdentificativo() {
		return docIdentificativo;
	}
	public void setDocIdentificativo(String docIdentificativo) {
		this.docIdentificativo = docIdentificativo;
	}
	public String getMotivoResolucion() {
		return motivoResolucion;
	}
	public void setMotivoResolucion(String motivoResolucion) {
		this.motivoResolucion = motivoResolucion;
	}
	public Double getImporte() {
		return importe;
	}
	public void setImporte(Double importe) {
		this.importe = importe;
	}
	public Date getFechaVenta() {
		return fechaVenta;
	}
	public void setFechaVenta(Date fechaVenta) {
		this.fechaVenta = fechaVenta;
	}
	public String getNumProtocolo() {
		return numProtocolo;
	}
	public void setNumProtocolo(String numProtocolo) {
		this.numProtocolo = numProtocolo;
	}
	public Boolean getGeneracionHojaDatos() {
		return generacionHojaDatos;
	}
	public void setGeneracionHojaDatos(Boolean generacionHojaDatos) {
		this.generacionHojaDatos = generacionHojaDatos;
	}
	public Date getFechaContabilizacion() {
		return fechaContabilizacion;
	}
	public void setFechaContabilizacion(Date fechaContabilizacion) {
		this.fechaContabilizacion = fechaContabilizacion;
	}
	public Date getFechaFirmaContrato() {
		return fechaFirmaContrato;
	}
	public void setFechaFirmaContrato(Date fechaFirmaContrato) {
		this.fechaFirmaContrato = fechaFirmaContrato;
	}
	public String getNumeroProtocoloCaixa() {
		return numeroProtocoloCaixa;
	}
	public void setNumeroProtocoloCaixa(String numeroProtocoloCaixa) {
		this.numeroProtocoloCaixa = numeroProtocoloCaixa;
	}
	public Boolean getVentaPlazos() {
		return ventaPlazos;
	}
	public void setVentaPlazos(Boolean ventaPlazos) {
		this.ventaPlazos = ventaPlazos;
	}
	public Boolean getVentaCondicionSupensiva() {
		return ventaCondicionSupensiva;
	}
	public void setVentaCondicionSupensiva(Boolean ventaCondicionSupensiva) {
		this.ventaCondicionSupensiva = ventaCondicionSupensiva;
	}
	public String getId() {
		return id;
	}
	public void setId(String id) {
		this.id = id;
	}
	public Boolean getCesionRemate() {
		return cesionRemate;
	}
	public void setCesionRemate(Boolean cesionRemate) {
		this.cesionRemate = cesionRemate;
	}
	public Boolean getContratoPrivado() {
		return contratoPrivado;
	}
	public void setContratoPrivado(Boolean contratoPrivado) {
		this.contratoPrivado = contratoPrivado;
	}
	public Date getFechaInicioCnt() {
		return fechaInicioCnt;
	}
	public void setFechaInicioCnt(Date fechaInicioCnt) {
		this.fechaInicioCnt = fechaInicioCnt;
	}
	public Date getFechaFinCnt() {
		return fechaFinCnt;
	}
	public void setFechaFinCnt(Date fechaFinCnt) {
		this.fechaFinCnt = fechaFinCnt;
	}
	public String getLlamadaRealizada() {
		return llamadaRealizada;
	}
	public void setLlamadaRealizada(String llamadaRealizada) {
		this.llamadaRealizada = llamadaRealizada;
	}
	public Date getFechaLlamada() {
		return fechaLlamada;
	}
	public void setFechaLlamada(Date fechaLlamada) {
		this.fechaLlamada = fechaLlamada;
	}
	public String getBurofaxEnviado() {
		return burofaxEnviado;
	}
	public void setBurofaxEnviado(String burofaxEnviado) {
		this.burofaxEnviado = burofaxEnviado;
	}
	public Date getFechaBurofax() {
		return fechaBurofax;
	}
	public void setFechaBurofax(Date fechaBurofax) {
		this.fechaBurofax = fechaBurofax;
	}
	public Boolean getEsSubrogacionEjecucionHipotecaria() {
		return esSubrogacionEjecucionHipotecaria;
	}
	public void setEsSubrogacionEjecucionHipotecaria(Boolean esSubrogacionEjecucionHipotecaria) {
		this.esSubrogacionEjecucionHipotecaria = esSubrogacionEjecucionHipotecaria;
	}
	
}
