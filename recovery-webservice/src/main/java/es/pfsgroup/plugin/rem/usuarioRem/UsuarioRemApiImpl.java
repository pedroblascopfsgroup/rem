package es.pfsgroup.plugin.rem.usuarioRem;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import es.pfsgroup.plugin.rem.adapter.GenericAdapter;
import es.pfsgroup.plugin.rem.model.UsuarioCartera;
import es.pfsgroup.plugin.rem.model.dd.DDCartera;
import org.springframework.beans.factory.annotation.Autowired;

import es.capgemini.devon.beans.Service;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.plugin.rem.adapter.RemUtils;
import es.pfsgroup.plugin.rem.api.GestorActivoApi;
import es.pfsgroup.plugin.rem.api.GestorExpedienteComercialApi;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.ExpedienteComercial;
import es.pfsgroup.plugin.rem.model.GestorSustituto;

@Service("usuarioRemApiImpl")
public class UsuarioRemApiImpl implements UsuarioRemApi {

	@Autowired
	private GenericABMDao genericDao;
	
	@Autowired
	private GestorActivoApi gestorActivoManager;
	
	@Autowired
	private RemUtils remUtils;
	
	@Autowired
	private GestorExpedienteComercialApi gestorExpedienteComercialApi;

	@Autowired
	private GenericAdapter adapter;

	public List<String> getGestorSustitutoUsuario(Usuario usuario) {

		List<String> mailsPara = new ArrayList<String>();

		if (!Checks.esNulo(usuario)) {
			List<GestorSustituto> sustitutos = genericDao.getList(GestorSustituto.class,
					genericDao.createFilter(FilterType.EQUALS, "usuarioGestorOriginal.id", usuario.getId()));
			if (!Checks.estaVacio(sustitutos)) {
				for (GestorSustituto gestorSustituto : sustitutos) {
					if (!Checks.esNulo(gestorSustituto) 
							&& (gestorSustituto.getFechaFin() == null || gestorSustituto.getFechaFin().after(new Date())
								|| gestorSustituto.getFechaFin().equals(new Date()))
								&& (gestorSustituto.getFechaInicio().before(new Date())
										|| gestorSustituto.getFechaInicio().equals(new Date()))
								&& !gestorSustituto.getAuditoria().isBorrado() 
								&& (!Checks.esNulo(gestorSustituto.getUsuarioGestorSustituto())
									|| !Checks.esNulo(gestorSustituto.getUsuarioGestorSustituto().getEmail()))) {
						mailsPara.add(gestorSustituto.getUsuarioGestorSustituto().getEmail());
					}
				}
			}
		}
		return mailsPara;
	}

	public List<String> getApellidoNombreSustituto(Usuario usuario) {

		List<String> apellidoNombreSus = new ArrayList<String>();

		if (!Checks.esNulo(usuario)) {
			List<GestorSustituto> sustitutos = genericDao.getList(GestorSustituto.class,
					genericDao.createFilter(FilterType.EQUALS, "usuarioGestorOriginal.id", usuario.getId()));
			if (!Checks.estaVacio(sustitutos)) {
				for (GestorSustituto gestorSustituto : sustitutos) {
					if (!Checks.esNulo(gestorSustituto) 
							&& (gestorSustituto.getFechaFin() == null || gestorSustituto.getFechaFin().after(new Date())
								|| gestorSustituto.getFechaFin().equals(new Date()))
								&& (gestorSustituto.getFechaInicio().before(new Date())
										|| gestorSustituto.getFechaInicio().equals(new Date()))
								&& !gestorSustituto.getAuditoria().isBorrado()
								&& !Checks.esNulo(gestorSustituto.getUsuarioGestorSustituto())
									|| !Checks.esNulo(gestorSustituto.getUsuarioGestorSustituto().getEmail())) {
						apellidoNombreSus.add(gestorSustituto.getUsuarioGestorSustituto().getApellidoNombre());
					}
				}
			}
		}
		return apellidoNombreSus;
	}
	
	public void rellenaListaCorreos(ExpedienteComercial expediente, String codigoTipo, List<String> mailsPara, List<String> mailsCC,
			boolean addDirector) {
		Usuario gestorExpediente = gestorExpedienteComercialApi.getGestorByExpedienteComercialYTipo(expediente,codigoTipo);
		rellenaListaCorreos(gestorExpediente, codigoTipo, mailsPara, mailsCC, addDirector);
	}

	public void rellenaListaCorreos(Activo activo, String codigoTipo, List<String> mailsPara, List<String> mailsCC,
			boolean addDirector) {
		Usuario gestorActivo = gestorActivoManager.getGestorByActivoYTipo(activo, codigoTipo);
		rellenaListaCorreos(gestorActivo, codigoTipo, mailsPara, mailsCC, addDirector);
	}
	
