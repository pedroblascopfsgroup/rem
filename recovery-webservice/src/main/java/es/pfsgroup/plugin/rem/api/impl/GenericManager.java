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
import es.pfsgroup.plugin.rem.adapter.GenericAdapter;
import es.pfsgroup.plugin.rem.api.GenericApi;
import es.pfsgroup.plugin.rem.model.ActivoProveedor;
import es.pfsgroup.plugin.rem.model.AuthenticationData;
import es.pfsgroup.plugin.rem.model.DtoDiccionario;
import es.pfsgroup.plugin.rem.model.dd.DDEntidadProveedor;
import es.pfsgroup.plugin.rem.model.dd.DDSubtipoActivo;
import es.pfsgroup.plugin.rem.model.dd.DDSubtipoCarga;
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
			// TODO Auto-generated catch block
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
	@BusinessOperationDefinition("genericManager.getDiccionarioTipoProveedor")//DDTipoProveedor
	public List<DDTipoProveedor> getDiccionarioSubtipoProveedor(String codigoTipoProveedor) {
		Filter filterTipo = genericDao.createFilter(FilterType.EQUALS, "codigo", codigoTipoProveedor);
		DDEntidadProveedor tipo = (DDEntidadProveedor) genericDao.get(DDEntidadProveedor.class, filterTipo);
		
		String codigoTipo = null;
		
		if(!Checks.esNulo(tipo)) {
			codigoTipo = tipo.getCodigo();
		}
		
		Order order = new Order(GenericABMDao.OrderType.ASC, "id");
		Filter filterSubtipo = genericDao.createFilter(FilterType.EQUALS, "tipoEntidadProveedor.codigo", codigoTipo);
		
		return (List<DDTipoProveedor>) genericDao.getListOrdered(DDTipoProveedor.class, order, filterSubtipo);
		
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
					// TODO Auto-generated catch block
					e.printStackTrace();
				} catch (InvocationTargetException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
				listaDD.add(seguroDD);
			}
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
	public List<DDTipoTrabajo> getComboTipoTrabajoCreaFiltered() {
		
		List<DDTipoTrabajo> tiposTrabajo = new ArrayList<DDTipoTrabajo>();
		List<DDTipoTrabajo> tiposTrabajoFiltered = new ArrayList<DDTipoTrabajo>();
		tiposTrabajo.addAll((List<DDTipoTrabajo>)(List)adapter.getDiccionario("tiposTrabajo"));
		
		for(DDTipoTrabajo tipoTrabajo : tiposTrabajo){
			if(!DDTipoTrabajo.CODIGO_PRECIOS.equals(tipoTrabajo.getCodigo())){
				tiposTrabajoFiltered.add(tipoTrabajo);
			}
		}
		
		return tiposTrabajoFiltered;

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
			else if(DDSubtipoTrabajo.CODIGO_CARGA_PRECIOS.equals(subtipo.getCodigo()) 
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
	@BusinessOperationDefinition("genericManager.getComboTipoJuzgadoPlaza")
	public List<TipoJuzgado> getComboTipoJuzgadoPlaza(Long idPlaza){
		
		Order order = new Order(GenericABMDao.OrderType.ASC, "descripcion");
		Filter filter = genericDao.createFilter(FilterType.EQUALS, "plaza.id", idPlaza);
		return (List<TipoJuzgado>) genericDao.getListOrdered(TipoJuzgado.class, order, filter);
	}
		
	
}