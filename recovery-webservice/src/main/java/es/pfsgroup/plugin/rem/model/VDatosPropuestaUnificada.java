package es.pfsgroup.plugin.rem.model;

import java.io.Serializable;
import java.util.Date;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;

@Entity
@Table(name = "V_DATOS_PROPUESTA_UNIFICADA", schema = "${entity.schema}")
public class VDatosPropuestaUnificada implements Serializable {
	
	private static final long serialVersionUID = 1L;
	
	@Id
	@Column(name = "ACT_ID")
	private Long id;
	@Column(name = "PRP_ID")
	private Long idPropuesta;
	@Column(name = "CARTERA_CODIGO")
	private String codCartera;
	@Column(name = "SUBCARTERA_CODIGO")
	private String codSubCartera;
	@Column(name = "SOCIEDAD_PROPIETARIA")
	private String sociedadPropietaria;
	
	
	//Activo - Identificación
	@Column(name = "ORIGEN")
	private String origen;
	@Column(name = "FECHA_ENTRADA")
	private Date fechaEntrada;
	@Column(name = "ID_CARTERA")
	private String numActivo; //Num activo
	@Column(name = "ID_HAYA")
	private String numActivoRem; //Num activo REM
	@Column(name = "REF_CATASTRAL")
	private String refCatastral;
	@Column(name = "FINCA_REGISTRAL")
	private String numFincaRegistral;
	
	//Activo - Agrupación
	@Column(name = "AGR_NUEVA_NUM")
	private String numAgrupacionObraNueva;
	@Column(name = "AGR_RESTRINGIDA_NUM")
	private String numAgrupacionRestringida;
	
	//Activo - Tipología
	@Column(name = "TIPO_CODIGO")
	private String tipoActivoCodigo;
	@Column(name = "TIPO_DESCRIPCION")
	private String tipoActivoDescripcion;
	@Column(name = "SUBTIPO_DESCRIPCION")
	private String subtipoActivoDescripcion;
	
	//Activo - Dirección
	@Column(name = "DIRECCION")
	private String direccion;
	@Column(name = "MUNICIPIO")
	private String municipio;
	@Column(name = "PROVINCIA")
	private String provincia;
	@Column(name = "COD_POSTAL")
	private String codigoPostal;
	
	
	//Estado Dptos. - Información Comercial
	@Column(name = "ASCENSOR")
	private Boolean ascensor;
	@Column(name = "NUM_DORMITORIOS")
	private Integer numDormitorios;
	@Column(name = "SUPERFICIE_TOTAL")
	private Double superficieTotal;
	@Column(name = "ANO_CONSTRUCCION")
	private Integer anoConstruccion;
	@Column(name = "ESTADO_CONSTRUCCION")
	private String estadoConstruccion;
	
	//Estado Dptos. - Comercial
	@Column(name = "ESTADO_COMERCIAL")
	private String situacionComercialDescripcion;
	@Column(name = "NUM_VISITAS")
	private Integer numVisitas;
	@Column(name = "NUM_OFERTAS")
	private Integer numOfertas;
	
	//Estado Dptos. - Admisión
	@Column(name = "FECHA_INSCRIPCION")
	private Date fechaInscripcion;
	@Column(name = "FECHA_REV_CARGAS")
	private Date fechaRevisionCargas;
	@Column(name = "FECHA_TOMA_POSESION")
	private Date fechaTomaPosesion;
	
	//Estado Dptos. - Gestión
	@Column(name = "OCUPADO")
	private String ocupado;
	
	//Estado Dptos. - Publicacion
	@Column(name = "FECHA_PUBLICACION")
	private Date fechaPublicacion;
	
	
	//Valores - Estimado venta
	@Column(name = "VALOR_ESTIMADO_VENTA")
	private Double valorEstimadoVenta;
	@Column(name = "FECHA_ESTIMADO_VENTA")
	private Date fechaEstimadoVenta;
	
	//Valores - Estimado venta
	@Column(name = "VALOR_TASACION")
	private Double valorTasacion;
	@Column(name = "FECHA_TASACION")
	private Date fechaTasacion;
	
	//Valores - FSV
	@Column(name = "FSV_VENTA")
	private Double valorFsv;
	@Column(name = "FSV_VENTA_F_INI")
	private Date fechaFsv;
	
