package es.pfsgroup.plugin.rem.api.impl;

import java.io.File;
import java.io.FileNotFoundException;
import java.lang.reflect.InvocationTargetException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.List;
import java.util.Scanner;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;
import net.sf.sojo.interchange.json.JsonParser;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import es.capgemini.devon.utils.MessageUtils;
import es.capgemini.pfs.direccion.model.Localidad;
import es.capgemini.pfs.multigestor.model.EXTDDTipoGestor;
import es.capgemini.pfs.procesosJudiciales.model.TipoJuzgado;
import es.capgemini.pfs.users.domain.Funcion;
import es.capgemini.pfs.users.domain.Perfil;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.api.BusinessOperationDefinition;
import es.pfsgroup.commons.utils.bo.BusinessOperationOverrider;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.OrderType;
import es.pfsgroup.commons.utils.dao.abm.Order;
import es.pfsgroup.framework.paradise.utils.BeanUtilNotNull;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.model.DDUnidadPoblacional;
import es.pfsgroup.plugin.rem.adapter.GenericAdapter;
import es.pfsgroup.plugin.rem.api.ActivoApi;
import es.pfsgroup.plugin.rem.api.GenericApi;
import es.pfsgroup.plugin.rem.model.ActivoPropietario;
import es.pfsgroup.plugin.rem.model.ActivoProveedor;
import es.pfsgroup.plugin.rem.model.AuthenticationData;
import es.pfsgroup.plugin.rem.model.DtoDiccionario;
import es.pfsgroup.plugin.rem.model.Ejercicio;
import es.pfsgroup.plugin.rem.model.PerimetroActivo;
import es.pfsgroup.plugin.rem.model.dd.DDComiteSancion;
import es.pfsgroup.plugin.rem.model.dd.DDEntidadProveedor;
import es.pfsgroup.plugin.rem.model.dd.DDSubtipoActivo;
import es.pfsgroup.plugin.rem.model.dd.DDSubtipoCarga;
import es.pfsgroup.plugin.rem.model.dd.DDSubtipoClaseActivoBancario;
import es.pfsgroup.plugin.rem.model.dd.DDSubtipoGasto;
import es.pfsgroup.plugin.rem.model.dd.DDSubtipoTrabajo;
import es.pfsgroup.plugin.rem.model.dd.DDTipoProveedor;
import es.pfsgroup.plugin.rem.model.dd.DDTipoTrabajo;


@Service("genericManager")
public class GenericManager extends BusinessOperationOverrider<GenericApi> implements GenericApi {

	SimpleDateFormat ft = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss");
	
	protected static final Log logger = LogFactory.getLog(GenericManager.class);

    @Autowired
    private GenericABMDao genericDao;
    
    @Autowired
    private GenericAdapter adapter;
    
    @Autowired
    private ActivoApi activoApi;
    
    BeanUtilNotNull beanUtilNotNull = new BeanUtilNotNull();    

	@Override
	public String managerName() {
		return "genericManager";
	}
	
	@Override
	@BusinessOperationDefinition("genericManager.getAuthenticationData")
	public AuthenticationData getAuthenticationData() {
		
		Usuario usuario = adapter.getUsuarioLogado();
		
		List<String> authorities = new ArrayList<String>();
		List<String> roles = new ArrayList<String>();
		
		for (Perfil perfil : usuario.getPerfiles()) {
            for (Funcion funcion : perfil.getFunciones()) {
            	authorities.add(funcion.getDescripcion());
            }            
            roles.add(perfil.getCodigo());
        }		
		
		AuthenticationData authData = new AuthenticationData();
		
		authData.setUserName(usuario.getApellidoNombre());
		authData.setAuthorities(authorities);
		authData.setUserId(usuario.getId());
		authData.setRoles(roles);
		
		return authData;
		
	}	
	
