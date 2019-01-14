package es.pfsgroup.plugin.rem.model;

import java.io.Serializable;
import java.util.Date;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.Table;

import es.capgemini.pfs.direccion.model.DDProvincia;
import es.capgemini.pfs.direccion.model.Localidad;
import es.pfsgroup.plugin.rem.model.dd.DDTipoAgrupacion;


@Entity
@Table(name = "V_BUSQUEDA_AGRUPACIONES", schema = "${entity.schema}")
public class VBusquedaAgrupaciones implements Serializable {
	
	private static final long serialVersionUID = 1L;


	@Id
	@Column(name = "AGR_ID")
	private Long id;	
	
    @ManyToOne	
    @JoinColumn(name = "DD_TAG_ID")
    private DDTipoAgrupacion tipoAgrupacion;

    @Column(name = "AGR_NUM_AGRUP_REM")
	private String numAgrupacionRem;
    
    @Column(name = "AGR_NUM_AGRUP_UVEM")
    private String numAgrupacionUvem;
    
    @ManyToOne
    @JoinColumn(name = "provincia")
    private DDProvincia provincia;
    
    @ManyToOne
    @JoinColumn(name = "localidad")
    private Localidad localidad;
    
    @Column(name = "direccion")
    private String direccion;
    
    @Column(name = "AGR_PUBLICADO")
	private String publicado;

    @Column(name = "AGR_NOMBRE")
	private String nombre;	
	
	@Column(name = "AGR_DESCRIPCION")
	private String descripcion;
	
	@Column(name = "AGR_FECHA_ALTA")
	private Date fechaAlta;
	
	@Column(name = "AGR_FECHA_BAJA")
	private Date fechaBaja;

	@Column(name = "AGR_INI_VIGENCIA")
	private Date fechaInicioVigencia;
	
	@Column(name = "AGR_FIN_VIGENCIA")
	private Date fechaFinVigencia;

	@Column(name = "ACTIVOS")
	private String activos;
	
	@Column(name = "PUBLICADOS")
	private String publicados;

	@Column(name = "CARTERA")
	private String cartera;
	
	@Column(name = "AGR_IS_FORMALIZACION")
	private Integer isFormalizacion;
	
	@Column(name = "IDTIPOALQUILER")
	private Integer idTipoAlquiler;
	
	@Column(name = "CODTIPOALQUILER")
	private String codTipoAlquiler;

	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public DDTipoAgrupacion getTipoAgrupacion() {
		return tipoAgrupacion;
	}

	public void setTipoAgrupacion(DDTipoAgrupacion tipoAgrupacion) {
		this.tipoAgrupacion = tipoAgrupacion;
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

	public String getActivos() {
		return activos;
	}

	public void setActivos(String activos) {
		this.activos = activos;
	}

	public String getPublicados() {
		return publicados;
	}

	public void setPublicados(String publicados) {
		this.publicados = publicados;
	}

	public DDProvincia getProvincia() {
		return provincia;
	}

	public void setProvincia(DDProvincia provincia) {
		this.provincia = provincia;
	}

	public String getPublicado() {
		return publicado;
	}

	public void setPublicado(String publicado) {
		this.publicado = publicado;
	}

	public Localidad getLocalidad() {
		return localidad;
	}

	public void setLocalidad(Localidad localidad) {
		this.localidad = localidad;
	}

	public String getDireccion() {
		return direccion;
	}

	public void setDireccion(String direccion) {
		this.direccion = direccion;
	}
	
	public String getCartera() {
		return cartera;
	}

	public void setCartera(String cartera) {
		this.cartera = cartera;
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

	public Integer getIsFormalizacion() {
		return isFormalizacion;
	}

	public void setIsFormalizacion(Integer isFormalizacion) {
		this.isFormalizacion = isFormalizacion;
	}

	public Integer getIdTipoAlquiler() {
		return idTipoAlquiler;
	}

	public void setIdTipoAlquiler(Integer idTipoAlquiler) {
		this.idTipoAlquiler = idTipoAlquiler;
	}

	public String getCodTipoAlquiler() {
		return codTipoAlquiler;
	}

	public void setCodTipoAlquiler(String codTipoAlquiler) {
		this.codTipoAlquiler = codTipoAlquiler;
	}

}