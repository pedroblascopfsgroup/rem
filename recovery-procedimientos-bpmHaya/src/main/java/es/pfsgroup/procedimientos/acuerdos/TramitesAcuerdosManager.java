package es.pfsgroup.procedimientos.acuerdos;

import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;

import es.capgemini.devon.beans.Service;
import es.capgemini.pfs.asunto.ProcedimientoManager;
import es.capgemini.pfs.asunto.model.Procedimiento;
import es.capgemini.pfs.procesosJudiciales.model.TareaExterna;
import es.capgemini.pfs.procesosJudiciales.model.TareaExternaValor;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.plugin.recovery.coreextension.utils.api.UtilDiccionarioApi;

/**
 *
 */
@Service("tramitesAcuerdosManager")
public class TramitesAcuerdosManager implements TramitesAcuerdosApi {

	
	@Autowired
	private GenericABMDao genericDao;	

	@Autowired
	private UtilDiccionarioApi diccionarioApi;
	
	@Autowired
	ProcedimientoManager procedimientoManager;

	
	@Override
	public Boolean[] bpmGetValoresRamasDefinirDocumentacion(Procedimiento prc, TareaExterna tex){
		Boolean[] resultado = {false, false, false};
		
		List<TareaExternaValor> listadoValores = new ArrayList<TareaExternaValor>();

		String juridica = "";
		String tecnica = "";
		String validacionCN = "";	
		
		// Obtenemos la lista de valores de esa tarea
		listadoValores = tex.getValores();
		for (TareaExternaValor val : listadoValores) {
			if ("comboJuridica".equals(val.getNombre())){
				juridica =  val.getValor();
			}
			if ("comboTecnica".equals(val.getNombre())){
				tecnica =  val.getValor();
			}
			if ("comboValidacionCN".equals(val.getNombre())){
				validacionCN =  val.getValor();
			}
		}	
			
		if("01".equals(juridica)){
			resultado[0] = true;
		}
		if("01".equals(validacionCN)){
			resultado[1] = true;
		}
		if("01".equals(tecnica)){
			resultado[2] = true;
		}
		
		return resultado;
	}

}
