package es.pfsgroup.plugin.rem.model;

import es.capgemini.devon.dto.WebDto;

/**
 * Dto para el filtro de Activos
 * @author Benjamín Guerrero
 *
 */
public class DtoAgrupacionFilter extends WebDto {

	private static final long serialVersionUID = 0L;

	private String nombre;
	private String tipoAgrupacion;
	private String fechaCreacionDesde;
	private String fechaCreacionHasta;
	private String fechaInicioVigenciaDesde;
	private String fechaInicioVigenciaHasta;
	private String fechaFinVigenciaDesde;
	private String fechaFinVigenciaHasta;
	private String numAgrupacionRem;
	private String numAgrUVEM;
	private String publicado;
	private String agrupacionId;
	private Long id;
	private Long agrId;
	private Long actId;
	private String codCartera;
	private Long subcarteraCodigo;
	private String codProvincia;
	private String localidadDescripcion;
	private Long numActHaya;
	private Long numActPrinex;
	private Long numActSareb;
	private Long numActUVEM;
	private Long numActReco;
	private Long idNumActivoPrincipal;
	private String nif;
	private String tipoAlquiler;
	private Long activo_gencat;


	public String getNombre() {
		return nombre;
	}

	public void setNombre(String nombre) {
		this.nombre = nombre;
	}

	public String getTipoAgrupacion() {
		return tipoAgrupacion;
	}

	public void setTipoAgrupacion(String tipoAgrupacion) {
		this.tipoAgrupacion = tipoAgrupacion;
	}

	public String getNumAgrupacionRem() {
		return numAgrupacionRem;
	}

	public void setNumAgrupacionRem(String numAgrupacionRem) {
		this.numAgrupacionRem = numAgrupacionRem;
	}

	public String getNumAgrUVEM() {
		return numAgrUVEM;
	}

	public void setNumAgrUVEM(String numAgrUVEM) {
		this.numAgrUVEM = numAgrUVEM;
	}

	public String getPublicado() {
		return publicado;
	}

	public void setPublicado(String publicado) {
		this.publicado = publicado;
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

	public String getAgrupacionId() {
		return agrupacionId;
	}

	public void setAgrupacionId(String agrupacionId) {
		this.agrupacionId = agrupacionId;
	}

	public Long getAgrId() {
		return agrId;
	}

	public void setAgrId(Long agrId) {
		this.agrId = agrId;
	}

	public Long getActId() {
		return actId;
	}

	public void setActId(Long actId) {
		this.actId = actId;
	}

	public String getCodCartera() {
		return codCartera;
	}

	public void setCodCartera(String codCartera) {
		this.codCartera = codCartera;
	}

	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}
	
	public String getCodProvincia() {
		return codProvincia;
	}

	public void setCodProvincia(String codProvincia) {
		this.codProvincia = codProvincia;
	}

	public String getLocalidadDescripcion() {
		return localidadDescripcion;
	}

	public void setLocalidadDescripcion(String localidadDescripcion) {
		this.localidadDescripcion = localidadDescripcion;
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

	public Long getNumActHaya() {
		return numActHaya;
	}

	public void setNumActHaya(Long numActHaya) {
		this.numActHaya = numActHaya;
	}

	public Long getNumActPrinex() {
		return numActPrinex;
	}

	public void setNumActPrinex(Long numActPrinex) {
		this.numActPrinex = numActPrinex;
	}

	public Long getNumActSareb() {
		return numActSareb;
	}

	public void setNumActSareb(Long numActSareb) {
		this.numActSareb = numActSareb;
	}

	public Long getNumActUVEM() {
		return numActUVEM;
	}

	public void setNumActUVEM(Long numActUVEM) {
		this.numActUVEM = numActUVEM;
	}

	public Long getNumActReco() {
		return numActReco;
	}

	public void setNumActReco(Long numActReco) {
		this.numActReco = numActReco;
	}

	public Long getSubcarteraCodigo() {
		return subcarteraCodigo;
	}

	public void setSubcarteraCodigo(Long subcarteraCodigo) {
		this.subcarteraCodigo = subcarteraCodigo;
	}

	public String getNif() {
		return nif;
	}

	public void setNif(String nif) {
		this.nif = nif;
	}

	public String getTipoAlquiler() {
		return tipoAlquiler;
	}

	public void setTipoAlquiler(String tipoAlquiler) {
		this.tipoAlquiler = tipoAlquiler;
	}
	public Long getIdNumActivoPrincipal() {
		return idNumActivoPrincipal;
	}

	public void setIdNumActivoPrincipal(Long idNumActivoPrincipal) {
		this.idNumActivoPrincipal = idNumActivoPrincipal;
	}

	public Long getActivo_gencat() {
		return activo_gencat;
	}

	public void setActivo_gencat(Long activo_gencat) {
		this.activo_gencat = activo_gencat;
	}

}