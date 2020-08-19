package es.pfsgroup.plugin.rem.api.impl;

import java.io.IOException;
import java.sql.SQLException;
import java.text.ParseException;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.Order;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.OrderType;
import es.pfsgroup.framework.paradise.bulkUpload.liberators.MSVLiberator;
import es.pfsgroup.framework.paradise.bulkUpload.model.MSVDDOperacionMasiva;
import es.pfsgroup.framework.paradise.bulkUpload.model.ResultadoProcesarFila;
import es.pfsgroup.framework.paradise.bulkUpload.utils.impl.MSVHojaExcel;
import es.pfsgroup.framework.paradise.utils.JsonViewerException;
import es.pfsgroup.plugin.rem.api.TrabajoApi;
import es.pfsgroup.plugin.rem.model.ActivoProveedor;
import es.pfsgroup.plugin.rem.model.ActivoProveedorContacto;
import es.pfsgroup.plugin.rem.model.GastoLineaDetalle;
import es.pfsgroup.plugin.rem.model.GastoProveedor;
import es.pfsgroup.plugin.rem.model.Trabajo;
import es.pfsgroup.plugin.rem.model.dd.DDSubtipoGasto;
import es.pfsgroup.plugin.rem.model.dd.DDTipoRecargoGasto;
import es.pfsgroup.plugin.rem.model.dd.DDTiposImpuesto;


@Component
public class MSVMasivaModificacionLineasDetalle extends AbstractMSVActualizador implements MSVLiberator {
	private static final int DATOS_PRIMERA_FILA = 1;
	private static final int ID_GASTO = 0;
	private static final int ACCION_LINIA_DETALLE = 1;
	private static final int SUBTIPO_GASTO = 2;
	private static final int PRINCIPAL_SUJETO_A_IMPUESTO = 3;
	private static final int PRINCIPAL_NO_SUJETO_A_IMPUESTO = 4;
	private static final int TIPO_RECARGO = 5;
	private static final int IMPORTE_RECARGO = 6;
	private static final int INTERES_DEMORA = 7;
	private static final int COSTES = 8;
	private static final int OTROS_INCREMENTOS = 9;
	private static final int PROVISIONES_SUPLIDOS = 10;
	private static final int TIPO_IMPUESTO = 11;
	private static final int OPERACION_EXENTA = 12;
	private static final int RENUNCIA_EXENCION = 13;
	private static final int TIPO_IMPOSITIVO = 14;
	private static final int OPTA_POR_CRITERIO_DE_CAJA_EN_IVA = 15;
	private static final int ID_ELEMENTO = 16;
	private static final int TIPO_ELEMENTO = 17;
	private static final int PARTICIPACION_LINEA_DETALLE = 18;
	
	private static final String ACCION_BORRAR = "Borrar";
	private static final String ACCION_AÑADIR = "Añadir";
	
	private static final String SI = "SI";
	private static final String S = "S";
	
	@Autowired
	private GenericABMDao genericDao;
		
	@Override
	public String getValidOperation() {
		return MSVDDOperacionMasiva.CODE_FILE_BULKUPLOAD_CARGA_MASIVA_MODIFICACION_LINEAS_DETALLE;
	}
	@Autowired
	private TrabajoApi trabajoApi;
	

