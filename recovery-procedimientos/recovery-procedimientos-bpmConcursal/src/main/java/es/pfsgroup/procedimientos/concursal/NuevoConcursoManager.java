package es.pfsgroup.procedimientos.concursal;

import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.capgemini.devon.bo.Executor;
import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.pfs.asunto.model.Asunto;
import es.capgemini.pfs.asunto.model.Procedimiento;
import es.capgemini.pfs.externa.ExternaBusinessOperation;

@Component
public class NuevoConcursoManager {
	
	@Autowired
	private Executor executor;

	
	@BusinessOperation(overrides = "concursoManager.dameNumDeProcsFaseComun")
	public int dameNumDeProcsFaseComun(Long idAsunto) {
		Asunto asu = (Asunto) executor.execute(
				ExternaBusinessOperation.BO_ASU_MGR_GET, idAsunto);
		List<Procedimiento> faseConvenio = procedimientosFaseComun(asu); /*
																		 * O
																		 * ANTICIAPADA
																		 */
		return faseConvenio.size();
	}
	
	/**
	 * Este m�todo nos devuelve los procedimientos del asunto que son del tipo
	 * Fase Comun O CONVENIO ANTICIPADO
	 * 
	 * @param asunto
	 * @return
	 */
	private List<Procedimiento> procedimientosFaseComun(Asunto asunto) {
		List<Procedimiento> listaProcedimientosFaseComunAsunto = new ArrayList<Procedimiento>();
		List<Procedimiento> listaDeTodosLosProcedimientosAsunto = asunto
				.getProcedimientos();
		if (listaDeTodosLosProcedimientosAsunto != null) {
			for (Procedimiento p : listaDeTodosLosProcedimientosAsunto) {
				if (p.getTipoProcedimiento().getTipoActuacion().getCodigo()
						.equals("CO"))
					// if
					// ((p.getTipoProcedimiento().getCodigo().equals("P56"))||(p.getTipoProcedimiento().getCodigo().equals("P24"))||(p.getTipoProcedimiento().getCodigo().equals("P30")))
					listaProcedimientosFaseComunAsunto.add(p);
			}
		}
		return listaProcedimientosFaseComunAsunto;
	}
}
