package es.capgemini.pfs.iplus;

import java.util.Set;

import es.capgemini.pfs.asunto.model.AdjuntoAsunto;
import es.capgemini.pfs.asunto.model.Asunto;
import es.capgemini.pfs.asunto.model.Procedimiento;
import es.pfsgroup.recovery.ext.impl.asunto.model.EXTAdjuntoAsunto;

public interface IPLUSUtils {

	public boolean instalado();

	public void almacenar(Asunto asunto, EXTAdjuntoAsunto adjuntoAsunto);
	
	public Set<AdjuntoAsunto> listarAdjuntosIplus(String idProcedi);
	
	public String obtenerIdAsuntoExterno(Long id);
	
	public Procedimiento obtenerProcedimiento(Long asuId, String nombre); 
	
}
