package es.pfsgroup.plugin.rem.model;

import java.io.Serializable;
import java.util.Date;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.Table;

import es.pfsgroup.plugin.rem.model.dd.DDSubtipoActivo;


@Entity
@Table(name = "V_BUSQUEDA_AGRUPACIONES_BY_ACTIVO", schema = "${entity.schema}")
public class VBusquedaAgrupacionByActivo implements Serializable {


	
	/**
	 * Para usar esta vista hay que filtrar por ID_ACTIVO, si no traerá repetidos.
	 */
	
	private static final long serialVersionUID = 1L;

	@Id
	@Column(name = "ID")
	private Long id;
	
	@Column(name = "ACTIVO_ID")
	private Long idActivo;
	
	@Column(name = "AGR_ID")
	private Long idAgrupacion;
	
	@Column(name = "NOMBRE_AGRUPACION")
	private String nombre;
	
	@Column(name = "DESCRIPCION_AGRUPACION")
	private String descripcion;
	
	@Column(name = "FECHA_CREACION_AGRUPACION")
	private Date fechaAlta;
	
	@Column(name = "FECHA_BAJA_AGRUPACION")
	private Date fechaBaja;
	
	@Column(name = "FECHA_INCLUSION_ACTIVO")
	private Date fechaInclusion;
	
	@Column(name = "NUM_AGRUPACION_REM")
	private Long numAgrupRem;
	
	@Column(name = "NUM_AGRUPACION_UVEM")
	private Long numAgrupUvem;
	
	@Column(name = "TIPO_AGRUPACION_DESCRIPCION")
	private String tipoAgrupacionDescripcion;
	
	@Column(name = "TIPO_AGRUPACION_CODIGO")
	private String tipoAgrupacionCodigo;
	
	@Column(name = "NUM_ACTIVOS")
	private String numActivos;
	
	@Column(name = "FECHA_INI_VIGENCIA")
	private Date fechaInicioVigencia;
	
	@Column(name = "FECHA_FIN_VIGENCIA")
	private Date fechaFinVigencia;
	
	@Column(name = "ACT_PUBLICADOS")
	private String numActivosPublicados;

	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public Long getIdActivo() {
		return idActivo;
	}

	public void setIdActivo(Long idActivo) {
		this.idActivo = idActivo;
	}

	public Long getIdAgrupacion() {
		return idAgrupacion;
	}

	public void setIdAgrupacion(Long idAgrupacion) {
		this.idAgrupacion = idAgrupacion;
	}

	public String getNombre() {
		return nombre;
	}

	public void setNombre(String nombre) {
		this.nombre = nombre;
	}

	public String getDescripcion() {
		return descripcion;
	}

	public void setDescripcion(String descripcion) {
		this.descripcion = descripcion;
	}

	public Date getFechaAlta() {
		return fechaAlta;
	}

	public void setFechaAlta(Date fechaAlta) {
		this.fechaAlta = fechaAlta;
	}

	public Date getFechaBaja() {
		return fechaBaja;
	}

	public void setFechaBaja(Date fechaBaja) {
		this.fechaBaja = fechaBaja;
	}

	public Date getFechaInclusion() {
		return fechaInclusion;
	}

	public void setFechaInclusion(Date fechaInclusion) {
		this.fechaInclusion = fechaInclusion;
	}

	public Long getNumAgrupRem() {
		return numAgrupRem;
	}

	public void setNumAgrupRem(Long numAgrupRem) {
		this.numAgrupRem = numAgrupRem;
	}

	public Long getNumAgrupUvem() {
		return numAgrupUvem;
	}

	public void setNumAgrupUvem(Long numAgrupUvem) {
		this.numAgrupUvem = numAgrupUvem;
	}

	public String getTipoAgrupacionDescripcion() {
		return tipoAgrupacionDescripcion;
	}

	public void setTipoAgrupacionDescripcion(String tipoAgrupacionDescripcion) {
		this.tipoAgrupacionDescripcion = tipoAgrupacionDescripcion;
	}

	public String getTipoAgrupacionCodigo() {
		return tipoAgrupacionCodigo;
	}

	public void setTipoAgrupacionCodigo(String tipoAgrupacionCodigo) {
		this.tipoAgrupacionCodigo = tipoAgrupacionCodigo;
	}

	public String getNumActivos() {
		return numActivos;
	}

	public void setNumActivos(String numActivos) {
		this.numActivos = numActivos;
	}

	public Date getFechaInicioVigencia() {
		return fechaInicioVigencia;
	}

	public void setFechaInicioVigencia(Date fechaInicioVigencia) {
		this.fechaInicioVigencia = fechaInicioVigencia;
	}

	public Date getFechaFinVigencia() {
		return fechaFinVigencia;
	}

	public void setFechaFinVigencia(Date fechaFinVigencia) {
		this.fechaFinVigencia = fechaFinVigencia;
	}

	public String getNumActivosPublicados() {
		return numActivosPublicados;
	}

	public void setNumActivosPublicados(String numActivosPublicados) {
		this.numActivosPublicados = numActivosPublicados;
	}
}