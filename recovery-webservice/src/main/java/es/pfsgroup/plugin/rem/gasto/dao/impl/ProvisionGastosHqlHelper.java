package es.pfsgroup.plugin.rem.gasto.dao.impl;


import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.plugin.rem.model.DtoGastosFilter;

public class ProvisionGastosHqlHelper {
	

	
	public static final String ALIAS = "provision";
	public static final String FROM = ",ProvisionGastos " + ALIAS;
	public static final String WHERE_JOIN = " vgasto.idProvision = " + ALIAS + ".id";

	public static String getFrom(DtoGastosFilter dtoGastosFilter) {
		if (Checks.esNulo(dtoGastosFilter) || Checks.esNulo(dtoGastosFilter.getNumProvision())){
			return null;
		} else {
			return FROM;
		}
		
	}
	
	public static String getWhereJoin(DtoGastosFilter dtoGastosFilter, Boolean hasWhere) {
		if(Checks.esNulo(dtoGastosFilter) || Checks.esNulo(dtoGastosFilter.getNumProvision())){
			return null;
		} else {
			return hasWhere ? " and" : " where" +  WHERE_JOIN;
		}
		
	}
}
