package es.pfsgroup.plugin.recovery.coreextension.informes.cierreDeuda;
 
public class BienLoteDto {
	private Long idBien;
	private String bien;
	private Long lote;
	

	public BienLoteDto(Long idBien, String bien, Long lote) {
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
	public Long getLote() {
		return lote;
	}
	public void setLote(Long lote) {
		this.lote = lote;
	}
}