package es.capgemini.pfs.asunto;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;

import es.capgemini.devon.bo.Executor;
import es.capgemini.pfs.configuracion.ConfiguracionBusinessOperation;
import es.capgemini.pfs.multigestor.model.EXTGestorAdicionalAsunto;
import es.capgemini.pfs.parametrizacion.model.Parametrizacion;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.recovery.ext.api.asunto.EXTAsuntoApi;
import es.pfsgroup.recovery.ext.impl.asunto.dto.EXTDtoBusquedaAsunto;

@Controller
public class EXTAsuntoController {
	
	private static final String GESTORES_ADICIONALES_ASUNTO_JSON = "plugin/coreextension/multigestor/multiGestorAdicionalAsuntoDataJSON";

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
	

	
	@SuppressWarnings("unchecked")
	@RequestMapping
    public String getMsgErrorEnvioCDDCabecera(Long idAsunto, ModelMap model) {		
    	
		String mensaje = proxyFactory.proxy(EXTAsuntoApi.class).getMsgErrorEnvioCDDCabecera(idAsunto);
		
		model.put("okko", mensaje);
		
        return "plugin/coreextension/OkRespuestaJSON";
    }
	
	@SuppressWarnings("unchecked")
	@RequestMapping
	public String getGestoresAdicionalesAsunto(Long idAsunto, ModelMap model) {
		List<EXTGestorAdicionalAsunto> listadoGestoresAdicionalesAsunto = proxyFactory.proxy(EXTAsuntoApi.class).getGestoresAdicionalesAsunto(idAsunto);
		model.put("listaGestoresAdicionales", listadoGestoresAdicionalesAsunto);
		
		return GESTORES_ADICIONALES_ASUNTO_JSON;
	}

}
