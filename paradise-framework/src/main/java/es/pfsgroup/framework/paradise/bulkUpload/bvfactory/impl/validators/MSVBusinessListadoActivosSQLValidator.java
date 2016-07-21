package es.pfsgroup.framework.paradise.bulkUpload.bvfactory.impl.validators;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.framework.paradise.bulkUpload.bvfactory.MSVBusinessValidatorsAutowiredSupport;
import es.pfsgroup.framework.paradise.bulkUpload.bvfactory.impl.validators.querys.MSVFactoriaQuerysSQLValidarListadoActivos;
import es.pfsgroup.framework.paradise.bulkUpload.bvfactory.impl.validators.types.MSVColumnMultiResultSQL;
import es.pfsgroup.framework.paradise.bulkUpload.bvfactory.types.MSVColumnValidator;
import es.pfsgroup.framework.paradise.bulkUpload.model.MSVDDOperacionMasiva;


@Component
public class MSVBusinessListadoActivosSQLValidator implements MSVBusinessValidatorsAutowiredSupport {
	
	@Autowired(required=false)
	MSVFactoriaQuerysSQLValidarListadoActivos msvQuerys;

	@Override
	public String getCodigoTipoOperacion() {
		return MSVDDOperacionMasiva.CODE_FILE_BULKUPLOAD_LISTAACTIVOS;
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
	
	public MSVFactoriaQuerysSQLValidarListadoActivos getMsvQuerys() {
		return msvQuerys;
	}

	public void setMsvQuerys(MSVFactoriaQuerysSQLValidarListadoActivos msvQuerys) {
		this.msvQuerys = msvQuerys;
	}


}