	@Override
	public ResultadoProcesarFila procesaFila(MSVHojaExcel exc, int fila, Long prmToken)
			throws IOException, ParseException, JsonViewerException, SQLException, Exception {
		
		try {
			
			String accionRealizar = exc.dameCelda(fila, ACCION_LINIA_DETALLE);
			
			if(ACCION_AÑADIR.equals(accionRealizar)) {
				
				GastoLineaDetalle gastoLineaDetalle = new GastoLineaDetalle();
				
				Filter filtroGasto = genericDao.createFilter(FilterType.EQUALS, "numGastoHaya", Long.parseLong(exc.dameCelda(fila, ID_GASTO)));
				GastoProveedor gastoProveedor = genericDao.get(GastoProveedor.class, filtroGasto);
				
				gastoLineaDetalle.setGastoProveedor(gastoProveedor);
				
				Filter filtroSubGasto = genericDao.createFilter(FilterType.EQUALS, "codigo", exc.dameCelda(fila, SUBTIPO_GASTO));
				DDSubtipoGasto subtipoGasto = genericDao.get(DDSubtipoGasto.class, filtroSubGasto);
				
				gastoLineaDetalle.setSubtipoGasto(subtipoGasto);
				
				if(exc.dameCelda(fila, PRINCIPAL_SUJETO_A_IMPUESTO) != null) {
					gastoLineaDetalle.setPrincipalSujeto(Double.parseDouble(exc.dameCelda(fila, PRINCIPAL_SUJETO_A_IMPUESTO)));
				}
				
				if(exc.dameCelda(fila, PRINCIPAL_NO_SUJETO_A_IMPUESTO) != null) {
					gastoLineaDetalle.setPrincipalNoSujeto(Double.parseDouble(exc.dameCelda(fila, PRINCIPAL_NO_SUJETO_A_IMPUESTO)));
				}
				
				if(exc.dameCelda(fila, TIPO_RECARGO) != null) {
					Filter filtroTipoRecargo = genericDao.createFilter(FilterType.EQUALS, "codigo", exc.dameCelda(fila, TIPO_RECARGO));
					DDTipoRecargoGasto tipoRecargoGasto = genericDao.get(DDTipoRecargoGasto.class, filtroTipoRecargo);
					
					gastoLineaDetalle.setTipoRecargoGasto(tipoRecargoGasto);
				}
				
				if(exc.dameCelda(fila, IMPORTE_RECARGO) != null) {
					gastoLineaDetalle.setRecargo(Double.parseDouble(exc.dameCelda(fila, IMPORTE_RECARGO)));
				}
				
				if(exc.dameCelda(fila, INTERES_DEMORA) != null) {
					gastoLineaDetalle.setInteresDemora(Double.parseDouble(exc.dameCelda(fila, INTERES_DEMORA)));
				}
				
				if(exc.dameCelda(fila, COSTES) != null) {
					gastoLineaDetalle.setCostas(Double.parseDouble(exc.dameCelda(fila, COSTES)));
				}
				
				if(exc.dameCelda(fila, OTROS_INCREMENTOS) != null) {
					gastoLineaDetalle.setOtrosIncrementos(Double.parseDouble(exc.dameCelda(fila, OTROS_INCREMENTOS)));
				}
				
				if(exc.dameCelda(fila, PROVISIONES_SUPLIDOS) != null) {
					gastoLineaDetalle.setProvSuplidos(Double.parseDouble(exc.dameCelda(fila, PROVISIONES_SUPLIDOS)));
				}
				
				if(exc.dameCelda(fila, TIPO_IMPUESTO) != null) {
					Filter filtroTipoImpuesto= genericDao.createFilter(FilterType.EQUALS, "codigo", exc.dameCelda(fila, TIPO_IMPUESTO));
					DDTiposImpuesto tipoImpuesto = genericDao.get(DDTiposImpuesto.class, filtroTipoImpuesto);
					
					gastoLineaDetalle.setTipoImpuesto(tipoImpuesto);
				}
				
				if(exc.dameCelda(fila, OPERACION_EXENTA) != null) {
					
					if(SI.equalsIgnoreCase(exc.dameCelda(fila, OPERACION_EXENTA)) || S.equalsIgnoreCase(exc.dameCelda(fila, OPERACION_EXENTA))) {
						gastoLineaDetalle.setEsImporteIndirectoExento(true);
					} else {
						gastoLineaDetalle.setEsImporteIndirectoExento(false);
					}
				}
				
				if(exc.dameCelda(fila, RENUNCIA_EXENCION) != null) {
					
					if(SI.equalsIgnoreCase(exc.dameCelda(fila, RENUNCIA_EXENCION)) || S.equalsIgnoreCase(exc.dameCelda(fila, RENUNCIA_EXENCION))) {
						gastoLineaDetalle.setEsImporteIndirectoRenunciaExento(true);
					} else {
						gastoLineaDetalle.setEsImporteIndirectoRenunciaExento(false);
					}
				}
				
				if(exc.dameCelda(fila, TIPO_IMPOSITIVO) != null) {
					gastoLineaDetalle.setImporteIndirectoTipoImpositivo(Double.parseDouble(exc.dameCelda(fila, TIPO_IMPOSITIVO)));
				}
				
				if(gastoLineaDetalle.getPrincipalSujeto() != null || gastoLineaDetalle.getImporteIndirectoTipoImpositivo() != null) {
					
					Double importe = (gastoLineaDetalle.getPrincipalSujeto() * gastoLineaDetalle.getImporteIndirectoTipoImpositivo())/100;
					
					gastoLineaDetalle.setImporteIndirectoCuota(importe);
				}
				
				if(gastoLineaDetalle.getPrincipalSujeto() != null || gastoLineaDetalle.getPrincipalNoSujeto() != null || gastoLineaDetalle.get() != null
						|| gastoLineaDetalle.get() != null || gastoLineaDetalle.get() != null || gastoLineaDetalle.get() != null) {
					
					Double importeTotal = (gastoLineaDetalle.getPrincipalSujeto() * gastoLineaDetalle.getImporteIndirectoTipoImpositivo())/100;
					
					gastoLineaDetalle.setImporteIndirectoCuota(importeTotal);
				}
			}
			
		} catch (Exception e) {
			// TODO: handle exception
		}
		
		
//		Trabajo trabajo = trabajoApi.getTrabajoByNumeroTrabajo(Long.parseLong(exc.dameCelda(fila, NUM_TRABAJO)));
//		
//		Usuario usuarioResponsable = getUsuarioByUsername(exc.dameCelda(fila, RESPONSABLE_TRABAJO));
//		
//		Usuario gestorActivo = getUsuarioByUsername(exc.dameCelda(fila, GESTOR_ACTIVO));
//		
//		Usuario supervisorActivo = getUsuarioByUsername(exc.dameCelda(fila, SUPERVISOR_ACTIVO));
//		
//		Usuario usuarioContacto = getUsuarioByUsername(exc.dameCelda(fila, USUARIO_CONTACTO));
//		
//		String codProveedor = exc.dameCelda(fila, CODIGO_PROVEEDOR);
//		
//		
//		if (usuarioResponsable != null )
//		    trabajo.setUsuarioResponsableTrabajo(usuarioResponsable);
//		if (gestorActivo != null)
//		    trabajo.setUsuarioGestorActivoResponsable(gestorActivo);
//		if (supervisorActivo != null)
//		    trabajo.setSupervisorActivoResponsable(supervisorActivo);
//		if (usuarioContacto != null && codProveedor.length() > 0) {
//		    ActivoProveedorContacto activoProveedorContacto = getProveedorByCodigoAndUser(codProveedor, usuarioContacto);
//		    trabajo.setProveedorContacto(activoProveedorContacto);
//		}
		
		
		
		genericDao.save(Trabajo.class, trabajo);
		return new ResultadoProcesarFila();
	}

