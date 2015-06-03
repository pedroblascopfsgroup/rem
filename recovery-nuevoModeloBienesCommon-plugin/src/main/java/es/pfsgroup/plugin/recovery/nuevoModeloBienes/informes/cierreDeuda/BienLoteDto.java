package es.pfsgroup.plugin.recovery.nuevoModeloBienes.informes.cierreDeuda;

public class BienLoteDto {
	private Long idBien;
	private String bien;
	private Integer lote;

	public BienLoteDto(Long idBien, String bien, Integer lote) {
		this.idBien = idBien;
		this.bien = bien;
		this.lote = lote;
	}

	public Long getIdBien() {
		return idBien;
	}

	public void setIdBien(Long idBien) {
		this.idBien = idBien;
	}

	public String getBien() {
		return bien;
	}

	public void setBien(String bien) {
		this.bien = bien;
	}

	public Integer getLote() {
		return lote;
	}

	public void setLote(Integer lote) {
		this.lote = lote;
	}
}