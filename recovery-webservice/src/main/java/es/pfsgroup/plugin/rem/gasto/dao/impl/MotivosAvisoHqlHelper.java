package es.pfsgroup.plugin.rem.gasto.dao.impl;


import java.util.HashMap;
import java.util.Map;

import org.apache.commons.collections.MapUtils;

import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.plugin.rem.model.DtoGastosFilter;

public class MotivosAvisoHqlHelper {
	
	private static final Map<String, String> MAPA_CODIGOS = new HashMap<String, String>();
	
	/**
	 * Mapea el DD con propiedades de es.pfsgroup.plugin.rem.model.GastoProveedorAvisos
	 */
	static {
		MAPA_CODIGOS.put("00", "algunMotivo");
		MAPA_CODIGOS.put("01", "correspondeComprador");
		MAPA_CODIGOS.put("02", "ibiExento");
		MAPA_CODIGOS.put("03", "noDevengaImpuesto");
		MAPA_CODIGOS.put("04", "primerPago");
		MAPA_CODIGOS.put("05", "incrementoImporte");
		MAPA_CODIGOS.put("06", "importeDiferente");
		MAPA_CODIGOS.put("07", "bajaProveedor");
		MAPA_CODIGOS.put("08", "proveedorSinSaldo");
		MAPA_CODIGOS.put("09", "fueraPerimetro");
	}
	
	public static final String ALIAS = "gastoAvisos";
	public static final String FROM = ",GastoProveedorAvisos " + ALIAS + " where vgasto.id = gastoAvisos.gastoProveedor.id ";

	public static String getFrom(DtoGastosFilter dtoGastosFilter) {
		if (Checks.esNulo(dtoGastosFilter) || Checks.esNulo(dtoGastosFilter.getCodigoMotivoAviso())){
			return null;
		} else {
			return FROM;
		}
		
	}

	public static String getWhere(DtoGastosFilter dtoGastosFilter) {
		if (Checks.esNulo(dtoGastosFilter) || Checks.esNulo(dtoGastosFilter.getCodigoMotivoAviso())){
			return null;
		} else {
			String campo = MAPA_CODIGOS.get(dtoGastosFilter.getCodigoMotivoAviso());
			return fitroPor(campo);
		}
	}

	public static String fitroPor(String campo) {
		
		if (!Checks.esNulo(campo)){
			return MotivosAvisoHqlHelper.ALIAS + "." + campo + " = true";
		} else {
			return null;
		}
		
	}

	public static String codigoMotivo(String campo) {
		if (!Checks.esNulo(campo)) {
			return (String) MapUtils.invertMap(MAPA_CODIGOS).get(campo);
		} else {
			return null;
		}
		
	}

}
