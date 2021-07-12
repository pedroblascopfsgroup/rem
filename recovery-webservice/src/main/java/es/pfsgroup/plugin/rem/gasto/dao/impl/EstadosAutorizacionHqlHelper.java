package es.pfsgroup.plugin.rem.gasto.dao.impl;


import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.plugin.rem.model.DtoGastosFilter;

public class EstadosAutorizacionHqlHelper {
	

	
	public static final String ALIAS_EAH = "estAutHaya";
	public static final String ALIAS_EAP = "estAutProp";
	public static final String FROM_EAH = ",DDEstadoAutorizacionHaya " + ALIAS_EAH;
	public static final String FROM_EAP = ",DDEstadoAutorizacionPropietario " + ALIAS_EAP;
	public static final String WHERE_JOIN_EAH = ALIAS_EAH + ".id = vgasto.idEstAutHaya ";
	public static final String WHERE_JOIN_EAP = ALIAS_EAP + ".id = vgasto.idEstAutProp ";
	
	
	public static String getFrom(DtoGastosFilter dtoGastosFilter) {
		String from = null;
		if (!Checks.esNulo(dtoGastosFilter)) {
			if (!Checks.esNulo(dtoGastosFilter.getEstadoAutorizacionHayaCodigo()) && !Checks.esNulo(dtoGastosFilter.getEstadoAutorizacionPropietarioCodigo())) {
				from = FROM_EAH + FROM_EAP;
			}else if (!Checks.esNulo(dtoGastosFilter.getEstadoAutorizacionHayaCodigo())) {
				from = FROM_EAH;
			}else if (!Checks.esNulo(dtoGastosFilter.getEstadoAutorizacionPropietarioCodigo())) {
				from = FROM_EAP;
			}
		}
		return from;
	}
	
	public static String getWhereJoin(DtoGastosFilter dtoGastosFilter, Boolean hasWhere) {
		String where = (hasWhere ? " and" : " where ");
		if (!Checks.esNulo(dtoGastosFilter.getEstadoAutorizacionHayaCodigo()) && !Checks.esNulo(dtoGastosFilter.getEstadoAutorizacionPropietarioCodigo())) {
			where += WHERE_JOIN_EAH + " and " + WHERE_JOIN_EAP;
		}else if (!Checks.esNulo(dtoGastosFilter.getEstadoAutorizacionHayaCodigo())) {
			where += WHERE_JOIN_EAH;
		}else if (!Checks.esNulo(dtoGastosFilter.getEstadoAutorizacionPropietarioCodigo())) {
			where += WHERE_JOIN_EAP;
		}
		return where;	
	}
	
}