package es.capgemini.pfs.iplus;

import es.capgemini.pfs.asunto.model.Procedimiento;
import es.pfsgroup.recovery.ext.impl.tipoFicheroAdjunto.DDTipoFicheroAdjunto;

public interface IPLUSAdjuntoAuxDto {

	public Procedimiento getProc();
	public void setProc(Procedimiento proc);
	
	public String getContentType();
	public void setContentType(String contentType); 
	
	public Long getLongitud();
	public void setLongitud(Long longitud); 
	
	public DDTipoFicheroAdjunto getTipoDocumento();
	public void setTipoDocumento(DDTipoFicheroAdjunto tipoFicheroAdjunto);
	
}
