package es.pfsgroup.plugin.recovery.masivo.test.MSVFileUploadFacade.matchers;

import org.mockito.ArgumentMatcher;

import es.capgemini.devon.files.FileItem;
import es.pfsgroup.plugin.recovery.masivo.model.ExcelFileBean;

public class UploadFormArgumentMatcher extends ArgumentMatcher<ExcelFileBean> {
	
	private FileItem fileItem;

	public UploadFormArgumentMatcher(FileItem fileItem) {
		this.fileItem = fileItem;
	}

	@Override
	public boolean matches(Object arg0) {
		if (arg0 instanceof ExcelFileBean){
			ExcelFileBean efb = (ExcelFileBean) arg0;
			if (efb.getFileItem() != null){
				return efb.getFileItem().equals(fileItem);
			}
		}
		return false;
	}

}