	@Override
	@BusinessOperationDefinition("genericManager.getMenuItems")
	public JSONArray getMenuItems(String tipo) {
		
		AuthenticationData authData =  getAuthenticationData();
		JsonParser jsonParser = new JsonParser(); 
		JSONArray menuItemsPerm = new JSONArray();
		// Buscamos el fichero json que incluye todas las opciones del menú
		File menuItemsJsonFile = new File(getClass().getResource("/").getPath()+"menuitems_"+tipo+"_"+MessageUtils.DEFAULT_LOCALE.getLanguage()+".json");
				
		Scanner scan = null;
		Object obj = null;

			
		// Leemos el fichero completo
		try {
			scan = new Scanner(menuItemsJsonFile).useDelimiter("#");
		} catch (FileNotFoundException e) {
			e.printStackTrace();
		}
		
		// Lo convertimos en un object y posteriormente en un jsonobject para iterar sobre los elementos de menu y comprobar
		// si el usuario tiene permisos para esa opción.
		obj = jsonParser.parse(scan.next());

		JSONObject jsonObject = JSONObject.fromObject(obj);
		JSONArray menuItems = (JSONArray) jsonObject.get("data");			
		
		for (Object item: menuItems) {
			String secFunPermToRender = null;
			JSONObject itemObject = JSONObject.fromObject(item);
			
			if(itemObject.containsKey("secFunPermToRender")) {
				secFunPermToRender = itemObject.getString("secFunPermToRender");
			}
			
			if(secFunPermToRender == null || authData.getAuthorities().contains(secFunPermToRender)) {
				menuItemsPerm.add(item);
			}
		}
	
			
		return menuItemsPerm;		
		
	}	
	
	@Override
	@BusinessOperationDefinition("genericManager.getComboMunicipio")
	public List<Localidad> getComboMunicipio(String codigoProvincia) {
		
		Order order = new Order(GenericABMDao.OrderType.ASC, "descripcion");
		Filter filter = genericDao.createFilter(FilterType.EQUALS, "provincia.codigo", codigoProvincia);
		
		return (List<Localidad>) genericDao.getListOrdered(Localidad.class, order, filter);
	}
	
	@Override
	public List<Localidad> getComboMunicipioSinFiltro() {
		Order order = new Order(GenericABMDao.OrderType.ASC, "descripcion");
		
		return (List<Localidad>) genericDao.getListOrdered(Localidad.class, order);
	}

	@Override
	public List<DDUnidadPoblacional> getUnidadPoblacionalByProvincia(String codigoProvincia) {
		List<Localidad> localidades = this.getComboMunicipio(codigoProvincia);
		
		List<DDUnidadPoblacional> unidadesPoblacionales = new ArrayList<DDUnidadPoblacional>();
		
		Order order = new Order(GenericABMDao.OrderType.ASC, "descripcion");
		
		for(Localidad l : localidades) {
			Filter filterUnidadPoblacional = genericDao.createFilter(FilterType.EQUALS, "localidad.id", l.getId());
			List<DDUnidadPoblacional> lista = (List<DDUnidadPoblacional>) genericDao.getListOrdered(DDUnidadPoblacional.class, order, filterUnidadPoblacional);
			
			if(!Checks.estaVacio(lista)) {
				unidadesPoblacionales.addAll(lista);
			}
		}
		
		
		return unidadesPoblacionales;
	}
	
	@Override
	@BusinessOperationDefinition("genericManager.getDiccionarioTipoProveedor")//DDTipoProveedor
	public List<DDTipoProveedor> getDiccionarioSubtipoProveedor(String codigoTipoProveedor) {
		List<DDTipoProveedor> listaTipoProveedor = new ArrayList<DDTipoProveedor>();
		
		if(!Checks.esNulo(codigoTipoProveedor)){
			Filter filterTipo = genericDao.createFilter(FilterType.EQUALS, "codigo", codigoTipoProveedor);
			DDEntidadProveedor tipo = (DDEntidadProveedor) genericDao.get(DDEntidadProveedor.class, filterTipo);

			if(!Checks.esNulo(tipo)) {
				Order order = new Order(GenericABMDao.OrderType.ASC, "id");
				Filter filterSubtipo = genericDao.createFilter(FilterType.EQUALS, "tipoEntidadProveedor.codigo", tipo.getCodigo());
				listaTipoProveedor = (List<DDTipoProveedor>) genericDao.getListOrdered(DDTipoProveedor.class, order, filterSubtipo);
			}
		}
		
		return listaTipoProveedor;
	}

	@Override
	@BusinessOperationDefinition("genericManager.getComboSubtipoActivo")
	public List<DDSubtipoActivo> getComboSubtipoActivo(String codigoTipo) {
		
		Order order = new Order(GenericABMDao.OrderType.ASC, "descripcion");			
		Filter filter = genericDao.createFilter(FilterType.EQUALS, "tipoActivo.codigo", codigoTipo);
		return (List<DDSubtipoActivo>) genericDao.getListOrdered(DDSubtipoActivo.class, order, filter);
		
	}
	
