package es.pfsgroup.plugin.rem.api;

import java.util.List;

import net.sf.json.JSONArray;
import es.capgemini.pfs.direccion.model.Localidad;
import es.capgemini.pfs.multigestor.model.EXTDDTipoGestor;
import es.capgemini.pfs.procesosJudiciales.model.TipoJuzgado;
import es.capgemini.pfs.procesosJudiciales.model.TipoPlaza;
import es.pfsgroup.commons.utils.api.BusinessOperationDefinition;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.model.DDUnidadPoblacional;
import es.pfsgroup.plugin.rem.model.AuthenticationData;
import es.pfsgroup.plugin.rem.model.DtoDiccionario;
import es.pfsgroup.plugin.rem.model.dd.DDSubtipoActivo;
import es.pfsgroup.plugin.rem.model.dd.DDSubtipoCarga;
import es.pfsgroup.plugin.rem.model.dd.DDSubtipoTrabajo;
import es.pfsgroup.plugin.rem.model.dd.DDTipoTrabajo;


public interface GenericApi {
    

	/**
	 * Devuelve la información del usuario identificado
	 * @return
	 */
	@BusinessOperationDefinition("genericManager.getAuthenticationData")
	public AuthenticationData getAuthenticationData() ;
	
	/**
	 * 
	 * @param tipo 
	 * @return Devuelve los items permitidos de menú según tipo y usuario identificado
	 */
	@BusinessOperationDefinition("genericManager.getMenuItems")
	public JSONArray getMenuItems(String tipo);	
	
	/**
	 * Devuelve los municipios de la provincia que recibe
	 * @param codigoProvincia
	 * @return
	 */
	@BusinessOperationDefinition("genericManager.getComboMunicipio")
	public List<Localidad> getComboMunicipio(String codigoProvincia);
	
	/**
	 * Devuelve los subtipos de un activo del tipo que recibe
	 * @param codigoTipo
	 * @return
	 */
	@BusinessOperationDefinition("genericManager.getComboSubtipoActivo")
	public List<DDSubtipoActivo> getComboSubtipoActivo(String codigoTipo);	
	
	/**
	 * Devuelve los subtipos de carga del tipo que recibe
	 * @param codigoTipo
	 * @return
	 */
	@BusinessOperationDefinition("genericManager.getComboSubtipoCarga")
	public List<DDSubtipoCarga> getComboSubtipoCarga(String codigoTipo);
	
	/**
	 * 
	 * @param diccionario
	 * @return
	 */
	@BusinessOperationDefinition("genericManager.getComboEspecial")
	public List<DtoDiccionario> getComboEspecial(String diccionario);
	
	@BusinessOperationDefinition("genericManager.getComboTipoGestor")
	public List<EXTDDTipoGestor> getComboTipoGestor();

	/**
	 * Devuelve los tipos de trabajo, filtrando los del tipo que no deben crearse
	 * @return
	 */
	@BusinessOperationDefinition("genericManager.getComboTipoTrabajoCreaFiltered")
	public List<DDTipoTrabajo> getComboTipoTrabajoCreaFiltered();
	
	/**
	 * Devuelve los subtipos de trabajo del tipo que recibe
	 * @param tipoTrabajoCodigo
	 * @return
	 */
	@BusinessOperationDefinition("genericManager.getComboSubtipoTrabajo")
	public List<DDSubtipoTrabajo> getComboSubtipoTrabajo(String tipoTrabajoCodigo);
	
	/**
	 * Devuelve los subtipos de trabajo del tipo que recibe y que sólo son tarificados
	 * @param tipoTrabajoCodigo
	 * @return
	 */
	@BusinessOperationDefinition("genericManager.getComboSubtipoTrabajoTarificado")
	public List<DDSubtipoTrabajo> getComboSubtipoTrabajoTarificado(String tipoTrabajoCodigo);	
	
	

	@BusinessOperationDefinition("genericManager.getComboTipoJuzgadoPlaza")
	public List<TipoJuzgado> getComboTipoJuzgadoPlaza(Long idPlaza); 

}

	  
	    