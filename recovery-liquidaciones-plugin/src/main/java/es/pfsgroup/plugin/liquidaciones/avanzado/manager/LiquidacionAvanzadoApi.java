package es.pfsgroup.plugin.liquidaciones.avanzado.manager;

import java.util.List;

import es.pfsgroup.plugin.liquidaciones.avanzado.dto.LIQDtoLiquidacionCabecera;
import es.pfsgroup.plugin.liquidaciones.avanzado.dto.LIQDtoLiquidacionResumen;
import es.pfsgroup.plugin.liquidaciones.avanzado.dto.LIQDtoReportRequest;
import es.pfsgroup.plugin.liquidaciones.avanzado.dto.LIQDtoTramoLiquidacion;
import es.pfsgroup.plugin.liquidaciones.avanzado.dto.LIQTramoPendientes;

public interface LiquidacionAvanzadoApi {

	public LIQDtoLiquidacionCabecera completarCabecera(
			LIQDtoReportRequest request);

	public List<LIQDtoTramoLiquidacion> obtenerLiquidaciones(
			LIQDtoReportRequest request, LIQTramoPendientes pendientes);

	public LIQDtoLiquidacionResumen crearResumen(LIQDtoReportRequest request,
			List<LIQDtoTramoLiquidacion> cuerpo, LIQTramoPendientes pendientes);

}