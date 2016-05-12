package es.pfsgroup.plugin.recovery.mejoras.decisionProcedimiento.nuevoController;

import java.util.ArrayList;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;

import es.capgemini.pfs.actitudAptitudActuacion.model.DDMotivoNoLitigar;
import es.pfsgroup.plugin.recovery.coreextension.utils.api.UtilDiccionarioApi;

@Controller
public class MEJActuacionController {

	private static final String JSON_MOTIVOS = "expedientes/motivosJSON";

	protected final Log logger = LogFactory.getLog(getClass());

	@Autowired
	private UtilDiccionarioApi diccionarioApi;


	@SuppressWarnings("unchecked")
	@RequestMapping
	public String getDiccionarioMotivos(ModelMap model) {
		
		ArrayList<DDMotivoNoLitigar> motivos =  (ArrayList<DDMotivoNoLitigar>) diccionarioApi.dameValoresDiccionario(DDMotivoNoLitigar.class);
		model.put("motivos", motivos);
		
		return JSON_MOTIVOS;
	}
	
}