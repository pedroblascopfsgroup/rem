package es.pfsgroup.plugin.recovery.diccionarios.diccionarios;

import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import es.capgemini.devon.bo.Executor;
import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.devon.web.DynamicElement;
import es.capgemini.pfs.dao.AbstractDao;
import es.capgemini.pfs.eventfactory.EventFactory;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.plugin.recovery.diccionarios.api.web.DynamicElementApi;
import es.pfsgroup.plugin.recovery.diccionarios.diccionarios.dao.DICDiccionarioEditableDao;
import es.pfsgroup.plugin.recovery.diccionarios.diccionarios.dao.DICDiccionarioEditableLogDao;
import es.pfsgroup.plugin.recovery.diccionarios.diccionarios.dao.DICDiccionarioEditableLogDaoInterface;
import es.pfsgroup.plugin.recovery.diccionarios.diccionarios.dto.DICDtoValorDiccionario;
import es.pfsgroup.plugin.recovery.diccionarios.diccionarios.model.DICDiccionarioEditable;
import es.pfsgroup.plugin.recovery.diccionarios.diccionarios.model.DICDiccionarioEditableLog;


@Service("dicDiccionarioEditableManager")
public class DICDiccionarioEditableManager extends DICAbstractDiccionarioEditableManager<DICDiccionarioEditable, DICDiccionarioEditableLog> {

	@Autowired
	private DICDiccionarioEditableDao diccionarioEditableDao;

	@Autowired
	private DICDiccionarioEditableLogDao diccionarioEditableLogDao;
	
	@Autowired
	Executor executor;	
	
	@Autowired
	ApiProxyFactory proxyFactory;
	//private List<ADMDiccionarioHandler> manejadores = new ArrayList<ADMDiccionarioHandler>();
	
	
	public void setManejadores(List<DICDiccionarioHandler> manejadores) {
		//this.manejadores = manejadores;
	}

	/**
	 *  Devuelve el listado de todos los diccionarios editables
	 * @return lista de diccionarios.
	 *  
	 * */
	@BusinessOperation("plugin.diccionarios.diccionarioEditableManager.listaDiccionariosEditables")
	public List<DICDiccionarioEditable> listaDiccionariosEditables(){
		EventFactory.onMethodStart(this.getClass());
		return diccionarioEditableDao.getList();
		//return super.listaDiccionariosEditables();
	}

	/**
	 *  Devuelve los valores para un diccionario concreto
	 * @param Id del diccionario Editable a consutlar
	 * @return lista de diccionarios. 
	 * */
	@BusinessOperation("plugin.diccionarios.diccionarioEditableManager.dameDiccionarioEditable")
	public DICDiccionarioEditable dameDiccionarioEditable(Long idDiccionario){
		return super.getDiccionarioEditable(idDiccionario);
	}
	
	/**
	 *  Devuelve el listado de todos los diccionarios editables
	 * @return lista de diccionarios paginada.
	 *  
	 * */
	@SuppressWarnings("unchecked")
	@BusinessOperation("plugin.diccionarios.diccionarioEditableManager.listaDiccionariosEditablesPaginado")
	public List listaDiccionariosEditablesPaginado(){
		return super.listaDiccionariosEditablesPaginado();
	}

	/**
	 *  Devuelve los valores para un diccionario concreto
	 * @param Id del diccionario Editable a consutlar
	 * @return lista de diccionarios. 
	 * Se cambia a dameDiccionarioEditable
	 * */
	//@BusinessOperation("plugin.diccionarios.diccionarioEditableManager.getDiccionarioEditableTITITI")
	//public DICDiccionarioEditable getDiccionarioEditable(Long idDiccionario) {
	//	return super.getDiccionarioEditable(idDiccionario);
	//}

	/**
	 *  Apartir del id del diccionario editable devuelve el objeto correspondiente
	 * Cargado con los valores que contiene dicha tabla.
	 * @param Id del diccionario Editable a consutlar
	 * @return lista de valores para el diccionario recivido diccionarios. 
	 * */
	@BusinessOperation("plugin.diccionarios.diccionarioEditableManager.getDiccionarioDatos")
	public List<DICDtoValorDiccionario> getDiccionarioDatos(Long idDiccionario) {
		EventFactory.onMethodStart(this.getClass());
		return super.getDiccionarioDatos(idDiccionario);
	}	
	
