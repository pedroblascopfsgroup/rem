package es.pfsgroup.plugin.rem.model;

import java.io.Serializable;
import java.util.Date;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;

@Entity
@Table(name = "V_DATOS_PROPUESTA_ENTIDAD02", schema = "${entity.schema}")
public class VDatosPropuestaEntidad02 implements Serializable {

	private static final long serialVersionUID = 1L;
	
	@Id
	@Column(name = "ACT_ID")
	private Long id;
	@Column(name = "PRP_ID")
	private Long idPropuesta;
	@Column(name = "CARTERA_CODIGO")
	private String codCartera;
	
	//Se ha mantenido el mismo orden que aparecerá en la excel de propuestas
	@Column(name = "ID_ENTIDAD")
	private String sociedadPropietaria;
	@Column(name = "ID_HAYA") 
	private String numActivoRem; 
	@Column(name = "ID_SAREB") // Activo
	private String numActivo; 
	@Column(name = "CODIGO_PROMOCION")
	private String numAgrupacionObraNueva;
	@Column(name = "NOMBRE_PROMOCION")
	private String nombreAgrupacionObraNueva;
	@Column(name = "FECHA_INSCRIPCION")
	private Date fechaInscripcion;
	@Column(name = "FECHA_REV_CARGAS")
	private Date fechaRevisionCargas;
	@Column(name = "FECHA_TOMA_POSESION")
	private Date fechaTomaPosesion;
	@Column(name = "SITUACION_COMERCIAL")
	private String situacionComercialDescripcion;
	@Column(name = "TIPO_DESCRIPCION")
	private String tipoActivoDescripcion;
	@Column(name = "DETALLE_VIVIENDA")
	private String subtipoActivoDescripcion;
	@Column(name = "DIRECCION")
	private String direccion;
	@Column(name = "ESPECIFIC_DIRECCION")
	private String especificacionesDireccion;
	@Column(name = "MUNICIPIO")
	private String municipio;
	@Column(name = "PROVINCIA")
	private String provincia;
	@Column(name = "ASCENSOR")
	private Boolean ascensor;
	@Column(name = "NUM_DORMITORIOS")
	private Integer numDormitorios;
	@Column(name = "REF_CATASTRAL")
	private String refCatastral;
	@Column(name = "FINCA_REGISTRAL")
	private String numFincaRegistral;
	@Column(name = "FECHA_PUBLICACION")
	private Date fechaPublicacion;
	@Column(name = "SUPERFICIE_TOTAL")
	private Double superficieTotal;
	@Column(name = "SUPERIFICIE_UTIL")
	private Double superficieUtil;
	@Column(name = "SUPERFICIE_TERRAZA")
	private Double superficieTerraza;
	@Column(name = "SUPERFICIE_PARCELA")
	private Double superficieParcela;
	@Column(name = "ANO_CONSTRUCCION")
	private Integer anoConstruccion;
	@Column(name = "ESTADO_CONSTRUCCION")
	private String estadoConstruccion;
	@Column(name = "OCUPADO")
	private String ocupado;
	@Column(name = "NUM_VISITAS")
	private Integer numVisitas;
	@Column(name = "NUM_OFERTAS")
	private Integer numOfertas;
	@Column(name = "NUM_RESERVAS")
	private Integer numReservas;
	@Column(name = "VALOR_ESTIMADO_VENTA")
	private Double valorEstimadoVenta;
	@Column(name = "VALOR_TASACION")
	private Double valorTasacion;
	@Column(name = "FECHA_TASACION")
	private Date fechaTasacion;
	@Column(name = "VALOR_ASESORADO_LIQ")
	private Double valorLiquidativo;
	@Column(name = "VNC")
	private Double valorVnc;
	
	//No se muestran en la exel, pero se requieren
	@Column(name = "FSV_VENTA")
	private Double valorFsv;
	
	
	
	
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
	public String getNumActivoRem() {
		return numActivoRem;
	}
	public void setNumActivoRem(String numActivoRem) {
		this.numActivoRem = numActivoRem;
	}
	public String getNumActivo() {
		return numActivo;
	}
	public void setNumActivo(String numActivo) {
		this.numActivo = numActivo;
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
	public String getSituacionComercialDescripcion() {
		return situacionComercialDescripcion;
	}
	public void setSituacionComercialDescripcion(
			String situacionComercialDescripcion) {
		this.situacionComercialDescripcion = situacionComercialDescripcion;
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
	public String getEspecificacionesDireccion() {
		return especificacionesDireccion;
	}
	public void setEspecificacionesDireccion(String especificacionesDireccion) {
		this.especificacionesDireccion = especificacionesDireccion;
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
	public Date getFechaPublicacion() {
		return fechaPublicacion;
	}
	public void setFechaPublicacion(Date fechaPublicacion) {
		this.fechaPublicacion = fechaPublicacion;
	}
	public Double getSuperficieTotal() {
		return superficieTotal;
	}
	public void setSuperficieTotal(Double superficieTotal) {
		this.superficieTotal = superficieTotal;
	}
	public Double getSuperficieUtil() {
		return superficieUtil;
	}
	public void setSuperficieUtil(Double superficieUtil) {
		this.superficieUtil = superficieUtil;
	}
	public Double getSuperficieTerraza() {
		return superficieTerraza;
	}
	public void setSuperficieTerraza(Double superficieTerraza) {
		this.superficieTerraza = superficieTerraza;
	}
	public Double getSuperficieParcela() {
		return superficieParcela;
	}
	public void setSuperficieParcela(Double superficieParcela) {
		this.superficieParcela = superficieParcela;
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
	public Integer getNumReservas() {
		return numReservas;
	}
	public void setNumReservas(Integer numReservas) {
		this.numReservas = numReservas;
	}
	public Double getValorEstimadoVenta() {
		return valorEstimadoVenta;
	}
	public void setValorEstimadoVenta(Double valorEstimadoVenta) {
		this.valorEstimadoVenta = valorEstimadoVenta;
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
	public Double getValorLiquidativo() {
		return valorLiquidativo;
	}
	public void setValorLiquidativo(Double valorLiquidativo) {
		this.valorLiquidativo = valorLiquidativo;
	}
	public Double getValorVnc() {
		return valorVnc;
	}
	public void setValorVnc(Double valorVnc) {
		this.valorVnc = valorVnc;
	}
	public Double getValorFsv() {
		return valorFsv;
	}
	public void setValorFsv(Double valorFsv) {
		this.valorFsv = valorFsv;
	}

	
}
