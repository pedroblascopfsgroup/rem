package es.pfsgroup.plugin.rem.gasto.dao.impl;


import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.plugin.rem.model.DtoGastosFilter;

public class GastoActivosHqlHelper {
	

	
	public static final String ALIAS = "gastoActivo";
	public static final String ALIAS_GLD = "gastoLinea";
	public static final String ALIAS_GGE = "gastoGestion";
	public static final String ALIAS_EAH = "estadoAutorizacionHayaCodigo";
	public static final String ALIAS_STG = "subtipoGasto";
	public static final String FROM = ",GastoLineaDetalleEntidad " + ALIAS;
	public static final String FROM_GLD = ",GastoLineaDetalle " + ALIAS_GLD;
	public static final String FROM_GGE = ",GastoGestion " + ALIAS_GGE;
	public static final String FROM_STG = ",DDSubtipoGasto " + ALIAS_STG;
	public static final String FROM_EAH = ",DDEstadoAutorizacionHaya " + ALIAS_EAH;
	public static final String WHERE_JOIN = " vgasto.id = " + ALIAS + ".gastoLineaDetalle.gastoProveedor.id ";
	public static final String WHERE_JOIN_GLD = " vgasto.id = " + ALIAS_GLD + ".gastoProveedor.id ";
	public static final String WHERE_JOIN_GGE = " vgasto.id = " + ALIAS_GGE + ".gastoProveedor.id ";
	public static final String WHERE_JOIN_STG = ALIAS_STG + ".codigo = " + ALIAS_GLD + ".subtipoGasto.codigo ";
	public static final String WHERE_JOIN_EAH = ALIAS_GGE +".estadoAutorizacionHaya.codigo = " + ALIAS_EAH + ".codigo ";
	
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
	
	public static String getFromSTG(DtoGastosFilter dtoGastosFilter) {
		if (Checks.esNulo(dtoGastosFilter) || 
				(Checks.esNulo(dtoGastosFilter.getSubtipoGastoCodigo()))){
			return null;
		} else {
			return (FROM_GLD + FROM_STG);
		}
		
	}
	
	public static String getFromEAH(DtoGastosFilter dtoGastosFilter) {
		if (Checks.esNulo(dtoGastosFilter) || 
				(Checks.esNulo(dtoGastosFilter.getEstadoAutorizacionHayaCodigo()))){
			return null;
		} else {
			return (FROM_GGE + FROM_EAH);
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
	
	public static String getWhereJoinSTG(DtoGastosFilter dtoGastosFilter, Boolean hasWhere) {
		if (Checks.esNulo(dtoGastosFilter) 
			|| (Checks.esNulo(dtoGastosFilter.getSubtipoGastoCodigo()))){
			return null;
		} else {
			return (hasWhere ? " and" : " where ") + WHERE_JOIN_GLD + " and " + WHERE_JOIN_STG;
		}
		
	}
	
	public static String getWhereJoinEAH(DtoGastosFilter dtoGastosFilter, Boolean hasWhere) {
		if (Checks.esNulo(dtoGastosFilter) 
			|| (Checks.esNulo(dtoGastosFilter.getEstadoAutorizacionHayaCodigo()))){
			return null;
		} else {
			return (hasWhere ? " and" : " where ") + WHERE_JOIN_GGE + " and " + WHERE_JOIN_EAH;
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