	public void rellenaListaCorreos(Usuario usuarioGestor, String codigoTipo, List<String> mailsPara, List<String> mailsCC,
			boolean addDirector) {
		List<String> mailsConsulta = getGestorSustitutoUsuario(usuarioGestor);
		if(!Checks.esNulo(usuarioGestor)) {
			if (!addDirector) {
				if (!Checks.estaVacio(mailsConsulta)) {
					mailsPara.addAll(mailsConsulta);
					if (usuarioGestor.getEmail() != null) {
						mailsCC.add(usuarioGestor.getEmail());
					}
				} else {
					if (usuarioGestor.getEmail() != null) {
						mailsPara.add(usuarioGestor.getEmail());
					}
				}
			} else {
				Usuario directorEquipo = gestorActivoManager.getDirectorEquipoByGestor(usuarioGestor);
				if (directorEquipo != null) {
					if (!Checks.estaVacio(mailsConsulta)) {
						mailsPara.addAll(mailsConsulta);
						if (directorEquipo.getEmail() != null) {
							mailsCC.add(directorEquipo.getEmail());
						}
					} else {
						if (usuarioGestor.getEmail() != null) {
							mailsPara.add(directorEquipo.getEmail());
						}
					}
				}
			}
		}
	}

	public void rellenaListaCorreosPorDefecto(String codigoTipo, List<String> mailsPara){
		String usuarioName = remUtils.obtenerUsuarioPorDefecto(codigoTipo);
		Filter filtroUsuarioPorDefecto = null;
		if(!Checks.esNulo(usuarioName)) {
			filtroUsuarioPorDefecto = genericDao.createFilter(FilterType.EQUALS ,"username", usuarioName);
			Usuario usuPorDefecto = genericDao.get(Usuario.class, filtroUsuarioPorDefecto);
			if (!Checks.esNulo(usuPorDefecto) && !Checks.esNulo(usuPorDefecto.getEmail())) {
				mailsPara.add(usuPorDefecto.getEmail());
			}
		}
	}

	/**
	 * Método que devuelve los códigos de las carteras relacionadas con el usuario mediante la UCA.
	 * @param tieneSubcartera Parámetro que indica que carteras recuperará:
	 *                        - null: Todas las carteras relacionadas con el usuario.
	 *                        - true: Las carteras relacioandas con el usuario que tengan subcartera informada.
	 *                        - false: Las carteras relacionadas con el usuario que NO tengan la subcartera infromada.
	 * @param usuario Usuario logueado.
	 * @return Devuelve una lista de Strings con los códigos de las carteras.
	 */
	public List<String> getCodigosCarterasUsuario(Boolean tieneSubcartera, Usuario usuario) {

		List<String> codigosCarterasUsuarioLogado = new ArrayList<String>();

		if(Checks.esNulo(usuario))
			usuario = adapter.getUsuarioLogado();

		List<UsuarioCartera> usuarioCarteraList = genericDao.getList(UsuarioCartera.class, genericDao.createFilter(FilterType.EQUALS, "usuario.id", usuario.getId()));

		if(!Checks.estaVacio(usuarioCarteraList)) {
			for(UsuarioCartera usuarioCartera : usuarioCarteraList) {
				if(usuarioCartera.getCartera() != null && !codigosCarterasUsuarioLogado.contains(usuarioCartera.getCartera().getCodigo())) {
					if(tieneSubcartera == null)
						codigosCarterasUsuarioLogado.add(usuarioCartera.getCartera().getCodigo());
					else if(tieneSubcartera && usuarioCartera.getSubCartera() != null)
						codigosCarterasUsuarioLogado.add(usuarioCartera.getCartera().getCodigo());
					else if (!tieneSubcartera && usuarioCartera.getSubCartera() == null)
						codigosCarterasUsuarioLogado.add(usuarioCartera.getCartera().getCodigo());
				}
			}
		}

		return codigosCarterasUsuarioLogado;
	}

	public List<String> getCodigosSubcarterasUsuario(String codCartera, Usuario usuario) {

		List<String> codigosSubcarterasUsuarioLogado = new ArrayList<String>();

		if(Checks.esNulo(usuario))
			usuario = adapter.getUsuarioLogado();

		List<UsuarioCartera> usuarioCarteraList;

		if(Checks.esNulo(codCartera)) {
			usuarioCarteraList = genericDao.getList(UsuarioCartera.class, genericDao.createFilter(FilterType.EQUALS, "usuario.id", usuario.getId()));
		} else {
			DDCartera cartera = genericDao.get(DDCartera.class, genericDao.createFilter(FilterType.EQUALS, "codigo", codCartera));
			if(cartera == null)
				return codigosSubcarterasUsuarioLogado;

			usuarioCarteraList = genericDao.getList(UsuarioCartera.class, genericDao.createFilter(FilterType.EQUALS, "usuario.id", usuario.getId()),
					genericDao.createFilter(FilterType.EQUALS, "cartera.id", cartera.getId()));
		}

		if(!Checks.estaVacio(usuarioCarteraList)) {
			for(UsuarioCartera usuarioCartera : usuarioCarteraList) {
				if(usuarioCartera.getSubCartera() != null && !codigosSubcarterasUsuarioLogado.contains(usuarioCartera.getSubCartera().getCodigo()))
					codigosSubcarterasUsuarioLogado.add(usuarioCartera.getSubCartera().getCodigo());
			}
		}

		return codigosSubcarterasUsuarioLogado;
	}
}