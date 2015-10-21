package es.capgemini.pfs.termino.dto;

import es.capgemini.devon.dto.WebDto;
import es.capgemini.pfs.acuerdo.model.DDTipoAcuerdo;
import es.capgemini.pfs.auditoria.model.Auditoria;

public class CamposTerminoTipoAcuerdoDto extends WebDto{
	

	private static final long serialVersionUID = -3746399692512887715L;


    private Long id;
	private DDTipoAcuerdo tipoAcuerdo;	
    private String nombreCampo;
    private Integer version;
    private Auditoria auditoria;
    
    
	public Long getId() {
		return id;
	}
	public void setId(Long id) {
		this.id = id;
	}
	
	public DDTipoAcuerdo getTipoAcuerdo() {
		return tipoAcuerdo;
	}
	public void setTipoAcuerdo(DDTipoAcuerdo tipoAcuerdo) {
		this.tipoAcuerdo = tipoAcuerdo;
	}
	
	public String getNombreCampo() {
		return nombreCampo;
	}
	public void setNombreCampo(String nombreCampo) {
		this.nombreCampo = nombreCampo;
	}
	
	public Integer getVersion() {
		return version;
	}
	public void setVersion(Integer version) {
		this.version = version;
	}
	
	public Auditoria getAuditoria() {
		return auditoria;
	}
	public void setAuditoria(Auditoria auditoria) {
		this.auditoria = auditoria;
	}
}
