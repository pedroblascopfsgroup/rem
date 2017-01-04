package es.pfsgroup.plugin.rem.model;

import java.io.Serializable;
import java.util.Date;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;


@Entity
@Table(name = "V_BUSQUEDA_ACTIVOS_PRECIOS", schema = "${entity.schema}")
public class VBusquedaActivosPrecios implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	
	
	@Id
	@Column(name = "ACT_ID")
	private String id;	
	
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
	
    @Column(name = "ENTIDAD_CODIGO")
    private String entidadPropietariaCodigo;
    
    @Column(name = "ENTIDAD_DESCRIPCION")
    private String entidadPropietariaDescripcion;
    
    @Column(name = "SUBCARTERA_CODIGO")
    private String subcarteraCodigo;
    
    @Column(name = "SUBCARTERA_DESCRIPCION")
    private String subcarteraDescripcion;
    
    @Column(name = "TIPO_TITULO_CODIGO")
    private String tipoTituloActivoCodigo;
    
    @Column(name = "TIPO_TITULO_DESCRIPCION")
    private String tipoTituloActivoDescripcion;
    
    @Column(name = "SUBTIPO_TITULO_CODIGO")
    private String subTipoTituloActivoCodigo;
    
    @Column(name = "SUBTIPO_TITULO_DESCRIPCION")
    private String subTipoTituloActivoDescripcion;
    
    @Column(name = "INSCRITO")
    private Integer inscrito;

    @Column(name = "CON_POSESION")
    private Integer conPosesion;
    
    @Column(name = "CON_FECHA_REVISION_CARGAS")
    private Integer conCargas;
    
    @Column(name = "DESTINO_COMERCIAL_CODIGO")
    private String destinoComercialCodigo;
    
    @Column(name = "DESTINO_COMERCIAL_DESCRIPCION")
    private String destinoComercialDescripcion;
    
    @Column(name = "CON_OFERTA_APROBADA")
    private Integer conOfertaAprobada;
    
    @Column(name = "CON_RESERVA")
    private Integer conReserva;
    
    @Column(name = "TIENE_MEDIADOR")
    private Integer tieneMediador;
    
    //@Column(name = "TIENE_LLAVES_MEDIADOR")
    
    @Column(name = "ESTADO_INF_COMERCIAL")
    private String estadoInformeComercial;
    
    @Column(name = "CON_TASACION")
    private Integer conTasacion;
    
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
    
