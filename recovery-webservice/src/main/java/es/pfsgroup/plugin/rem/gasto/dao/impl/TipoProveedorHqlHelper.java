package es.pfsgroup.plugin.rem.gasto.dao.impl;


import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.plugin.rem.model.DtoGastosFilter;

public class TipoProveedorHqlHelper {
	

	
	public static final String ALIAS_TPR = "tipoProv";
	public static final String ALIAS_TEP = "tipoEntProv";
	public static final String FROM_TPR = ",DDTipoProveedor " + ALIAS_TPR;
	public static final String FROM_TEP = ",DDEntidadProveedor " + ALIAS_TEP;
	public static final String WHERE_JOIN_TPR = " vgasto.idTipoProv = " + ALIAS_TPR + ".id ";
	public static final String WHERE_JOIN_TEP = ALIAS_TPR + ".tipoEntidadProveedor.id = " + ALIAS_TEP + ".id ";
	
	
	public static String getFrom(DtoGastosFilter dtoGastosFilter) {
		String from = null;
		if (!Checks.esNulo(dtoGastosFilter) && !Checks.esNulo(dtoGastosFilter.getCodigoTipoProveedor())){
			from = FROM_TPR + FROM_TEP;
		}
		return from;
	}
	
	public static String getWhereJoin(DtoGastosFilter dtoGastosFilter, Boolean hasWhere) {
		return (hasWhere ? " and" : " where ") + WHERE_JOIN_TPR + " and " + WHERE_JOIN_TEP;	
	}
	
}