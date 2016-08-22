package es.pfsgroup.framework.paradise.bulkUpload.api.impl;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import es.capgemini.devon.bo.BusinessOperationException;
import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.devon.files.WebFileItem;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.framework.paradise.bulkUpload.api.MSVFileManagerApi;
import es.pfsgroup.framework.paradise.bulkUpload.dto.MSVDtoResultadoSubidaFicheroMasivo;
import es.pfsgroup.framework.paradise.bulkUpload.model.MSVFileItem;
import es.pfsgroup.recovery.ext.impl.tipoFicheroAdjunto.DDTipoFicheroAdjunto;

@Service
public class MSVFileManager implements MSVFileManagerApi{

	@Autowired
	private GenericABMDao genericDao;
	
	@Override
	@BusinessOperation(MSVFileManagerApi.MSV_BO_UPLOAD_FICHERO)
	public MSVDtoResultadoSubidaFicheroMasivo uploadFile(WebFileItem uploadForm) {
		
		if (uploadForm.getFileItem() == null)
			throw new BusinessOperationException("El objeto FileItem es nulo.");
		
		MSVFileItem msvFileItem = new MSVFileItem();
		msvFileItem.setFileItem(uploadForm.getFileItem());
		msvFileItem.setNombre(uploadForm.getFileItem().getFileName());
		msvFileItem.setContentType(uploadForm.getFileItem().getContentType());
		
		// DIANA: insertamos tambi�n el tipo de documento adjunto
		String comboTipoFichero = uploadForm.getParameter("comboTipoFichero");
		
		if (comboTipoFichero != null) {
			DDTipoFicheroAdjunto tipoFicheroAdjunto = genericDao.get(DDTipoFicheroAdjunto.class, genericDao.createFilter(FilterType.EQUALS, "codigo", comboTipoFichero));
			msvFileItem.setTipoFichero(tipoFicheroAdjunto);
		}
		
		msvFileItem = genericDao.save(MSVFileItem.class, msvFileItem);
		
		MSVDtoResultadoSubidaFicheroMasivo dto = new MSVDtoResultadoSubidaFicheroMasivo();
		dto.setIdFichero(msvFileItem.getId());
		
		return dto;
		
	}

	@Override
	@BusinessOperation(MSVFileManagerApi.MSV_BO_GET_FILE)
	public MSVFileItem getFile(Long idFichero) {

		if (idFichero == null)
			return null;
			//throw new BusinessOperationException("El par�metro idFichero es nulo.");
		
		Filter filter = genericDao.createFilter(FilterType.EQUALS, "id", idFichero);
		MSVFileItem msvFileItem = genericDao.get(MSVFileItem.class, filter);
		
		return msvFileItem;
	}

}
