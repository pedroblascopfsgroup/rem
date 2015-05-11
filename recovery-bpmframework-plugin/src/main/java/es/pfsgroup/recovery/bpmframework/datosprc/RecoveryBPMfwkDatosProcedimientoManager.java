package es.pfsgroup.recovery.bpmframework.datosprc;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.pfs.asunto.model.Procedimiento;
import es.capgemini.pfs.procesosJudiciales.model.TipoJuzgado;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.recovery.api.ProcedimientoApi;
import es.pfsgroup.recovery.bpmframework.api.config.RecoveryBPMfwkCfgInputDto;
import es.pfsgroup.recovery.bpmframework.api.config.RecoveryBPMfwkGrupoDatoDto;
import es.pfsgroup.recovery.bpmframework.datosprc.model.RecoveryBPMfwkDatosProcedimiento;
import es.pfsgroup.recovery.bpmframework.exceptions.RecoveryBPMfwkConfiguracionError;


/**
 * Implementación de la interfaz {@link RecoveryBPMfwkDatosProcedimientoApi}
 * @author manuel
 *
 */
@Service
public class RecoveryBPMfwkDatosProcedimientoManager implements	RecoveryBPMfwkDatosProcedimientoApi {

    @Autowired
    private transient ApiProxyFactory proxyFactory;
    
    @Autowired
    private transient GenericABMDao genericDao;

	/* (non-Javadoc)
	 * @see es.pfsgroup.recovery.bpmframework.datosprc.RecoveryBPMfwkDatosProcedimientoApi#guardaDatos(java.lang.Long, java.util.Map, es.pfsgroup.recovery.bpmframework.api.config.RecoveryBPMfwkCfgInputDto)
	 */
	@Override
	public void guardaDatos(Long idProcedimiento, Map<String, Object> datosInput, RecoveryBPMfwkCfgInputDto config) 
			throws RecoveryBPMfwkConfiguracionError {
		
		this.validaDatos(idProcedimiento, datosInput, config);
		
		Procedimiento prc = this.getProcedimiento(idProcedimiento);
		
		//No se encuentra el procedimiento.
		if (prc == null)
			throw new RecoveryBPMfwkConfiguracionError(RecoveryBPMfwkConfiguracionError.ProblemasConocidos.ARGUMENTOS_INCORRECTOS, "El procedimiento es nulo.", idProcedimiento, datosInput, config);
		
		this.guardaDatos(prc, datosInput, config);


	}

	/**
	 * Crea y guarda en base de datos los objetos de tipo {@link RecoveryBPMfwkDatosProcedimientoManager} 
	 * generados a partir de los datos recibidos.
	 * 
	 * Si los datos ya existen los actualiza, de forma que no hay duplicidad en el campo nombreDato para cada procedimiento.
	 * 
	 * @param prc procedimiento {@link Procedimiento}
	 * @param datosInput datos del input.
	 * @param config datos de configuración.
	 */
	private void guardaDatos(Procedimiento prc, Map<String, Object> datosInput, RecoveryBPMfwkCfgInputDto config) {
		
		Map<String, RecoveryBPMfwkDatosProcedimiento> datosPersistidos = this.getDatosPersistidos(prc);
		
		boolean guardarProcedimiento = false;
		String plaza = "";
		
		for(Map.Entry<String,RecoveryBPMfwkGrupoDatoDto> entry : config.getConfigDatos().entrySet()){
			
			RecoveryBPMfwkDatosProcedimiento obj = datosPersistidos.get(entry.getValue().getDato());
			
			//Si no existe el dato en base de datos, lo creamos nuevo.
			if (obj == null)
				obj = new RecoveryBPMfwkDatosProcedimiento();
			
			//PBO: obtenemos el nombre del campo 
			// (para tener en cuenta los campos que se grabarán, además, en el procedimiento)
			String nombreDato = entry.getValue().getDato();
			// Y el valor
			Object valorInput = datosInput.get(entry.getValue().getNombreInput());
			
			obj.setNombreDato(nombreDato);
			obj.setNombreGrupo(entry.getValue().getGrupo());
			if (valorInput != null)
				obj.setValor(valorInput.toString());
			obj.setProcedimiento(prc);
			genericDao.save(RecoveryBPMfwkDatosProcedimiento.class, obj);

			//PBO: tenemos en cuenta los campos particulares que se graban directamente en el procedimiento
			// Casos particulares: 'plaza', 'juzgado', 'numAutos'
			//FIXME: cambiar esto por casos generales (UPDATES definidos en la tabla de datos de inputs o scripts en Groovy)
			if (nombreDato.equalsIgnoreCase("plaza")) {
				guardarProcedimiento = true;
				if (valorInput != null)
					plaza = valorInput.toString();
			}
			if (nombreDato.equalsIgnoreCase("juzgado")) {
				guardarProcedimiento = true;
				TipoJuzgado juzgado = null;
				if (valorInput != null && plaza != null)
					juzgado = obtenerJuzgado(plaza, valorInput.toString());
				prc.setJuzgado(juzgado );
			}
			if (nombreDato.equalsIgnoreCase("numAutos")) {
				guardarProcedimiento = true;
				if (valorInput != null)
					prc.setCodigoProcedimientoEnJuzgado(valorInput.toString());
			}
			
		}
		//FIXME: Sustituir estas líneas por el código genérico diseñado para casos generales
		if (guardarProcedimiento) {
			genericDao.save(Procedimiento.class, prc);
		}
	}

