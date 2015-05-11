package es.pfsgroup.recovery.recobroCommon.cartera.manager;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.capgemini.pfs.arquetipo.factory.ReglasFactory;
import es.capgemini.pfs.ruleengine.rule.definition.RuleDefinition;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.recovery.recobroCommon.cartera.model.RecobroCartera;
import es.pfsgroup.recovery.recobroCommon.esquema.manager.api.RecobroEsquemaApi;
import es.pfsgroup.recovery.recobroCommon.esquema.model.RecobroCarteraEsquema;
import es.pfsgroup.recovery.recobroCommon.esquema.model.RecobroEsquema;

@Component
public class ReglasFactoryCartera implements ReglasFactory {
	
	@Autowired
	private ApiProxyFactory proxyFactory;
	
	@Override
	public Boolean isReglaEditable(Long idRegla) {			
		List<RecobroEsquema> esquemasLiberados = proxyFactory.proxy(RecobroEsquemaApi.class).getEsquemasBloqueados();
		for (RecobroEsquema esquemaLiberado : esquemasLiberados) {
			//Obtengo las carteras que contienen los esquemas
			 List<RecobroCarteraEsquema> carterasEsquema = esquemaLiberado.getCarterasEsquema();
			 for (RecobroCarteraEsquema recobroCarteraEsquema : carterasEsquema) {
				RecobroCartera cartera = recobroCarteraEsquema.getCartera();
				if (!Checks.esNulo(cartera)) {
					//Obtengo las reglas que tienen las carteras
					if (!Checks.esNulo(cartera.getRegla())) {
						if (idRegla.equals(cartera.getRegla().getId())) {
							//Si la regla existe en un esquema bloqueado, no es editable
							return false;
						}
					}
				}
				
			}
		}		
		
		return true;
	}

}
