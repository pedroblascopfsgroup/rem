package es.pfsgroup.plugin.rem.model;

import java.io.Serializable;
import java.util.Date;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;

@Entity
@Table(name = "V_DATOS_PROPUESTA_ENTIDAD01", schema = "${entity.schema}")
public class VDatosPropuestaEntidad01 implements Serializable {
	
	private static final long serialVersionUID = 1L;
	
	@Id
	@Column(name = "ACT_ID")
	private Long id;
	@Column(name = "PRP_ID")
	private Long idPropuesta;
	@Column(name = "CARTERA_CODIGO")
	private String codCartera;
	
	@Column(name = "SOCIEDAD_PROPIETARIA")
	private String sociedadPropietaria;
	@Column(name = "CODIGO_PROMOCION	")
	private String numAgrupacionObraNueva;
	@Column(name = "NOMBRE_PROMOCION")
	private String nombreAgrupacionObraNueva;
	@Column(name = "AGR_RESTRINGIDA_NUM")
	private String numAgrupacionRestringida;
	@Column(name = "ID_CARTERA")
	private String numActivo; //Num activo
	@Column(name = "ACT_NUM_ACTIVO_UVEM")
	private String numActivoUvem;
	@Column(name = "ID_HAYA")
	private String numActivoRem; //Num activo REM
	@Column(name = "DIRECCION")
	private String direccion;
	@Column(name = "MUNICIPIO")
	private String municipio;
	@Column(name = "PROVINCIA")
	private String provincia;
	@Column(name = "COD_POSTAL")
	private String codigoPostal;
	@Column(name = "TIPO_DESCRIPCION")
	private String tipoActivoDescripcion;
	@Column(name = "ESTADO_COMERCIAL")
	private String situacionComercialDescripcion;
	@Column(name = "ORIGEN")
	private String origen;
	@Column(name = "FECHA_INSCRIPCION")
	private Date fechaInscripcion;
	@Column(name = "FECHA_REV_CARGAS")
	private Date fechaRevisionCargas;
	@Column(name = "FECHA_TOMA_POSESION")
	private Date fechaTomaPosesion;
	@Column(name = "FECHA_PUBLICACION")
	private Date fechaPublicacion;
	@Column(name = "OCUPADO")
	private String ocupado;
	@Column(name = "NUM_VISITAS")
	private Integer numVisitas;
	@Column(name = "NUM_OFERTAS")
	private Integer numOfertas;
	@Column(name = "FSV_VENTA")
	private Double valorFsv;
	@Column(name = "FSV_VENTA_F_INI")
	private Date fechaFsv;
	@Column(name = "VALOR_ESTIMADO_VENTA")
	private Double valorEstimadoVenta;
	@Column(name = "FECHA_ESTIMADO_VENTA")
	private Date fechaEstimadoVenta;
	@Column(name = "VNC")
	private Double valorVnc;
	@Column(name = "COSTE_ADIQUISICION")
	private Double valorAdquisicion;
	@Column(name = "VALOR_TASACION")
	private Double valorTasacion;
	@Column(name = "FECHA_TASACION")
	private Date fechaTasacion;
	@Column(name = "PRECIO_AUTORIZADO")
	private Double precioAutorizado;
	@Column(name = "FECHA_AUTORIZADO")
	private Date fechaAutorizado;
	@Column(name = "APROBADO_VENTA_WEB")
	private Double valorVentaWeb;
	@Column(name = "APROBADO_VENTA_WEB_F_INI")
	private Date fechaVentaWeb;
	@Column(name = "PRECIO_EVENTO_AUTORIZADO")
	private Double precioEventoAutorizado;
	@Column(name = "FECHA_INI_EVEN_AUTORIZADO")
	private Date fechaInicioEventoAutorizado;
	@Column(name = "FECHA_FIN_EVEN_AUTORIZADO")
	private Date fechaFinEventoAutorizado;
	@Column(name = "PRECIO_DESCUENTO_WEB")
	private Double precioEventoWeb;
	@Column(name = "FECHA_INI_DESC_WEB")
	private Date fechaInicioEventoWeb;
	@Column(name = "FECHA_FIN_DESC_WEB")
	private Date fechaFinEventoWeb;
	@Column(name = "APROBADO_RENTA_WEB")
	private Double valorRentaWeb;
	
	
	