	@Override
	@BusinessOperationDefinition("genericManager.getComboSubtipoCarga")
	public List<DDSubtipoCarga> getComboSubtipoCarga(String codigoTipo) {
		
		Order order = new Order(GenericABMDao.OrderType.ASC, "descripcion");			
		Filter filter = genericDao.createFilter(FilterType.EQUALS, "tipoCargaActivo.codigo", codigoTipo);
		return (List<DDSubtipoCarga>) genericDao.getListOrdered(DDSubtipoCarga.class, order, filter);
		
	}
	
	@Override
	@BusinessOperationDefinition("genericManager.getComboEspecial")
	public List<DtoDiccionario> getComboEspecial(String diccionario) {
		List<DtoDiccionario> listaDD = new ArrayList<DtoDiccionario>();
		if(diccionario.equals("DDSeguros"))
		{
			Filter filtroBorrado = genericDao.createFilter(FilterType.EQUALS, "auditoria.borrado", false);
			Filter filtroAseguradora = genericDao.createFilter(FilterType.EQUALS, "tipoProveedor.codigo", DDTipoProveedor.COD_ASEGURADORA);
			Order order = new Order(OrderType.ASC, "nombre");
			List<ActivoProveedor> listaSeguros = genericDao.getListOrdered(ActivoProveedor.class, order, filtroBorrado, filtroAseguradora);
			
			for(ActivoProveedor seguro: listaSeguros){
				DtoDiccionario seguroDD = new DtoDiccionario();;
				try {
					beanUtilNotNull.copyProperty(seguroDD, "id", seguro.getId());
					beanUtilNotNull.copyProperty(seguroDD, "descripcion", seguro.getNombre());
				} catch (IllegalAccessException e) {
					e.printStackTrace();
				} catch (InvocationTargetException e) {
					e.printStackTrace();
				}
				listaDD.add(seguroDD);
			}
		}
		else if(diccionario.equals("DDPropietario")) {
			listaDD = this.getListDtoPropietarioDiccionario();
		}
		
		return listaDD;
	}
	
	@Override
	@BusinessOperationDefinition("genericManager.getComboTipoGestor")
	public List<EXTDDTipoGestor> getComboTipoGestor(){
		
		Order order = new Order(GenericABMDao.OrderType.ASC, "descripcion");
		
		return (List<EXTDDTipoGestor>) genericDao.getListOrdered(EXTDDTipoGestor.class, order, genericDao.createFilter(FilterType.EQUALS, "borrado", false));
	}
	
	@Override
	@BusinessOperationDefinition("genericManager.getComboTipoTrabajoCreaFiltered")
	public List<DDTipoTrabajo> getComboTipoTrabajoCreaFiltered(String idActivo) {
		
		List<DDTipoTrabajo> tiposTrabajo = new ArrayList<DDTipoTrabajo>();
		List<DDTipoTrabajo> tiposTrabajoFiltered = new ArrayList<DDTipoTrabajo>();
		tiposTrabajo.addAll((List<DDTipoTrabajo>)(List)adapter.getDiccionario("tiposTrabajo"));
				
		if(!Checks.esNulo(idActivo)){
			Long activo = Long.parseLong(idActivo);
			
			for(DDTipoTrabajo tipoTrabajo : tiposTrabajo){
	
				// No se pueden crear tipos de trabajo ACTUACION TECNICA ni OBTENCION DOCUMENTAL
				// cuando el activo no tiene condicion de gestion en el perimetro (check gestion = false)
				if(DDTipoTrabajo.CODIGO_ACTUACION_TECNICA.equals(tipoTrabajo.getCodigo())
						|| DDTipoTrabajo.CODIGO_OBTENCION_DOCUMENTAL.equals(tipoTrabajo.getCodigo())){
					// Si no hay registro en BBDD de perimetro, el get nos devuelve un PerimetroActivo nuevo
					// con todas las condiciones de perimetro activas
					PerimetroActivo perimetroActivo = activoApi.getPerimetroByIdActivo(activo);
				
					if(!Checks.esNulo(perimetroActivo.getAplicaGestion()) && perimetroActivo.getAplicaGestion() == 1){
						// Activo con Gestion en perimetro
						tiposTrabajoFiltered.add(tipoTrabajo);
					}
				} else {
					// El resto de tipos si se pueden crear
					tiposTrabajoFiltered.add(tipoTrabajo);
				}
			}
			
			return tiposTrabajoFiltered;
		} else {
			return tiposTrabajo;
		}
	}
	
