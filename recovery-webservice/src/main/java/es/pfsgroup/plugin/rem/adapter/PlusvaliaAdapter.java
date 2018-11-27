package es.pfsgroup.plugin.rem.adapter;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

import javax.annotation.Resource;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.transaction.annotation.Transactional;

import es.capgemini.devon.beans.Service;
import es.capgemini.devon.message.MessageService;
import es.capgemini.pfs.procesosJudiciales.TipoProcedimientoManager;
import es.capgemini.pfs.procesosJudiciales.model.DDSiNo;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.framework.paradise.bulkUpload.adapter.ProcessAdapter;
import es.pfsgroup.framework.paradise.jbpm.JBPMProcessManagerApi;
import es.pfsgroup.framework.paradise.utils.BeanUtilNotNull;
import es.pfsgroup.framework.paradise.utils.JsonViewerException;
import es.pfsgroup.plugin.rem.api.AgrupacionAvisadorApi;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.ActivoOferta;
import es.pfsgroup.plugin.rem.model.ExpedienteComercial;
import es.pfsgroup.plugin.rem.model.Oferta;
import es.pfsgroup.plugin.rem.model.PlusvaliaVentaExpedienteComercial;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoOferta;
import es.pfsgroup.plugin.rem.model.dd.DDSituacionComercial;

@Service
public class PlusvaliaAdapter {

	@Autowired
	private GenericABMDao genericDao;

	@Autowired
	protected JBPMProcessManagerApi jbpmProcessManagerApi;

	@Autowired
	protected TipoProcedimientoManager tipoProcedimiento;

	BeanUtilNotNull beanUtilNotNull = new BeanUtilNotNull();

	@Autowired
	List<AgrupacionAvisadorApi> avisadores;

	@Resource
	MessageService messageServices;
	
	@Autowired
	ProcessAdapter processAdapter;

	private final Log logger = LogFactory.getLog(getClass());

	public static final String OFERTA_INCOMPATIBLE_AGR_MSG = "El tipo de oferta es incompatible con el destino comercial de algún activo";
	public static final String OFERTA_AGR_LOTE_COMERCIAL_GESTORES_NULL_MSG = "No se puede aceptar la oferta debido a que no se encuentran todos los gestores asignados";
	public static final String PUBLICACION_ACTIVOS_AGRUPACION_ERROR_MSG = "No ha sido posible publicar. Algún activo no tiene las condiciones necesarias";
	public static final String PUBLICACION_MOTIVO_MSG = "Publicado desde agrupación";
	public static final String PUBLICACION_AGRUPACION_BAJA_ERROR_MSG = "No ha sido posible publicar. La agrupación está dada de baja";
	public static final String AGRUPACION_BAJA_ERROR_OFERTAS_VIVAS = "No ha sido posible dar de baja la agrupación. Existen ofertas vivas";
	private static final String AVISO_MENSAJE_TIPO_NUMERO_DOCUMENTO = "activo.motivo.oferta.tipo.numero.documento";
	private static final String AVISO_MENSAJE_CLIENTE_OBLIGATORIO = "activo.motivo.oferta.cliente";


