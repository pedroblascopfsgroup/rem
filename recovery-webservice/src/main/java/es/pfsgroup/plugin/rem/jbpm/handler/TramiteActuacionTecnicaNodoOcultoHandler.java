package es.pfsgroup.plugin.rem.jbpm.handler;

import org.jbpm.graph.exe.ExecutionContext;

import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.plugin.rem.model.ActivoTramite;
import es.pfsgroup.plugin.rem.model.dd.DDCartera;
import es.pfsgroup.plugin.rem.model.dd.DDSubcartera;

public class TramiteActuacionTecnicaNodoOcultoHandler extends ActivoBaseActionHandler{
	
	private static final long serialVersionUID = 1L;
	
	@Override
	public void run(ExecutionContext executionContext) throws Exception{
		String normal = "SI";
		ActivoTramite tramite = getActivoTramite(executionContext);
		DDCartera cartera = tramite.getActivo().getCartera();
		DDSubcartera subcartera = tramite.getActivo().getSubcartera();
		if(!Checks.esNulo(cartera) && !Checks.esNulo(subcartera)){
			if((DDCartera.CODIGO_CARTERA_CERBERUS.equals(cartera.getCodigo()) 
					&& (DDSubcartera.CODIGO_JAIPUR_INMOBILIARIO.equals(subcartera.getCodigo()) 
							|| DDSubcartera.CODIGO_AGORA_INMOBILIARIO.equals(subcartera.getCodigo())
							|| DDSubcartera.CODIGO_EGEO.equals(subcartera.getCodigo())))
			   || (DDCartera.CODIGO_CARTERA_EGEO.equals(cartera.getCodigo())
					   && (DDSubcartera.CODIGO_ZEUS.equals(subcartera.getCodigo())
							   || DDSubcartera.CODIGO_PROMONTORIA.equals(subcartera.getCodigo())))){
				normal = "NO";
			}
		}
		executionContext.setVariable("nodoOrigenTramiteActuacionTecnicaDecision", normal);
		executionContext.getToken().signal();
	}

}
