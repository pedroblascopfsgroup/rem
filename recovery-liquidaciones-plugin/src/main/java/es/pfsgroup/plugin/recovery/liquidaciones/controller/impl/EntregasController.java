package es.pfsgroup.plugin.recovery.liquidaciones.controller.impl;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;

import es.capgemini.pfs.asunto.dao.ProcedimientoDao;
import es.capgemini.pfs.asunto.model.Procedimiento;
import es.capgemini.pfs.diccionarios.Dictionary;
import es.capgemini.pfs.diccionarios.DictionaryManager;
import es.pfsgroup.plugin.liquidaciones.avanzado.manager.LiquidacionAvanzadoApi;
import es.pfsgroup.plugin.liquidaciones.avanzado.manager.impl.LiquidacionAvanzadoManagerImpl;
import es.pfsgroup.plugin.liquidaciones.avanzado.model.CalculoLiquidacion;
import es.pfsgroup.plugin.liquidaciones.avanzado.model.EntregaCalculoLiq;
import es.pfsgroup.plugin.recovery.liquidaciones.LIQCobroPagoEntregasManager;
import es.pfsgroup.plugin.recovery.liquidaciones.dao.LIQCobroPagoDao;
import es.pfsgroup.plugin.recovery.liquidaciones.dto.LIQDtoCobroPagoEntregas;
import es.pfsgroup.plugin.recovery.liquidaciones.model.LIQCobroPago;

@Controller
public class EntregasController{
	
	
	
	static final String LISTADO_COBRO_PAGO_JSON= "plugin/liquidaciones/listadoEntregasJSON";
	static final String NUEVA_ENTREGA= "plugin/liquidaciones/avanzado/entregas";
	private static final String DEFAULT= "default";

	
	@Autowired
	private LIQCobroPagoEntregasManager liqCobroPagoEntregasManager;
	
	
	@Autowired
	LiquidacionAvanzadoApi liqAvanzadasApi;

	
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
		
		liqAvanzadasApi.createOrUpdateEntCalLiquidacion(dto);
		//liqCobroPagoEntregasManager.createOrUpdate(dto);
		return DEFAULT;
		
		// TODO Auto-generated method stub
		
	}

	@SuppressWarnings("unchecked")
	@RequestMapping
	public String eliminarEntrega(Long idEntrega) {
		
		liqAvanzadasApi.eliminarEntregaCalLiquidacion(idEntrega);
		
		return DEFAULT;
		// TODO Auto-generated method stub
		
	}

	@SuppressWarnings("unchecked")
	@RequestMapping
	public String getListbyCalculoId(Long id, ModelMap model) {
		// TODO Auto-generated method stub
		List<EntregaCalculoLiq> lista =  liqAvanzadasApi.getEntregasCalculo(id);
		model.put("listado", lista);
        
		return LISTADO_COBRO_PAGO_JSON; 
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping
	public String nuevaEntrega(Long idCalculo, ModelMap model) {
		// TODO Auto-generated method stub

//		List<Procedimiento>procedimientos= procedimientoDao.getProcedimientosAsunto(idAsunto);
		List<Dictionary> tipoEntrega= (List<Dictionary>)dictionaryManager.getList("DDAdjContableTipoEntrega");
		List<Dictionary> conceptoEntrega= (List<Dictionary>)dictionaryManager.getList("DDAdjContableConceptoEntrega");
		
		CalculoLiquidacion calculo= liqAvanzadasApi.getCalculoById(idCalculo);
		
		
		model.put("tipoEntrega", tipoEntrega);
		model.put("idCalculo", idCalculo);
		model.put("conceptoEntrega", conceptoEntrega);
		model.put("fechaCierre", calculo.getFechaCierre());
		model.put("fechaLiquidacion", calculo.getFechaLiquidacion());
//		model.put("procedimientos", procedimientos);
//		model.put("idAsunto", idAsunto);
        
		return NUEVA_ENTREGA; 
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping
	public String editarEntrega(Long idCalculo, ModelMap model, Long idEntrega) {
		// TODO Auto-generated method stub
		
		
		
		List<Dictionary> tipoEntrega= (List<Dictionary>)dictionaryManager.getList("DDAdjContableTipoEntrega");
		List<Dictionary> conceptoEntrega= (List<Dictionary>)dictionaryManager.getList("DDAdjContableConceptoEntrega");
		List<EntregaCalculoLiq> listaEntregas=  liqAvanzadasApi.getEntregasCalculo(idCalculo);
		
		EntregaCalculoLiq entrega= null;
		
		for(EntregaCalculoLiq e: listaEntregas){
			if(e.getId().equals(idEntrega)){
				entrega=e;
			}
		}
		CalculoLiquidacion calculo= liqAvanzadasApi.getCalculoById(idCalculo);
		
		model.put("idEntrega", idEntrega);
		model.put("idCalculo", idCalculo);
		model.put("tipoEntrega", tipoEntrega);
		model.put("conceptoEntrega", conceptoEntrega);
		if(entrega!=null){
			model.put("fechaCobro", entrega.getFechaEntrega());
			model.put("fechaValor", entrega.getFechaValor());
			if(entrega.getTipoEntrega()!=null){
				model.put("codigoTipoEntrega", entrega.getTipoEntrega().getCodigo());
			}
			if(entrega.getConceptoEntrega()!=null){
				model.put("codigoConceptoEntrega", entrega.getConceptoEntrega().getCodigo());
			}
			model.put("gastosProcurados", entrega.getGastosProcurador());
			model.put("gastosLetrado", entrega.getGastosLetrado());
			model.put("otrosGastos", entrega.getOtrosGastos());
			model.put("totalEntrega", entrega.getTotalEntrega());
		}
		
		if(calculo!=null){
			model.put("fechaCierre", calculo.getFechaCierre());
			model.put("fechaLiquidacion", calculo.getFechaLiquidacion());
		}
		
		
		
				
		
		return NUEVA_ENTREGA; 
	}
	
	
	
	
	
	
	

}