	@Override
	@BusinessOperationDefinition("genericManager.getComboSubtipoTrabajo")
	public List<DDSubtipoTrabajo> getComboSubtipoTrabajo(String tipoTrabajoCodigo) {
		
		Order order = new Order(GenericABMDao.OrderType.ASC, "descripcion");			
		Filter filter = genericDao.createFilter(FilterType.EQUALS, "tipoTrabajo.codigo", tipoTrabajoCodigo);
		return (List<DDSubtipoTrabajo>) genericDao.getListOrdered(DDSubtipoTrabajo.class, order, filter);

	}
	
	@Override
	@BusinessOperationDefinition("genericManager.getComboSubtipoTrabajo")
	public List<DDSubtipoTrabajo> getComboSubtipoTrabajoCreaFiltered(String tipoTrabajoCodigo) {
		
		Order order = new Order(GenericABMDao.OrderType.ASC, "descripcion");			
		Filter filter = genericDao.createFilter(FilterType.EQUALS, "tipoTrabajo.codigo", tipoTrabajoCodigo);
		List<DDSubtipoTrabajo> listaSubtipos = (List<DDSubtipoTrabajo>) genericDao.getListOrdered(DDSubtipoTrabajo.class, order, filter);
		List<DDSubtipoTrabajo> listaSubtiposFiltered = new ArrayList<DDSubtipoTrabajo>();
		
		for(DDSubtipoTrabajo subtipo : listaSubtipos) {
			if(!DDTipoTrabajo.CODIGO_PRECIOS.equals(subtipo.getCodigoTipoTrabajo())) {
					return listaSubtipos;
			}
			// Solo se pueden crear por la pantalla de crear trabajo estos subtipos relacionados con precios
			else if(DDSubtipoTrabajo.CODIGO_ACTUALIZACION_PRECIOS.equals(subtipo.getCodigo()) 
					|| DDSubtipoTrabajo.CODIGO_PRECIOS_BLOQUEAR_ACTIVOS.equals(subtipo.getCodigo())
					|| DDSubtipoTrabajo.CODIGO_PRECIOS_DESBLOQUEAR_ACTIVOS.equals(subtipo.getCodigo())) {
						listaSubtiposFiltered.add(subtipo);
			}
		}

		return listaSubtiposFiltered;
	}
	
	@Override
	@BusinessOperationDefinition("genericManager.getComboSubtipoTrabajoTarificado")
	public List<DDSubtipoTrabajo> getComboSubtipoTrabajoTarificado(String tipoTrabajoCodigo) {
		//Generar una lista de todos los trabajos relacionados con el tipo de trabajo que
		//llega y finalmente crear otra nueva y copiarla la primera sin aquellos que sean de códigos no tarificados
		Order order = new Order(GenericABMDao.OrderType.ASC, "descripcion");			
		Filter filter = genericDao.createFilter(FilterType.EQUALS, "tipoTrabajo.codigo", tipoTrabajoCodigo);
		List<DDSubtipoTrabajo> subtipos = (List<DDSubtipoTrabajo>) genericDao.getListOrdered(DDSubtipoTrabajo.class, order, filter);
		List<DDSubtipoTrabajo> subtiposTarificados = new ArrayList<DDSubtipoTrabajo>();
		for (DDSubtipoTrabajo subtipo : subtipos)
		{
		  if(!subtipo.getCodigo().equalsIgnoreCase(DDSubtipoTrabajo.CODIGO_AT_OBRA_MENOR_NO_TARIFICADA) && !subtipo.getCodigo().equalsIgnoreCase(DDSubtipoTrabajo.CODIGO_AT_CONTROL_ACTUACIONES) && !subtipo.getCodigo().equalsIgnoreCase(DDSubtipoTrabajo.CODIGO_AT_COLOCACION_PUERTAS) && !subtipo.getCodigo().equalsIgnoreCase(DDSubtipoTrabajo.CODIGO_AT_MOBILIARIO))
		  {	
			  subtiposTarificados.add(subtipo);
		  }
		}
		return subtiposTarificados;

	}
	
	@Override
	@BusinessOperationDefinition("genericManager.getComboSubtipoClaseActivo")
	public List<DDSubtipoClaseActivoBancario> getComboSubtipoClaseActivo(String tipoClaseActivoCodigo) {
		
		//Generar una lista de todos los subtipos de clase bancarios relacionados con el tipo de clase bancario
		Order order = new Order(GenericABMDao.OrderType.ASC, "descripcion");			
		Filter filter = genericDao.createFilter(FilterType.EQUALS, "claseActivo.codigo", tipoClaseActivoCodigo);

		return (List<DDSubtipoClaseActivoBancario>) 
				genericDao.getListOrdered(DDSubtipoClaseActivoBancario.class, order, filter);

	}
		
