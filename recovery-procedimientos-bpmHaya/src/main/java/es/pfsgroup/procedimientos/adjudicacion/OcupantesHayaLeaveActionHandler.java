package es.pfsgroup.procedimientos.adjudicacion;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import org.jbpm.graph.exe.ExecutionContext;
import org.springframework.beans.factory.annotation.Autowired;

import es.capgemini.devon.bo.Executor;
import es.capgemini.pfs.asunto.model.Procedimiento;
import es.capgemini.pfs.bien.model.Bien;
import es.capgemini.pfs.bien.model.ProcedimientoBien;
import es.capgemini.pfs.multigestor.api.GestorAdicionalAsuntoApi;
import es.capgemini.pfs.primaria.PrimariaBusinessOperation;
import es.capgemini.pfs.procesosJudiciales.model.TareaExterna;
import es.capgemini.pfs.procesosJudiciales.model.TareaExternaValor;
import es.capgemini.pfs.tareaNotificacion.model.DDTipoEntidad;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.plugin.recovery.coreextension.adjudicacion.api.AdjudicacionHandlerDelegateApi;
import es.pfsgroup.plugin.recovery.coreextension.adjudicacion.dto.DtoCrearAnotacion;
import es.pfsgroup.plugin.recovery.coreextension.subasta.api.SubastaProcedimientoApi;
import es.pfsgroup.plugin.recovery.coreextension.subasta.model.LoteSubasta;
import es.pfsgroup.plugin.recovery.coreextension.subasta.model.Subasta;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.api.model.NMBInformacionRegistralBienInfo;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.model.NMBAdjudicacionBien;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.model.NMBBien;
import es.pfsgroup.procedimientos.PROGenericLeaveActionHandler;
import es.pfsgroup.recovery.ext.impl.tareas.EXTTareaExternaValor;

