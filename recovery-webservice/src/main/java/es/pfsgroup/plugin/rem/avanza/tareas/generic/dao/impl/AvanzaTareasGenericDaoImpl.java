package es.pfsgroup.plugin.rem.avanza.tareas.generic.dao.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import es.capgemini.pfs.dao.AbstractEntityDao;
import es.capgemini.pfs.procesosJudiciales.model.TareaExterna;
import es.pfsgroup.framework.paradise.bulkUpload.bvfactory.MSVRawSQLDao;
import es.pfsgroup.plugin.rem.avanza.tareas.generic.dao.AvanzaTareasGenericDao;

@Repository("AvanzaTareasGenericDao")
public class AvanzaTareasGenericDaoImpl extends AbstractEntityDao<TareaExterna, Long> implements AvanzaTareasGenericDao{

	@Autowired
	private MSVRawSQLDao rawDao;
	
	@Override
	public boolean validaCamposTarea(String tapCodigo, Map<String, String[]> valores) {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("tapCodigo", tapCodigo);
		
		rawDao.addParams(params);
		String sql = " SELECT DISTINCT LISTAGG(querys, ' and ') WITHIN GROUP (ORDER BY TCC_INSTANCIA) over (partition by TCC_INSTANCIA) TCC_INSTANCIA "+
				" FROM ( "+
				" SELECT "+
					" CASE "+
					"     WHEN TCC_ACCION = 'IN' THEN tfi.TFI_NOMBRE||' '||TCC_ACCION||' ('||TCC_VALOR||')' "+
					"     WHEN TCC_ACCION = '=' THEN tfi.TFI_NOMBRE||' '||TCC_ACCION||' '||TCC_VALOR "+
					"    ELSE tfi.TFI_NOMBRE||' '||TCC_ACCION "+
					" END AS querys, TCC_INSTANCIA "+
					" FROM TCC_TAREA_CONFIG_CAMPOS tcc "+	
					" INNER JOIN TFI_TAREAS_FORM_ITEMS tfi ON tfi.TFI_ID = tcc.TFI_ID "+
					" INNER JOIN TAP_TAREA_PROCEDIMIENTO tap ON tap.TAP_ID = tcc.TAP_ID "+
					" WHERE tap.TAP_CODIGO = :tapCodigo"
					+ ")";
		
		List<Object> validaciones = rawDao.getExecuteSQLList(sql);
		
		if(validaciones.size() > 0){
			String finalValidacionQuery = " SELECT * FROM DUAL WHERE ";
			for(Object validacion : validaciones){
				finalValidacionQuery += "("+ validacion.toString()+ ") OR";
			}
			finalValidacionQuery = finalValidacionQuery.substring(0, finalValidacionQuery.length()-2);
			
			//Remplazamos los campos pos sus valoreas
			for (Map.Entry<String, String[]> entry : valores.entrySet()) {
				finalValidacionQuery = finalValidacionQuery.replaceAll(entry.getKey(), "'"+entry.getValue()[0]+"'");
			}
			
			//Ejecutamos la query final
			int numResults = rawDao.getCount(finalValidacionQuery);
			boolean resultado = (numResults > 0)?true:false;
			return resultado;
			
		}else{
			return true;
		}
	}

}