/*    @Column(name="PRECIO_DESCUENTO_APROBADO")
    private Double precioDescuentoAprobado;
    
    @Column(name="PRECIO_DESCUENTO_PUBLICADO")
    private Double precioDescuentoPublicado;
 */   
    @Column(name="FSV_VENTA")
    private Double fsvVenta;
    
    @Column(name="FSV_RENTA")
    private Double fsvRenta;
    
    @Column(name="CON_BLOQUEO")
    private Integer conBloqueo;
    
    @Column(name="FECHA_PRECIAR")
    private Date fechaPreciar;
    
    @Column(name="FECHA_REPRECIAR")
    private Date fechaRepreciar;
    
    @Column(name="FECHA_DESCUENTO")
    private Date fechaDescuento;
    
    @Column(name="PRO_ID")
    private String idPropietario;
    
    @Column(name="ESTADO_FISICO_CODIGO")
    private String estadoActivoCodigo;
    
    @Column(name="ESTADO_FISICO_DESCRIPCION")
    private String estadoActivoDescripcion;


	public String getId() {
		return id;
	}

	public void setId(String id) {
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

	public String getEntidadPropietariaCodigo() {
		return entidadPropietariaCodigo;
	}

	public void setEntidadPropietariaCodigo(String entidadPropietariaCodigo) {
		this.entidadPropietariaCodigo = entidadPropietariaCodigo;
	}

	public String getEntidadPropietariaDescripcion() {
		return entidadPropietariaDescripcion;
	}

	public void setEntidadPropietariaDescripcion(
			String entidadPropietariaDescripcion) {
		this.entidadPropietariaDescripcion = entidadPropietariaDescripcion;
	}

	public String getTipoTituloActivoCodigo() {
		return tipoTituloActivoCodigo;
	}

	public void setTipoTituloActivoCodigo(String tipoTituloActivoCodigo) {
		this.tipoTituloActivoCodigo = tipoTituloActivoCodigo;
	}

	public String getTipoTituloActivoDescripcion() {
		return tipoTituloActivoDescripcion;
	}

	public void setTipoTituloActivoDescripcion(String tipoTituloActivoDescripcion) {
		this.tipoTituloActivoDescripcion = tipoTituloActivoDescripcion;
	}

	public String getSubTipoTituloActivoCodigo() {
		return subTipoTituloActivoCodigo;
	}

	public void setSubTipoTituloActivoCodigo(String subTipoTituloActivoCodigo) {
		this.subTipoTituloActivoCodigo = subTipoTituloActivoCodigo;
	}

	public String getSubTipoTituloActivoDescripcion() {
		return subTipoTituloActivoDescripcion;
	}

	public void setSubTipoTituloActivoDescripcion(
			String subTipoTituloActivoDescripcion) {
		this.subTipoTituloActivoDescripcion = subTipoTituloActivoDescripcion;
	}

	public Integer getInscrito() {
		return inscrito;
	}

	public void setInscrito(Integer inscrito) {
		this.inscrito = inscrito;
	}

	public Integer getConPosesion() {
		return conPosesion;
	}

	public void setConPosesion(Integer conPosesion) {
		this.conPosesion = conPosesion;
	}

	public Integer getConCargas() {
		return conCargas;
	}

	public void setConCargas(Integer conCargas) {
		this.conCargas = conCargas;
	}

	public Integer getTieneMediador() {
		return tieneMediador;
	}

	public void setTieneMediador(Integer tieneMediador) {
		this.tieneMediador = tieneMediador;
	}

	public String getEstadoInformeComercial() {
		return estadoInformeComercial;
	}

	public void setEstadoInformeComercial(String estadoInformeComercial) {
		this.estadoInformeComercial = estadoInformeComercial;
	}

	public Integer getConTasacion() {
		return conTasacion;
	}

	public void setConTasacion(Integer conTasacion) {
		this.conTasacion = conTasacion;
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
/*
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
*/
	public Double getFsvVenta() {
		return fsvVenta;
	}

	public void setFsvVenta(Double fsvVenta) {
		this.fsvVenta = fsvVenta;
	}

	public Double getFsvRenta() {
		return fsvRenta;
	}

	public void setFsvRenta(Double fsvRenta) {
		this.fsvRenta = fsvRenta;
	}

	public Integer getConBloqueo() {
		return conBloqueo;
	}

	public void setConBloqueo(Integer conBloqueo) {
		this.conBloqueo = conBloqueo;
	}

	public Date getFechaPreciar() {
		return fechaPreciar;
	}

	public void setFechaPreciar(Date fechaPreciar) {
		this.fechaPreciar = fechaPreciar;
	}

	public Date getFechaRepreciar() {
		return fechaRepreciar;
	}

	public void setFechaRepreciar(Date fechaRepreciar) {
		this.fechaRepreciar = fechaRepreciar;
	}

	public Date getFechaDescuento() {
		return fechaDescuento;
	}

	public void setFechaDescuento(Date fechaDescuento) {
		this.fechaDescuento = fechaDescuento;
	}

	public String getIdPropietario() {
		return idPropietario;
	}

	public void setIdPropietario(String idPropietario) {
		this.idPropietario = idPropietario;
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

	public String getEstadoActivoDescripcion() {
		return estadoActivoDescripcion;
	}

	public void setEstadoActivoDescripcion(String estadoActivoDescripcion) {
		this.estadoActivoDescripcion = estadoActivoDescripcion;
	}

	public String getDestinoComercialCodigo() {
		return destinoComercialCodigo;
	}

	public void setDestinoComercialCodigo(String destinoComercialCodigo) {
		this.destinoComercialCodigo = destinoComercialCodigo;
	}

	public String getDestinoComercialDescripcion() {
		return destinoComercialDescripcion;
	}

	public void setDestinoComercialDescripcion(String destinoComercialDescripcion) {
		this.destinoComercialDescripcion = destinoComercialDescripcion;
	}
	
	public Integer getConOfertaAprobada() {
		return conOfertaAprobada;
	}

	public void setConOfertaAprobada(Integer conOfertaAprobada) {
		this.conOfertaAprobada = conOfertaAprobada;
	}

	public Integer getConReserva() {
		return conReserva;
	}

	public void setConReserva(Integer conReserva) {
		this.conReserva = conReserva;
	}
	

}