package es.pfsgroup.plugin.rem.jbpm.handler.user.impl;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.capgemini.pfs.multigestor.model.EXTDDTipoGestor;
import es.capgemini.pfs.procesosJudiciales.model.TareaExterna;
import es.capgemini.pfs.users.UsuarioManager;
import es.capgemini.pfs.users.dao.UsuarioDao;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.plugin.rem.adapter.RemUtils;
import es.pfsgroup.plugin.rem.api.GestorActivoApi;
import es.pfsgroup.plugin.rem.jbpm.handler.user.UserAssigantionService;
import es.pfsgroup.plugin.rem.model.ActivoProveedorContacto;
import es.pfsgroup.plugin.rem.model.TareaActivo;
import es.pfsgroup.plugin.rem.model.dd.DDCartera;

@Component
public class CedulaHabitabilidadUserAssigantionService implements UserAssigantionService {

	private static final String CODIGO_T008_ANALISIS_PETICION = "T008_AnalisisPeticion";
	private static final String CODIGO_T008_SOLICITUD_DOCUMENTO = "T008_SolicitudDocumento";
	private static final String CODIGO_T008_OBTENCION_DOCUMENTO = "T008_ObtencionDocumento";

	@Autowired
	private GestorActivoApi gestorActivoApi;

	@Autowired
	private GenericABMDao genericDao;
	
	@Autowired
	private RemUtils remUtils;

	@Override
	public String[] getKeys() {
		return this.getCodigoTarea();
	}

	@Override
	public String[] getCodigoTarea() {
		// TODO: poner los códigos de tipos de tareas
		return new String[] { CODIGO_T008_ANALISIS_PETICION, CODIGO_T008_SOLICITUD_DOCUMENTO,
				CODIGO_T008_OBTENCION_DOCUMENTO };
	}

	@Override
	public Usuario getUser(TareaExterna tareaExterna) {
		TareaActivo tareaActivo = (TareaActivo) tareaExterna.getTareaPadre();
		if (!Checks.esNulo(tareaActivo) && !Checks.esNulo(tareaActivo.getTramite())
				&& !Checks.esNulo(tareaActivo.getTramite().getActivo())
				&& !Checks.esNulo(tareaActivo.getTramite().getActivo().getCartera())) {

			DDCartera cartera = tareaActivo.getTramite().getActivo().getCartera();

			String codTarea = tareaExterna.getTareaProcedimiento().getCodigo();

			if (DDCartera.CODIGO_CARTERA_BANKIA.equals(cartera.getCodigo())
					|| DDCartera.CODIGO_CARTERA_SAREB.equals(cartera.getCodigo())
					|| DDCartera.CODIGO_CARTERA_TANGO.equals(cartera.getCodigo())
					|| DDCartera.CODIGO_CARTERA_HYT.equals(cartera.getCodigo())
					|| DDCartera.CODIGO_CARTERA_GIANTS.equals(cartera.getCodigo())) {

				Filter filtroTipoGestor = null;
				Filter filtroUsuarioPorDefecto = null;
				if (((CODIGO_T008_SOLICITUD_DOCUMENTO.equals(codTarea) && !DDCartera.CODIGO_CARTERA_BANKIA.equals(cartera.getCodigo()))
						|| CODIGO_T008_OBTENCION_DOCUMENTO.equals(codTarea)) 
						&& gestorActivoApi.existeGestorEnActivo(tareaActivo.getActivo(), GestorActivoApi.CODIGO_GESTORIA_CEDULAS)) {
					filtroTipoGestor = genericDao.createFilter(FilterType.EQUALS, "codigo",
								GestorActivoApi.CODIGO_GESTORIA_CEDULAS);
				}else if(CODIGO_T008_SOLICITUD_DOCUMENTO.equals(codTarea) && DDCartera.CODIGO_CARTERA_BANKIA.equals(cartera.getCodigo())) {
					ActivoProveedorContacto proveedor = tareaActivo.getTramite().getTrabajo().getProveedorContacto();
					if (!Checks.esNulo(proveedor)) {
						return proveedor.getUsuario();
					}
				}else if(CODIGO_T008_ANALISIS_PETICION.equals(codTarea) && (DDCartera.CODIGO_CARTERA_SAREB.equals(cartera.getCodigo()) 
						|| DDCartera.CODIGO_CARTERA_BANKIA.equals(cartera.getCodigo()))) {
					if(gestorActivoApi.existeGestorEnActivo(tareaActivo.getActivo(), GestorActivoApi.CODIGO_GESTOR_ACTIVO))
						filtroTipoGestor = genericDao.createFilter(FilterType.EQUALS, "codigo",
								GestorActivoApi.CODIGO_GESTOR_ACTIVO);
				}else {
					filtroTipoGestor = genericDao.createFilter(FilterType.EQUALS, "codigo",
							GestorActivoApi.CODIGO_GESTOR_ADMISION);
				}
				if(Checks.esNulo(filtroTipoGestor)) return null;
				EXTDDTipoGestor tipoGestorActivo = genericDao.get(EXTDDTipoGestor.class, filtroTipoGestor);

				if (!Checks.esNulo(tipoGestorActivo.getId()))
					return gestorActivoApi.getGestorByActivoYTipo(tareaActivo.getActivo(), tipoGestorActivo.getId());

			} else {
				if (CODIGO_T008_SOLICITUD_DOCUMENTO.equals(codTarea)
						|| CODIGO_T008_OBTENCION_DOCUMENTO.equals(codTarea)) {
					
					ActivoProveedorContacto proveedor = tareaActivo.getTramite().getTrabajo().getProveedorContacto();
					if (!Checks.esNulo(proveedor)) {
						return proveedor.getUsuario();
					}

				} else {
					Filter filtroTipoGestor = genericDao.createFilter(FilterType.EQUALS, "codigo",
							GestorActivoApi.CODIGO_GESTOR_ACTIVO);
					
					EXTDDTipoGestor tipoGestorActivo = genericDao.get(EXTDDTipoGestor.class, filtroTipoGestor);
					if (!Checks.esNulo(tipoGestorActivo.getId()))
						return gestorActivoApi.getGestorByActivoYTipo(tareaActivo.getActivo(), tipoGestorActivo.getId());

				}

			}
		}

		// Si no se ha podido determinar el gestor destinatario se mantiene el
		// que tenga asociado la TAR_TAREAS
		// (gestor del activo para estas tareas)
		return null;
	}

	@Override
	public Usuario getSupervisor(TareaExterna tareaExterna) {
		TareaActivo tareaActivo = (TareaActivo) tareaExterna.getTareaPadre();

		Filter filtroTipoGestor = null;
		String codigoTarea = tareaExterna.getTareaProcedimiento().getCodigo();
		if (CODIGO_T008_ANALISIS_PETICION.equals(codigoTarea)) {
			filtroTipoGestor = genericDao.createFilter(FilterType.EQUALS, "codigo",
					GestorActivoApi.CODIGO_SUPERVISOR_ADMISION);
		} else {
			filtroTipoGestor = genericDao.createFilter(FilterType.EQUALS, "codigo",
					GestorActivoApi.CODIGO_GESTOR_ADMISION);
		}

		EXTDDTipoGestor tipoGestor = genericDao.get(EXTDDTipoGestor.class, filtroTipoGestor);

		return gestorActivoApi.getGestorByActivoYTipo(tareaActivo.getActivo(), tipoGestor.getId());
	}

}
