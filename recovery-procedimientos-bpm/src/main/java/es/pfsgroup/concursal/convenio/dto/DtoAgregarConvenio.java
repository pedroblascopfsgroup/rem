package es.pfsgroup.concursal.convenio.dto;

import javax.validation.constraints.NotNull;
import javax.validation.constraints.Size;

import es.capgemini.devon.dto.WebDto;

public class DtoAgregarConvenio extends WebDto{
	
	private static final long serialVersionUID = 4134246258943431546L;

	private Long id;
	
	@NotNull
	private Long idProcedimiento;
	
	private Long idConvenio;
	
	private Long banderaEntrada;
	
	@NotNull(message="procedimiento.agregarConvenio.numeroProponentes")
	private Long numeroProponentes;
	
	//@NotNull(message="procedimiento.agregarConvenio.totalMasa")
	private Float totalMasa;
	
	//@NotNull(message="procedimiento.agregarConvenio.porcentaje")
	private Float porcentaje;
	
	private Long adherirse;
	
	@NotNull(message="procedimiento.agregarConvenio.Estado")
	private Long estado;
		
	private Long postura;
	
	@NotNull(message="procedimiento.agregarConvenio.Origen")
	private Long inicio;
	
	@NotNull(message="procedimiento.agregarConvenio.Tipo")
	private Long tipo;
	
	@NotNull(message="procedimiento.agregarConvenio.fecha")
	@Size(min=10,max=10,message="procedimiento.agregarConvenio.fecha.formato")
	private String fecha;
	
	private String descripcion;
	
	private String descripcionTerceros;
	
	private String descripcionAnticipado;
	
	private String descripcionAdhesiones;
	
	private Long alternativa;

	private Long tipoAdhesion;
	
	private String descripcionConvenio;
	
	private Float totalMasaOrd;
	
	private Float porcentajeOrd;
	
	private String guid;
	
	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public Long getIdProcedimiento() {
		return idProcedimiento;
	}

	public void setIdProcedimiento(Long idProcedimiento) {
		this.idProcedimiento = idProcedimiento;
	}

	public void setIdConvenio(Long idConvenio) {
		this.idConvenio = idConvenio;
	}

	public Long getIdConvenio() {
		return idConvenio;
	}

	public Long getBanderaEntrada() {
		return banderaEntrada;
	}

	public void setBanderaEntrada(Long banderaEntrada) {
		this.banderaEntrada = banderaEntrada;
	}

	public void setNumeroProponentes(Long numeroProponentes) {
		this.numeroProponentes = numeroProponentes;
	}

	public Long getNumeroProponentes() {
		return numeroProponentes;
	}

	public void setTotalMasa(Float totalMasa) {
		this.totalMasa = totalMasa;
	}

	public Float getTotalMasa() {
		return totalMasa;
	}

	public void setPorcentaje(Float porcentaje) {
		this.porcentaje = porcentaje;
	}

	public Float getPorcentaje() {
		return porcentaje;
	}

	public void setEstado(Long estado) {
		this.estado = estado;
	}

	public Long getEstado() {
		return estado;
	}

	public void setPostura(Long postura) {
		this.postura = postura;
	}

	public Long getPostura() {
		return postura;
	}

	public void setFecha(String fecha) {
		this.fecha = fecha;
	}

	public String getFecha() {
		return fecha;
	}

	public void setDescripcion(String descripcion) {
		this.descripcion = descripcion;
	}

	public String getDescripcion() {
		return descripcion;
	}

	public void setInicio(Long inicio) {
		this.inicio = inicio;
	}

	public Long getInicio() {
		return inicio;
	}

	public void setTipo(Long tipo) {
		this.tipo = tipo;
	}

	public Long getTipo() {
		return tipo;
	}

	public void setAdherirse(Long adherirse) {
		this.adherirse = adherirse;
	}

	public Long getAdherirse() {
		return adherirse;
	}

	public void setDescripcionTerceros(String descripcionTerceros) {
		this.descripcionTerceros = descripcionTerceros;
	}

	public String getDescripcionTerceros() {
		return descripcionTerceros;
	}

	public void setDescripcionAdhesiones(String descripcionAdhesiones) {
		this.descripcionAdhesiones = descripcionAdhesiones;
	}

	public String getDescripcionAdhesiones() {
		return descripcionAdhesiones;
	}

	public void setDescripcionAnticipado(String descripcionAnticipado) {
		this.descripcionAnticipado = descripcionAnticipado;
	}

	public String getDescripcionAnticipado() {
		return descripcionAnticipado;
	}
	
	public void setDescripcionConvenio(String descripcionConvenio) {
		this.descripcionConvenio = descripcionConvenio;
	}

	public String getDescripcionConvenio() {
		return descripcionConvenio;
	}

	public Long getAlternativa() {
		return alternativa;
	}

	public void setAlternativa(Long alternativa) {
		this.alternativa = alternativa;
	}

	public void setTipoAdhesion(Long tipoAdhesion) {
		this.tipoAdhesion = tipoAdhesion;
	}

	public Long getTipoAdhesion() {
		return tipoAdhesion;
	}

	public Float getTotalMasaOrd() {
		return totalMasaOrd;
	}

	public void setTotalMasaOrd(Float totalMasaOrd) {
		this.totalMasaOrd = totalMasaOrd;
	}

	public Float getPorcentajeOrd() {
		return porcentajeOrd;
	}

	public void setPorcentajeOrd(Float porcentajeOrd) {
		this.porcentajeOrd = porcentajeOrd;
	}

	public String getGuid() {
		return guid;
	}

	public void setGuid(String guid) {
		this.guid = guid;
	}
	
	

}
