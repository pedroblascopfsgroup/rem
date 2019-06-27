package es.pfsgroup.plugin.rem.jbpm.handler;

import org.jbpm.graph.exe.ExecutionContext;

import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.plugin.rem.model.ActivoTramite;
import es.pfsgroup.plugin.rem.model.dd.DDCartera;
import es.pfsgroup.plugin.rem.model.dd.DDSubcartera;

public class TramiteSancionOfertaNodoOcultoHandler extends ActivoBaseActionHandler{
	
	private static final long serialVersionUID = 1L;
	
	@Override
	public void run(ExecutionContext executionContext) throws Exception{
		String normal = "NO";
		ActivoTramite tramite = getActivoTramite(executionContext);
		DDCartera cartera = tramite.getActivo().getCartera();
		DDSubcartera subcartera = tramite.getActivo().getSubcartera();
		if(!Checks.esNulo(cartera) && !Checks.esNulo(subcartera)){
			if((DDCartera.CODIGO_CARTERA_THIRD_PARTY.equals(cartera.getCodigo())) && (DDSubcartera.CODIGO_YUBAI.equals(subcartera.getCodigo()))){
				normal = "SI";
			}
		}
		executionContext.setVariable("nodoOrigenTramiteSancionOFertaDecision", normal);
		executionContext.getToken().signal();
	}

}
