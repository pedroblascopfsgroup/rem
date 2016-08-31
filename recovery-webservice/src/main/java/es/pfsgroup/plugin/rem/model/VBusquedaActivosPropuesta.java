package es.pfsgroup.plugin.rem.model;

import java.io.Serializable;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;

@Entity
@Table(name = "V_BUSQUEDA_ACTIVOS_PROPUESTA", schema = "${entity.schema}")
public class VBusquedaActivosPropuesta implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	@Id
	@Column(name = "ACT_ID")
	private String idActivo;	
	
	@Column(name = "ACT_NUM_ACTIVO")
	private String numActivo;
	
	@Column(name = "PRP_ID")
	private String idPropuesta;
	
	@Column(name="SUBTIPO_ACTIVO_CODIGO")
	private String subtipoActivoCodigo;
	
	@Column(name="SUBTIPO_ACTIVO_DESCRIPCION")
	private String subtipoActivoDescripcion;
	
	@Column(name="TIPO_ACTIVO_DESCRIPCION")
	private String tipoActivoDescripcion;
	
	@Column(name="TIPO_ACTIVO_CODIGO")
	private String tipoActivoCodigo;
    
    @Column(name = "PROVINCIA_CODIGO")
    private String codigoProvincia;
    
    @Column(name = "PROVINCIA_DESCRIPCION")
    private String provincia;
    
    @Column(name = "LOCALIDAD_CODIGO")
    private String codigoMunicipio;
    
    @Column(name = "LOCALIDAD_DESCRIPCION")
    private String municipio;
    
    @Column(name = "CODIGO_POSTAL")
    private String codigoPostal;
    
    @Column(name = "DIRECCION")
    private String direccion;
    
    @Column(name="PRECIO_APROBADO_VENTA")
    private Double precioAprobadoVenta;
    
    @Column(name="PRECIO_APROBADO_RENTA")
    private Double precioAprobadoRenta;
    
    @Column(name="PRECIO_MINIMO_AUTORIZADO")
    private Double precioMinimoAutorizado;
    
    @Column(name="PRECIO_DESCUENTO_APROBADO")
    private Double precioDescuentoAprobado;
    
    @Column(name="PRECIO_DESCUENTO_PUBLICADO")
    private Double precioDescuentoPublicado;
    
    @Column(name="ESTADO_CODIGO")
    private String codigoEstadoActivo;
    
    @Column(name="ESTADO_DESCRIPCION")
    private String descripcionEstadoActivo;
    
    @Column(name="MOTIVO_DESCARTE")
    private String motivoDescarte;

	public String getIdActivo() {
		return idActivo;
	}

	public void setIdActivo(String id) {
		this.idActivo = id;
	}

	public String getNumActivo() {
		return numActivo;
	}

	public void setNumActivo(String numActivo) {
		this.numActivo = numActivo;
	}

	public String getIdPropuesta() {
		return idPropuesta;
	}

	public void setIdPropuesta(String idPropuesta) {
		this.idPropuesta = idPropuesta;
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

	public String getCodigoProvincia() {
		return codigoProvincia;
	}

	public void setCodigoProvincia(String codigoProvincia) {
		this.codigoProvincia = codigoProvincia;
	}

	public String getProvincia() {
		return provincia;
	}

	public void setProvincia(String provincia) {
		this.provincia = provincia;
	}

	public String getCodigoMunicipio() {
		return codigoMunicipio;
	}

	public void setCodigoMunicipio(String codigoMunicipio) {
		this.codigoMunicipio = codigoMunicipio;
	}

	public String getMunicipio() {
		return municipio;
	}

	public void setMunicipio(String municipio) {
		this.municipio = municipio;
	}

	public String getCodigoPostal() {
		return codigoPostal;
	}

	public void setCodigoPostal(String codigoPostal) {
		this.codigoPostal = codigoPostal;
	}

	public String getDireccion() {
		return direccion;
	}

	public void setDireccion(String direccion) {
		this.direccion = direccion;
	}

	public Double getPrecioAprobadoVenta() {
		return precioAprobadoVenta;
	}

	public void setPrecioAprobadoVenta(Double precioAprobadoVenta) {
		this.precioAprobadoVenta = precioAprobadoVenta;
	}

	public Double getPrecioAprobadoRenta() {
		return precioAprobadoRenta;
	}

	public void setPrecioAprobadoRenta(Double precioAprobadoRenta) {
		this.precioAprobadoRenta = precioAprobadoRenta;
	}

	public Double getPrecioMinimoAutorizado() {
		return precioMinimoAutorizado;
	}

	public void setPrecioMinimoAutorizado(Double precioMinimoAutorizado) {
		this.precioMinimoAutorizado = precioMinimoAutorizado;
	}

	public Double getPrecioDescuentoAprobado() {
		return precioDescuentoAprobado;
	}

	public void setPrecioDescuentoAprobado(Double precioDescuentoAprobado) {
		this.precioDescuentoAprobado = precioDescuentoAprobado;
	}

	public Double getPrecioDescuentoPublicado() {
		return precioDescuentoPublicado;
	}

	public void setPrecioDescuentoPublicado(Double precioDescuentoPublicado) {
		this.precioDescuentoPublicado = precioDescuentoPublicado;
	}

	public String getCodigoEstadoActivo() {
		return codigoEstadoActivo;
	}

	public void setCodigoEstadoActivo(String codigoEstadoActivo) {
		this.codigoEstadoActivo = codigoEstadoActivo;
	}

	public String getDescripcionEstadoActivo() {
		return descripcionEstadoActivo;
	}

	public void setDescripcionEstadoActivo(String descripcionEstadoActivo) {
		this.descripcionEstadoActivo = descripcionEstadoActivo;
	}

	public String getMotivoDescarte() {
		return motivoDescarte;
	}

	public void setMotivoDescarte(String motivoDescarte) {
		this.motivoDescarte = motivoDescarte;
	}
    
	
}
