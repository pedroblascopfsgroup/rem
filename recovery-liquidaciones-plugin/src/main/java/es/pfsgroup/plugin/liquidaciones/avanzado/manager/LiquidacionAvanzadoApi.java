package es.pfsgroup.plugin.liquidaciones.avanzado.manager;

import java.util.List;

import org.springframework.transaction.annotation.Transactional;

import es.pfsgroup.plugin.liquidaciones.avanzado.dto.DtoCalculoLiquidacion;
import es.pfsgroup.plugin.liquidaciones.avanzado.dto.LIQDtoLiquidacionCabecera;
import es.pfsgroup.plugin.liquidaciones.avanzado.dto.LIQDtoLiquidacionResumen;
import es.pfsgroup.plugin.liquidaciones.avanzado.dto.LIQDtoTramoLiquidacion;
import es.pfsgroup.plugin.liquidaciones.avanzado.dto.LIQTramoPendientes;
import es.pfsgroup.plugin.liquidaciones.avanzado.model.CalculoLiquidacion;
import es.pfsgroup.plugin.liquidaciones.avanzado.model.EntregaCalculoLiq;
import es.pfsgroup.plugin.recovery.liquidaciones.dto.LIQDtoCobroPagoEntregas;

public interface LiquidacionAvanzadoApi {

	public LIQDtoLiquidacionCabecera completarCabecera(CalculoLiquidacion request);

	public List<LIQDtoTramoLiquidacion> obtenerLiquidaciones(CalculoLiquidacion request, LIQTramoPendientes pendientes);

	public LIQDtoLiquidacionResumen crearResumen(CalculoLiquidacion request, List<LIQDtoTramoLiquidacion> cuerpo, LIQTramoPendientes pendientes);

	public CalculoLiquidacion getCalculoById(Long calculoId);

	public CalculoLiquidacion convertDtoCalculoLiquidacionTOCalculoLiquidacion(DtoCalculoLiquidacion dto);
	
	public void createOrUpdateEntCalLiquidacion(LIQDtoCobroPagoEntregas dto);
	
	@Transactional(readOnly = false)
	public CalculoLiquidacion saveCalculoLiquidacionAvanzado(CalculoLiquidacion cl);

	List<CalculoLiquidacion> obtenerCalculosLiquidacionesAsunto(Long idAsunto);

	List<EntregaCalculoLiq> getEntregasCalculo(Long idCalculo);
	
	@Transactional(readOnly = false)
	public void creaTiposInteresParaCalculoLiquidacion(List<String> tiposInteres, CalculoLiquidacion calculoLiquidacion);
	
	public CalculoLiquidacion getCalculoLiquidacion(Long idCalcLiq);
	
	public DtoCalculoLiquidacion convertCalculoLiquidacionTODtoCalculoLiquidacion(CalculoLiquidacion calcLiq);

	void eliminarEntregaCalLiquidacion(Long idEntrega);

}