package es.pfsgroup.plugin.recovery.arquetipos.modelosArquetipos.dto;

public class ARQDtoInsertarArquetiposModelo {
	
	private Long idModelo;
	private String arquetipos;
	
	public void setIdModelo(Long idModelo) {
		this.idModelo = idModelo;
	}
	public Long getIdModelo() {
		return idModelo;
	}
	public void setArquetipos(String arquetipos) {
		this.arquetipos = arquetipos;
	}
	public String getArquetipos() {
		return arquetipos;
	}

}
