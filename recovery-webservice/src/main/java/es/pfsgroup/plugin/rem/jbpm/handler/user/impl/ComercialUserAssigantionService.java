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
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.TareaActivo;
import es.pfsgroup.plugin.rem.model.dd.DDTipoComercializar;

@Component
public class ComercialUserAssigantionService implements UserAssigantionService  {

	private static final String CODIGO_T013_DEFINICION_OFERTA = "T013_DefinicionOferta";
	private static final String CODIGO_T013_FIRMA_PROPIETARIO = "T013_FirmaPropietario";
	private static final String CODIGO_T013_RESOLUCION_COMITE = "T013_ResolucionComite";
	private static final String CODIGO_T013_RESPUESTA_OFERTANTE = "T013_RespuestaOfertante";
	private static final String CODIGO_T013_DOBLE_FIRMA = "T013_DobleFirma";
	private static final String CODIGO_T013_INSTRUCCIONES_RESERVA = "T013_InstruccionesReserva";
	private static final String CODIGO_T013_RESOLUCION_EXPEDIENTE = "T013_ResolucionExpediente";
	
	//Las siguientes tareas, NO las realizan gestores comerciales
	//private static final String CODIGO_T013_CIERRE_ECONOMICO = "T013_CierreEconomico";
	//private static final String CODIGO_T013_INFORME_JURIDICO = "T013_InformeJuridico";
	//private static final String CODIGO_T013_OBTENCION_CONTRATO_RESERVA = "T013_ObtencionContratoReserva";
	//private static final String CODIGO_T013_RESOLUCION_TANTEO = "T013_ResolucionTanteo";
	//private static final String CODIGO_T013_RESULTADO_PBC = "T013_ResultadoPBC";
	//private static final String CODIGO_T013_POSICIONAMIENTO_FIRMA = "T013_PosicionamientoYFirma";
	//private static final String CODIGO_T013_DEVOLUCION_LLAVES = "T013_DevolucionLlaves";
	//private static final String CODIGO_T013_DOCUMENTOS_POSTVENTA = "T013_DocumentosPostVenta";

	
	
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
		return new String[]{CODIGO_T013_DEFINICION_OFERTA, CODIGO_T013_FIRMA_PROPIETARIO,  CODIGO_T013_RESOLUCION_COMITE,
				 	CODIGO_T013_RESPUESTA_OFERTANTE, CODIGO_T013_DOBLE_FIRMA,  CODIGO_T013_INSTRUCCIONES_RESERVA,
				 	CODIGO_T013_RESOLUCION_EXPEDIENTE };
	}

	@Override
	@SuppressWarnings("static-access")
	public Usuario getUser(TareaExterna tareaExterna) {
		TareaActivo tareaActivo = (TareaActivo)tareaExterna.getTareaPadre();
		
		Filter filtroTipoGestor = genericDao.createFilter(FilterType.EQUALS, "codigo", gestorActivoApi.CODIGO_GESTOR_COMERCIAL);
		Activo activo = tareaActivo.getTramite().getActivo();
		
		if(!Checks.esNulo(activo)) {
			//Si el tipo es nulo, por defecto, se entiende como tipo RETAIL 
			String codigoComercializacionActivo = Checks.esNulo(activo.getTipoComercializar()) ? DDTipoComercializar.CODIGO_RETAIL : activo.getTipoComercializar().getCodigo();
			
			if(codigoComercializacionActivo.equals(DDTipoComercializar.CODIGO_RETAIL)) {
				filtroTipoGestor = genericDao.createFilter(FilterType.EQUALS, "codigo", gestorActivoApi.CODIGO_GESTOR_COMERCIAL_RETAIL);
			} 
			else if(codigoComercializacionActivo.equals(DDTipoComercializar.CODIGO_SINGULAR)) {
				filtroTipoGestor = genericDao.createFilter(FilterType.EQUALS, "codigo", gestorActivoApi.CODIGO_GESTOR_COMERCIAL_SINGULAR);
			}
		}
		
		EXTDDTipoGestor tipoGestor = genericDao.get(EXTDDTipoGestor.class, filtroTipoGestor);

		return gestorActivoApi.getGestorByActivoYTipo(tareaActivo.getActivo(), tipoGestor.getId());
	}

	@Override
	@SuppressWarnings("static-access")
	public Usuario getSupervisor(TareaExterna tareaExterna) {
		TareaActivo tareaActivo = (TareaActivo)tareaExterna.getTareaPadre();
		
		Filter filtroTipoGestor = genericDao.createFilter(FilterType.EQUALS, "codigo", gestorActivoApi.CODIGO_SUPERVISOR_COMERCIAL);
		Activo activo = tareaActivo.getTramite().getActivo();
		
		if(!Checks.esNulo(activo)) {
			//Si el tipo es nulo, por defecto, se entiende como tipo RETAIL 
			String codigoComercializacionActivo = Checks.esNulo(activo.getTipoComercializar()) ? DDTipoComercializar.CODIGO_RETAIL : activo.getTipoComercializar().getCodigo();
			
			if(codigoComercializacionActivo.equals(DDTipoComercializar.CODIGO_RETAIL)) {
				filtroTipoGestor = genericDao.createFilter(FilterType.EQUALS, "codigo", gestorActivoApi.CODIGO_SUPERVISOR_COMERCIAL_RETAIL);
			} 
			else if(codigoComercializacionActivo.equals(DDTipoComercializar.CODIGO_SINGULAR)) {
				filtroTipoGestor = genericDao.createFilter(FilterType.EQUALS, "codigo", gestorActivoApi.CODIGO_SUPERVISOR_COMERCIAL_SINGULAR);
			}
		}
		
		EXTDDTipoGestor tipoGestor = genericDao.get(EXTDDTipoGestor.class, filtroTipoGestor);

		return gestorActivoApi.getGestorByActivoYTipo(tareaActivo.getActivo(), tipoGestor.getId());
	}
}
