package es.pfsgroup.plugin.precontencioso.liquidacion.generar.prestamo;

import java.util.HashMap;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.capgemini.devon.bo.BusinessOperationException;
import es.pfsgroup.plugin.precontencioso.liquidacion.api.LiquidacionApi;
import es.pfsgroup.plugin.precontencioso.liquidacion.generar.DatosPlantillaFactory;
import es.pfsgroup.plugin.precontencioso.liquidacion.generar.dao.DatosDescubiertoDao;
import es.pfsgroup.plugin.precontencioso.liquidacion.generar.dao.DatosLiquidacionDao;
import es.pfsgroup.plugin.precontencioso.liquidacion.generar.prestamo.vo.DatosGeneralesLiqVO;
import es.pfsgroup.plugin.precontencioso.liquidacion.generar.prestamo.vo.DescubiertoLiqVO;
import es.pfsgroup.plugin.precontencioso.liquidacion.model.LiquidacionPCO;

@Component
public class DatosPlantillaDescubierto extends DatosPlantillaPrestamoAbstract implements DatosPlantillaFactory {
	
	// Codigo de la liquidacion a la que aplica los datos
	private static final String CODIGO_TIPO_LIQUIDACION = "DESCUBIERTO";

	@Autowired
	private DatosLiquidacionDao datosLiquidacionDao;
		
	@Autowired
	private DatosDescubiertoDao datosDescubiertoDao;

	@Autowired
	private LiquidacionApi liquidacionApi;

	@Override
	public String codigoTipoLiquidacion() {
		return CODIGO_TIPO_LIQUIDACION;
	}
	
	@Override
	public HashMap<String, Object> obtenerDatos(Long idLiquidacion) {
		HashMap<String, Object> datosLiquidacion = new HashMap<String, Object>();
		
		// data
		List<DatosGeneralesLiqVO> datosGenerales = datosLiquidacionDao.getDatosGeneralesContratoLiquidacion(idLiquidacion);
		LiquidacionPCO liquidacion = liquidacionApi.getLiquidacionPCOById(idLiquidacion);
		//AÑADIDO PARA EL DESCUBIERTO
		List<DescubiertoLiqVO> descubiertoLiquidacion = datosDescubiertoDao.getDescubiertoLiquidacion(idLiquidacion);
		
		if (datosGenerales.isEmpty()) {
			throw new BusinessOperationException("GenerarLiquidacionBankiaManager.obtenerDatosLiquidacion: No se encuentra datos LQ03");
		}
		
		if (descubiertoLiquidacion.isEmpty()) {
			throw new BusinessOperationException("GenerarLiquidacionBankiaManager.obtenerDatosLiquidacion: No se encuentra datos EC05");
		}

		// add data
		datosLiquidacion.put("LQ03", datosGenerales.get(0));
		
		//AÑADIDO PARA EL DESCUBIERTO
		datosLiquidacion.put("EC05", descubiertoLiquidacion);
		

		// calculated data
		datosLiquidacion.putAll(obtenerDatosLiquidacionPco(liquidacion));
		datosLiquidacion.put("FECHA_FIRMA", datosGenerales.get(0).FEVACM());
		datosLiquidacion.put("CIUDAD_FIRMA", "Madrid");
		//AÑADIDO PARA EL DESCUBIERTO
		datosLiquidacion.put("NUM_SUCURSAL", descubiertoLiquidacion.get(0).COCAAH());
		datosLiquidacion.put("SALDO_ANTERIOR", descubiertoLiquidacion.get(0).SAANAH());
		datosLiquidacion.put("SALDO_POSTERIOR", descubiertoLiquidacion.get(descubiertoLiquidacion.size()-1).SAPOAH());
		
		if (descubiertoLiquidacion.isEmpty()) {
             datosLiquidacion.put("CPL_COEAAH", "");
             datosLiquidacion.put("CPL_COCAAH", "");
             datosLiquidacion.put("CPL_NUDCAH", "");
             datosLiquidacion.put("CPL_NUCTAH", "");
             datosLiquidacion.put("N_CUENTA", "");
             return datosLiquidacion;
		}
		//VALORES DEL Nº DE CUENTA
		String coeaah = descubiertoLiquidacion.get(0).COEAAH();
		String cocaah = descubiertoLiquidacion.get(0).COCAAH();
		String nudcah = descubiertoLiquidacion.get(0).NUDCAH();
		String nuctah = descubiertoLiquidacion.get(0).NUCTAH();
		//DATOS DE LA CUENTA CONCATENADOS
		String n_cuenta = coeaah + "." + cocaah + "." + nudcah + "." + nuctah;
		
		datosLiquidacion.put("N_CUENTA", n_cuenta);

		return datosLiquidacion;
	}
}