public class OcupantesHayaLeaveActionHandler extends
		PROGenericLeaveActionHandler {
	/**
	 * 
	 */
	private static final long serialVersionUID = 4574718797919597271L;

	private final static String CODIGO_TIPO_GESTOR_ADMISION = "GAREO";

	@Autowired
	GenericABMDao genericDao;

	@Autowired
	private ApiProxyFactory proxyFactory;

	@Autowired
	private Executor executor;
	
	private SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd");

	@Override
	protected void process(Object delegateTransitionClass,
			Object delegateSpecificClass, ExecutionContext executionContext) {

		super.process(delegateTransitionClass, delegateSpecificClass,
				executionContext);

		personalizamosTramiteAdjudicacion(executionContext);
	}

	private void personalizamosTramiteAdjudicacion(
			ExecutionContext executionContext) {

		Procedimiento prc = getProcedimiento(executionContext);
		TareaExterna tex = getTareaExterna(executionContext);
		List<EXTTareaExternaValor> listado = ((SubastaProcedimientoApi) proxyFactory
				.proxy(SubastaProcedimientoApi.class))
				.obtenerValoresTareaByTexId(tex.getId());
		
		if ("H048_ResolucionFirme".equals(executionContext.getNode().getName())) {
			List<Usuario> lUsuario = proxyFactory.proxy(
					GestorAdicionalAsuntoApi.class).findGestoresByAsunto(
					prc.getAsunto().getId(), CODIGO_TIPO_GESTOR_ADMISION);
			if (!Checks.estaVacio(lUsuario)) {
				List<Long> listIdUsuarioGestor = new ArrayList<Long>();
				for (Usuario usu : lUsuario) {
					listIdUsuarioGestor.add(usu.getId());
				}
				// Se crea la anotacion y se llamara al EXECUTOR

				NMBInformacionRegistralBienInfo infoBien = getDatosRegistralesActivo(prc);

				String asunto = "Referencia del asunto de ocupantes";
				StringBuilder cuerpoEmail = new StringBuilder();
				cuerpoEmail.append("Le comunico la resoluci&oacute;n favorable de gesti&oacute;n de");
				cuerpoEmail.append(" ocupantes del inmueble numero de finca:");
				cuerpoEmail.append(!Checks.esNulo(infoBien) && !Checks.esNulo(infoBien.getNumFinca())? infoBien.getNumFinca() : "     "); // numeroFinca
				cuerpoEmail.append(" y referencia catastral:");
				cuerpoEmail.append(!Checks.esNulo(infoBien) && !Checks.esNulo(infoBien.getReferenciaCatastralBien()) ? infoBien.getReferenciaCatastralBien() : "          "); // RefCatastral
				cuerpoEmail.append(" para que notifique al departamento de alquileres de la situaci&oacute;n");
				cuerpoEmail.append(" en la que se encuentra el inmueble.");

				DtoCrearAnotacion crearAnotacion = DtoCrearAnotacion
						.crearAnotacionDTO(listIdUsuarioGestor, false, true,
								null, asunto, cuerpoEmail.toString(), prc
										.getAsunto().getId(),
								DDTipoEntidad.CODIGO_ENTIDAD_ASUNTO, "A");

				proxyFactory.proxy(AdjudicacionHandlerDelegateApi.class)
						.createAnotacion(crearAnotacion);
			}
		}
		else if ("H048_TrasladoDocuDeteccionOcupantes".equals(executionContext.getNode().getName())) {
			
			for (TareaExternaValor tev : listado) {
				try {
					if ("comboInquilino".equals(tev.getNombre())) {
						guardaInfoBienes("comboInquilino", tev.getValor(), prc);
					}
					if ("fechaContrato".equals(tev.getNombre())) {
						guardaInfoBienes("fechaContrato", tev.getValor(), prc);
					}
				} catch (Exception e) {
					e.printStackTrace();
				}
			}
		}
	}

	private void guardaInfoBienes(String campo, String valor, Procedimiento prc) {
		
		if("comboInquilino".equals(campo) || "fechaContrato".equals(campo)){
			//Comprobamos los bienes
			List<Bien> listadoBienes = getBienesSubastaByPrcId(prc.getId());
			for(Bien b : listadoBienes){
				if(b instanceof NMBBien){
					NMBBien bien = (NMBBien) b;
					if(!Checks.esNulo(((NMBBien) b).getAdjudicacion())){
						NMBAdjudicacionBien adju = ((NMBBien) b).getAdjudicacion();
						
						if("comboInquilino".equals(campo)){						
							adju.setExisteInquilino("01".equals(valor));
						}
						if("fechaContrato".equals(campo)){						
							try {
								Date fecha = formatter.parse(valor);
								adju.setFechaContratoArrendamiento(fecha);
							} catch (ParseException e) {
								e.printStackTrace();
							}							
						}
						
						genericDao.save(NMBAdjudicacionBien.class, adju);
					}
				}
			}
		}
		
	}
	
	private List<Bien> getBienesSubastaByPrcId(Long prcId){
		// Buscamos primero la subasta asociada al prc
		Subasta sub = genericDao.get(Subasta.class, genericDao.createFilter(FilterType.EQUALS, "procedimiento.id", prcId), genericDao.createFilter(FilterType.EQUALS, "borrado", false));
		
		List<Bien> bienes = new ArrayList<Bien>();
		
		if (!Checks.esNulo(sub)) {

			// buscamos los lotes de la subasta
			List<LoteSubasta> listadoLotes = sub.getLotesSubasta();
			
			if (!Checks.estaVacio(listadoLotes)) {
				for(int i=0; i<listadoLotes.size(); i++){		
					bienes.addAll(listadoLotes.get(i).getBienes());
				}
			}
		}
		
		return bienes;
	}

	private NMBInformacionRegistralBienInfo getDatosRegistralesActivo(
			Procedimiento prc) {
		NMBInformacionRegistralBienInfo infoBien = null;
		if (!Checks.estaVacio(prc.getBienes())) {
			ProcedimientoBien prcBien = prc.getBienes().get(0);
			NMBBien nmbBien = (NMBBien) executor.execute(
					PrimariaBusinessOperation.BO_BIEN_MGR_GET, prcBien.getBien().getId());
			infoBien = nmbBien.getDatosRegistralesActivo();
		}
		return infoBien;
	}

}
