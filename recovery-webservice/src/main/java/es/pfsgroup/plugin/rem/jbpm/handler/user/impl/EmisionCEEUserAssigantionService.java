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
import es.pfsgroup.plugin.rem.api.GestorActivoApi;
import es.pfsgroup.plugin.rem.jbpm.handler.user.UserAssigantionService;
import es.pfsgroup.plugin.rem.model.ActivoProveedor;
import es.pfsgroup.plugin.rem.model.ActivoProveedorContacto;
import es.pfsgroup.plugin.rem.model.TareaActivo;
import es.pfsgroup.plugin.rem.model.dd.DDCartera;

@Component
public class EmisionCEEUserAssigantionService implements UserAssigantionService {

	private static final String CODIGO_T003_EMISION_CERTIFICADO = "T003_EmisionCertificado";
	private static final String CODIGO_T003_SOLICITUD_ETIQUETA = "T003_SolicitudEtiqueta";
	private static final String CODIGO_T003_OBTENCION_ETIQUETA = "T003_ObtencionEtiqueta";
	
	private static final String NOMBRE_PROVEEDOR_BANKIA_SAREB = "Tinsa Certify";
	
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
			
			// Si la cartera es BANKIA o SAREB, el gestor de las tareas es TINSA CERTIFY
			if(DDCartera.CODIGO_CARTERA_BANKIA.equals(cartera.getCodigo()) || DDCartera.CODIGO_CARTERA_SAREB.equals(cartera.getCodigo())){
				//Proveedor Tinsa
				Filter filtroProveedorBankiaSareb = genericDao.createFilter(FilterType.EQUALS, "nombre", NOMBRE_PROVEEDOR_BANKIA_SAREB);
				ActivoProveedor proveedorBankiaSareb = genericDao.get(ActivoProveedor.class, filtroProveedorBankiaSareb);
				//Proveedor contacto Tinsa
				Filter filtroProveedorContactoBankiaSareb = genericDao.createFilter(FilterType.EQUALS, "id", proveedorBankiaSareb.getId());
				ActivoProveedorContacto proveedorContactoBankiaSareb = genericDao.get(ActivoProveedorContacto.class, filtroProveedorContactoBankiaSareb);
				
				if(!Checks.esNulo(proveedorContactoBankiaSareb))
					return proveedorContactoBankiaSareb.getUsuario();

			} else {
			//Otras carteras, el gestor de las tareas es el proveedor del trabajo
				ActivoProveedorContacto proveedor = tareaActivo.getTramite().getTrabajo().getProveedorContacto();
				if(!Checks.esNulo(proveedor))
					return proveedor.getUsuario();
			}
		}

		//Si no se ha podido determinar el gestor destinatario de las tareas en este punto, pondremos como gestor
		//el gestor del activo
		//TODO: ¡Hay que cambiar el método para que no pida ID sino código!
		Filter filtroTipoGestor = genericDao.createFilter(FilterType.EQUALS, "codigo", gestorActivoApi.CODIGO_GESTOR_ACTIVO);
		EXTDDTipoGestor tipoGestor = genericDao.get(EXTDDTipoGestor.class, filtroTipoGestor);
		
		return gestorActivoApi.getGestorByActivoYTipo(tareaActivo.getActivo(), tipoGestor.getId());
	}

	@Override
	public Usuario getSupervisor(TareaExterna tareaExterna) {
		TareaActivo tareaActivo = (TareaActivo)tareaExterna.getTareaPadre();
		
		//TODO: ¡Hay que cambiar el método para que no pida ID sino código!
		Filter filtroTipoGestor = genericDao.createFilter(FilterType.EQUALS, "codigo", gestorActivoApi.CODIGO_GESTOR_ACTIVO);
		EXTDDTipoGestor tipoGestor = genericDao.get(EXTDDTipoGestor.class, filtroTipoGestor);
		
		return gestorActivoApi.getGestorByActivoYTipo(tareaActivo.getActivo(), tipoGestor.getId());
	}

}
