package es.pfsgroup.plugin.recovery.iplus;

import es.capgemini.pfs.asunto.model.Procedimiento;
import es.capgemini.pfs.iplus.IPLUSAdjuntoAuxDto;
import es.pfsgroup.recovery.ext.impl.tipoFicheroAdjunto.DDTipoFicheroAdjunto;

public class IPLUSAdjuntoAuxDtoImpl implements IPLUSAdjuntoAuxDto {

	private Procedimiento proc = null;
	private String contentType = "";
	private Long longitud = null;
	private DDTipoFicheroAdjunto tipoDocumento = null;
	
	public Procedimiento getProc() {
		return proc;
	}
	public void setProc(Procedimiento proc) {
		this.proc = proc;
	}
	public String getContentType() {
		return contentType;
	}
	public void setContentType(String contentType) {
		this.contentType = contentType;
	}
	public Long getLongitud() {
		return longitud;
	}
	public void setLongitud(Long longitud) {
		this.longitud = longitud;
	}
	public DDTipoFicheroAdjunto getTipoDocumento() {
		return tipoDocumento;
	}
	public void setTipoDocumento(DDTipoFicheroAdjunto tipoDocumento) {
		this.tipoDocumento = tipoDocumento;
	}
	

}
