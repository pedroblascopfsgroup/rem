package es.pfsgroup.plugin.recovery.liquidaciones.controller.impl;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;

import es.capgemini.devon.bo.Executor;
import es.capgemini.pfs.asunto.dao.ProcedimientoDao;
import es.capgemini.pfs.asunto.model.Asunto;
import es.capgemini.pfs.asunto.model.Procedimiento;
import es.capgemini.pfs.diccionarios.Dictionary;
import es.capgemini.pfs.diccionarios.DictionaryManager;
import es.capgemini.pfs.externa.ExternaBusinessOperation;
import es.pfsgroup.commons.utils.Assertions;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.plugin.recovery.liquidaciones.LIQCobroPagoEntregasManager;
import es.pfsgroup.plugin.recovery.liquidaciones.dao.LIQCobroPagoDao;
import es.pfsgroup.plugin.recovery.liquidaciones.dto.LIQDtoCobroPago;
import es.pfsgroup.plugin.recovery.liquidaciones.dto.LIQDtoCobroPagoEntregas;
import es.pfsgroup.plugin.recovery.liquidaciones.model.DDOrigenCobro;
import es.pfsgroup.plugin.recovery.liquidaciones.model.LIQCobroPago;
import es.pfsgroup.recovery.hrebcc.model.DDAdjContableConceptoEntrega;
import es.pfsgroup.recovery.hrebcc.model.DDAdjContableTipoEntrega;

@Controller
public class EntregasController{
	
	
	
	static final String LISTADO_COBRO_PAGO_JSON= "plugin/liquidaciones/listadoEntregasJSON";
	static final String NUEVA_ENTREGA= "plugin/liquidaciones/override/entregas";
	private static final String DEFAULT= "default";

	
	@Autowired
	private LIQCobroPagoEntregasManager liqCobroPagoEntregasManager;
	
	@Autowired
	LIQCobroPagoDao cobroPagoDao;
	
	@Autowired
    private ProcedimientoDao procedimientoDao;
	
    @Autowired
    private DictionaryManager dictionaryManager;
		
	/**
	 * {@inheritDoc} 
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping
	public String saveEntrega(ModelMap model,LIQDtoCobroPagoEntregas dto) {
		
		
		liqCobroPagoEntregasManager.createOrUpdate(dto);
		return DEFAULT;
		
		// TODO Auto-generated method stub
		
	}

	@SuppressWarnings("unchecked")
	@RequestMapping
	public String deleteEntregas(Long id) {
		return DEFAULT;
		// TODO Auto-generated method stub
		
	}

	@SuppressWarnings("unchecked")
	@RequestMapping
	public String getListbyAsuntoId(Long id, ModelMap model) {
		// TODO Auto-generated method stub
		List<LIQCobroPago> lista = cobroPagoDao.getByIdAsunto(id); 
		model.put("listado", lista);
        
		return LISTADO_COBRO_PAGO_JSON; 
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping
	public String nuevaEntrega(Long idAsunto, ModelMap model) {
		// TODO Auto-generated method stub

		List<Procedimiento>procedimientos= procedimientoDao.getProcedimientosAsunto(idAsunto);
		List<Dictionary> tipoEntrega= (List<Dictionary>)dictionaryManager.getList("DDAdjContableTipoEntrega");
		List<Dictionary> conceptoEntrega= (List<Dictionary>)dictionaryManager.getList("DDAdjContableConceptoEntrega");
		

		
		model.put("tipoEntrega", tipoEntrega);
		model.put("conceptoEntrega", conceptoEntrega);
		model.put("procedimientos", procedimientos);
		model.put("idAsunto", idAsunto);
        
		return NUEVA_ENTREGA; 
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping
	public String editarEntrega(Long idAsunto, ModelMap model, Long id) {
		// TODO Auto-generated method stub
		
		
		
		List<Procedimiento>procedimientos= procedimientoDao.getProcedimientosAsunto(idAsunto);
		List<Dictionary> tipoEntrega= (List<Dictionary>)dictionaryManager.getList("DDAdjContableTipoEntrega");
		List<Dictionary> conceptoEntrega= (List<Dictionary>)dictionaryManager.getList("DDAdjContableConceptoEntrega");
		
		List<LIQCobroPago> lista = cobroPagoDao.getByIdAsunto(idAsunto); 
		LIQCobroPago LIQCP= null;
		
		for(LIQCobroPago lc: lista){
			if(lc.getId().equals(id)){
				LIQCP= lc;
			}
		}
		
		
		model.put("tipo", LIQCP.getTipoCobroPago());
		model.put("liqCobroPago.fecha", LIQCP.getFecha());
		model.put("liqCobroPago.fechaValor", LIQCP.getFechaValor());
		
		
		model.put("tipoEntrega", tipoEntrega);
		model.put("conceptoEntrega", conceptoEntrega);
		model.put("procedimientos", procedimientos);
		model.put("idAsunto", idAsunto);
        model.put("liqCobroPago", LIQCP);
		
		return NUEVA_ENTREGA; 
	}
	
	
	
	
	
	
	

}