	//Valores - Mayor Valoración
	@Column(name = "MAYOR_VALORACION")
	private Double mayorValoracion;
	
	
	//Precios Actuales
	@Column(name = "APROBADO_VENTA_WEB")
	private Double valorVentaWeb;
	@Column(name = "APROBADO_VENTA_WEB_F_INI")
	private Date fechaVentaWeb;
	@Column(name = "APROBADO_RENTA_WEB")
	private Double valorRentaWeb;
	@Column(name = "VNC")
	private Double valorVnc;
	@Column(name = "COSTE_ADIQUISICION")
	private Double valorAdquisicion;
	@Column(name = "COSTE_ADIQUISICION_F_INI")
	private Date fechaValorAdquisicion;
	@Column(name = "VALOR_ASESORADO_LIQ")
	private Double valorLiquidativo;
	@Column(name = "VALOR_ASESORADO_LIQ_F_INI")
	private Date fechaValorLiquidativo;
	
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
	public String getCodSubCartera() {
		return codSubCartera;
	}
	public void setCodSubCartera(String codSubCartera) {
		this.codSubCartera = codSubCartera;
	}
	public String getSociedadPropietaria() {
		return sociedadPropietaria;
	}
	public void setSociedadPropietaria(String sociedadPropietaria) {
		this.sociedadPropietaria = sociedadPropietaria;
	}
	public String getOrigen() {
		return origen;
	}
	public void setOrigen(String origen) {
		this.origen = origen;
	}
	public Date getFechaEntrada() {
		return fechaEntrada;
	}
	public void setFechaEntrada(Date fechaEntrada) {
		this.fechaEntrada = fechaEntrada;
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
	public String getRefCatastral() {
		return refCatastral;
	}
	public void setRefCatastral(String refCatastral) {
		this.refCatastral = refCatastral;
	}
	public String getNumFincaRegistral() {
		return numFincaRegistral;
	}
	public void setNumFincaRegistral(String numFincaRegistral) {
		this.numFincaRegistral = numFincaRegistral;
	}
	public String getNumAgrupacionObraNueva() {
		return numAgrupacionObraNueva;
	}
	public void setNumAgrupacionObraNueva(String numAgrupacionObraNueva) {
		this.numAgrupacionObraNueva = numAgrupacionObraNueva;
	}
	public String getNumAgrupacionRestringida() {
		return numAgrupacionRestringida;
	}
	public void setNumAgrupacionRestringida(String numAgrupacionRestringida) {
		this.numAgrupacionRestringida = numAgrupacionRestringida;
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
	public String getSubtipoActivoDescripcion() {
		return subtipoActivoDescripcion;
	}
	public void setSubtipoActivoDescripcion(String subtipoActivoDescripcion) {
		this.subtipoActivoDescripcion = subtipoActivoDescripcion;
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
	public Boolean getAscensor() {
		return ascensor;
	}
	public void setAscensor(Boolean ascensor) {
		this.ascensor = ascensor;
	}
	public Integer getNumDormitorios() {
		return numDormitorios;
	}
	public void setNumDormitorios(Integer numDormitorios) {
		this.numDormitorios = numDormitorios;
	}
	public Double getSuperficieTotal() {
		return superficieTotal;
	}
	public void setSuperficieTotal(Double superficieTotal) {
		this.superficieTotal = superficieTotal;
	}
	public Integer getAnoConstruccion() {
		return anoConstruccion;
	}
	public void setAnoConstruccion(Integer anoConstruccion) {
		this.anoConstruccion = anoConstruccion;
	}
	public String getEstadoConstruccion() {
		return estadoConstruccion;
	}
	public void setEstadoConstruccion(String estadoConstruccion) {
		this.estadoConstruccion = estadoConstruccion;
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
	public String getOcupado() {
		return ocupado;
	}
	public void setOcupado(String ocupado) {
		this.ocupado = ocupado;
	}
	public Date getFechaPublicacion() {
		return fechaPublicacion;
	}
	public void setFechaPublicacion(Date fechaPublicacion) {
		this.fechaPublicacion = fechaPublicacion;
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
	public Double getMayorValoracion() {
		return mayorValoracion;
	}
	public void setMayorValoracion(Double mayorValoracion) {
		this.mayorValoracion = mayorValoracion;
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
	public Double getValorRentaWeb() {
		return valorRentaWeb;
	}
	public void setValorRentaWeb(Double valorRentaWeb) {
		this.valorRentaWeb = valorRentaWeb;
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
	public Double getValorLiquidativo() {
		return valorLiquidativo;
	}
	public void setValorLiquidativo(Double valorLiquidativo) {
		this.valorLiquidativo = valorLiquidativo;
	}
	public String getSituacionComercialDescripcion() {
		return situacionComercialDescripcion;
	}
	public void setSituacionComercialDescripcion(
			String situacionComercialDescripcion) {
		this.situacionComercialDescripcion = situacionComercialDescripcion;
	}
	public Date getFechaInscripcion() {
		return fechaInscripcion;
	}
	public void setFechaInscripcion(Date fechaInscripcion) {
		this.fechaInscripcion = fechaInscripcion;
	}
	public Date getFechaValorAdquisicion() {
		return fechaValorAdquisicion;
	}
	public void setFechaValorAdquisicion(Date fechaValorAdquisicion) {
		this.fechaValorAdquisicion = fechaValorAdquisicion;
	}
	public Date getFechaValorLiquidativo() {
		return fechaValorLiquidativo;
	}
	public void setFechaValorLiquidativo(Date fechaValorLiquidativo) {
		this.fechaValorLiquidativo = fechaValorLiquidativo;
	}
	
	
}
