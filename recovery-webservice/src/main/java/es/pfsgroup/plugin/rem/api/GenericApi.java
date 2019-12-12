package es.pfsgroup.plugin.rem.api;

import java.util.List;
import java.util.Set;

import org.springframework.ui.ModelMap;

import es.capgemini.devon.dto.WebDto;
import es.capgemini.pfs.direccion.model.Localidad;
import es.capgemini.pfs.multigestor.model.EXTDDTipoGestor;
import es.capgemini.pfs.procesosJudiciales.model.TipoJuzgado;
import es.pfsgroup.commons.utils.api.BusinessOperationDefinition;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.model.DDUnidadPoblacional;
import es.pfsgroup.plugin.rem.model.AuthenticationData;
import es.pfsgroup.plugin.rem.model.DtoDiccionario;
import es.pfsgroup.plugin.rem.model.DtoLocalidadSimple;
import es.pfsgroup.plugin.rem.model.DtoMenuItem;
import es.pfsgroup.plugin.rem.model.DtoUsuarios;
import es.pfsgroup.plugin.rem.model.Ejercicio;
import es.pfsgroup.plugin.rem.model.dd.DDComiteAlquiler;
import es.pfsgroup.plugin.rem.model.dd.DDComiteSancion;
import es.pfsgroup.plugin.rem.model.dd.DDCondicionIndicadorPrecio;
import es.pfsgroup.plugin.rem.model.dd.DDMotivoRechazoOferta;
import es.pfsgroup.plugin.rem.model.dd.DDSubcartera;
import es.pfsgroup.plugin.rem.model.dd.DDSubestadoGestion;
import es.pfsgroup.plugin.rem.model.dd.DDSubfasePublicacion;
import es.pfsgroup.plugin.rem.model.dd.DDSubtipoActivo;
import es.pfsgroup.plugin.rem.model.dd.DDSubtipoCarga;
import es.pfsgroup.plugin.rem.model.dd.DDSubtipoClaseActivoBancario;
import es.pfsgroup.plugin.rem.model.dd.DDSubtipoGasto;
import es.pfsgroup.plugin.rem.model.dd.DDSubtipoTrabajo;
import es.pfsgroup.plugin.rem.model.dd.DDTipoAgrupacion;
import es.pfsgroup.plugin.rem.model.dd.DDTipoBloqueo;
import es.pfsgroup.plugin.rem.model.dd.DDTipoCalculo;
import es.pfsgroup.plugin.rem.model.dd.DDTipoComercializacion;
import es.pfsgroup.plugin.rem.model.dd.DDTipoDocumentoTributos;
import es.pfsgroup.plugin.rem.model.dd.DDTipoProveedor;
import es.pfsgroup.plugin.rem.model.dd.DDTipoTituloActivoTPA;
import es.pfsgroup.plugin.rem.model.dd.DDTipoTrabajo;
import es.pfsgroup.plugin.rem.model.dd.DDTiposPorCuenta;


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
	public List<DtoMenuItem> getMenuItems(String tipo);	
	
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
	
	@BusinessOperationDefinition("genericManager.getComboTipoGestorActivo")
	public List<EXTDDTipoGestor> getComboTipoGestorByActivo(WebDto webDto, ModelMap model, String idActivo);

	List<EXTDDTipoGestor> getComboTipoGestorFiltrado(Set<String> tipoGestorCodigos);

	@BusinessOperationDefinition("genericManager.getComboTipoGestorOfertas")
	public List<EXTDDTipoGestor> getComboTipoGestorOfertas();

	/**
	 * Devuelve los tipos de trabajo, filtrando los del tipo que no deben crearse para un activo dado
	 * Si no se pasa ningun activo, devuelve la lista completa de tipos.
	 * @return
	 */
	@BusinessOperationDefinition("genericManager.getComboTipoTrabajoCreaFiltered")
	public List<DDTipoTrabajo> getComboTipoTrabajoCreaFiltered(String idActivo);
	
	/**
	 * Devuelve los subtipos de trabajo del tipo que recibe
	 * @param tipoTrabajoCodigo
	 * @return
	 */
	@BusinessOperationDefinition("genericManager.getComboSubtipoTrabajo")
	public List<DDSubtipoTrabajo> getComboSubtipoTrabajo(String tipoTrabajoCodigo, Long idActivo);
	
	/**
	 * Devuelve los subtipos de trabajo del tipo que recibe, pero no incluye los de tipo Precio (a excepcion 
	 * de los subtipos (Carga, bloqueo y desbloqueo) del trámite de actualización de precios ).
	 * @param tipoTrabajoCodigo
	 * @return
	 */
	@BusinessOperationDefinition("genericManager.getComboSubtipoTrabajoCreaFiltered")
	public List<DDSubtipoTrabajo> getComboSubtipoTrabajoCreaFiltered(String tipoTrabajoCodigo);
	
	/**
	 * Devuelve los subtipos de trabajo del tipo que recibe y que sólo son tarificados
	 * @param tipoTrabajoCodigo
	 * @return
	 */
	@BusinessOperationDefinition("genericManager.getComboSubtipoTrabajoTarificado")
	public List<DDSubtipoTrabajo> getComboSubtipoTrabajoTarificado(String tipoTrabajoCodigo);	
	
	/**
	 * Devuelve los subtipos de clase bancarios, para un codigo de tipo de clase bancario
	 * @param tipoClaseActivoCodigo
	 * @return
	 */
	@BusinessOperationDefinition("genericManager.getComboSubtipoClaseActivo")
	public List<DDSubtipoClaseActivoBancario> getComboSubtipoClaseActivo(String tipoClaseActivoCodigo);

	@BusinessOperationDefinition("genericManager.getComboTipoJuzgadoPlaza")
	public List<TipoJuzgado> getComboTipoJuzgadoPlaza(Long idPlaza);

	public List<DDTipoProveedor> getDiccionarioSubtipoProveedor(String codigoTipoProveedor);
	
	@BusinessOperationDefinition("genericManager.getComboSubtipoGasto")
	public List<DDSubtipoGasto> getComboSubtipoGasto(String codigoTipoGasto);

	/**
	 * Este método recibe un código de provincia y obtiene una lista de unidades poblacionales
	 * filtradas por la localidad de la provincia.
	 * 
	 * @param codigoProvincia : codigo de la provincia.
	 * @return Devuelve una lista de unidades poblacionales.
	 */
	public List<DDUnidadPoblacional> getUnidadPoblacionalByProvincia(String codigoProvincia);

	/**
	 * Este método obtiene una lista completa de todas las localidades sin filtrar.
	 * 
	 * @return Devuelve una lista de localidades.
	 */
	public List<DtoLocalidadSimple> getComboMunicipioSinFiltro();
	
	@BusinessOperationDefinition("genericManager.getComboEjercicioContabilidad")
	public List<Ejercicio> getComboEjercicioContabilidad();
	
	/**
	 * Devuelve un diccionario de comités filtrado por cartera
	 * @param carteraCodigo
	 * @return
	 */
	public List<DDComiteSancion> getComitesByCartera(String carteraCodigo, String subcarteraCodigo);

	/**
	 * Devuelve una lista de proveedores para mostrar en un combo, filtrado por subtipo proveedor
	 * @param subtipoProveedorCodigo
	 * @return
	 */
	public List<DtoDiccionario> getComboProveedorBySubtipo(String subtipoProveedorCodigo);
	
	/**
	 * Devuelve una Lista de tipos de destino comercial (Confunde el nombre con el diccionario, preguntar a Fernando)
	 * filtrada, ya que 
	 * @return
	 */
	public List<DDTipoComercializacion> getComboTipoDestinoComercialCreaFiltered();

	
	public List<DDTiposPorCuenta> getDiccionarioPorCuenta(String tipoCodigo);
	
	public List<DDTipoCalculo> getDiccionarioByTipoOferta(String diccionario, String codTipoOferta);

	/**
	 * Devuelve una lista de todos aquellos proveedores que dan de alta gastos de forma masiva.
	 * @return
	 */
	public List<DtoDiccionario> getComboGestoriasGasto();

	/**
	 * Este método obtiene una lista con los datos filtrados por el código del área de bloqueo.
	 * 
	 * @param areaCodigo : código a filtrar.
	 * @return Devuelve una lista con los resultados filtrados.
	 */
	public List<DDTipoBloqueo> getDiccionarioTipoBloqueo(String areaCodigo);

	/**
	 * Este método obtiene una lista con los datos filtrados por el código de cartera.
	 * 
	 * @param codigoCartera : código de cartera.
	 * @return Devuelve una lista con los resultados filtrados.
	 */
	public List<DDCondicionIndicadorPrecio> getIndicadorCondicionPrecioFiltered(String codigoCartera);

	/**
	 * Este método obtiene una lista con las carteras filtradas por el código de cartera.
	 * 
	 * @param codigoCartera : código de cartera.
	 * @return Devuelve una lista con las subcarteras
	 */
	public List<DDSubcartera> getComboSubcartera(String codigoCartera);

	/**
	 * Motivos de anulacion/denegacion de la Oferta
	 * @param tipoRechazoOfertaCodigo
	 * @return
	 */
	List<DDMotivoRechazoOferta> getComboMotivoRechazoOferta(String tipoRechazoOfertaCodigo, Long idOferta);

	List<DDComiteSancion> getComitesByIdExpediente(String expediente);
		
	
	public List<DDComiteAlquiler> getComitesAlquilerByCartera(Long idActivo);
	
	/**
	 * Devuelve una lista de comites alquiler por el código de cartera.
	 * @param carteraCodigo
	 * @return
	 */
	public List<DDComiteAlquiler> getComitesAlquilerByCarteraCodigo(String carteraCodigo);
	/**
	 * Este método obtiene una lista con los tipos de agrupaciones. 
	 * Filtrará los resultados dependiendo del tipo de gestor del usuario logado
	 * 
	 * @return Devuelve una lista de tipos de agrupaciones
	 */
	public List<DDTipoAgrupacion> getComboTipoAgrupacion();
	
	/**
	 * Este método obtiene una lista con todos los tipos de agrupaciones.
	 * 
	 * @return Devuelve una lista de tipos de agrupaciones
	 */
	public List<DDTipoAgrupacion> getTodosComboTipoAgrupacion();
	
	/**
	 * Este método obtiene una lista con todos los tipos de agrupaciones.
	 * 
	 * @return Devuelve una lista de tipos de agrupaciones
	 */
	public List<DtoUsuarios> getTodosComboUsuarios();

	/**
	 * Devuelve los tipos de titulo, filtrando por la posesión del activo
	 * Si no se pasa ningun activo, devuelve la lista completa de tipos.
	 * @return
	 */
	public List<DDTipoTituloActivoTPA> getComboTipoTituloActivoTPA(Long idActivo);

	public List<DDTipoDocumentoTributos> getDiccionarioTiposDocumentoTributo();

	/**
	 * Devuelve las subfases correspondientes de la fase seleccionada
	 * @param idActivo
	 * @return Devuelve las subfases correspondientes de la fase seleccionada
	 */
	List<DDSubfasePublicacion> getComboSubfase(Long idActivo);
	
	/**
	 * Devuelve las subfases correspondientes de la fase seleccionada
	 * @param codFase
	 * @return Devuelve las subfases correspondientes de la fase seleccionada
	 */
	List<DDSubfasePublicacion> getComboSubfaseFiltered(String codFase);

	List<DDSubestadoGestion> getComboSubestadoGestionFiltered(String codLocalizacion);

	public DDSubestadoGestion getSubestadoGestion(Long idActivo);
}