	private TipoJuzgado obtenerJuzgado(String plaza, String codigoJuzgado) {
		
		Filter f1 = genericDao.createFilter(FilterType.EQUALS, "codigo", codigoJuzgado);
		TipoJuzgado juzgado = genericDao.get(TipoJuzgado.class, f1);
		return juzgado;
	}

	/**
	 * Recupera de la base de datos los datos del procedimiento ya almacenados.
	 * @param prc el objeto {@link Procedimiento}
	 * @return mapa con los datos encontrado, la clave es el campo nombreDato.
	 */
	private Map<String,RecoveryBPMfwkDatosProcedimiento> getDatosPersistidos(Procedimiento prc) {
		
		return this.getDatosPersistidos(prc.getId());
	}
	
	/**
	 * Recupera de la base de datos los datos del procedimiento ya almacenados.
	 * @param Id del procedimiento
	 * @return mapa con los datos encontrado, la clave es el campo nombreDato.
	 */
	@BusinessOperation(PLUGIN_RECOVERYBPMFWK_BO_GET_DATOS_PERSISTIDOS)
	public Map<String,RecoveryBPMfwkDatosProcedimiento> getDatosPersistidos(Long idProcedimiento) {
		
		Filter f1 = genericDao.createFilter(FilterType.EQUALS, "procedimiento.id", idProcedimiento);
		List<RecoveryBPMfwkDatosProcedimiento> lista = genericDao.getList(RecoveryBPMfwkDatosProcedimiento.class, f1);
		
		Map<String, RecoveryBPMfwkDatosProcedimiento> mapa = new HashMap<String, RecoveryBPMfwkDatosProcedimiento>();
		
		for(RecoveryBPMfwkDatosProcedimiento datos: lista){
			
			mapa.put(datos.getNombreDato(), datos);
			
		}
		
		return mapa;
	}

	/**
	 * Recupera un procedimiento a partir del idProcedimiento
	 * @param idProcedimiento id del procedimiento.
	 * @return devuelve un objeto {@link Procedimiento}ç
	 */
	private Procedimiento getProcedimiento(Long idProcedimiento) {
		
		return proxyFactory.proxy(ProcedimientoApi.class).getProcedimiento(idProcedimiento);
	}

	/**
	 * Comprobamos que los datos del mapa se corresponden con los datos de la configuración.
	 * @param idProcedimiento 
	 * @param datosInput
	 * @param config
	 * @throws RecoveryBPMfwkConfiguracionError 
	 */
	private void validaDatos(Long idProcedimiento, Map<String, Object> datosInput, RecoveryBPMfwkCfgInputDto config) throws RecoveryBPMfwkConfiguracionError {

		//datos nulos
		if (datosInput == null || config == null || idProcedimiento == null)
			throw new RecoveryBPMfwkConfiguracionError(RecoveryBPMfwkConfiguracionError.ProblemasConocidos.ARGUMENTOS_INCORRECTOS,
					creaStringSalidaExcepcionDatosNulos("Se encontraron datos nulos.",  idProcedimiento, datosInput, config),
					idProcedimiento, datosInput, config);
		
		// El número de datos deber ser el mismo.
		if (datosInput.size() != config.getConfigDatos().size()){
			throw new RecoveryBPMfwkConfiguracionError(RecoveryBPMfwkConfiguracionError.ProblemasConocidos.ARGUMENTOS_INCORRECTOS,
					creaStringSalidaExcepcionDatosDistintos("La cantidad de datos del mapa no coincide con la configuracion.", datosInput, config),
					idProcedimiento, datosInput, config);
		}
		
		//Comprobamos que existan todas las claves en ambos mapas.
		for(Map.Entry<String,RecoveryBPMfwkGrupoDatoDto> entry : config.getConfigDatos().entrySet()){
			if(!datosInput.containsKey(entry.getValue().getNombreInput())){
				throw new RecoveryBPMfwkConfiguracionError(RecoveryBPMfwkConfiguracionError.ProblemasConocidos.ARGUMENTOS_INCORRECTOS,
						creaStringSalidaExcepcionDatosDistintos("Los datos del mapa no coinciden con los de la configuracion.", datosInput, config),
						idProcedimiento, datosInput, config);
			}
		}

	}
	
