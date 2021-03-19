package es.pfsgroup.plugin.rem.model;

import es.capgemini.devon.dto.WebDto;

public class DtoAgrupacionGridFilter extends WebDto {

	private static final long serialVersionUID = 0L;

	private Long id;
	private String tipoAgrupacionCodigo;
	private String tipoAgrupacionDescripcion;
	private String nombre;
	private String numAgrupacionRem;
	private String numAgrupacionUvem;
	private String descripcion;
	private String fechaAlta;
	private String fechaBaja;
	private String fechaInicioVigencia;
	private String fechaFinVigencia;
	private String fechaCreacionDesde;
	private String fechaCreacionHasta;
	private String fechaInicioVigenciaDesde;
	private String fechaInicioVigenciaHasta;
	private String fechaFinVigenciaDesde;
	private String fechaFinVigenciaHasta;
	private Integer publicado;
	private Integer numActivos;
	private Integer numPublicados;
	private String direccion;
	private String carteraCodigo;
	private String carteraDescripcion;
	private String subcarteraCodigo;
	private String subcarteraDescripcion;
	private Integer formalizacion;
	private String numActHaya;
	private String numActPrinex;
	private String numActSareb;
	private String numActUVEM;
	private String numActReco;
	private String nif;
	private String tipoAlquilerCodigo;
	private String tipoAlquilerDescripcion;
	private String localidadCodigo;
	private String localidadDescripcion;
	private String provinciaCodigo;
	private String provinciaDescripcion;

	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public String getTipoAgrupacionCodigo() {
		return tipoAgrupacionCodigo;
	}

	public void setTipoAgrupacionCodigo(String tipoAgrupacionCodigo) {
		this.tipoAgrupacionCodigo = tipoAgrupacionCodigo;
	}

	public String getTipoAgrupacionDescripcion() {
		return tipoAgrupacionDescripcion;
	}

	public void setTipoAgrupacionDescripcion(String tipoAgrupacionDescripcion) {
		this.tipoAgrupacionDescripcion = tipoAgrupacionDescripcion;
	}

	public String getNombre() {
		return nombre;
	}

	public void setNombre(String nombre) {
		this.nombre = nombre;
	}

	public String getNumAgrupacionRem() {
		return numAgrupacionRem;
	}

	public void setNumAgrupacionRem(String numAgrupacionRem) {
		this.numAgrupacionRem = numAgrupacionRem;
	}

	public String getNumAgrupacionUvem() {
		return numAgrupacionUvem;
	}

	public void setNumAgrupacionUvem(String numAgrupacionUvem) {
		this.numAgrupacionUvem = numAgrupacionUvem;
	}

	public String getDescripcion() {
		return descripcion;
	}

	public void setDescripcion(String descripcion) {
		this.descripcion = descripcion;
	}

	public String getFechaAlta() {
		return fechaAlta;
	}

	public void setFechaAlta(String fechaAlta) {
		this.fechaAlta = fechaAlta;
	}

	public String getFechaBaja() {
		return fechaBaja;
	}

	public void setFechaBaja(String fechaBaja) {
		this.fechaBaja = fechaBaja;
	}

	public String getFechaInicioVigencia() {
		return fechaInicioVigencia;
	}

	public void setFechaInicioVigencia(String fechaInicioVigencia) {
		this.fechaInicioVigencia = fechaInicioVigencia;
	}

	public String getFechaFinVigencia() {
		return fechaFinVigencia;
	}

	public void setFechaFinVigencia(String fechaFinVigencia) {
		this.fechaFinVigencia = fechaFinVigencia;
	}

	public String getFechaCreacionDesde() {
		return fechaCreacionDesde;
	}

	public void setFechaCreacionDesde(String fechaCreacionDesde) {
		this.fechaCreacionDesde = fechaCreacionDesde;
	}

	public String getFechaCreacionHasta() {
		return fechaCreacionHasta;
	}

	public void setFechaCreacionHasta(String fechaCreacionHasta) {
		this.fechaCreacionHasta = fechaCreacionHasta;
	}

	public String getFechaInicioVigenciaDesde() {
		return fechaInicioVigenciaDesde;
	}

	public void setFechaInicioVigenciaDesde(String fechaInicioVigenciaDesde) {
		this.fechaInicioVigenciaDesde = fechaInicioVigenciaDesde;
	}

