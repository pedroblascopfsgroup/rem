package es.pfsgroup.plugin.rem.gasto.dao.impl;


import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.plugin.rem.model.DtoGastosFilter;

public class GastoActivosHqlHelper {
	

	
	public static final String ALIAS = "gastoActivo";
	public static final String FROM = ",GastoLineaDetalleEntidad " + ALIAS;
	public static final String WHERE_JOIN = " vgasto.id = " + ALIAS + ".gastoLineaDetalle.gastoProveedor.id ";
	
	public static final String FROMSUBCARTERA = ",Activo act ";
	public static final String WHERE_JOIN_SUBCARTERA = ALIAS + ".entidad = act.id ";
	

	public static String getFrom(DtoGastosFilter dtoGastosFilter) {
		if (Checks.esNulo(dtoGastosFilter) || 
				(Checks.esNulo(dtoGastosFilter.getNumActivo()) && Checks.esNulo(dtoGastosFilter.getSubentidadPropietariaCodigo()))){
			return null;
		} else {
			return FROM;
		}
		
	}
	
	public static String getWhereJoin(DtoGastosFilter dtoGastosFilter, Boolean hasWhere) {
		if (Checks.esNulo(dtoGastosFilter) 
			|| ((Checks.esNulo(dtoGastosFilter.getNumActivo())) && Checks.esNulo(dtoGastosFilter.getSubentidadPropietariaCodigo()))){
			return null;
		} else {
			return (hasWhere ? " and" : " where ") +  WHERE_JOIN;
		}
		
	}
	
	public static String getFromSubcartera(DtoGastosFilter dtoGastosFilter) {
		if (Checks.esNulo(dtoGastosFilter) || Checks.esNulo(dtoGastosFilter.getSubentidadPropietariaCodigo())){
			return null;
		} else {
			return FROMSUBCARTERA;
		}
		
	}
	
	public static String getWhereJoinSubcartera(DtoGastosFilter dtoGastosFilter, Boolean hasWhere) {
		if (Checks.esNulo(dtoGastosFilter) || (Checks.esNulo(dtoGastosFilter.getSubentidadPropietariaCodigo()))){
			return null;
		} else {
			return (hasWhere ? " and " : " where ") +  WHERE_JOIN_SUBCARTERA;
		}
		
	}
	
}