	@Override
	public int getFilaInicial() {
		return DATOS_PRIMERA_FILA;
	}

	private Usuario getUsuarioByUsername(String userName) {
	    if ( userName == null || userName.length() == 0) {
	        return null;
	    }else {
	        return genericDao.get(Usuario.class, genericDao.createFilter(FilterType.EQUALS, "username", userName));
	    }
	}
	private ActivoProveedorContacto getProveedorByCodigoAndUser(String codProveedor, Usuario usuario) {
	    ActivoProveedorContacto resp = null;
        if (codProveedor != null && codProveedor.length() >0  && usuario != null){
            Filter filtroActivoProveedor  = genericDao.createFilter(FilterType.EQUALS, "codigoProveedorRem", Long.valueOf(codProveedor));
        	ActivoProveedor activoProveedor = genericDao.get(ActivoProveedor.class, filtroActivoProveedor);
        	if(activoProveedor != null) {
	            Filter f1  = genericDao.createFilter(FilterType.EQUALS, "id", activoProveedor.getId());
	            Filter f2 =  genericDao.createFilter(FilterType.EQUALS, "usuario", usuario);
	            Order order = new Order(OrderType.DESC, "id");
	            List<ActivoProveedorContacto> apList = genericDao.getListOrdered(ActivoProveedorContacto.class, order, f1, f2);
	            if(apList != null && !apList.isEmpty()) {
	            	resp = apList.get(0);
	            }
	        }
        }
	       
	    return resp;
	}
}