	/**
	 *  Apartir del id del diccionario editable y del id de la linea a editar
	 * devolver los valores para dicha linea
	 * @param Id del diccionario Editable a consutlar / id de la linea en el diccionario
	 * @return valores para la linea editable
	 * */
	@BusinessOperation("plugin.diccionarios.diccionarioEditableManager.getDiccionarioDatosLinea")
	public DICDtoValorDiccionario getDiccionarioDatosLinea(Long idDiccionario, Long idLineaEnDiccionario) {
		return super.getDiccionarioDatosLinea(idDiccionario, idLineaEnDiccionario);
	}	
	
	/**
	 *  Apartir del id del diccionario editable crear una entrada nueva en el diccionario recivido
	 * @param Id del diccionario Editable a consutlar / id de la linea en el diccionario
	 * @return valores para la linea editable
	 * */
	@BusinessOperation("plugin.diccionarios.diccionarioEditableManager.nuevoDiccionarioDatosLinea")
	@Transactional(readOnly = false)
	public void nuevoDiccionarioDatosLinea(DICDtoValorDiccionario dto) {
		super.nuevoDiccionarioDatosLinea(dto);
	}
	
	/**
	 *  Apartir del id del diccionario editable y del id de la linea a editar
	 * guardar los valores del dto recivido
	 * @param Id del diccionario Editable a consutlar / id de la linea en el diccionario
	 * @return valores para la linea editable
	 * */
	@BusinessOperation("plugin.diccionarios.diccionarioEditableManager.editarDiccionarioDatosLinea")
	@Transactional(readOnly = false)
	public void editarDiccionarioDatosLinea(DICDtoValorDiccionario dto) {
		super.editarDiccionarioDatosLinea(dto);
	}
	
	
	/**
	 *  Devuelve el log de un diccionario editable
	 * @return Lista de sucesos sobre un diccionario editable
	 *  
	 * */
	@BusinessOperation("plugin.diccionarios.diccionarioEditableManager.listarSucesosDiccionarioEditable")
	public List<DICDiccionarioEditableLog> listarSucesosDiccionarioEditable(Long idDiccionarioEditable){
		return super.listarSucesosDiccionarioEditable(idDiccionarioEditable);
	}
	
	/**
	 * Elimina un valor de un diccionario de datos editable
	 */
	@BusinessOperation("plugin.diccionarios.diccionarioEditableManager.eliminarDiccionarioDatosLinea")
	@Transactional(readOnly = false)
	public void eliminarDiccionarioDatosLinea(Long id,Long idValor){
		super.eliminarDiccionarioDatosLinea(id,idValor);
	}

	@Override
	protected AbstractDao<DICDiccionarioEditable, Long> getDiccionarioDao() {
		return diccionarioEditableDao;
	}

	@Override
	protected DICDiccionarioEditableLogDaoInterface<DICDiccionarioEditableLog, Long> getLogDao() {
		return diccionarioEditableLogDao;
	}

//	@Override
//	protected UsuarioManager getUsuarioManager() {
//		return usuarioManager;
//	}
	
	@BusinessOperation("plugin.diccionarios.web.diccionariosDatos.buttons.left")
	List<DynamicElement> getButtonConfiguracionDespachoExternoLeft() {
		List<DynamicElement> l = proxyFactory.proxy(DynamicElementApi.class)
				.getDynamicElements(
						"plugin.diccionarios.web.diccionariosDatos.buttons.left",
						null);
		if (l == null)
			return new ArrayList<DynamicElement>();
		else
			return l;
	}

	@BusinessOperation("plugin.diccionarios.web.diccionariosDatos.buttons.right")
	List<DynamicElement> getButtonsConfiguracionDespachoExternoRight() {
		List<DynamicElement> l =  proxyFactory.proxy(DynamicElementApi.class).getDynamicElements(
				"plugin.diccionarios.web.diccionariosDatos.buttons.right", null);
		if (l == null)
			return new ArrayList<DynamicElement>();
		else
			return l;
	}
	
}
