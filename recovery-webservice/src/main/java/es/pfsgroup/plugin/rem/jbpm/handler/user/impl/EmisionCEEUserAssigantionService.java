package es.pfsgroup.plugin.rem.jbpm.handler.user.impl;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.capgemini.pfs.multigestor.model.EXTDDTipoGestor;
import es.capgemini.pfs.procesosJudiciales.model.TareaExterna;
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
public class EmisionCEEUserAssigantionService implements UserAssigantionService {

	private static final String CODIGO_T003_EMISION_CERTIFICADO = "T003_EmisionCertificado";
	private static final String CODIGO_T003_SOLICITUD_ETIQUETA = "T003_SolicitudEtiqueta";
	private static final String CODIGO_T003_OBTENCION_ETIQUETA = "T003_ObtencionEtiqueta";
	
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
		//TODO: poner los códigos de tipos de tareas
		return new String[]{CODIGO_T003_EMISION_CERTIFICADO, CODIGO_T003_SOLICITUD_ETIQUETA, CODIGO_T003_OBTENCION_ETIQUETA};
	}

	@Override
	public Usuario getUser(TareaExterna tareaExterna) {
		TareaActivo tareaActivo = (TareaActivo)tareaExterna.getTareaPadre();
		
		if(!Checks.esNulo(tareaActivo) && 
				!Checks.esNulo(tareaActivo.getTramite()) && 
				!Checks.esNulo(tareaActivo.getTramite().getActivo()) &&
				!Checks.esNulo(tareaActivo.getTramite().getActivo().getCartera())) {
			
			DDCartera cartera = tareaActivo.getTramite().getActivo().getCartera();
			
			// Si la cartera es TANGO o GIANTS, el gestor de las tareas es TINSA CERTIFY
			if(DDCartera.CODIGO_CARTERA_TANGO.equals(cartera.getCodigo())
			|| DDCartera.CODIGO_CARTERA_GIANTS.equals(cartera.getCodigo())){
				//Usuario del Proveedor Tinsa para asignar a tareas (encontrado por CIF)
				
				Filter filtroUsuProveedorTangoGiants = genericDao.createFilter(FilterType.EQUALS, "username", remUtils.obtenerUsuarioPorDefecto(GestorActivoApi.USU_PROVEEDOR_BANKIA_SAREB_TINSA));
				Usuario usuProveedorTangoGiants = genericDao.get(Usuario.class, filtroUsuProveedorTangoGiants);
				
				if(!Checks.esNulo(usuProveedorTangoGiants))
					return usuProveedorTangoGiants;

			} else if (DDCartera.CODIGO_CARTERA_BANKIA.equals(cartera.getCodigo())) {
				
				Filter filtroUsuProveedorBankia = genericDao.createFilter(FilterType.EQUALS, "username", remUtils.obtenerUsuarioPorDefecto(GestorActivoApi.USU_PROVEEDOR_PACI));
				Usuario usuProveedorBankia = genericDao.get(Usuario.class, filtroUsuProveedorBankia);
				
				if(!Checks.esNulo(usuProveedorBankia))
					return usuProveedorBankia;
				
			}else if (DDCartera.CODIGO_CARTERA_SAREB.equals(cartera.getCodigo())){
				
				Filter filtroUsuProveedorSareb = genericDao.createFilter(FilterType.EQUALS, "username", remUtils.obtenerUsuarioPorDefecto(GestorActivoApi.USU_PROVEEDOR_ELECNOR));
				Usuario usuProveedorSareb = genericDao.get(Usuario.class, filtroUsuProveedorSareb);
				
				if(!Checks.esNulo(usuProveedorSareb))
					return usuProveedorSareb;
				
			}else {
			//Otras carteras, el gestor de las tareas es el proveedor del trabajo
				ActivoProveedorContacto proveedor = tareaActivo.getTramite().getTrabajo().getProveedorContacto();
				if(!Checks.esNulo(proveedor))
					return proveedor.getUsuario();
			}
		}

		//Si no se ha podido determinar el gestor destinatario se mantiene el que tenga asociado la TAR_TAREAS
		//(gestor del activo para estas tareas)
		return null;
	}

	@Override
	public Usuario getSupervisor(TareaExterna tareaExterna) {
		TareaActivo tareaActivo = (TareaActivo)tareaExterna.getTareaPadre();
		
		//TODO: ¡Hay que cambiar el método para que no pida ID sino código!
		Filter filtroTipoGestor = genericDao.createFilter(FilterType.EQUALS, "codigo", GestorActivoApi.CODIGO_GESTOR_ACTIVO);
		EXTDDTipoGestor tipoGestor = genericDao.get(EXTDDTipoGestor.class, filtroTipoGestor);
		
		return gestorActivoApi.getGestorByActivoYTipo(tareaActivo.getActivo(), tipoGestor.getId());
	}

}
