package es.pfsgroup.plugin.recovery.masivo.bvfactory.impl.validators;


import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.plugin.recovery.masivo.bvfactory.MSVBusinessValidatorsAutowiredSupport;
import es.pfsgroup.plugin.recovery.masivo.bvfactory.impl.validators.querys.MSVFactoriaQuerysSQLRegenerarDocumentacion;
import es.pfsgroup.plugin.recovery.masivo.bvfactory.impl.validators.types.MSVColumnMultiResultSQL;
import es.pfsgroup.plugin.recovery.masivo.bvfactory.types.MSVColumnValidator;
import es.pfsgroup.plugin.recovery.masivo.model.MSVDDOperacionMasiva;

@Component
public class MSVBusinessRegenerarDocumentacionSQLValidator implements MSVBusinessValidatorsAutowiredSupport  {

	@Autowired(required=false)
	MSVFactoriaQuerysSQLRegenerarDocumentacion msvQuerys;

	@Override
	public String getCodigoTipoOperacion() {
		return MSVDDOperacionMasiva.CODIGO_REGENERAR_DOCUMENTACION;
	}

	@Override
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

	public MSVFactoriaQuerysSQLRegenerarDocumentacion getMsvQuerys() {
		return msvQuerys;
	}

	public void setMsvQuerys(MSVFactoriaQuerysSQLRegenerarDocumentacion msvQuerys) {
		this.msvQuerys = msvQuerys;
	}

	
}
