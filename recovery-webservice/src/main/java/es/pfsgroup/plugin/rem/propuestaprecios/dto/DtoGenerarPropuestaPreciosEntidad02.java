package es.pfsgroup.plugin.rem.propuestaprecios.dto;

public class DtoGenerarPropuestaPreciosEntidad02 extends DtoGenerarPropuestaPrecios {
	
	//Detalle vivienda
	private String subtipoActivoDescripcion;
	private String especificacionesDireccion;
	private Boolean ascensor;
	private Integer numDormitorios;	
	private String refCatastral;
	private String numFincaRegistral;
	private Double superficieTotal = (double) 0.0;
	private Integer anoConstruccion;
	private String estadoConstruccion;
	private Double superficieUtil = (double) 0.0;
	private Double superficieTerraza = (double) 0.0;
	private Double superficieParcela = (double) 0.0;
	private Integer numReservas;

	
	public String getSubtipoActivoDescripcion() {
		return subtipoActivoDescripcion;
	}

	public void setSubtipoActivoDescripcion(String subtipoActivoDescripcion) {
		this.subtipoActivoDescripcion = subtipoActivoDescripcion;
	}

	public String getEspecificacionesDireccion() {
		return especificacionesDireccion;
	}

	public void setEspecificacionesDireccion(String especificacionesDireccion) {
		this.especificacionesDireccion = especificacionesDireccion;
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

	public Integer getNumReservas() {
		return numReservas;
	}

	public void setNumReservas(Integer numReservas) {
		this.numReservas = numReservas;
	}
	
	
}
