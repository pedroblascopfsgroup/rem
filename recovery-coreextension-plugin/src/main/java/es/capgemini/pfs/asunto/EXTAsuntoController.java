package es.capgemini.pfs.asunto;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;

import es.capgemini.devon.bo.Executor;
import es.capgemini.pfs.configuracion.ConfiguracionBusinessOperation;
import es.capgemini.pfs.parametrizacion.model.Parametrizacion;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.recovery.ext.api.asunto.EXTAsuntoApi;
import es.pfsgroup.recovery.ext.impl.asunto.dto.EXTDtoBusquedaAsunto;

@Controller
public class EXTAsuntoController {

	@Autowired
	private ApiProxyFactory proxyFactory;
	
	@Autowired
    private Executor executor;	
	
	@SuppressWarnings("unchecked")
	@RequestMapping
    public String exportacionAsuntosCount(EXTDtoBusquedaAsunto dto, String params, ModelMap model) {		
    	
		Parametrizacion param = (Parametrizacion) executor.execute(ConfiguracionBusinessOperation.BO_PARAMETRIZACION_MGR_BUSCAR_PARAMETRO_POR_NOMBRE,
                Parametrizacion.LIMITE_EXPORT_EXCEL_BUSCADOR_ASUNTOS);
		
		model.put("count", proxyFactory.proxy(EXTAsuntoApi.class).findAsuntosPaginatedDinamicoCount(dto, params));
		model.put("limit", Integer.parseInt(param.getValor()));
		
        return "plugin/coreextension/exportacionGenericoCountJSON";
    }

}
