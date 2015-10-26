package es.pfsgroup.plugin.recovery.expediente.listadoPreProyectado.web;

import java.util.ArrayList;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;

import es.capgemini.pfs.acuerdo.model.DDTipoAcuerdo;
import es.capgemini.pfs.itinerario.model.DDEstadoItinerario;
import es.capgemini.pfs.persona.model.DDTipoPersona;
import es.capgemini.pfs.termino.model.DDEstadoGestionTermino;
import es.capgemini.pfs.vencidos.model.DDTramosDiasVencidos;
import es.capgemini.pfs.zona.model.DDZona;
import es.capgemini.pfs.zona.model.Nivel;
import es.pfsgroup.plugin.recovery.coreextension.utils.api.UtilDiccionarioApi;
import es.pfsgroup.plugin.recovery.expediente.listadoPreProyectado.dto.ListadoPreProyectadoDTO;

@Controller
public class ListadoPreProyectadoController {

	static final String LISTADO_PREPROYECTADO = "plugin/expediente/listadoPreProyectado/listadoPreProyectado";
	
	@Autowired
	UtilDiccionarioApi utilDiccionario;
	
	@SuppressWarnings("unchecked")
	@RequestMapping
	public String abrirListado(ModelMap model) {

		//Diccionarios pestanya Datos Generales
		ArrayList<DDEstadoGestionTermino> ddEstadoGestionTermino =  (ArrayList<DDEstadoGestionTermino>) utilDiccionario.dameValoresDiccionario(DDEstadoGestionTermino.class); 
		model.put("estadosGestion", ddEstadoGestionTermino);
		
		ArrayList<DDTipoPersona> ddTipoPersona = (ArrayList<DDTipoPersona>) utilDiccionario.dameValoresDiccionario(DDTipoPersona.class);
		model.put("tipoPersonas", ddTipoPersona);
		
		ArrayList<DDTramosDiasVencidos> ddTramosDiasVencidos = (ArrayList<DDTramosDiasVencidos>) utilDiccionario.dameValoresDiccionario(DDTramosDiasVencidos.class);
		model.put("tramo", ddTramosDiasVencidos);
		
		ArrayList<DDTipoAcuerdo> ddTipoAcuerdo = (ArrayList<DDTipoAcuerdo>) utilDiccionario.dameValoresDiccionario(DDTipoAcuerdo.class);
		model.put("propuesta", ddTipoAcuerdo);
		
		//Diccionarios pestanya Expediente y contrato
		ArrayList<Nivel> nivel = (ArrayList<Nivel>) utilDiccionario.dameValoresDiccionario(Nivel.class);
		model.put("niveles", nivel);
		
		ArrayList<DDZona> ddZona = (ArrayList<DDZona>) utilDiccionario.dameValoresDiccionario(DDZona.class);
		model.put("centro", ddZona);
		
		ArrayList<DDEstadoItinerario> ddEstadoItinerario = (ArrayList<DDEstadoItinerario>) utilDiccionario.dameValoresDiccionario(DDEstadoItinerario.class);
		model.put("fase", ddEstadoItinerario);
		
		return LISTADO_PREPROYECTADO;
	}

}
