package es.pfsgroup.plugin.rem.jbpm.handler.user.impl;

import org.springframework.beans.factory.annotation.Autowired;

import es.capgemini.pfs.core.api.usuario.UsuarioApi;
import es.capgemini.pfs.multigestor.model.EXTDDTipoGestor;
import es.capgemini.pfs.procesosJudiciales.model.TareaExterna;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.plugin.rem.api.GestorActivoApi;
import es.pfsgroup.plugin.rem.api.GestorExpedienteComercialApi;
import es.pfsgroup.plugin.rem.expedienteComercial.dao.ExpedienteComercialDao;
import es.pfsgroup.plugin.rem.jbpm.handler.user.UserAssigantionService;
import es.pfsgroup.plugin.rem.model.ExpedienteComercial;
import es.pfsgroup.plugin.rem.model.TareaActivo;

public class TramiteAprobacionInformeComercialAsignationService implements UserAssigantionService {

	public static final String CODIGO_T011_ANALISIS_PETICION_CORRECCION = "T011_AnalisisPeticionCorreccion";
	public static final String CODIGO_T011_REVISION_INFORME_COMERCIAL = "T011_RevisionInformeComercial";

	@Autowired
	private GenericABMDao genericDao;

	@Autowired
	private GestorActivoApi gestorActivoApi;

	@Autowired
	private GestorExpedienteComercialApi gestorExpedienteComercialApi;

	@Autowired
	private ExpedienteComercialDao expedienteComercialDao;

	@Autowired
	private ApiProxyFactory proxyFactory;

	@Override
	public String[] getKeys() {
		return this.getCodigoTarea();
	}

	@Override
	public String[] getCodigoTarea() {
		return new String[] { CODIGO_T011_ANALISIS_PETICION_CORRECCION, CODIGO_T011_REVISION_INFORME_COMERCIAL };
	}

	@Override
	public Usuario getUser(TareaExterna tareaExterna) {
		TareaActivo tareaActivo = (TareaActivo) tareaExterna.getTareaPadre();
		// String codigoTarea =
		// tareaExterna.getTareaProcedimiento().getCodigo();
		String codigoGestor = GestorActivoApi.CODIGO_GESTOR_PUBLICACION;
		// Usuario usuario =
		// proxyFactory.proxy(UsuarioApi.class).getUsuarioLogado();

		Filter filtroTipoGestor = genericDao.createFilter(FilterType.EQUALS, "codigo", codigoGestor);

		EXTDDTipoGestor tipoGestor = genericDao.get(EXTDDTipoGestor.class, filtroTipoGestor);
		if (!Checks.esNulo(tipoGestor)) {
			if (GestorActivoApi.CODIGO_GESTOR_PUBLICACION.equals(codigoGestor)
					|| GestorActivoApi.CODIGO_SUPERVISOR_PUBLICACION.equals(codigoGestor)) {
				return this.getGestorOrSupervisorExpedienteByCodigo(tareaExterna, codigoGestor);
			}
		}
		return null;
		// return
		// gestorActivoApi.getGestorByActivoYTipo(tareaActivo.getActivo(),
		// tipoGestor.getId());
	}

	// Obtención de usuarios desde el expediente comecial
	private Usuario getGestorOrSupervisorExpedienteByCodigo(TareaExterna tareaExterna, String codigo) {

		TareaActivo tareaActivo = (TareaActivo) tareaExterna.getTareaPadre();

		if (!Checks.esNulo(tareaActivo.getTramite().getTrabajo())) {

			ExpedienteComercial expediente = expedienteComercialDao.getExpedienteComercialByIdTrabajo(tareaActivo.getTramite().getTrabajo().getId());
			return gestorExpedienteComercialApi.getGestorByExpedienteComercialYTipo(expediente, codigo);
		}

		return null;
	}

	@Override
	public Usuario getSupervisor(TareaExterna tareaExterna) {
		TareaActivo tareaActivo = (TareaActivo) tareaExterna.getTareaPadre();
		// String codigoTarea =
		// tareaExterna.getTareaProcedimiento().getCodigo();
		String codigoGestor = GestorActivoApi.CODIGO_SUPERVISOR_PUBLICACION;
		// Usuario usuario =
		// proxyFactory.proxy(UsuarioApi.class).getUsuarioLogado();

		Filter filtroTipoGestor = genericDao.createFilter(FilterType.EQUALS, "codigo", codigoGestor);

		EXTDDTipoGestor tipoGestor = genericDao.get(EXTDDTipoGestor.class, filtroTipoGestor);
		if (!Checks.esNulo(tipoGestor)) {
			if (GestorActivoApi.CODIGO_SUPERVISOR_PUBLICACION.equals(codigoGestor)) {
				return this.getGestorOrSupervisorExpedienteByCodigo(tareaExterna, codigoGestor);
			}
		}
		return null;
		// return
		// gestorActivoApi.getGestorByActivoYTipo(tareaActivo.getActivo(),
		// tipoGestor.getId());

	}
}
