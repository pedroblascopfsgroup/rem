package es.pfsgroup.recovery.ext.turnadodespachos;

public class EsquemaTurnadoConfigDto {

	private Long id;
	private String tipo;
	private String codigo;
	private Double importeDesde;
	private Double importeHasta;
	private Double porcentaje;
	
	public EsquemaTurnadoConfigDto() {
		importeDesde=0D;
		importeHasta=0D;
		porcentaje=0D;
	}
	
	public Long getId() {
		return id;
	}
	public void setId(Long id) {
		this.id = id;
	}
	public String getTipo() {
		return tipo;
	}
	public void setTipo(String tipo) {
		this.tipo = tipo;
	}
	public String getCodigo() {
		return codigo;
	}
	public void setCodigo(String codigo) {
		this.codigo = codigo;
	}
	public Double getImporteDesde() {
		return importeDesde;
	}
	public void setImporteDesde(Double importeDesde) {
		this.importeDesde = importeDesde;
	}
	public Double getImporteHasta() {
		return importeHasta;
	}
	public void setImporteHasta(Double importeHasta) {
		this.importeHasta = importeHasta;
	}
	public Double getPorcentaje() {
		return porcentaje;
	}
	public void setPorcentaje(Double porcentaje) {
		this.porcentaje = porcentaje;
	}
	
}