	public String getFechaInicioVigenciaHasta() {
		return fechaInicioVigenciaHasta;
	}

	public void setFechaInicioVigenciaHasta(String fechaInicioVigenciaHasta) {
		this.fechaInicioVigenciaHasta = fechaInicioVigenciaHasta;
	}

	public String getFechaFinVigenciaDesde() {
		return fechaFinVigenciaDesde;
	}

	public void setFechaFinVigenciaDesde(String fechaFinVigenciaDesde) {
		this.fechaFinVigenciaDesde = fechaFinVigenciaDesde;
	}

	public String getFechaFinVigenciaHasta() {
		return fechaFinVigenciaHasta;
	}

	public void setFechaFinVigenciaHasta(String fechaFinVigenciaHasta) {
		this.fechaFinVigenciaHasta = fechaFinVigenciaHasta;
	}

	public Integer getPublicado() {
		return publicado;
	}

	public void setPublicado(Integer publicado) {
		this.publicado = publicado;
	}

	public Integer getNumActivos() {
		return numActivos;
	}

	public void setNumActivos(Integer numActivos) {
		this.numActivos = numActivos;
	}

	public Integer getNumPublicados() {
		return numPublicados;
	}

	public void setNumPublicados(Integer numPublicados) {
		this.numPublicados = numPublicados;
	}

	public String getDireccion() {
		return direccion;
	}

	public void setDireccion(String direccion) {
		this.direccion = direccion;
	}

	public String getCarteraCodigo() {
		return carteraCodigo;
	}

	public void setCarteraCodigo(String carteraCodigo) {
		this.carteraCodigo = carteraCodigo;
	}

	public String getCarteraDescripcion() {
		return carteraDescripcion;
	}

	public void setCarteraDescripcion(String carteraDescripcion) {
		this.carteraDescripcion = carteraDescripcion;
	}

	public String getSubcarteraCodigo() {
		return subcarteraCodigo;
	}

	public void setSubcarteraCodigo(String subcarteraCodigo) {
		this.subcarteraCodigo = subcarteraCodigo;
	}

	public String getSubcarteraDescripcion() {
		return subcarteraDescripcion;
	}

	public void setSubcarteraDescripcion(String subcarteraDescripcion) {
		this.subcarteraDescripcion = subcarteraDescripcion;
	}

	public Integer getFormalizacion() {
		return formalizacion;
	}

	public void setFormalizacion(Integer formalizacion) {
		this.formalizacion = formalizacion;
	}

	public String getNumActHaya() {
		return numActHaya;
	}

	public void setNumActHaya(String numActHaya) {
		this.numActHaya = numActHaya;
	}

	public String getNumActPrinex() {
		return numActPrinex;
	}

	public void setNumActPrinex(String numActPrinex) {
		this.numActPrinex = numActPrinex;
	}

	public String getNumActSareb() {
		return numActSareb;
	}

	public void setNumActSareb(String numActSareb) {
		this.numActSareb = numActSareb;
	}

	public String getNumActUVEM() {
		return numActUVEM;
	}

	public void setNumActUVEM(String numActUVEM) {
		this.numActUVEM = numActUVEM;
	}

	public String getNumActReco() {
		return numActReco;
	}

	public void setNumActReco(String numActReco) {
		this.numActReco = numActReco;
	}

	public String getNif() {
		return nif;
	}

	public void setNif(String nif) {
		this.nif = nif;
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

	public String getLocalidadCodigo() {
		return localidadCodigo;
	}

	public void setLocalidadCodigo(String localidadCodigo) {
		this.localidadCodigo = localidadCodigo;
	}

	public String getLocalidadDescripcion() {
		return localidadDescripcion;
	}

	public void setLocalidadDescripcion(String localidadDescripcion) {
		this.localidadDescripcion = localidadDescripcion;
	}

	public String getProvinciaCodigo() {
		return provinciaCodigo;
	}

	public void setProvinciaCodigo(String provinciaCodigo) {
		this.provinciaCodigo = provinciaCodigo;
	}

	public String getProvinciaDescripcion() {
		return provinciaDescripcion;
	}

	public void setProvinciaDescripcion(String provinciaDescripcion) {
		this.provinciaDescripcion = provinciaDescripcion;
	}

}