	@Transactional(readOnly = false)
	public void updatePlusvalia(Long numActivo, String exento,  String autoLiquidacion, String fechaEscritoAyto, String observaciones)
			throws JsonViewerException {

		Filter filter = genericDao.createFilter(FilterType.EQUALS, "numActivo", numActivo);
		Activo activo = genericDao.get(Activo.class, filter);
		if (DDSituacionComercial.CODIGO_VENDIDO.equals(activo.getSituacionComercial().getCodigo())){
			List<ActivoOferta> actOfrList = genericDao.getList(ActivoOferta.class, genericDao.createFilter(FilterType.EQUALS, "activo", activo.getId()));
			Oferta ofertaTramitada = null;
			ExpedienteComercial eco = null;
			for (ActivoOferta ao : actOfrList){
				if (DDEstadoOferta.CODIGO_ACEPTADA.equals(ao.getPrimaryKey().getOferta().getEstadoOferta().getCodigo())){
					ofertaTramitada = ao.getPrimaryKey().getOferta();
				}
			}
			
			PlusvaliaVentaExpedienteComercial plusvalia = new PlusvaliaVentaExpedienteComercial();
	
			try {
				
				if (Checks.esNulo(activo)) {
					throw new JsonViewerException("El activo no existe");
				}
				
				if (!Checks.esNulo(ofertaTramitada)){
					eco = genericDao.get(ExpedienteComercial.class, genericDao.createFilter(FilterType.EQUALS, "oferta.id", ofertaTramitada.getId()));
					if (!Checks.esNulo(eco)) {						
						plusvalia = genericDao.get(PlusvaliaVentaExpedienteComercial.class, genericDao.createFilter(FilterType.EQUALS,"expediente.id",eco.getId()),
								genericDao.createFilter(FilterType.EQUALS,"auditoria.borrado", false));
						
						if (!Checks.esNulo(plusvalia)) {
							if (!Checks.esNulo(plusvalia.getExento()) && !Checks.esNulo(plusvalia.getAutoliquidacion()) && !Checks.esNulo(plusvalia.getFechaEscritoAyt()) && !Checks.esNulo(plusvalia.getObservaciones())){
								throw new JsonViewerException("La plusvalia de este activo ya está informada");
							} else {
								if (!Checks.esNulo(exento) && Checks.esNulo(plusvalia.getExento())){
									if ("SI".equals(exento.toUpperCase())) {
										plusvalia.setExento(1);
									}else if ("NO".equals(exento.toUpperCase())){
										plusvalia.setExento(0);
									}
								}
								if (!Checks.esNulo(autoLiquidacion) && Checks.esNulo(plusvalia.getAutoliquidacion())){
									if ("SI".equals(autoLiquidacion.toUpperCase())) {
										plusvalia.setAutoliquidacion(1);
									}else if ("NO".equals(autoLiquidacion.toUpperCase())){
										plusvalia.setAutoliquidacion(0);
									}
									
								}
								if (!Checks.esNulo(fechaEscritoAyto) && Checks.esNulo(plusvalia.getFechaEscritoAyt())){
									Date date1=new SimpleDateFormat("dd/MM/yyyy").parse(fechaEscritoAyto);  
								    plusvalia.setFechaEscritoAyt(date1);
								}
							    if (!Checks.esNulo(observaciones) && Checks.esNulo(plusvalia.getObservaciones())){
							    	plusvalia.setObservaciones(observaciones);
							    }
							}				
						    genericDao.update(PlusvaliaVentaExpedienteComercial.class, plusvalia);
						} else {
							PlusvaliaVentaExpedienteComercial plusvaliaNew = new PlusvaliaVentaExpedienteComercial();
							if (!Checks.esNulo(exento)){
								if ("SI".equals(exento.toUpperCase())) {
									plusvalia.setExento(1);
								}else if ("NO".equals(exento.toUpperCase())){
									plusvalia.setExento(0);
								}
							}
							if (!Checks.esNulo(autoLiquidacion)){
								if ("SI".equals(autoLiquidacion.toUpperCase())) {
									plusvalia.setAutoliquidacion(1);
								}else if ("NO".equals(autoLiquidacion.toUpperCase())){
									plusvalia.setAutoliquidacion(0);
								}
							}
							if (!Checks.esNulo(fechaEscritoAyto)){
								Date date1=new SimpleDateFormat("dd/MM/yyyy").parse(fechaEscritoAyto);  
								plusvaliaNew.setFechaEscritoAyt(date1);
							}
						    if (!Checks.esNulo(observaciones)){
						    	plusvaliaNew.setObservaciones(observaciones);
						    }
						    if (!Checks.esNulo(eco)){
						    	plusvaliaNew.setExpediente(eco);
						    }
						    genericDao.save(PlusvaliaVentaExpedienteComercial.class, plusvaliaNew);
						}
					}else {
						throw new JsonViewerException("El activo no tiene ofertas con expediente");
					}
				}else {
					throw new JsonViewerException("El activo no tiene ofertas tramitadas");
				}
				
		} catch (JsonViewerException jve) {
			throw jve;
		} catch (Exception e) {
			logger.error(e);
			e.printStackTrace();
		}
		}else {
			throw new JsonViewerException("El activo no esta vendido");
		}
	}

}