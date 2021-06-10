package es.pfsgroup.plugin.rem.gasto.dao.impl;


import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.plugin.rem.model.DtoGastosFilter;

public class GastoLineaDetalleHqlHelper {
	

	
	public static final String ALIAS = "gastoLineaDetalle";
	public static final String ALIAS_STG = "subtipoGasto";
	public static final String ALIAS_TBJ = "trabajo";
	public static final String ALIAS_GLDTBJ = "gldtbj";
	public static final String FROM = ",GastoLineaDetalle " + ALIAS;
	public static final String FROM_STG = ",DDSubtipoGasto " + ALIAS_STG;
	public static final String FROM_TBJ = ",Trabajo " + ALIAS_TBJ;
	public static final String FROM_GLDTBJ = ",GastoLineaDetalleTrabajo " + ALIAS_GLDTBJ;
	public static final String WHERE_JOIN_GLD = " vgasto.id = " + ALIAS + ".gastoProveedor.id ";
	public static final String WHERE_JOIN_STG = ALIAS_STG + ".codigo = " + ALIAS + ".subtipoGasto.codigo ";
	public static final String WHERE_JOIN_GLDTBJ = ALIAS_GLDTBJ + ".gastoLineaDetalle.id = " + ALIAS + ".id ";
	public static final String WHERE_JOIN_TBJ = ALIAS_GLDTBJ + ".trabajo.id = " + ALIAS_TBJ + ".id ";
	
	
	public static String getFrom(DtoGastosFilter dtoGastosFilter) {
		String from = null;
		if (!Checks.esNulo(dtoGastosFilter)) {
			from = FROM;
			if (!Checks.esNulo(dtoGastosFilter.getSubtipoGastoCodigo()) && !Checks.esNulo(dtoGastosFilter.getNumTrabajo())) {
				from += FROM_STG + FROM_GLDTBJ + FROM_TBJ;
			}else if (!Checks.esNulo(dtoGastosFilter.getSubtipoGastoCodigo())) {
				from += FROM_STG;
			}else if (!Checks.esNulo(dtoGastosFilter.getNumTrabajo())) {
				from += FROM_GLDTBJ + FROM_TBJ;
			} else {
				from = null;
			}
		}
		return from;
	}
	
	public static String getWhereJoin(DtoGastosFilter dtoGastosFilter, Boolean hasWhere) {
		String where = (hasWhere ? " and" : " where ") + WHERE_JOIN_GLD;
		if (!Checks.esNulo(dtoGastosFilter.getSubtipoGastoCodigo()) && !Checks.esNulo(dtoGastosFilter.getNumTrabajo())) {
			where += " and " + WHERE_JOIN_STG + " and " + WHERE_JOIN_GLDTBJ + " and " + WHERE_JOIN_TBJ;
		}else if (!Checks.esNulo(dtoGastosFilter.getSubtipoGastoCodigo())) {
			where += " and " + WHERE_JOIN_STG;
		}else if (!Checks.esNulo(dtoGastosFilter.getNumTrabajo())) {
			where += " and " + WHERE_JOIN_GLDTBJ + " and " + WHERE_JOIN_TBJ;
		}
		return where;	
	}
	
}