	@Override
	@BusinessOperationDefinition("genericManager.getComboTipoJuzgadoPlaza")
	public List<TipoJuzgado> getComboTipoJuzgadoPlaza(Long idPlaza){
		
		Order order = new Order(GenericABMDao.OrderType.ASC, "descripcion");
		Filter filter = genericDao.createFilter(FilterType.EQUALS, "plaza.id", idPlaza);
		return (List<TipoJuzgado>) genericDao.getListOrdered(TipoJuzgado.class, order, filter);
	}
	
	@Override
	@BusinessOperationDefinition("genericManager.getComboSubtipoGasto")
	public List<DDSubtipoGasto> getComboSubtipoGasto(String codigoTipoGasto) {
		
		Order order = new Order(GenericABMDao.OrderType.ASC, "descripcion");			
		Filter filter = genericDao.createFilter(FilterType.EQUALS, "tipoGasto.codigo", codigoTipoGasto);
		return (List<DDSubtipoGasto>) genericDao.getListOrdered(DDSubtipoGasto.class, order, filter);
		
	}
	
	@Override
	@BusinessOperationDefinition("genericManager.getComboEjercicioContabilidad")
	public List<Ejercicio> getComboEjercicioContabilidad(){
		
		Order order = new Order(GenericABMDao.OrderType.ASC, "anyo");			
		return (List<Ejercicio>) genericDao.getListOrdered(Ejercicio.class, order);
		
	}
	
	/**
	 * Devuelve una lista de ActivoPropietario parseado en DtoDiccionario
	 * @return
	 */
	private List<DtoDiccionario> getListDtoPropietarioDiccionario() {
		
		List<DtoDiccionario> listaDD = new ArrayList<DtoDiccionario>();
		
		Filter filtroBorrado = genericDao.createFilter(FilterType.EQUALS, "auditoria.borrado", false);
		Order order = new Order(OrderType.ASC, "nombre");
		List<ActivoPropietario> listaPropietarios = genericDao.getListOrdered(ActivoPropietario.class, order, filtroBorrado);
		
		for(ActivoPropietario propietario: listaPropietarios){
			DtoDiccionario propietarioDD = new DtoDiccionario();;
			try {
				beanUtilNotNull.copyProperty(propietarioDD, "id", propietario.getId());
				beanUtilNotNull.copyProperty(propietarioDD, "descripcion", propietario.getFullName());
				beanUtilNotNull.copyProperty(propietarioDD, "codigo", propietario.getCartera().getCodigo());
			} catch (IllegalAccessException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			} catch (InvocationTargetException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			listaDD.add(propietarioDD);
		}
		
		return listaDD;
	}
	
	@Override
	public List<DDComiteSancion> getComitesByCartera(String carteraCodigo) {
		
		Order order = new Order(GenericABMDao.OrderType.ASC, "descripcion");			
		Filter filter = genericDao.createFilter(FilterType.EQUALS, "cartera.codigo", carteraCodigo);

		return (List<DDComiteSancion>) genericDao.getListOrdered(DDComiteSancion.class, order, filter);

	}
	
	@Override
	public List<DtoDiccionario> getComboProveedorBySubtipo(String subtipoProveedorCodigo ) {
			
		List<DtoDiccionario> listaDD = new ArrayList<DtoDiccionario>();

		Filter filtroBorrado = genericDao.createFilter(FilterType.EQUALS, "auditoria.borrado", false);
		Filter filtroSubtipo = genericDao.createFilter(FilterType.EQUALS, "tipoProveedor.codigo", subtipoProveedorCodigo);
		Order order = new Order(OrderType.ASC, "nombre");
		List<ActivoProveedor> lista = genericDao.getListOrdered(ActivoProveedor.class, order, filtroBorrado, filtroSubtipo);
		
		for(ActivoProveedor proveedor: lista){
			DtoDiccionario dto = new DtoDiccionario();;
			try {
				beanUtilNotNull.copyProperty(dto, "id", proveedor.getId());
				beanUtilNotNull.copyProperty(dto, "descripcion", proveedor.getNombre());
			} catch (IllegalAccessException e) {
				e.printStackTrace();
			} catch (InvocationTargetException e) {
				e.printStackTrace();
			}
			listaDD.add(dto);
		}
		
		
		return listaDD;
	}
}
