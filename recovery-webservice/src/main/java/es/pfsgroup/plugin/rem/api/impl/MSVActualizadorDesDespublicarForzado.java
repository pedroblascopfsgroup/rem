package es.pfsgroup.plugin.rem.api.impl;

import java.io.IOException;
import java.util.Date;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.core.api.usuario.UsuarioApi;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.Order;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.OrderType;
import es.pfsgroup.framework.paradise.bulkUpload.adapter.ProcessAdapter;
import es.pfsgroup.framework.paradise.bulkUpload.api.ExcelManagerApi;
import es.pfsgroup.framework.paradise.bulkUpload.liberators.MSVLiberator;
import es.pfsgroup.framework.paradise.bulkUpload.model.MSVDDOperacionMasiva;
import es.pfsgroup.framework.paradise.bulkUpload.model.MSVDocumentoMasivo;
import es.pfsgroup.framework.paradise.bulkUpload.utils.impl.MSVHojaExcel;
import es.pfsgroup.plugin.recovery.coreextension.utils.api.UtilDiccionarioApi;
import es.pfsgroup.plugin.rem.api.ActivoApi;
import es.pfsgroup.plugin.rem.api.ActivoEstadoPublicacionApi;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.ActivoHistoricoEstadoPublicacion;
import es.pfsgroup.plugin.rem.model.DtoCambioEstadoPublicacion;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoPublicacion;
import es.pfsgroup.plugin.rem.model.dd.DDTipoPublicacion;

@Component
public class MSVActualizadorDesDespublicarForzado implements MSVLiberator {

	@Autowired
	private ApiProxyFactory proxyFactory;
		
	@Autowired
	ProcessAdapter processAdapter;
	
	@Autowired
	private GenericABMDao genericDao;
	
	@Autowired
	private UtilDiccionarioApi utilDiccionarioApi;
	
	@Autowired
	ActivoApi activoApi;

	@Autowired
	UsuarioApi usuarioApi;
	
	@Autowired
	ActivoEstadoPublicacionApi activoEstadoPublicacionApi;

	@Override
	public Boolean isValidFor(MSVDDOperacionMasiva tipoOperacion) {
		if (!Checks.esNulo(tipoOperacion)){
			if (MSVDDOperacionMasiva.CODE_FILE_BULKUPLOAD_ACTUALIZAR_DESMARCAR_DESPUBLICAR_FORZADO.equals(tipoOperacion.getCodigo())){
				return true;
			}else {
				return false;
			}
		}else{
			return false;
		}
	}

	@Override
	@Transactional(readOnly = false)
	public Boolean liberaFichero(MSVDocumentoMasivo file) throws IllegalArgumentException, IOException {

		// Desmarcar "Despublicacion forzada": el activo vuelve al estado de publicacion anterior (del historico)
		processAdapter.setStateProcessing(file.getProcesoMasivo().getId());
		MSVHojaExcel exc = proxyFactory.proxy(ExcelManagerApi.class).getHojaExcel(file);
	
		for (int fila = 1; fila < exc.getNumeroFilas(); fila++) {
			Activo activo = activoApi.getByNumActivo(Long.parseLong(exc.dameCelda(fila, 0)));
			
			Filter filtro = genericDao.createFilter(FilterType.EQUALS, "activo.id", activo.getId());
			Order order = new Order(OrderType.DESC, "id");
			ActivoHistoricoEstadoPublicacion ultimoActivoHistoricoEstadosPublicacion = genericDao
					.getListOrdered(ActivoHistoricoEstadoPublicacion.class, order, filtro).get(0);
			
			DDEstadoPublicacion estadoPublicacionAnterior;
			if(!Checks.esNulo(ultimoActivoHistoricoEstadosPublicacion)){
				estadoPublicacionAnterior  = ultimoActivoHistoricoEstadosPublicacion.getEstadoPublicacion();
			}else{
				estadoPublicacionAnterior = (DDEstadoPublicacion) utilDiccionarioApi.dameValorDiccionarioByCod(DDEstadoPublicacion.class, DDEstadoPublicacion.CODIGO_PUBLICADO);
			}
			
			// Se establece en el activo, el estado de publicacion anterior
			activo.setEstadoPublicacion(estadoPublicacionAnterior);
			
			// Se historifica de nuevo el estado que cambiamos
			ActivoHistoricoEstadoPublicacion estadoHistoricoPublicacion = new ActivoHistoricoEstadoPublicacion();
			estadoHistoricoPublicacion.setActivo(activo);
			estadoHistoricoPublicacion.setEstadoPublicacion(estadoPublicacionAnterior);
			//Fecha desde
			if(!Checks.esNulo(ultimoActivoHistoricoEstadosPublicacion))
				estadoHistoricoPublicacion.setFechaDesde(ultimoActivoHistoricoEstadosPublicacion.getFechaDesde());
			else
				estadoHistoricoPublicacion.setFechaDesde(new Date());
			//Fecha hasta
			if(!Checks.esNulo(ultimoActivoHistoricoEstadosPublicacion))
				estadoHistoricoPublicacion.setFechaHasta(ultimoActivoHistoricoEstadosPublicacion.getFechaHasta());
			else
				estadoHistoricoPublicacion.setFechaHasta(null);
			//Tipo publicacion: Forzada
			estadoHistoricoPublicacion.setTipoPublicacion((DDTipoPublicacion) utilDiccionarioApi.dameValorDiccionarioByCod(DDTipoPublicacion.class, DDTipoPublicacion.CODIGO_FORZADA));
			//Portal web
			if(!Checks.esNulo(ultimoActivoHistoricoEstadosPublicacion))
				estadoHistoricoPublicacion.setPortal(ultimoActivoHistoricoEstadosPublicacion.getPortal());
			else
				estadoHistoricoPublicacion.setPortal(null);
			//Auditoria
			Auditoria auditoria = new Auditoria();
			auditoria.setFechaCrear(new Date());
			auditoria.setUsuarioCrear(usuarioApi.getUsuarioLogado().getUsername());
			estadoHistoricoPublicacion.setAuditoria(auditoria);
			
			genericDao.save(ActivoHistoricoEstadoPublicacion.class, estadoHistoricoPublicacion);
			activoApi.saveOrUpdate(activo);

		}

		return true;
	}

}
