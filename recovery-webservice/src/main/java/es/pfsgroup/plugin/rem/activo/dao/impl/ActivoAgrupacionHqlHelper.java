package es.pfsgroup.plugin.rem.activo.dao.impl;

public class ActivoAgrupacionHqlHelper {

	public static String getFromActivos(){
		return ", Activo ac, ActivoAgrupacionActivo aaa";
	}
	
	public static String getFromPropietarios() {
		return ", ActivoPropietario ap, ActivoPropietarioActivo apa";
	}
	
	public static String getWhereAndNumActHaya(Long id){
		return " ac.numActivo = " + id;	
	}
	
	public static String getWhereAndNumActUvem(Long id){
		return " ac.numActivoUvem = " + id;
	}
	
	public static String getWhereAndNumActSareb(Long id){
		return " ac.idSareb like '" +id+ "'";
	}
	
	public static String getWhereAndNumActPrinex(Long id){
		return " ac.idProp = " + id;
	}
	
	public static String getWhereAndNumActRecovery(Long id){
		return " ac.idRecovery = " + id;
	}
	
	public static String getWhereAndSubcarteraCodigo(String codigo){
		return " ac.subcartera.codigo = " + codigo;
	}
	
	public static String getWhereAndNif(String id){
		return " ap.docIdentificativo = '"+id+"'";
	}

}
