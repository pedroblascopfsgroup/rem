package es.pfsgroup.plugin.rem.model;

import java.io.Serializable;
import java.util.Date;

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
    
    @Column(name="ESTADO_PUBLICACION_CODIGO")
    private String estadoPublicacionCodigo;
    
    @Column(name="ESTADO_PUBLICACION_DESCRIPCION")
    private String estadoPublicacionDescripcion;

	@Column(name="TIPO_COMERCIALIZACION_CODIGO")
    private String tipoComercializacionCodigo;
    
    @Column(name="TIPO_COMERCIALIZACION_DESC")
    private String tipoComercializacionDescripcion;
	
    @Column(name="ADMISION")
    private Boolean admision;
    
    @Column(name="GESTION")
    private Boolean gestion;

    @Column(name="PUBLICACION")
    private Boolean publicacion;
    
    @Column(name="INFORME_COMERCIAL")
    private Boolean informeComercial;
    
    @Column(name="PRECIO")
    private Boolean precio;
    
    @Column(name="CARTERA_CODIGO")
    private String cartera;
    
    @Column(name="SUBCARTERA_CODIGO")
    private String subCartera;
    
    @Column(name="OKALQUILER")
    private Boolean okalquiler;
    
    @Column(name="OKVENTA")
    private Boolean okventa;
    
    @Column(name="MOTIVO_OCULTACION_ALQUILER")
    private String motivoOcultacionAlquiler;
    
    @Column(name="MOTIVO_OCULTACION_VENTA")
    private String motivoOcultacionVenta;
    
    @Column(name = "GPUBL_USU_USERNAME")
    private String gestorPublicacionUsername;
	
	@Column(name = "FASE_PUBLICACION_CODIGO")
	private String fasePublicacionCodigo;
	
	@Column(name = "FASE_PUBLICACION_DESCRIPCION")
	private String fasePublicacionDescripcion;
	
	@Column(name = "SUBFASE_PUBLICACION_CODIGO")
	private String subFasePublicacionCodigo;
	
	@Column(name = "SUBFASE_PUBLICACION_DESCRIPCION")
	private String subFasePublicacionDescripcion;
	
	@Column(name = "TAS_IMPORTE_TAS_FIN")
	private Long precioTasacionActivo;
	
	@Column(name = "DD_TAL_DESCRIPCION")
	private String tipoAlquilerDescripcion;
	
	@Column(name = "APU_FECHA_INI_VENTA")
	private Date fechaPublicacionVenta;
	
	@Column(name = "APU_FECHA_INI_ALQUILER")
	private Date fechaPublicacionAlquiler;
	
	@Column(name = "EPV_CODIGO")
	private String estadoPublicacionVenta;
	
	@Column(name = "EPA_CODIGO")
	private String estadoPublicacionAlquiler;
	

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

	public String getEstadoPublicacionCodigo() {
		return estadoPublicacionCodigo;
	}

	public void setEstadoPublicacionCodigo(String estadoPublicacionCodigo) {
		this.estadoPublicacionCodigo = estadoPublicacionCodigo;
	}

	public String getEstadoPublicacionDescripcion() {
		return estadoPublicacionDescripcion;
	}

	public void setEstadoPublicacionDescripcion(String estadoPublicacionDescripcion) {
		this.estadoPublicacionDescripcion = estadoPublicacionDescripcion;
	}
	
	public String getTipoComercializacionCodigo() {
		return tipoComercializacionCodigo;
	}

	public void setTipoComercializacionCodigo(String tipoComercializacionCodigo) {
		this.tipoComercializacionCodigo = tipoComercializacionCodigo;
	}

	public String getTipoComercializacionDescripcion() {
		return tipoComercializacionDescripcion;
	}

	public void setTipoComercializacionDescripcion(String tipoComercializacionDescripcion) {
		this.tipoComercializacionDescripcion = tipoComercializacionDescripcion;
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
	
	public String getSubCartera() {
		return subCartera;
	}

	public void setSubCartera(String subCartera) {
		this.subCartera = subCartera;
	}

	public Boolean getOkalquiler() {
		return okalquiler;
	}

	public void setOkalquiler(Boolean okalquiler) {
		this.okalquiler = okalquiler;
	}

	public Boolean getOkventa() {
		return okventa;
	}

	public void setOkventa(Boolean okventa) {
		this.okventa = okventa;
	}

	public String getMotivoOcultacionAlquiler() {
		return motivoOcultacionAlquiler;
	}

	public void setMotivoOcultacionAlquiler(String motivoOcultacionAlquiler) {
		this.motivoOcultacionAlquiler = motivoOcultacionAlquiler;
	}

	public String getMotivoOcultacionVenta() {
		return motivoOcultacionVenta;
	}

	public void setMotivoOcultacionVenta(String motivoOcultacionVenta) {
		this.motivoOcultacionVenta = motivoOcultacionVenta;
	}

	public String getFasePublicacionCodigo() {
		return fasePublicacionCodigo;
	}

	public void setFasePublicacionCodigo(String fasePublicacionCodigo) {
		this.fasePublicacionCodigo = fasePublicacionCodigo;
	}

	public Boolean getInformeComercial() {
		return informeComercial;
	}

	public void setInformeComercial(Boolean informeComercial) {
		this.informeComercial = informeComercial;
	}

	public String getGestorPublicacionUsername() {
		return gestorPublicacionUsername;
	}

	public void setGestorPublicacionUsername(String gestorPublicacionUsername) {
		this.gestorPublicacionUsername = gestorPublicacionUsername;
	}

	public String getFasePublicacionDescripcion() {
		return fasePublicacionDescripcion;
	}

	public void setFasePublicacionDescripcion(String fasePublicacionDescripcion) {
		this.fasePublicacionDescripcion = fasePublicacionDescripcion;
	}

	public String getSubFasePublicacionCodigo() {
		return subFasePublicacionCodigo;
	}

	public void setSubFasePublicacionCodigo(String subFasePublicacionCodigo) {
		this.subFasePublicacionCodigo = subFasePublicacionCodigo;
	}

	public String getSubFasePublicacionDescripcion() {
		return subFasePublicacionDescripcion;
	}

	public void setSubFasePublicacionDescripcion(String subFasePublicacionDescripcion) {
		this.subFasePublicacionDescripcion = subFasePublicacionDescripcion;
	}

	public Long getPrecioTasacionActivo() {
		return precioTasacionActivo;
	}

	public void setPrecioTasacionActivo(Long precioTasacionActivo) {
		this.precioTasacionActivo = precioTasacionActivo;
	}

	public String getTipoAlquilerDescripcion() {
		return tipoAlquilerDescripcion;
	}

	public void setTipoAlquilerDescripcion(String tipoAlquilerDescripcion) {
		this.tipoAlquilerDescripcion = tipoAlquilerDescripcion;
	}

	public Date getFechaPublicacionVenta() {
		return fechaPublicacionVenta;
	}

	public void setFechaPublicacionVenta(Date fechaPublicacionVenta) {
		this.fechaPublicacionVenta = fechaPublicacionVenta;
	}

	public Date getFechaPublicacionAlquiler() {
		return fechaPublicacionAlquiler;
	}

	public void setFechaPublicacionAlquiler(Date fechaPublicacionAlquiler) {
		this.fechaPublicacionAlquiler = fechaPublicacionAlquiler;
	}

	public String getEstadoPublicacionVenta() {
		return estadoPublicacionVenta;
	}

	public void setEstadoPublicacionVenta(String estadoPublicacionVenta) {
		this.estadoPublicacionVenta = estadoPublicacionVenta;
	}

	public String getEstadoPublicacionAlquiler() {
		return estadoPublicacionAlquiler;
	}

	public void setEstadoPublicacionAlquiler(String estadoPublicacionAlquiler) {
		this.estadoPublicacionAlquiler = estadoPublicacionAlquiler;
	}
	
    
}