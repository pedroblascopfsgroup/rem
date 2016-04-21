package es.pfsgroup.procedimientos.subastaElectronica;

import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;

import es.capgemini.devon.beans.Service;
import es.capgemini.pfs.asunto.ProcedimientoManager;
import es.capgemini.pfs.asunto.model.Procedimiento;
import es.capgemini.pfs.procesosJudiciales.model.TareaExterna;
import es.capgemini.pfs.procesosJudiciales.model.TareaExternaValor;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.recovery.ext.impl.tareas.EXTTareaExternaValor;

/**
 *
 */
@Service("tramitesElectronicosManager")
public class TramitesElectronicosManager implements TramitesElectronicosApi {

		
	@Autowired
	ProcedimientoManager procedimientoManager;

	
	@SuppressWarnings("unchecked")
	@Override
	public Boolean[] bpmGetValoresRamasRevisarDocumentacion(Procedimiento prc, TareaExterna tex, List<EXTTareaExternaValor> listado){
		Boolean[] resultado = {false, false, false, true};
		
		List<TareaExternaValor> listadoValores = new ArrayList<TareaExternaValor>();

		String notaSimple = "";
		String tasacion = "";
		String fiscal = "";	
		
		// Obtenemos la lista de valores de esa tarea
		listadoValores = tex.getValores();
		if(Checks.esNulo(listadoValores)){
			listadoValores =  (List<TareaExternaValor>)(List<?>) listado;
		}
		for (TareaExternaValor val : listadoValores) {
			if ("comboNotaSimple".equals(val.getNombre())){
				notaSimple =  val.getValor();
			}
			if ("comboTasacion".equals(val.getNombre())){
				tasacion =  val.getValor();
			}
			if ("comboFiscal".equals(val.getNombre())){
				fiscal =  val.getValor();
			}
		}	
			
		if("01".equals(notaSimple)){
			resultado[0] = true;
		}
		if("01".equals(tasacion)){
			resultado[1] = true;
		}
		if("01".equals(fiscal)){
			resultado[2] = true;
		}
		
		return resultado;
	}

}
