package es.pfsgroup.plugin.proyectoBankiaOnline.procedimiento.api;

import es.capgemini.pfs.asunto.dto.ProcedimientoDto;

public interface BankiaProcedimientoApi {
	
	public static final String BO_BANKIA_PROCEDIMIENTO_NOLITIGAR = "plugin.proyectoBankiaOnline.noLitigar";

	public void noLitigar(ProcedimientoDto dto);

}