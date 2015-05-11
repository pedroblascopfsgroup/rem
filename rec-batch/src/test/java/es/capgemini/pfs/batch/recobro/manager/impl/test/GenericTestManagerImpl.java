package es.capgemini.pfs.batch.recobro.manager.impl.test;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import es.capgemini.pfs.batch.recobro.api.test.GenericConstantsTest.Genericas;
import es.capgemini.pfs.batch.recobro.jdbc.api.test.GenericTestDAO;
import es.capgemini.pfs.batch.recobro.manager.api.test.GenericTestManager;

/**
 * Implementación del Manager genérico que permite ejecutar los procesos de preparación y/o validación de los jobs
 * @author Guillem
 *
 */
@Component
public class GenericTestManagerImpl implements GenericTestManager {

	protected Log logger = LogFactory.getLog(getClass());
	
	@Autowired
	private GenericTestDAO genericTestDAO;
	
	/**
	 * {@inheritDoc}
	 */
	@Override
	@Transactional
	public void ejecutarSQL(String tipo, String sql, String msg, String expected) throws Throwable {
		try{
			if(tipo != null && (Genericas.UPDATE.equals(tipo.toUpperCase()) || Genericas.INSERT.equals(tipo.toUpperCase()))){
				Integer result = genericTestDAO.ejecutarUPDATESQLCarga(sql, msg);
				logger.info(msg + result);
			}else if(tipo != null && Genericas.CREATE.equals(tipo.toUpperCase()) || Genericas.DROP.equals(tipo.toUpperCase()) 
					|| Genericas.EXECUTE.equals(tipo.toUpperCase())){
				genericTestDAO.ejecutarCREATESQLCarga(sql, msg);
				logger.info(msg);
			}else if(tipo != null && Genericas.COUNT.equals(tipo.toUpperCase())){
				Integer result = genericTestDAO.ejecutarCOUNTSQLValidacion(sql, msg);
				if(expected == null){
					logger.info(msg + result);					
				}else{
					if(result == Integer.parseInt(expected)){
						logger.info(Genericas.ACCION_VALIDACION + msg + Genericas.FINALIZADO_MSG + 
								Genericas.RESULTADO_ESPERADO + expected + Genericas.RESULTADO_OBTENIDO + result);
					}else{
						throw new Throwable(Genericas.ACCION_VALIDACION + msg + Genericas.HA_FALLADO + 
							Genericas.RESULTADO_ESPERADO + expected + Genericas.RESULTADO_OBTENIDO + result);
					}
				}						
			}else{
				throw new Throwable(Genericas.TIPO_SQL_NULO_O_NO_VALIDO);
			}
		}catch(Throwable e){	
			throw new Throwable(Genericas.ACCION_REALIZADA + msg + Genericas.HA_FALLADO + e);
		}		
	}
	
}
