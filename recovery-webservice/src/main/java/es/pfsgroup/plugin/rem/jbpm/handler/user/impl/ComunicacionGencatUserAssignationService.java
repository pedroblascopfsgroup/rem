package es.pfsgroup.plugin.rem.jbpm.handler.user.impl;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.capgemini.pfs.multigestor.model.EXTDDTipoGestor;
import es.capgemini.pfs.procesosJudiciales.model.EXTTareaProcedimiento;
import es.capgemini.pfs.procesosJudiciales.model.TareaExterna;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.plugin.rem.api.GestorActivoApi;
import es.pfsgroup.plugin.rem.jbpm.handler.user.UserAssigantionService;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.TareaActivo;
import es.pfsgroup.plugin.rem.model.dd.DDCartera;

@Component
public class ComunicacionGencatUserAssignationService implements UserAssigantionService {

	private static final String CODIGO_T016_PROCESO_ADECUACION = "T016_ProcesoAdecuacion";
	private static final String CODIGO_T016_COMUNICAR_GENCAT = "T016_ComunicarGENCAT";
	
	private static final String GRUPO_FORM_GENCAT = "grpformgencat";
	
	@Autowired
	private GestorActivoApi gestorActivoApi;

	@Autowired
	private GenericABMDao genericDao;
	
	@Override
	public String[] getKeys() {
		return this.getCodigoTarea();
	}

	@Override
	public String[] getCodigoTarea() {
		return new String[]{CODIGO_T016_PROCESO_ADECUACION, CODIGO_T016_COMUNICAR_GENCAT};
	}

	@Override
	public Usuario getUser(TareaExterna tareaExterna) {
		TareaActivo tareaActivo = (TareaActivo) tareaExterna.getTareaPadre();
		EXTTareaProcedimiento tareaProcedimiento = (EXTTareaProcedimiento)tareaExterna.getTareaProcedimiento();
		Activo activo = tareaActivo.getTramite().getActivo();
		String codigoTarea = tareaExterna.getTareaProcedimiento().getCodigo();
		String codigoCartera = activo.getCartera().getCodigo();
		EXTDDTipoGestor tipoGestor = null;
		
		if(CODIGO_T016_COMUNICAR_GENCAT.equals(codigoTarea)
				&& (DDCartera.CODIGO_CARTERA_LIBERBANK.equals(codigoCartera)
						|| DDCartera.CODIGO_CARTERA_BANKIA.equals(codigoCartera)
						|| DDCartera.CODIGO_CARTERA_CAJAMAR.equals(codigoCartera)
						|| DDCartera.CODIGO_CARTERA_SAREB.equals(codigoCartera)
						|| DDCartera.CODIGO_CARTERA_CERBERUS.equals(codigoCartera))) {
			
			return genericDao.get(Usuario.class,
					genericDao.createFilter(FilterType.EQUALS, "username", GRUPO_FORM_GENCAT));
		} else {
			tipoGestor = tareaProcedimiento.getTipoGestor();
		}
			
		return gestorActivoApi.getGestorByActivoYTipo(activo, tipoGestor.getCodigo());
	}
	
	@Override
	public Usuario getSupervisor(TareaExterna tareaExterna) {
		TareaActivo tareaActivo = (TareaActivo)tareaExterna.getTareaPadre();
		EXTTareaProcedimiento tareaProcedimiento = (EXTTareaProcedimiento)tareaExterna.getTareaProcedimiento();
		Usuario gestor = null;

		if(GestorActivoApi.CODIGO_GESTOR_ADMISION.equals(tareaProcedimiento.getTipoGestor().getCodigo())){
			Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", GestorActivoApi.CODIGO_SUPERVISOR_ADMISION);
			gestor = gestorActivoApi.getGestorByActivoYTipo(tareaActivo.getActivo(), genericDao.get(EXTDDTipoGestor.class, filtro).getId());
		} else{
			if(GestorActivoApi.CODIGO_GESTOR_ACTIVO.equals(tareaProcedimiento.getTipoGestor().getCodigo())){
				Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", GestorActivoApi.CODIGO_SUPERVISOR_ACTIVOS);
				gestor = gestorActivoApi.getGestorByActivoYTipo(tareaActivo.getActivo(), genericDao.get(EXTDDTipoGestor.class, filtro).getId());
			}else{
				if(GestorActivoApi.CODIGO_GESTORIA_ADMISION.equals(tareaProcedimiento.getTipoGestor().getCodigo())){
					Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", GestorActivoApi.CODIGO_GESTOR_ACTIVO);
					gestor = gestorActivoApi.getGestorByActivoYTipo(tareaActivo.getActivo(), genericDao.get(EXTDDTipoGestor.class, filtro).getId());
				}else{
					if(GestorActivoApi.CODIGO_PROVEEDOR.equals(tareaProcedimiento.getTipoGestor().getCodigo())){
						Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", GestorActivoApi.CODIGO_GESTOR_ACTIVO);
						gestor = gestorActivoApi.getGestorByActivoYTipo(tareaActivo.getActivo(), genericDao.get(EXTDDTipoGestor.class, filtro).getId());
					}
				}
			}
		}
		
		//Validamos por si no se hubiese obtenido el supervisor.
		if(Checks.esNulo(gestor))
			return this.getUser(tareaExterna);
		else
			return gestor;
	}
}
