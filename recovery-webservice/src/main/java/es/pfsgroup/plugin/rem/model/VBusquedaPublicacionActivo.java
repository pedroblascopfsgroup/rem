package es.pfsgroup.plugin.rem.model;

import java.io.Serializable;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;


@Entity
@Table(name = "V_BUSQUEDA_PUBLICACION_ACTIVO", schema = "${entity.schema}")
public class VBusquedaPublicacionActivo implements Serializable {

	private static final long serialVersionUID = 1L;

	@Id
	@Column(name = "ACT_ID")
	private Long id;	
	
	@Column(name = "ACT_NUM_ACTIVO")
	private String numActivo;
	
	@Column(name="SUBTIPO_ACTIVO_CODIGO")
	private String subtipoActivoCodigo;
	
	@Column(name="SUBTIPO_ACTIVO_DESCRIPCION")
	private String subtipoActivoDescripcion;
	
	@Column(name="TIPO_ACTIVO_DESCRIPCION")
	private String tipoActivoDescripcion;
	
	@Column(name="TIPO_ACTIVO_CODIGO")
	private String tipoActivoCodigo;

    @Column(name = "DIRECCION")
    private String direccion;
    
    @Column(name="DESPUBLICADO_FORZADO")
    private Boolean despublicadoForzado;
    
    @Column(name="PUBLICADO_FORZADO")
    private Boolean publicadoForzado;
	
    @Column(name="ADMISION")
    private Boolean admision;
    
    @Column(name="GESTION")
    private Boolean gestion;

    @Column(name="PUBLICACION")
    private Boolean publicacion;
    
    @Column(name="PRECIO")
    private Boolean precio;
    
    @Column(name="CARTERA_CODIGO")
    private String cartera;
    
    @Column(name="PRECIO_CONSULTAR")
    private Boolean precioConsultar;

	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public String getNumActivo() {
		return numActivo;
	}

	public void setNumActivo(String numActivo) {
		this.numActivo = numActivo;
	}

	public String getSubtipoActivoCodigo() {
		return subtipoActivoCodigo;
	}

	public void setSubtipoActivoCodigo(String subtipoActivoCodigo) {
		this.subtipoActivoCodigo = subtipoActivoCodigo;
	}

	public String getSubtipoActivoDescripcion() {
		return subtipoActivoDescripcion;
	}

	public void setSubtipoActivoDescripcion(String subtipoActivoDescripcion) {
		this.subtipoActivoDescripcion = subtipoActivoDescripcion;
	}

	public String getTipoActivoDescripcion() {
		return tipoActivoDescripcion;
	}

	public void setTipoActivoDescripcion(String tipoActivoDescripcion) {
		this.tipoActivoDescripcion = tipoActivoDescripcion;
	}

	public String getTipoActivoCodigo() {
		return tipoActivoCodigo;
	}

	public void setTipoActivoCodigo(String tipoActivoCodigo) {
		this.tipoActivoCodigo = tipoActivoCodigo;
	}

	public String getDireccion() {
		return direccion;
	}

	public void setDireccion(String direccion) {
		this.direccion = direccion;
	}

	public Boolean getDespubliForzado() {
		return despublicadoForzado;
	}

	public void setDespubliForzado(Boolean despubliForzado) {
		this.despublicadoForzado = despubliForzado;
	}

	public Boolean getPubliForzado() {
		return publicadoForzado;
	}

	public void setPubliForzado(Boolean publiForzado) {
		this.publicadoForzado = publiForzado;
	}

	public Boolean getAdmision() {
		return admision;
	}

	public void setAdmision(Boolean admision) {
		this.admision = admision;
	}

	public Boolean getGestion() {
		return gestion;
	}

	public void setGestion(Boolean gestion) {
		this.gestion = gestion;
	}

	public Boolean getPublicacion() {
		return publicacion;
	}

	public void setPublicacion(Boolean publicacion) {
		this.publicacion = publicacion;
	}

	public Boolean getPrecio() {
		return precio;
	}

	public void setPrecio(Boolean precio) {
		this.precio = precio;
	}

	public String getCartera() {
		return cartera;
	}

	public void setCartera(String cartera) {
		this.cartera = cartera;
	}

	public Boolean getPrecioConsultar() {
		return precioConsultar;
	}

	public void setPrecioConsultar(Boolean precioConsultar) {
		this.precioConsultar = precioConsultar;
	}
    
}