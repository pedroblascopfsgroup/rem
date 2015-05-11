package es.pfsgroup.plugin.recovery.masivo.bvfactory.impl.validators;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.plugin.recovery.masivo.bvfactory.MSVBusinessValidatorsAutowiredSupport;
import es.pfsgroup.plugin.recovery.masivo.bvfactory.impl.validators.querys.MSVFactoriaQuerysSQLValidarAltaAsuntosJudicializados;
import es.pfsgroup.plugin.recovery.masivo.bvfactory.impl.validators.types.MSVColumnMultiResultSQL;
import es.pfsgroup.plugin.recovery.masivo.bvfactory.types.MSVColumnValidator;
import es.pfsgroup.plugin.recovery.masivo.model.MSVDDOperacionMasiva;


@Component
public class MSVBusinessAltaAsuntosJudicializadosSQLValidator implements MSVBusinessValidatorsAutowiredSupport {
	
//	/*
//	 * Bruno
//	 * Definimos las consultas SQL que haya para validar
//	 * TODO Esta definición debería ir en un xml de Spring 
//	 */
//	public static final String SQL_VALIDAR_LETRADO = "select * from ${master.schema}.USU_USUARIOS where usu_username = '"+MSVColumnSQLValidatorImpl.VALUE_TOKEN+"'";
//	
//	/*
//	 * Bruno
//	 * Damos de alta, para cada columna del excel, la SQL de validación que haya
//	 * TODO Esto se debería hacer mediante Spring
//	 */
//	private static final HashMap<String, String> validationSQLs = new HashMap<String, String>();
//	static {
//		validationSQLs.put(MSVAltaContratosColumns.LETRADO, SQL_VALIDAR_LETRADO);
//	}
	
	@Autowired(required=false)
	MSVFactoriaQuerysSQLValidarAltaAsuntosJudicializados msvQuerys;

	@Override
	public String getCodigoTipoOperacion() {
		return MSVDDOperacionMasiva.CODIGO_ALTA_CARTERA_JUDICIALIZADA;
	}
	
	public MSVColumnValidator getValidatorForColumn(String colName) {
		if (Checks.esNulo(colName) || Checks.esNulo(msvQuerys)){
			return null;
		}else{
			String sql = msvQuerys.getSql(colName);
			if (!Checks.esNulo(sql)){
				return new MSVColumnMultiResultSQL(sql, msvQuerys.getConfig(colName));
			}
		}
		return null;
	}
	
	public MSVFactoriaQuerysSQLValidarAltaAsuntosJudicializados getMsvQuerys() {
		return msvQuerys;
	}

	public void setMsvQuerys(MSVFactoriaQuerysSQLValidarAltaAsuntosJudicializados msvQuerys) {
		this.msvQuerys = msvQuerys;
	}


}
