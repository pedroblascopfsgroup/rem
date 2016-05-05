package es.pfsgroup.plugin.liquidaciones.avanzado.manager;

import java.util.List;

import es.pfsgroup.plugin.liquidaciones.avanzado.dto.LIQDtoLiquidacionCabecera;
import es.pfsgroup.plugin.liquidaciones.avanzado.dto.LIQDtoLiquidacionResumen;
import es.pfsgroup.plugin.liquidaciones.avanzado.dto.LIQDtoTramoLiquidacion;
import es.pfsgroup.plugin.liquidaciones.avanzado.dto.LIQTramoPendientes;
import es.pfsgroup.plugin.liquidaciones.avanzado.model.CalculoLiquidacion;

public interface LiquidacionAvanzadoApi {

	public LIQDtoLiquidacionCabecera completarCabecera(CalculoLiquidacion request);

	public List<LIQDtoTramoLiquidacion> obtenerLiquidaciones(CalculoLiquidacion request, LIQTramoPendientes pendientes);

	public LIQDtoLiquidacionResumen crearResumen(CalculoLiquidacion request, List<LIQDtoTramoLiquidacion> cuerpo, LIQTramoPendientes pendientes);

	public CalculoLiquidacion getCalculoById(Long calculoId);

}