	public Long getId() {
		return id;
	}
	public void setId(Long id) {
		this.id = id;
	}
	public Long getIdPropuesta() {
		return idPropuesta;
	}
	public void setIdPropuesta(Long idPropuesta) {
		this.idPropuesta = idPropuesta;
	}
	public String getCodCartera() {
		return codCartera;
	}
	public void setCodCartera(String codCartera) {
		this.codCartera = codCartera;
	}
	public String getSociedadPropietaria() {
		return sociedadPropietaria;
	}
	public void setSociedadPropietaria(String sociedadPropietaria) {
		this.sociedadPropietaria = sociedadPropietaria;
	}
	public String getNumAgrupacionObraNueva() {
		return numAgrupacionObraNueva;
	}
	public void setNumAgrupacionObraNueva(String numAgrupacionObraNueva) {
		this.numAgrupacionObraNueva = numAgrupacionObraNueva;
	}
	public String getNombreAgrupacionObraNueva() {
		return nombreAgrupacionObraNueva;
	}
	public void setNombreAgrupacionObraNueva(String nombreAgrupacionObraNueva) {
		this.nombreAgrupacionObraNueva = nombreAgrupacionObraNueva;
	}
	public String getNumAgrupacionRestringida() {
		return numAgrupacionRestringida;
	}
	public void setNumAgrupacionRestringida(String numAgrupacionRestringida) {
		this.numAgrupacionRestringida = numAgrupacionRestringida;
	}
	public String getNumActivo() {
		return numActivo;
	}
	public void setNumActivo(String numActivo) {
		this.numActivo = numActivo;
	}
	public String getNumActivoUvem() {
		return numActivoUvem;
	}
	public void setNumActivoUvem(String numActivoUvem) {
		this.numActivoUvem = numActivoUvem;
	}
	public String getNumActivoRem() {
		return numActivoRem;
	}
	public void setNumActivoRem(String numActivoRem) {
		this.numActivoRem = numActivoRem;
	}
	public String getDireccion() {
		return direccion;
	}
	public void setDireccion(String direccion) {
		this.direccion = direccion;
	}
	public String getMunicipio() {
		return municipio;
	}
	public void setMunicipio(String municipio) {
		this.municipio = municipio;
	}
	public String getProvincia() {
		return provincia;
	}
	public void setProvincia(String provincia) {
		this.provincia = provincia;
	}
	public String getCodigoPostal() {
		return codigoPostal;
	}
	public void setCodigoPostal(String codigoPostal) {
		this.codigoPostal = codigoPostal;
	}
	public String getTipoActivoDescripcion() {
		return tipoActivoDescripcion;
	}
	public void setTipoActivoDescripcion(String tipoActivoDescripcion) {
		this.tipoActivoDescripcion = tipoActivoDescripcion;
	}
	public String getSituacionComercialDescripcion() {
		return situacionComercialDescripcion;
	}
	public void setSituacionComercialDescripcion(
			String situacionComercialDescripcion) {
		this.situacionComercialDescripcion = situacionComercialDescripcion;
	}
	public String getOrigen() {
		return origen;
	}
	public void setOrigen(String origen) {
		this.origen = origen;
	}
	public Date getFechaInscripcion() {
		return fechaInscripcion;
	}
	public void setFechaInscripcion(Date fechaInscripcion) {
		this.fechaInscripcion = fechaInscripcion;
	}
	public Date getFechaRevisionCargas() {
		return fechaRevisionCargas;
	}
	public void setFechaRevisionCargas(Date fechaRevisionCargas) {
		this.fechaRevisionCargas = fechaRevisionCargas;
	}
	public Date getFechaTomaPosesion() {
		return fechaTomaPosesion;
	}
	public void setFechaTomaPosesion(Date fechaTomaPosesion) {
		this.fechaTomaPosesion = fechaTomaPosesion;
	}
	public Date getFechaPublicacion() {
		return fechaPublicacion;
	}
	public void setFechaPublicacion(Date fechaPublicacion) {
		this.fechaPublicacion = fechaPublicacion;
	}
	public String getOcupado() {
		return ocupado;
	}
	public void setOcupado(String ocupado) {
		this.ocupado = ocupado;
	}
	public Integer getNumVisitas() {
		return numVisitas;
	}
	public void setNumVisitas(Integer numVisitas) {
		this.numVisitas = numVisitas;
	}
	public Integer getNumOfertas() {
		return numOfertas;
	}
	public void setNumOfertas(Integer numOfertas) {
		this.numOfertas = numOfertas;
	}
	public Double getValorFsv() {
		return valorFsv;
	}
	public void setValorFsv(Double valorFsv) {
		this.valorFsv = valorFsv;
	}
	public Date getFechaFsv() {
		return fechaFsv;
	}
	public void setFechaFsv(Date fechaFsv) {
		this.fechaFsv = fechaFsv;
	}
	public Double getValorEstimadoVenta() {
		return valorEstimadoVenta;
	}
	public void setValorEstimadoVenta(Double valorEstimadoVenta) {
		this.valorEstimadoVenta = valorEstimadoVenta;
	}
	public Date getFechaEstimadoVenta() {
		return fechaEstimadoVenta;
	}
	public void setFechaEstimadoVenta(Date fechaEstimadoVenta) {
		this.fechaEstimadoVenta = fechaEstimadoVenta;
	}
	public Double getValorVnc() {
		return valorVnc;
	}
	public void setValorVnc(Double valorVnc) {
		this.valorVnc = valorVnc;
	}
	public Double getValorAdquisicion() {
		return valorAdquisicion;
	}
	public void setValorAdquisicion(Double valorAdquisicion) {
		this.valorAdquisicion = valorAdquisicion;
	}
	public Double getValorTasacion() {
		return valorTasacion;
	}
	public void setValorTasacion(Double valorTasacion) {
		this.valorTasacion = valorTasacion;
	}
	public Date getFechaTasacion() {
		return fechaTasacion;
	}
	public void setFechaTasacion(Date fechaTasacion) {
		this.fechaTasacion = fechaTasacion;
	}
	public Double getPrecioAutorizado() {
		return precioAutorizado;
	}
	public void setPrecioAutorizado(Double precioAutorizado) {
		this.precioAutorizado = precioAutorizado;
	}
	public Date getFechaAutorizado() {
		return fechaAutorizado;
	}
	public void setFechaAutorizado(Date fechaAutorizado) {
		this.fechaAutorizado = fechaAutorizado;
	}
	public Double getValorVentaWeb() {
		return valorVentaWeb;
	}
	public void setValorVentaWeb(Double valorVentaWeb) {
		this.valorVentaWeb = valorVentaWeb;
	}
	public Date getFechaVentaWeb() {
		return fechaVentaWeb;
	}
	public void setFechaVentaWeb(Date fechaVentaWeb) {
		this.fechaVentaWeb = fechaVentaWeb;
	}
	public Double getPrecioEventoAutorizado() {
		return precioEventoAutorizado;
	}
	public void setPrecioEventoAutorizado(Double precioEventoAutorizado) {
		this.precioEventoAutorizado = precioEventoAutorizado;
	}
	public Date getFechaInicioEventoAutorizado() {
		return fechaInicioEventoAutorizado;
	}
	public void setFechaInicioEventoAutorizado(Date fechaInicioEventoAutorizado) {
		this.fechaInicioEventoAutorizado = fechaInicioEventoAutorizado;
	}
	public Date getFechaFinEventoAutorizado() {
		return fechaFinEventoAutorizado;
	}
	public void setFechaFinEventoAutorizado(Date fechaFinEventoAutorizado) {
		this.fechaFinEventoAutorizado = fechaFinEventoAutorizado;
	}
	public Double getPrecioEventoWeb() {
		return precioEventoWeb;
	}
	public void setPrecioEventoWeb(Double precioEventoWeb) {
		this.precioEventoWeb = precioEventoWeb;
	}
	public Date getFechaInicioEventoWeb() {
		return fechaInicioEventoWeb;
	}
	public void setFechaInicioEventoWeb(Date fechaInicioEventoWeb) {
		this.fechaInicioEventoWeb = fechaInicioEventoWeb;
	}
	public Date getFechaFinEventoWeb() {
		return fechaFinEventoWeb;
	}
	public void setFechaFinEventoWeb(Date fechaFinEventoWeb) {
		this.fechaFinEventoWeb = fechaFinEventoWeb;
	}
	public Double getValorRentaWeb() {
		return valorRentaWeb;
	}
	public void setValorRentaWeb(Double valorRentaWeb) {
		this.valorRentaWeb = valorRentaWeb;
	}

}
