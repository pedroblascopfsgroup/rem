package es.pfsgroup.plugin.rem.propuestaprecios.dto;

import java.util.Date;

/**
 * Dto para los datos recogidos de una propuesta UNIFICADA
 *
 */
public class DtoGenerarPropuestaPreciosUnificada extends DtoGenerarPropuestaPrecios  {

	private Long id;
	private Long idPropuesta;
	private String codCartera;
	private String codSubCartera;
	private String sociedadPropietaria;
	//Activo - Identificación
	private String origen;
	private Date fechaEntrada;
	private String numActivo; //Num activo
	private String numActivoRem; //Num activo REM
	private String refCatastral;
	private String numFincaRegistral;
	//Activo - Agrupación
	private String numAgrupacionObraNueva;
	private String numAgrupacionRestringida;
	//Activo - Tipología
	private String tipoActivoCodigo;
	private String tipoActivoDescripcion;
	private String subtipoActivoDescripcion;
	//Activo - Dirección
	private String direccion;
	private String municipio;
	private String provincia;
	private String codigoPostal;
	//Estado Dptos. - Información Comercial
	private Boolean ascensor;
	private Integer numDormitorios;
	private Double superficieTotal = (double) 0.0;
	private Integer anoConstruccion;
	private String estadoConstruccion;
	//Estado Dptos. - Comercial
	private String situacionComercialDescripcion;
	private Integer numVisitas;
	private Integer numOfertas;
	//Estado Dptos. - Admisión
	private Date fechaInscripcion;
	private Date fechaRevisionCargas;
	private Date fechaTomaPosesion;
	//Estado Dptos. - Gestión
	private String ocupado;
	//Estado Dptos. - Publicacion
	private Date fechaPublicacion;
	//Valores - Estimado venta
	private Double valorEstimadoVenta = (double) 0.0;
	private Date fechaEstimadoVenta;
	//Valores - Estimado venta
	private Double valorTasacion = (double) 0.0;
	private Date fechaTasacion;
	//Valores - FSV
	private Double valorFsv = (double) 0.0;
	private Date fechaFsv;
	//Valores - Mayor Valoración
	private Double mayorValoracion = (double) 0.0;
	//Precios Actuales
	private Double valorVentaWeb = (double) 0.0;
	private Date fechaVentaWeb;
	private Double valorRentaWeb = (double) 0.0;
	private Double valorVnc = (double) 0.0;
	private Double valorAdquisicion = (double) 0.0;
	private Date fechaValorAdquisicion;
	private Double valorLiquidativo = (double) 0.0;
	private Date fechaValorLiquidativo;
	
	//PRECIOS PROPUESTOS (Valores calculados)
	private Double valorPropuesto = (double) 0.0;
	private Double diferenciaConValorTasacion = (double) 0.0;
	private Double porcSobreTasacion = (double) 0.0;
	private Double porcSobreFsv = (double) 0.0;
	private Double porcSobreVentaWeb = (double) 0.0;
	//private Double diferenciaVnc;
	private Double procSobreVnc = (double) 0.0;
	
	
	
	
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
	public Double getValorPropuesto() {
		return valorPropuesto;
	}
	public void setValorPropuesto(Double valorPropuesto) {
		this.valorPropuesto = valorPropuesto;
	}
	public Double getDiferenciaConValorTasacion() {
		return diferenciaConValorTasacion;
	}
	public void setDiferenciaConValorTasacion(Double diferenciaConValorTasacion) {
		this.diferenciaConValorTasacion = diferenciaConValorTasacion;
	}
	public Double getPorcSobreTasacion() {
		return porcSobreTasacion;
	}
	public void setPorcSobreTasacion(Double porcSobreTasacion) {
		this.porcSobreTasacion = porcSobreTasacion;
	}
	public Double getPorcSobreFsv() {
		return porcSobreFsv;
	}
	public void setPorcSobreFsv(Double porcSobreFsv) {
		this.porcSobreFsv = porcSobreFsv;
	}
	public Double getPorcSobreVentaWeb() {
		return porcSobreVentaWeb;
	}
	public void setPorcSobreVentaWeb(Double porcSobreVentaWeb) {
		this.porcSobreVentaWeb = porcSobreVentaWeb;
	}
	public Double getProcSobreVnc() {
		return procSobreVnc;
	}
	public void setProcSobreVnc(Double procSobreVnc) {
		this.procSobreVnc = procSobreVnc;
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
