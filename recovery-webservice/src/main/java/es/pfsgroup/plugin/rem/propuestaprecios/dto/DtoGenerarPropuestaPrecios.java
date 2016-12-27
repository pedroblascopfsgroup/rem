package es.pfsgroup.plugin.rem.propuestaprecios.dto;

import java.util.Date;

/**
 * Dto para los datos a rellenar en la generación de propuesta de precios.
 * 
 * Contiene los datos comunes entre todas las entidades
 * @author jros
 *
 */
public class DtoGenerarPropuestaPrecios {
	
	//Activo - Datos generales
	private Long id;
	private Long idPropuesta;
	private String codCartera;
	private String codSubCartera;
	private String sociedadPropietaria;
	private String numActivo; //Num activo 
	private String numActivoRem; //Num activo REM
	
	//Activo - Agrupación
	private String numAgrupacionRestringida;
	private String numAgrupacionObraNueva;
	
	//Activo - Dirección
	private String direccion;
	private String municipio;
	private String provincia;
	
	//Activo - Tipología
	private String tipoActivoCodigo;
	private String tipoActivoDescripcion;
	
	//Valores - Tasacion
	private Double valorTasacion = (double) 0.0;
	private Date fechaTasacion;
	
	//Valores - Estimado venta / Colaborador
	private Double valorEstimadoVenta = (double) 0.0;
	private Date fechaEstimadoVenta;
	
	//Valores - FSV
	private Double valorFsv = (double) 0.0;
	private Date fechaFsv;

	private Double valorVnc = (double) 0.0; //VNC Valor Necto Contable
	
	//Valores Asesoramiento JLL
	private Double valorLiquidativo = (double) 0.0;
	
	//PRECIOS PROPUESTOS (Valores calculados)
	private Double valorPropuesto = (double) 0.0;
	private Double diferenciaVnc; // VNC - DF
	
	//Publicacion
	private Date fechaPublicacion;
	
	//Estado Dptos. - Admisión
	private Date fechaInscripcion;
	private Date fechaRevisionCargas;
	private Date fechaTomaPosesion;
	
	//Estado Dptos. - Comercial
	private String situacionComercialDescripcion;
	private Integer numVisitas;
	private Integer numOfertas;
	
	//Estado Dptos. - Gestión
	private String ocupado;
	
	private String nombreAgrupacionObraNueva;
	private String origen;

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
	
	public String getNumAgrupacionRestringida() {
		return numAgrupacionRestringida;
	}

	public void setNumAgrupacionRestringida(String numAgrupacionRestringida) {
		this.numAgrupacionRestringida = numAgrupacionRestringida;
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

	public Double getValorVnc() {
		return valorVnc;
	}

	public void setValorVnc(Double valorVnc) {
		this.valorVnc = valorVnc;
	}

	public Double getValorPropuesto() {
		return valorPropuesto;
	}

	public void setValorPropuesto(Double valorPropuesto) {
		this.valorPropuesto = valorPropuesto;
	}

	public Date getFechaPublicacion() {
		return fechaPublicacion;
	}

	public void setFechaPublicacion(Date fechaPublicacion) {
		this.fechaPublicacion = fechaPublicacion;
	}
	
	public Double getDiferenciaVnc() {
		return diferenciaVnc;
	}

	public void setDiferenciaVnc(Double diferenciaVnc) {
		this.diferenciaVnc = diferenciaVnc;
	}

	public Double getValorLiquidativo() {
		return valorLiquidativo;
	}

	public void setValorLiquidativo(Double valorLiquidativo) {
		this.valorLiquidativo = valorLiquidativo;
	}

	public String getNumAgrupacionObraNueva() {
		return numAgrupacionObraNueva;
	}

	public void setNumAgrupacionObraNueva(String numAgrupacionObraNueva) {
		this.numAgrupacionObraNueva = numAgrupacionObraNueva;
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

	public String getOcupado() {
		return ocupado;
	}

	public void setOcupado(String ocupado) {
		this.ocupado = ocupado;
	}
	
	public String getNombreAgrupacionObraNueva() {
		return nombreAgrupacionObraNueva;
	}

	public void setNombreAgrupacionObraNueva(String nombreAgrupacionObraNueva) {
		this.nombreAgrupacionObraNueva = nombreAgrupacionObraNueva;
	}
	
	public String getOrigen() {
		return origen;
	}

	public void setOrigen(String origen) {
		this.origen = origen;
	}


}