	private String creaStringSalidaExcepcionDatosDistintos(String msg, Map<String, Object> datosInput, RecoveryBPMfwkCfgInputDto config) {
		StringBuffer sb = new StringBuffer(msg);
		sb.append("\n");
		sb.append("Tamanyo del mapa de campos de configuracion: " + config.getConfigDatos().size() + "\n");
		sb.append("Tamanyo del mapa de campos de datosInput: " + datosInput.size() + "\n");
		if (config.getConfigDatos().size() >= datosInput.size()){
			for(Map.Entry<String,RecoveryBPMfwkGrupoDatoDto> entry : config.getConfigDatos().entrySet()){
				if(!datosInput.containsKey(entry.getValue().getNombreInput())){
					sb.append("El mapa de datos del input no contiene el campo " + entry.getValue().getNombreInput() + "\n");
				}
			}
		}else{
			for(Entry<String, Object> entry : datosInput.entrySet()){
				if(!config.getConfigDatos().containsKey(entry.getKey())){
					sb.append("El mapa de datos de configuracion no contiene el campo " + entry.getKey() + "\n");
				}
			}
		}		
		sb.append("Datos de configuracion:" + config.toString()+ "\n");
		sb.append("Datos del input:" + datosInput.toString()+ "\n");
		return sb.toString();
	}

	private String creaStringSalidaExcepcionDatosNulos(String msg, Long idProcedimiento, Map<String, Object> datosInput, RecoveryBPMfwkCfgInputDto config){
		StringBuffer sb = new StringBuffer(msg);
		sb.append("\n");
		if (idProcedimiento == null) sb.append("El parametro idProcedimiento es nulo.\n");
		if (datosInput == null) sb.append("El parametro datosInput es nulo.\n");
		if (config == null) sb.append("El parametro config es nulo.\n");
		return sb.toString();
		
	}

	/* (non-Javadoc)
	 * @see es.pfsgroup.recovery.bpmframework.datosprc.RecoveryBPMfwkDatosProcedimientoApi#borrarDatosPersistidos(java.lang.Long, java.lang.String[])
	 */
	@Override
	@BusinessOperation(PLUGIN_RECOVERYBPMFWK_BO_BORRAR_DATOS_PERSISTIDOS)
	public void borrarDatosPersistidos(Long idProcedimiento, String[] datosInput, String tipoBorrado) {
		
		Procedimiento prc = this.getProcedimiento(idProcedimiento);

		if (prc == null){
			throw new RecoveryBPMfwkConfiguracionError(RecoveryBPMfwkConfiguracionError.ProblemasConocidos.ARGUMENTOS_INCORRECTOS, "El procedimiento " + idProcedimiento + " es nulo.");
		}
		
		Map<String, RecoveryBPMfwkDatosProcedimiento> datosPersistidos = this.getDatosPersistidos(prc);
		
		for (String clave: datosInput){

			RecoveryBPMfwkDatosProcedimiento obj = datosPersistidos.get(clave);
			
			if (obj != null){
				if (VALOR_A_NULL.equals(tipoBorrado)){
					obj.setValor(null);
					genericDao.save(RecoveryBPMfwkDatosProcedimiento.class, obj);
				}else if (BORRAR_DATO.equals(tipoBorrado)){
					genericDao.deleteById(RecoveryBPMfwkDatosProcedimiento.class, obj.getId());
				}
			}
		}
	}

}
