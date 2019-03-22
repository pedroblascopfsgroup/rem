package es.pfsgroup.plugin.rem.api.impl;

import java.io.File;
import java.io.FileNotFoundException;
import java.lang.reflect.InvocationTargetException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Properties;
import java.util.Scanner;
import java.util.Set;

import javax.annotation.Resource;

import org.apache.commons.beanutils.BeanUtils;
import org.apache.commons.lang.BooleanUtils;
import org.apache.commons.lang.StringUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.hibernate.LazyInitializationException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.ui.ModelMap;

import es.capgemini.devon.dto.WebDto;
import es.capgemini.devon.utils.MessageUtils;
import es.capgemini.pfs.core.api.usuario.UsuarioApi;
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
import es.pfsgroup.plugin.recovery.coreextension.utils.api.UtilDiccionarioApi;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.model.DDUnidadPoblacional;
import es.pfsgroup.plugin.rem.activo.dao.impl.ActivoPatrimonioDaoImpl;
import es.pfsgroup.plugin.rem.adapter.GenericAdapter;
import es.pfsgroup.plugin.rem.api.ActivoApi;
import es.pfsgroup.plugin.rem.api.GenericApi;
import es.pfsgroup.plugin.rem.api.GestorActivoApi;
import es.pfsgroup.plugin.rem.api.OfertaApi;
import es.pfsgroup.plugin.rem.gestor.GestorActivoManager;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.ActivoPatrimonio;
import es.pfsgroup.plugin.rem.model.ActivoPropietario;
import es.pfsgroup.plugin.rem.model.ActivoProveedor;
import es.pfsgroup.plugin.rem.model.AuthenticationData;
import es.pfsgroup.plugin.rem.model.CarteraCondicionesPrecios;
import es.pfsgroup.plugin.rem.model.DtoDiccionario;
import es.pfsgroup.plugin.rem.model.DtoLocalidadSimple;
import es.pfsgroup.plugin.rem.model.DtoMenuItem;
import es.pfsgroup.plugin.rem.model.Ejercicio;
import es.pfsgroup.plugin.rem.model.ExpedienteComercial;
import es.pfsgroup.plugin.rem.model.GestorSustituto;
import es.pfsgroup.plugin.rem.model.Oferta;
import es.pfsgroup.plugin.rem.model.PerimetroActivo;
import es.pfsgroup.plugin.rem.model.dd.DDCartera;
import es.pfsgroup.plugin.rem.model.dd.DDComiteAlquiler;
import es.pfsgroup.plugin.rem.model.dd.DDComiteSancion;
import es.pfsgroup.plugin.rem.model.dd.DDCondicionIndicadorPrecio;
import es.pfsgroup.plugin.rem.model.dd.DDEntidadProveedor;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoProveedor;
import es.pfsgroup.plugin.rem.model.dd.DDMotivoRechazoOferta;
import es.pfsgroup.plugin.rem.model.dd.DDSubcartera;
import es.pfsgroup.plugin.rem.model.dd.DDSubtipoActivo;
import es.pfsgroup.plugin.rem.model.dd.DDSubtipoCarga;
import es.pfsgroup.plugin.rem.model.dd.DDSubtipoClaseActivoBancario;
import es.pfsgroup.plugin.rem.model.dd.DDSubtipoGasto;
import es.pfsgroup.plugin.rem.model.dd.DDSubtipoTrabajo;
import es.pfsgroup.plugin.rem.model.dd.DDTipoActivo;
import es.pfsgroup.plugin.rem.model.dd.DDTipoAgrupacion;
import es.pfsgroup.plugin.rem.model.dd.DDTipoBloqueo;
import es.pfsgroup.plugin.rem.model.dd.DDTipoCalculo;
import es.pfsgroup.plugin.rem.model.dd.DDTipoComercializacion;
import es.pfsgroup.plugin.rem.model.dd.DDTipoOferta;
import es.pfsgroup.plugin.rem.model.dd.DDTipoProveedor;
import es.pfsgroup.plugin.rem.model.dd.DDTipoRechazoOferta;
import es.pfsgroup.plugin.rem.model.dd.DDTipoTituloActivoTPA;
import es.pfsgroup.plugin.rem.model.dd.DDTipoTrabajo;
import es.pfsgroup.plugin.rem.model.dd.DDTiposPorCuenta;
import es.pfsgroup.plugin.rem.trabajo.dao.DDSubtipoTrabajoDao;
import net.sf.json.JSONArray;
import net.sf.json.JSONObject;
import net.sf.sojo.interchange.json.JsonParser;

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

	@Autowired
	private ActivoPatrimonioDaoImpl activoPatrimonio;

	@Autowired
	private UtilDiccionarioApi utilDiccionarioApi;

	@Resource
	private Properties appProperties;

	@Autowired
	private GestorActivoApi gestorActivoApi;

	@Autowired
	private DDSubtipoTrabajoDao ddSubtipoTrabajoDao;

	BeanUtilNotNull beanUtilNotNull = new BeanUtilNotNull();

	@Autowired
	private GestorActivoManager gestorEntidad;
	
	@Autowired
	private OfertaApi ofertaApi;
	
	@Autowired
	private UsuarioApi usuarioApi;

	@Override
	public String managerName() {
		return "genericManager";
	}

	@Override
	@BusinessOperationDefinition("genericManager.getAuthenticationData")
	public AuthenticationData getAuthenticationData() {
		AuthenticationData authData = new AuthenticationData();
		try{
			Usuario usuario = adapter.getUsuarioLogado();
			if (usuario != null) {
				List<String> authorities = new ArrayList<String>();
				List<String> roles = new ArrayList<String>();
				
				/**
				 * Al lanzar este método en un hilo diferente
				 * al principal da un error lazy. Recargamos en la sesión el usuario logado
				 */
				try{
					usuario.getPerfiles();
				}catch(LazyInitializationException e){
					usuario = usuarioApi.get(usuario.getId());
				}
				
	
				for (Perfil perfil : usuario.getPerfiles()) {
					for (Funcion funcion : perfil.getFunciones()) {
						authorities.add(funcion.getDescripcion());
					}
					roles.add(perfil.getCodigo());
				}
				authData.setUserName(usuario.getApellidoNombre());
				authData.setAuthorities(authorities);
				
				authData.setUserId(usuario.getId());
				authData.setRoles(roles);
				authData.setCodigoGestor(gestorEntidad.getCodigoGestorPorUsuario(usuario.getId()));
	
				authData.setEsGestorSustituto(esGestorSustituto(usuario));
			}
		}catch(LazyInitializationException e){
			logger.info(e.getMessage());
		}

		return authData;

	}

	public Integer esGestorSustituto(Usuario usuarioLogado) {
		List<GestorSustituto> ges = new ArrayList<GestorSustituto>();
		ges = genericDao.getList(GestorSustituto.class,
				genericDao.createFilter(FilterType.EQUALS, "usuarioGestorSustituto", usuarioLogado));
		Date fechaHoy = new Date();

		if (Checks.estaVacio(ges)) {
			return 0;
		} else {
			for (GestorSustituto gestor : ges) {
				if (fechaHoy.compareTo(gestor.getFechaInicio()) >= 0
						&& (Checks.esNulo(gestor.getFechaFin()) || fechaHoy.compareTo(gestor.getFechaFin()) <= 0)) {
					return 1;
				}
			}
			return 0;
		}
	}

	@Override
	@BusinessOperationDefinition("genericManager.getMenuItems")
	public List<DtoMenuItem> getMenuItems(String tipo) {

		AuthenticationData authData = getAuthenticationData();
		JsonParser jsonParser = new JsonParser();
		List<DtoMenuItem> menuItemsPerm = new ArrayList<DtoMenuItem>();
		// Buscamos el fichero json que incluye todas las opciones del menú
		File menuItemsJsonFile = new File(getClass().getResource("/").getPath() + "menuitems_" + tipo + "_"
				+ MessageUtils.DEFAULT_LOCALE.getLanguage() + ".json");

		Scanner scan = null;
		Object obj = null;

		// Leemos el fichero completo
		try {
			scan = new Scanner(menuItemsJsonFile).useDelimiter("#");
		} catch (FileNotFoundException e) {
			e.printStackTrace();
		}

		// Lo convertimos en un object y posteriormente en un jsonobject para
		// iterar sobre los elementos de menu y comprobar
		// si el usuario tiene permisos para esa opción.
		obj = jsonParser.parse(scan.next());

		JSONObject jsonObject = JSONObject.fromObject(obj);
		JSONArray menuItems = (JSONArray) jsonObject.get("data");

		for (Object item : menuItems) {
			String secFunPermToRender = null;
			JSONObject itemObject = JSONObject.fromObject(item);

			if (itemObject.containsKey("secFunPermToRender")) {
				secFunPermToRender = itemObject.getString("secFunPermToRender");
			}

			if (secFunPermToRender == null || authData.getAuthorities().contains(secFunPermToRender)) {
				DtoMenuItem menuItem = new DtoMenuItem();
				try {
					beanUtilNotNull.copyProperties(menuItem, itemObject);

				} catch (Exception e) {
					logger.error(e.getCause());
				}
				menuItemsPerm.add(menuItem);
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
	public List<DtoLocalidadSimple> getComboMunicipioSinFiltro() {
		List<DtoLocalidadSimple> listaDtoLocalidadSimple = new ArrayList<DtoLocalidadSimple>();

		Order order = new Order(GenericABMDao.OrderType.ASC, "descripcion");

		List<Localidad> listaLocalidades = genericDao.getListOrdered(Localidad.class, order);

		for (Localidad source : listaLocalidades) {
			try {
				DtoLocalidadSimple target = new DtoLocalidadSimple();
				BeanUtils.copyProperties(target, source);
				target.setCodigoProvincia(source.getProvincia().getCodigo());

				listaDtoLocalidadSimple.add(target);
			} catch (IllegalAccessException e) {
				logger.error("Error al consultar las localidades sin filtro", e);
			} catch (InvocationTargetException e) {
				logger.error("Error al consultar las localidades sin filtro", e);
			}
		}

		return listaDtoLocalidadSimple;
	}

	@Override
	public List<DDUnidadPoblacional> getUnidadPoblacionalByProvincia(String codigoProvincia) {
		List<Localidad> localidades = this.getComboMunicipio(codigoProvincia);

		List<DDUnidadPoblacional> unidadesPoblacionales = new ArrayList<DDUnidadPoblacional>();

		Order order = new Order(GenericABMDao.OrderType.ASC, "descripcion");

		for (Localidad l : localidades) {
			Filter filterUnidadPoblacional = genericDao.createFilter(FilterType.EQUALS, "localidad.id", l.getId());
			List<DDUnidadPoblacional> lista = (List<DDUnidadPoblacional>) genericDao
					.getListOrdered(DDUnidadPoblacional.class, order, filterUnidadPoblacional);

			if (!Checks.estaVacio(lista)) {
				unidadesPoblacionales.addAll(lista);
			}
		}

		return unidadesPoblacionales;
	}

	@Override
	@BusinessOperationDefinition("genericManager.getDiccionarioTipoProveedor") // DDTipoProveedor
	public List<DDTipoProveedor> getDiccionarioSubtipoProveedor(String codigoTipoProveedor) {
		List<DDTipoProveedor> listaTipoProveedor = new ArrayList<DDTipoProveedor>();

		if (!Checks.esNulo(codigoTipoProveedor)) {
			Filter filterTipo = genericDao.createFilter(FilterType.EQUALS, "codigo", codigoTipoProveedor);
			DDEntidadProveedor tipo = (DDEntidadProveedor) genericDao.get(DDEntidadProveedor.class, filterTipo);

			if (!Checks.esNulo(tipo)) {
				Order order = new Order(GenericABMDao.OrderType.ASC, "id");
				Filter filterSubtipo = genericDao.createFilter(FilterType.EQUALS, "tipoEntidadProveedor.codigo",
						tipo.getCodigo());
				listaTipoProveedor = (List<DDTipoProveedor>) genericDao.getListOrdered(DDTipoProveedor.class, order,
						filterSubtipo);
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
		if (diccionario.equals("DDSeguros") || diccionario.equals("DDSegurosVigentes")) {
			Filter filtroBorrado = genericDao.createFilter(FilterType.EQUALS, "auditoria.borrado", false);
			Filter filtroAseguradora = genericDao.createFilter(FilterType.EQUALS, "tipoProveedor.codigo",
					DDTipoProveedor.COD_ASEGURADORA);
			List<ActivoProveedor> listaSeguros = null;
			Order order = new Order(OrderType.ASC, "nombre");
			if (diccionario.equals("DDSegurosVigentes")) {
				Filter filtroVigente = genericDao.createFilter(FilterType.EQUALS, "estadoProveedor.codigo",
						DDEstadoProveedor.ESTADO_BIGENTE);
				listaSeguros = genericDao.getListOrdered(ActivoProveedor.class, order, filtroBorrado, filtroAseguradora,
						filtroVigente);
			} else {
				listaSeguros = genericDao.getListOrdered(ActivoProveedor.class, order, filtroBorrado,
						filtroAseguradora);
			}

			for (ActivoProveedor seguro : listaSeguros) {
				DtoDiccionario seguroDD = new DtoDiccionario();
				;
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
		} else if (diccionario.equals("DDPropietario")) {
			listaDD = this.getListDtoPropietarioDiccionario();
		}

		return listaDD;
	}

	@Override
	@BusinessOperationDefinition("genericManager.getComboTipoGestor")
	public List<EXTDDTipoGestor> getComboTipoGestor() {

		Order order = new Order(GenericABMDao.OrderType.ASC, "descripcion");

		return (List<EXTDDTipoGestor>) genericDao.getListOrdered(EXTDDTipoGestor.class, order,
				genericDao.createFilter(FilterType.EQUALS, "borrado", false));
	}

	@Override
	@BusinessOperationDefinition("genericManager.getComboTipoGestorActivo")
	public List<EXTDDTipoGestor> getComboTipoGestorByActivo(WebDto webDto, ModelMap model, String idActivo) {
		Order order = new Order(GenericABMDao.OrderType.ASC, "descripcion");
		List<EXTDDTipoGestor> listaTiposGestor = genericDao.getListOrdered(EXTDDTipoGestor.class, order,
				genericDao.createFilter(FilterType.EQUALS, "borrado", false));

		try {

			EXTDDTipoGestor tipoGestorEdificaciones = (EXTDDTipoGestor) utilDiccionarioApi
					.dameValorDiccionarioByCod(EXTDDTipoGestor.class, "GEDI"); // Gestor
																				// de
																				// Edificaciones
			EXTDDTipoGestor tipoGestorSuelo = (EXTDDTipoGestor) utilDiccionarioApi
					.dameValorDiccionarioByCod(EXTDDTipoGestor.class, "GSUE"); // Gestor
																				// de
																				// Suelos
			EXTDDTipoGestor tipoGestorAlquileres = (EXTDDTipoGestor) utilDiccionarioApi
					.dameValorDiccionarioByCod(EXTDDTipoGestor.class, "GALQ"); // Gestor
																				// de
																				// Alquileres
			EXTDDTipoGestor tipoSupervisorEdificaciones = (EXTDDTipoGestor) utilDiccionarioApi
					.dameValorDiccionarioByCod(EXTDDTipoGestor.class, "SUPEDI"); // Gestor
																					// de
																					// Edificaciones
			EXTDDTipoGestor tipoSupervisorSuelo = (EXTDDTipoGestor) utilDiccionarioApi
					.dameValorDiccionarioByCod(EXTDDTipoGestor.class, "SUPSUE"); // Gestor
																					// de
																					// Suelos
			EXTDDTipoGestor tipoSupervisorAlquileres = (EXTDDTipoGestor) utilDiccionarioApi
					.dameValorDiccionarioByCod(EXTDDTipoGestor.class, "SUALQ"); // Gestor
																				// de
																				// Alquileres
			// HREOS-5012 - Tipo gestores Solo de Alquiler o Solo de Compra
			EXTDDTipoGestor tipoGestorComercial = (EXTDDTipoGestor) utilDiccionarioApi
					.dameValorDiccionarioByCod(EXTDDTipoGestor.class, "GCOM"); // Gestor
																				// comercial
			EXTDDTipoGestor tipoSupervisorComercial = (EXTDDTipoGestor) utilDiccionarioApi
					.dameValorDiccionarioByCod(EXTDDTipoGestor.class, "SCOM"); // Supervisor
																				// comercial
			EXTDDTipoGestor tipoGestorComercialAlquileres = (EXTDDTipoGestor) utilDiccionarioApi
					.dameValorDiccionarioByCod(EXTDDTipoGestor.class, "GESTCOMALQ"); // Gestor
																						// comercial
																						// alquiler
			EXTDDTipoGestor tipoSupervisorComercialAlquileres = (EXTDDTipoGestor) utilDiccionarioApi
					.dameValorDiccionarioByCod(EXTDDTipoGestor.class, "SUPCOMALQ"); // Supervisor
																					// comercial
																					// alquiler
			Activo activo = activoApi.get(Long.parseLong(idActivo));
			String tipoComercializacion = activo.getTipoComercializacion().getCodigo();
			String codigoTipoActivo = activo.getTipoActivo().getCodigo();
			ActivoPatrimonio actPatrimonio = activoPatrimonio.getActivoPatrimonioByActivo(activo.getId());

			if (!Checks.esNulo(activo) && !Checks.esNulo(activo.getTipoActivo())
					&& (!Checks.esNulo(actPatrimonio) && !Checks.esNulo(actPatrimonio.getCheckHPM()))) {
				// Si el Activo NO es de tipo Suelo eliminamos el gestor de
				// Suelos de la lista

				if (actPatrimonio.getCheckHPM()) {
					listaTiposGestor.remove(tipoGestorSuelo);
					listaTiposGestor.remove(tipoSupervisorSuelo);
					listaTiposGestor.remove(tipoGestorEdificaciones);
					listaTiposGestor.remove(tipoSupervisorEdificaciones);

				}

				else if (!DDTipoActivo.COD_SUELO.equals(codigoTipoActivo)) {
					listaTiposGestor.remove(tipoGestorSuelo);
					listaTiposGestor.remove(tipoSupervisorSuelo);
					listaTiposGestor.remove(tipoGestorAlquileres);
					listaTiposGestor.remove(tipoSupervisorAlquileres);

					// Si el Activo NO es de tipo Suelo y el Estado físico del
					// activo esta vacio eliminamos el gestor de edificacionnes
					if (Checks.esNulo(activo.getEstadoActivo())) {
						listaTiposGestor.remove(tipoGestorEdificaciones);
						listaTiposGestor.remove(tipoSupervisorEdificaciones);
						listaTiposGestor.remove(tipoGestorAlquileres);
						listaTiposGestor.remove(tipoSupervisorAlquileres);

					}
				} else {
					// Si el Activo es de tipo Suelo eliminamos el gestor de
					// edificacionnes y gestor de alquileres
					listaTiposGestor.remove(tipoGestorEdificaciones);
					listaTiposGestor.remove(tipoSupervisorEdificaciones);
					listaTiposGestor.remove(tipoGestorAlquileres);
					listaTiposGestor.remove(tipoSupervisorAlquileres);

				}
			}

			else {
				if (!DDTipoActivo.COD_SUELO.equals(codigoTipoActivo)) {
					listaTiposGestor.remove(tipoGestorSuelo);
					listaTiposGestor.remove(tipoSupervisorSuelo);
					listaTiposGestor.remove(tipoGestorAlquileres);
					listaTiposGestor.remove(tipoSupervisorAlquileres);

					// Si el Activo NO es de tipo Suelo y el Estado físico del
					// activo esta vacio eliminamos el gestor de edificacionnes
					if (Checks.esNulo(activo.getEstadoActivo())) {
						listaTiposGestor.remove(tipoGestorEdificaciones);
						listaTiposGestor.remove(tipoSupervisorEdificaciones);
						listaTiposGestor.remove(tipoGestorAlquileres);
						listaTiposGestor.remove(tipoSupervisorAlquileres);

					}
				} else {
					// Si el Activo es de tipo Suelo eliminamos el gestor de
					// edificacionnes
					listaTiposGestor.remove(tipoGestorEdificaciones);
					listaTiposGestor.remove(tipoSupervisorEdificaciones);
					listaTiposGestor.remove(tipoGestorAlquileres);
					listaTiposGestor.remove(tipoSupervisorAlquileres);

				}
			}
			// Filtramos los gestores dependiendo del tipo de comercialización
			// del activo
			if (!Checks.esNulo(activo) && !Checks.esNulo(tipoComercializacion) && !tipoComercializacion.isEmpty()) {
				if (DDTipoComercializacion.CODIGO_VENTA.equals(tipoComercializacion)) {
					listaTiposGestor.remove(tipoGestorComercialAlquileres);
					listaTiposGestor.remove(tipoSupervisorComercialAlquileres);
				}
				if (DDTipoComercializacion.CODIGO_SOLO_ALQUILER.equals(tipoComercializacion)) {
					listaTiposGestor.remove(tipoGestorComercial);
					listaTiposGestor.remove(tipoSupervisorComercial);
				}
			}
		} catch (NumberFormatException e) {
			e.printStackTrace();
		}

		return listaTiposGestor;
	}

	@Override
	public List<EXTDDTipoGestor> getComboTipoGestorFiltrado(Set<String> tipoGestorCodigos) {

		Order order = new Order(GenericABMDao.OrderType.ASC, "descripcion");
		List<EXTDDTipoGestor> lista = genericDao.getListOrdered(EXTDDTipoGestor.class, order,
				genericDao.createFilter(FilterType.EQUALS, "borrado", false));

		List<EXTDDTipoGestor> listaResultado = new ArrayList<EXTDDTipoGestor>();

		for (EXTDDTipoGestor tipoGestor : lista) {
			if (tipoGestorCodigos.contains(tipoGestor.getCodigo())) {
				listaResultado.add(tipoGestor);
			}
		}

		return listaResultado;
	}

	@Override
	@BusinessOperationDefinition("genericManager.getComboTipoGestorOfertas")
	public List<EXTDDTipoGestor> getComboTipoGestorOfertas() {

		Order order = new Order(GenericABMDao.OrderType.ASC, "descripcion");

		List<EXTDDTipoGestor> lista = genericDao.getListOrdered(EXTDDTipoGestor.class, order,
				genericDao.createFilter(FilterType.EQUALS, "borrado", false));
		List<EXTDDTipoGestor> listaResultado = new ArrayList<EXTDDTipoGestor>();
		for (EXTDDTipoGestor tipoGestor : lista) {
			if (tipoGestor.getCodigo().equals("GCOM") || tipoGestor.getCodigo().equals("GCBO")
					|| tipoGestor.getCodigo().equals("GFORM") || tipoGestor.getCodigo().equals("FVDNEG")
					|| tipoGestor.getCodigo().equals("FVDBACKOFR") || tipoGestor.getCodigo().equals("FVDBACKVNT")
					|| tipoGestor.getCodigo().equals("HAYAGBOINM")
					|| tipoGestor.getCodigo().equals("SBACKOFFICEINMLIBER") || tipoGestor.getCodigo().equals("GESRES")
					|| tipoGestor.getCodigo().equals("SUPRES")) {
				listaResultado.add(tipoGestor);
			}
		}

		return listaResultado;
	}

	@SuppressWarnings({ "unchecked", "rawtypes" })
	@Override
	@BusinessOperationDefinition("genericManager.getComboTipoTrabajoCreaFiltered")
	public List<DDTipoTrabajo> getComboTipoTrabajoCreaFiltered(String idActivo) {

		List<DDTipoTrabajo> tiposTrabajo = new ArrayList<DDTipoTrabajo>();
		List<DDTipoTrabajo> tiposTrabajoFiltered = new ArrayList<DDTipoTrabajo>();
		tiposTrabajo.addAll((List<DDTipoTrabajo>) (List) adapter.getDiccionario("tiposTrabajo"));

		if (idActivo != null && !idActivo.isEmpty() && StringUtils.isNumeric(idActivo)) {
			Activo act = activoApi.get(Long.parseLong(idActivo));
			for (DDTipoTrabajo tipoTrabajo : tiposTrabajo) {
				// No se pueden crear tipos de trabajo ACTUACION TECNICA ni
				// OBTENCION DOCUMENTAL
				// cuando el activo no tiene condicion de gestion en el
				// perimetro (check gestion = false)
				if (!Checks.esNulo(act.getEnTramite()) && act.getEnTramite()==1) {
					if (!Checks.esNulo(tipoTrabajo.getFiltroEnTramite()) && tipoTrabajo.getFiltroEnTramite()) {
						tiposTrabajoFiltered.add(tipoTrabajo);
					}
				} else {
					if (DDTipoTrabajo.CODIGO_ACTUACION_TECNICA.equals(tipoTrabajo.getCodigo())
							|| DDTipoTrabajo.CODIGO_OBTENCION_DOCUMENTAL.equals(tipoTrabajo.getCodigo())) {
						// Si no hay registro en BBDD de perimetro, el get nos
						// devuelve un PerimetroActivo nuevo
						// con todas las condiciones de perimetro activas
						PerimetroActivo perimetroActivo = activoApi.getPerimetroByIdActivo(Long.parseLong(idActivo));

						if (!Checks.esNulo(perimetroActivo.getAplicaGestion())
								&& perimetroActivo.getAplicaGestion() == 1) {
							// Activo con Gestion en perimetro
							tiposTrabajoFiltered.add(tipoTrabajo);
						}
					} else if (!DDTipoTrabajo.CODIGO_COMERCIALIZACION.equals(tipoTrabajo.getCodigo())
							&& !DDTipoTrabajo.CODIGO_PUBLICACIONES.equals(tipoTrabajo.getCodigo())
							&& !DDTipoTrabajo.CODIGO_TASACION.equals(tipoTrabajo.getCodigo())) {
						// El resto de tipos, si no es comercialización o
						// tasación,
						// se pueden generar.
						tiposTrabajoFiltered.add(tipoTrabajo);

					} else if (!DDTipoTrabajo.CODIGO_COMERCIALIZACION.equals(tipoTrabajo.getCodigo())
							&& !DDTipoTrabajo.CODIGO_TASACION.equals(tipoTrabajo.getCodigo())
							&& !DDTipoTrabajo.CODIGO_PUBLICACIONES.equals(tipoTrabajo.getCodigo())) {
						// El resto de tipos, si no es comercialización o
						// tasación,
						// se pueden generar.
						tiposTrabajoFiltered.add(tipoTrabajo);
					}
				}
			}
		} else {

			for (DDTipoTrabajo tipoTrabajo : tiposTrabajo) {
				// No se generan los tipos de trabajo tasación o
				// comercialización.
				if (!DDTipoTrabajo.CODIGO_COMERCIALIZACION.equals(tipoTrabajo.getCodigo())
						&& !DDTipoTrabajo.CODIGO_TASACION.equals(tipoTrabajo.getCodigo())
						&& !DDTipoTrabajo.CODIGO_PUBLICACIONES.equals(tipoTrabajo.getCodigo())) {
					// El resto de tipos, si no es comercialización o tasación,
					// se pueden generar.

					// Excluiremos los trabajos del tipo publicacion para las
					// agrupaciones de tipo asistida o de tipo obra nueva

					tiposTrabajoFiltered.add(tipoTrabajo);

				}
			}
		}
		return tiposTrabajoFiltered;

	}

	@Override
	@BusinessOperationDefinition("genericManager.getComboSubtipoTrabajo")
	public List<DDSubtipoTrabajo> getComboSubtipoTrabajo(String tipoTrabajoCodigo, Long idActivo) {
		List<DDSubtipoTrabajo> lista = new ArrayList<DDSubtipoTrabajo>();
		DDTipoTrabajo tipoTrabajo = genericDao.get(DDTipoTrabajo.class,
				genericDao.createFilter(FilterType.EQUALS, "codigo", tipoTrabajoCodigo));
		
		if (!Checks.esNulo(idActivo)) {
			Activo activo = activoApi.get(idActivo);
			if (!Checks.esNulo(activo.getEnTramite()) && activo.getEnTramite()==1) {
				Usuario gestorProveedorTecnico = gestorActivoApi.getGestorByActivoYTipo(activo, "PTEC");
				if (!Checks.esNulo(gestorProveedorTecnico)) {

					lista = ddSubtipoTrabajoDao.getSubtipoTrabajoconTarifaPlana(tipoTrabajo.getId(), new Date());
				} else {
					Order order = new Order(GenericABMDao.OrderType.ASC, "descripcion");
					Filter filter = genericDao.createFilter(FilterType.EQUALS, "tipoTrabajo.codigo", tipoTrabajoCodigo);
					lista = genericDao.getListOrdered(DDSubtipoTrabajo.class, order, filter);
				}
			} else {
				Order order = new Order(GenericABMDao.OrderType.ASC, "descripcion");
				Filter filter = genericDao.createFilter(FilterType.EQUALS, "tipoTrabajo.codigo", tipoTrabajoCodigo);
				lista = genericDao.getListOrdered(DDSubtipoTrabajo.class, order, filter);
			}
		} else {
			Order order = new Order(GenericABMDao.OrderType.ASC, "descripcion");
			Filter filter = genericDao.createFilter(FilterType.EQUALS, "tipoTrabajo.codigo", tipoTrabajoCodigo);
			lista = genericDao.getListOrdered(DDSubtipoTrabajo.class, order, filter);
		}

		return lista;

	}

	@Override
	@BusinessOperationDefinition("genericManager.getComboSubtipoTrabajo")
	public List<DDSubtipoTrabajo> getComboSubtipoTrabajoCreaFiltered(String tipoTrabajoCodigo) {

		Order order = new Order(GenericABMDao.OrderType.ASC, "descripcion");
		Filter filter = genericDao.createFilter(FilterType.EQUALS, "tipoTrabajo.codigo", tipoTrabajoCodigo);
		List<DDSubtipoTrabajo> listaSubtipos = (List<DDSubtipoTrabajo>) genericDao
				.getListOrdered(DDSubtipoTrabajo.class, order, filter);
		List<DDSubtipoTrabajo> listaSubtiposFiltered = new ArrayList<DDSubtipoTrabajo>();

		for (DDSubtipoTrabajo subtipo : listaSubtipos) {
			if (!DDTipoTrabajo.CODIGO_PRECIOS.equals(subtipo.getCodigoTipoTrabajo())) {
				return listaSubtipos;
			}
			// Solo se pueden crear por la pantalla de crear trabajo estos
			// subtipos relacionados con precios
			else if (DDSubtipoTrabajo.CODIGO_ACTUALIZACION_PRECIOS.equals(subtipo.getCodigo())
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
		// Generar una lista de todos los trabajos relacionados con el tipo de
		// trabajo que
		// llega y finalmente crear otra nueva y copiarla la primera sin
		// aquellos que sean de códigos no tarificados
		Order order = new Order(GenericABMDao.OrderType.ASC, "descripcion");
		Filter filter = genericDao.createFilter(FilterType.EQUALS, "tipoTrabajo.codigo", tipoTrabajoCodigo);
		List<DDSubtipoTrabajo> subtipos = (List<DDSubtipoTrabajo>) genericDao.getListOrdered(DDSubtipoTrabajo.class,
				order, filter);
		List<DDSubtipoTrabajo> subtiposTarificados = new ArrayList<DDSubtipoTrabajo>();
		for (DDSubtipoTrabajo subtipo : subtipos) {
			if (!subtipo.getCodigo().equalsIgnoreCase(DDSubtipoTrabajo.CODIGO_AT_OBRA_MENOR_NO_TARIFICADA)
					&& !subtipo.getCodigo().equalsIgnoreCase(DDSubtipoTrabajo.CODIGO_AT_CONTROL_ACTUACIONES)
					&& !subtipo.getCodigo().equalsIgnoreCase(DDSubtipoTrabajo.CODIGO_AT_MOBILIARIO)) {
				subtiposTarificados.add(subtipo);
			}
		}
		return subtiposTarificados;

	}

	@Override
	@BusinessOperationDefinition("genericManager.getComboSubtipoClaseActivo")
	public List<DDSubtipoClaseActivoBancario> getComboSubtipoClaseActivo(String tipoClaseActivoCodigo) {

		// Generar una lista de todos los subtipos de clase bancarios
		// relacionados con el tipo de clase bancario
		Order order = new Order(GenericABMDao.OrderType.ASC, "descripcion");
		Filter filter = genericDao.createFilter(FilterType.EQUALS, "claseActivo.codigo", tipoClaseActivoCodigo);

		return (List<DDSubtipoClaseActivoBancario>) genericDao.getListOrdered(DDSubtipoClaseActivoBancario.class, order,
				filter);

	}

	@Override
	@BusinessOperationDefinition("genericManager.getComboMotivoRechazoOferta")
	public List<DDMotivoRechazoOferta> getComboMotivoRechazoOferta(String tipoRechazoOfertaCodigo, Long idOferta) {

		Order order = new Order(GenericABMDao.OrderType.ASC, "descripcion");
		Filter filter = genericDao.createFilter(FilterType.EQUALS, "tipoRechazo.codigo", tipoRechazoOfertaCodigo);
		Filter filtroMotivoAlquiler = genericDao.createFilter(FilterType.EQUALS, "alquiler", true);
		Filter filtroMotivoVenta = genericDao.createFilter(FilterType.EQUALS, "venta", true);
		Oferta oferta = ofertaApi.getOfertaById(idOferta);
		
		if(tipoRechazoOfertaCodigo.equals("A")) {
			if(DDTipoOferta.CODIGO_ALQUILER.equals(oferta.getTipoOferta().getCodigo())) {
				return (List<DDMotivoRechazoOferta>) genericDao.getListOrdered(DDMotivoRechazoOferta.class, order, filter, filtroMotivoAlquiler);
			}else if(DDTipoOferta.CODIGO_VENTA.equals(oferta.getTipoOferta().getCodigo())) {
				return (List<DDMotivoRechazoOferta>) genericDao.getListOrdered(DDMotivoRechazoOferta.class, order, filter, filtroMotivoVenta);
			}
		}else if (tipoRechazoOfertaCodigo.equals("D")) {
			return (List<DDMotivoRechazoOferta>) genericDao.getListOrdered(DDMotivoRechazoOferta.class, order, filter);
		}

		return null;
	}

	@Override
	@BusinessOperationDefinition("genericManager.getComboTipoJuzgadoPlaza")
	public List<TipoJuzgado> getComboTipoJuzgadoPlaza(Long idPlaza) {

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
	public List<Ejercicio> getComboEjercicioContabilidad() {

		Order order = new Order(GenericABMDao.OrderType.ASC, "anyo");
		return (List<Ejercicio>) genericDao.getListOrdered(Ejercicio.class, order);

	}

	/**
	 * Devuelve una lista de ActivoPropietario parseado en DtoDiccionario
	 * 
	 * @return
	 */
	private List<DtoDiccionario> getListDtoPropietarioDiccionario() {

		List<DtoDiccionario> listaDD = new ArrayList<DtoDiccionario>();

		Filter filtroBorrado = genericDao.createFilter(FilterType.EQUALS, "auditoria.borrado", false);
		Order order = new Order(OrderType.ASC, "nombre");
		List<ActivoPropietario> listaPropietarios = genericDao.getListOrdered(ActivoPropietario.class, order,
				filtroBorrado);

		for (ActivoPropietario propietario : listaPropietarios) {
			DtoDiccionario propietarioDD = new DtoDiccionario();
			;
			try {
				beanUtilNotNull.copyProperty(propietarioDD, "id", propietario.getId());
				beanUtilNotNull.copyProperty(propietarioDD, "descripcion", propietario.getFullName());

				if (!Checks.esNulo(propietario.getCartera()))
					beanUtilNotNull.copyProperty(propietarioDD, "codigo", propietario.getCartera().getCodigo());

			} catch (IllegalAccessException e) {
				e.printStackTrace();
			} catch (InvocationTargetException e) {
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
	public List<DDComiteSancion> getComitesByIdExpediente(String expediente) {
		Filter filter = genericDao.createFilter(FilterType.EQUALS, "id", Long.valueOf(expediente));
		Filter filtroBorrado = genericDao.createFilter(FilterType.EQUALS, "auditoria.borrado", false);

		ExpedienteComercial expComercial = genericDao.get(ExpedienteComercial.class, filter, filtroBorrado);

		if (!Checks.esNulo(expComercial.getOferta().getActivoPrincipal().getCartera().getCodigo())) {
			return getComitesByCartera(expComercial.getOferta().getActivoPrincipal().getCartera().getCodigo());
			// return (List<DDComiteSancion>)
			// genericDao.getListOrdered(DDComiteSancion.class, order, filter,
			// filtroBorrado);
		} else {
			return new ArrayList<DDComiteSancion>();
		}
	}

	@Override
	public List<DtoDiccionario> getComboProveedorBySubtipo(String subtipoProveedorCodigo) {

		List<DtoDiccionario> listaDD = new ArrayList<DtoDiccionario>();

		Filter filtroBorrado = genericDao.createFilter(FilterType.EQUALS, "auditoria.borrado", false);
		Filter filtroSubtipo = genericDao.createFilter(FilterType.EQUALS, "tipoProveedor.codigo",
				subtipoProveedorCodigo);
		Filter filtroVigente = genericDao.createFilter(FilterType.NULL, "fechaBaja");
		Order order = new Order(OrderType.ASC, "nombre");
		List<ActivoProveedor> lista = genericDao.getListOrdered(ActivoProveedor.class, order, filtroBorrado,
				filtroSubtipo, filtroVigente);

		for (ActivoProveedor proveedor : lista) {
			DtoDiccionario dto = new DtoDiccionario();

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

	@Override
	public List<DDTipoComercializacion> getComboTipoDestinoComercialCreaFiltered() {

		Order order = new Order(GenericABMDao.OrderType.ASC, "descripcion");
		List<DDTipoComercializacion> listaDD = (List<DDTipoComercializacion>) genericDao
				.getListOrdered(DDTipoComercializacion.class, order);
		List<DDTipoComercializacion> listaTiposFiltered = new ArrayList<DDTipoComercializacion>();

		for (DDTipoComercializacion tipo : listaDD) {
			if (!DDTipoComercializacion.CODIGO_ALQUILER_OPCION_COMPRA.equals(tipo.getCodigo())) {
				listaTiposFiltered.add(tipo);
			}
		}

		return listaTiposFiltered;
	}

	@Override
	public List<DDTiposPorCuenta> getDiccionarioPorCuenta(String tipoCodigo) {
		List<DDTiposPorCuenta> listaTiposPorCuenta = (List<DDTiposPorCuenta>) genericDao
				.getList(DDTiposPorCuenta.class);
		List<DDTiposPorCuenta> listaTiposPorCuentaFiltered = new ArrayList<DDTiposPorCuenta>();

		if (!Checks.esNulo(tipoCodigo)) {
			if ("01".equals(tipoCodigo)) { // Venta.
				for (DDTiposPorCuenta tipo : listaTiposPorCuenta) {
					if (!DDTiposPorCuenta.TIPOS_POR_CUENTA_ARRENDADOR.equals(tipo.getCodigo())
							&& !DDTiposPorCuenta.TIPOS_POR_CUENTA_ARRENDATARIO.equals(tipo.getCodigo())) {
						listaTiposPorCuentaFiltered.add(tipo);
					}
				}
			} else { // Alquiler.
				for (DDTiposPorCuenta tipo : listaTiposPorCuenta) {
					if (!DDTiposPorCuenta.TIPOS_POR_CUENTA_COMPRADOR.equals(tipo.getCodigo())
							&& !DDTiposPorCuenta.TIPOS_POR_CUENTA_VENDEDOR.equals(tipo.getCodigo())) {
						listaTiposPorCuentaFiltered.add(tipo);
					}
				}
			}

			return listaTiposPorCuentaFiltered;
		}

		return listaTiposPorCuenta;
	}

	@Override
	public List<DDTipoCalculo> getDiccionarioByTipoOferta(String diccionario, String codTipoOferta) {
		Filter filtroTipoOferta = genericDao.createFilter(FilterType.EQUALS, "tipoOferta.codigo", codTipoOferta);

		return genericDao.getList(DDTipoCalculo.class, filtroTipoOferta);
	}

	@Override
	public List<DtoDiccionario> getComboGestoriasGasto() {

		List<DtoDiccionario> lista = getComboProveedorBySubtipo(DDTipoProveedor.COD_GESTORIA);
		lista.addAll(getComboProveedorBySubtipo(DDTipoProveedor.COD_CERTIFICADORA));

		return lista;
	}

	@Override
	public List<DDTipoBloqueo> getDiccionarioTipoBloqueo(String areaCodigo) {

		List<DDTipoBloqueo> listaTiposBloqueo = new ArrayList<DDTipoBloqueo>();

		if (!Checks.esNulo(areaCodigo)) {
			if (areaCodigo.equals("mostrarTodos")) {
				listaTiposBloqueo = genericDao.getList(DDTipoBloqueo.class);
			} else {
				listaTiposBloqueo = genericDao.getList(DDTipoBloqueo.class,
						genericDao.createFilter(FilterType.EQUALS, "area.codigo", areaCodigo));
			}
		}

		return listaTiposBloqueo;
	}

	@Override
	public List<DDCondicionIndicadorPrecio> getIndicadorCondicionPrecioFiltered(String codigoCartera) {
		List<DDCondicionIndicadorPrecio> listaTipoPropuestas = new ArrayList<DDCondicionIndicadorPrecio>();

		if (Checks.esNulo(codigoCartera)) {
			return listaTipoPropuestas;
		}

		// Obtener todos los tipos de propuestas.
		listaTipoPropuestas.addAll(genericDao.getList(DDCondicionIndicadorPrecio.class));

		// Obtener la lista de reglas actual filtradas por cartera.
		Filter filtroUsadoActualmentePorCartera = genericDao.createFilter(FilterType.EQUALS, "cartera.codigo",
				codigoCartera);
		List<CarteraCondicionesPrecios> listaUsadoActualmentePorCartera = genericDao
				.getList(CarteraCondicionesPrecios.class, filtroUsadoActualmentePorCartera);

		// Por cada regla actual, contrastar la propuesta de precio usada con la
		// lista de todas ellas y si coincide eliminarla de la lista.
		for (CarteraCondicionesPrecios condicion : listaUsadoActualmentePorCartera) {
			if (listaTipoPropuestas.contains(condicion.getCondicionIndicadorPrecio())) {
				listaTipoPropuestas.remove(condicion.getCondicionIndicadorPrecio());
			}
		}

		return listaTipoPropuestas;
	}

	@Override
	public List<DDSubcartera> getComboSubcartera(String codCartera) {

		Filter filtroCartera = genericDao.createFilter(FilterType.EQUALS, "cartera.codigo", codCartera);

		List<DDSubcartera> listaSubcartera = genericDao.getList(DDSubcartera.class, filtroCartera);

		return listaSubcartera;

	}

	@Override
	public List<DDComiteAlquiler> getComitesAlquilerByCartera(Long idActivo) {

		Activo activo = activoApi.get(idActivo);

		Order order = new Order(GenericABMDao.OrderType.ASC, "descripcion");

		Filter filter = genericDao.createFilter(FilterType.EQUALS, "cartera.codigo", activo.getCartera().getCodigo());
		Filter filterBorrado = genericDao.createFilter(FilterType.EQUALS, "auditoria.borrado", false);
		return (List<DDComiteAlquiler>) genericDao.getListOrdered(DDComiteAlquiler.class, order, filter, filterBorrado);
	}

	@Override
	public List<DDComiteAlquiler> getComitesAlquilerByCarteraCodigo(String carteraCodigo) {
		Filter filtroCartera = genericDao.createFilter(FilterType.EQUALS, "cartera.codigo", carteraCodigo);

		List<DDComiteAlquiler> listaSubcartera = genericDao.getList(DDComiteAlquiler.class, filtroCartera);

		return listaSubcartera;

	}

	@Override
	public List<DDTipoAgrupacion> getComboTipoAgrupacion() {
		// Se obtiene el tipo de gestor "Gestor de mantenimiento"
		// Filter filtroTipoAgrupacionBorrado =
		// genericDao.createFilter(FilterType.EQUALS, "auditoria.borrado",
		// false);
		// Filter filtroCodigoTipoAgrupacion =
		// genericDao.createFilter(FilterType.EQUALS, "codigo", "GACT");
		// EXTDDTipoGestor tipoGestor = genericDao.get(EXTDDTipoGestor.class,
		// filtroTipoAgrupacionBorrado, filtroCodigoTipoAgrupacion);

		// Se obtiene el listado completo de tipos de agrupacion.
		// List<DDTipoAgrupacion> listaTipoAgrupacionesFiltrado = new
		// ArrayList<DDTipoAgrupacion>();
		Filter filtroBorrado = genericDao.createFilter(FilterType.EQUALS, "auditoria.borrado", false);
		List<DDTipoAgrupacion> listaTipoAgrupaciones = genericDao.getList(DDTipoAgrupacion.class, filtroBorrado,
				filtroBorrado);

		/*
		 * // Se mira si el usuario logueado e s de tipo gestor mantenimiento.
		 * Usuario usuario = adapter.getUsuarioLogado(); List<DespachoExterno>
		 * despachos =
		 * proxyFactory.proxy(coreextensionApi.class).getListDespachosDeUsuario(
		 * tipoGestor.getId(), usuario.getId(), false, false);
		 * 
		 * 
		 * if (!despachos.isEmpty()) { for(DDTipoAgrupacion tipoAgr:
		 * listaTipoAgrupaciones) { if
		 * (!DDTipoAgrupacion.AGRUPACION_PROYECTO.equals(tipoAgr.getCodigo())) {
		 * listaTipoAgrupacionesFiltrado.add(tipoAgr); } } return
		 * listaTipoAgrupacionesFiltrado; } else { return listaTipoAgrupaciones;
		 * }
		 */ // REMVIP-2289
		return listaTipoAgrupaciones;
	}

	@Override
	public List<DDTipoAgrupacion> getTodosComboTipoAgrupacion() {
		Filter filtroBorrado = genericDao.createFilter(FilterType.EQUALS, "auditoria.borrado", false);
		List<DDTipoAgrupacion> listaTipoAgrupaciones = genericDao.getList(DDTipoAgrupacion.class, filtroBorrado,
				filtroBorrado);
		return listaTipoAgrupaciones;
	}
	
	@Override
	public List<DDTipoTituloActivoTPA> getComboTipoTituloActivoTPA(Long numActivo) {

		Activo activo = activoApi.getByNumActivo(numActivo);
		List<DDTipoTituloActivoTPA> combo = new ArrayList<DDTipoTituloActivoTPA>();
		
		DDTipoTituloActivoTPA tipoTituloSi = (DDTipoTituloActivoTPA) utilDiccionarioApi
				.dameValorDiccionarioByCod(DDTipoTituloActivoTPA.class, DDTipoTituloActivoTPA.tipoTituloSi);
		DDTipoTituloActivoTPA tipoTituloNo = (DDTipoTituloActivoTPA) utilDiccionarioApi
				.dameValorDiccionarioByCod(DDTipoTituloActivoTPA.class, DDTipoTituloActivoTPA.tipoTituloNo);
		DDTipoTituloActivoTPA tipoTituloNoConIndicios = (DDTipoTituloActivoTPA) utilDiccionarioApi
				.dameValorDiccionarioByCod(DDTipoTituloActivoTPA.class, DDTipoTituloActivoTPA.tipoTituloNoConIndicios);
		
		combo.add(tipoTituloSi);
		
		if(!Checks.esNulo(activo.getCartera())) {
			if(DDCartera.CODIGO_CARTERA_BANKIA.equals(activo.getCartera().getCodigo())) {
				if(!Checks.esNulo(activo.getSituacionPosesoria().getSitaucionJuridica())) {
					if (activo.getSituacionPosesoria().getSitaucionJuridica().getIndicaPosesion() == 1) {
						combo.add(tipoTituloNo);
					} else {
						combo.add(tipoTituloNoConIndicios);
					}
				}					
			} else {
				if (!Checks.esNulo(activo.getSituacionPosesoria().getFechaRevisionEstado())
						|| !Checks.esNulo(activo.getSituacionPosesoria().getFechaTomaPosesion())) {
					combo.add(tipoTituloNo);
				} else {
					combo.add(tipoTituloNoConIndicios);
				}
			}
		}
		
		return combo;
	}
}
