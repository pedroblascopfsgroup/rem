package es.pfsgroup.plugin.rem.model;

import java.io.Serializable;
import java.util.Date;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;

@Entity
@Table(name = "V_DATOS_PROPUESTA_ENTIDAD03", schema = "${entity.schema}")
public class VDatosPropuestaEntidad03 implements Serializable {
	
	private static final long serialVersionUID = 1L;
	

	@Id
	@Column(name = "ACT_ID")
	private Long id;
	@Column(name = "PRP_ID")
	private Long idPropuesta;
	@Column(name = "CARTERA_CODIGO")
	private String codCartera;
	
	@Column(name = "AGR_RESTRINGIDA_NUM") // Lote
	private String numAgrupacionRestringida; 
	@Column(name = "ID_CARTERA") // Activo
	private String numActivo; 
	@Column(name = "ID_HAYA") 
	private String numActivoRem; 
	@Column(name = "DIRECCION")
	private String direccion;
	@Column(name = "MUNICIPIO")
	private String municipio;
	@Column(name = "PROVINCIA")
	private String provincia;
	@Column(name = "COD_POSTAL")
	private String codigoPostal;
	@Column(name = "FECHA_ENTRADA")
	private Date fechaEntrada;
	@Column(name = "VALOR_TASACION")
	private Double valorTasacion;
	@Column(name = "FECHA_TASACION")
	private Date fechaTasacion;
	@Column(name = "VALOR_ESTIMADO_VENTA")
	private Double valorEstimadoVenta;
	@Column(name = "FECHA_ESTIMADO_VENTA")
	private Date fechaEstimadoVenta;
	@Column(name = "FSV_VENTA")
	private Double valorFsv;
	@Column(name = "FSV_VENTA_F_INI")
	private Date fechaFsv;
	@Column(name = "VALOR_ASESORADO_LIQ")
	private Double valorLiquidativo;
	@Column(name = "VALOR_ASESORADO_LIQ_F_INI")
	private Date fechaValorLiquidativo;
	@Column(name = "VNC")
	private Double valorVnc;
	@Column(name = "APROBADO_VENTA_WEB")
	private Double valorVentaWeb;
	@Column(name = "SOCIEDAD_PROPIETARIA")
	private String sociedadPropietaria;
	@Column(name = "FECHA_PUBLICACION")
	private Date fechaPublicacion;
	@Column(name = "ORIGEN")
	private String origen;
	@Column(name = "TIPO_CODIGO")
	private String tipoActivoCodigo;
	@Column(name = "TIPO_DESCRIPCION")
	private String tipoActivoDescripcion;
	@Column(name = "TASACION_CODIGO")
	private String tipoTasacionCodigo;
	@Column(name = "TASACION_DESCRIPCION")
	private String tipoTasacionDescripcion;
	@Column(name = "MAYOR_VALORACION")
	private Double mayorValoracion;

	
	
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

	public Date getFechaEntrada() {
		return fechaEntrada;
	}

	public void setFechaEntrada(Date fechaEntrada) {
		this.fechaEntrada = fechaEntrada;
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

	public Double getValorLiquidativo() {
		return valorLiquidativo;
	}

	public void setValorLiquidativo(Double valorLiquidativo) {
		this.valorLiquidativo = valorLiquidativo;
	}

	public Date getFechaValorLiquidativo() {
		return fechaValorLiquidativo;
	}

	public void setFechaValorLiquidativo(Date fechaValorLiquidativo) {
		this.fechaValorLiquidativo = fechaValorLiquidativo;
	}

	public Double getValorVnc() {
		return valorVnc;
	}

	public void setValorVnc(Double valorVnc) {
		this.valorVnc = valorVnc;
	}

	public Double getValorVentaWeb() {
		return valorVentaWeb;
	}

	public void setValorVentaWeb(Double valorVentaWeb) {
		this.valorVentaWeb = valorVentaWeb;
	}

	public String getSociedadPropietaria() {
		return sociedadPropietaria;
	}

	public void setSociedadPropietaria(String sociedadPropietaria) {
		this.sociedadPropietaria = sociedadPropietaria;
	}

	public Date getFechaPublicacion() {
		return fechaPublicacion;
	}

	public void setFechaPublicacion(Date fechaPublicacion) {
		this.fechaPublicacion = fechaPublicacion;
	}

	public String getOrigen() {
		return origen;
	}

	public void setOrigen(String origen) {
		this.origen = origen;
	}

	public String getTipoActivoCodigo() {
		return tipoActivoCodigo;
	}

	public void setTipoActivoCodigo(String tipoActivoCodigo) {
		this.tipoActivoCodigo = tipoActivoCodigo;
	}

	public String getTipoActivoDescripcion() {
		return tipoActivoDescripcion;
	}

	public void setTipoActivoDescripcion(String tipoActivoDescripcion) {
		this.tipoActivoDescripcion = tipoActivoDescripcion;
	}

	public String getTipoTasacionCodigo() {
		return tipoTasacionCodigo;
	}

	public void setTipoTasacionCodigo(String tipoTasacionCodigo) {
		this.tipoTasacionCodigo = tipoTasacionCodigo;
	}

	public String getTipoTasacionDescripcion() {
		return tipoTasacionDescripcion;
	}

	public void setTipoTasacionDescripcion(String tipoTasacionDescripcion) {
		this.tipoTasacionDescripcion = tipoTasacionDescripcion;
	}

	public Double getMayorValoracion() {
		return mayorValoracion;
	}

	public void setMayorValoracion(Double mayorValoracion) {
		this.mayorValoracion = mayorValoracion;
	}	
}
