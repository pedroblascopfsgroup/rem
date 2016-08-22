package es.pfsgroup.plugin.rem.excel;

import java.io.File;
import java.io.IOException;

import javax.servlet.http.HttpServletResponse;

public interface ExcelReportGeneratorApi {

	public void sendReport(File reportFile, HttpServletResponse response) throws IOException;

	public File generateReport(ExcelReport report);

	public void generateAndSend(ExcelReport report, HttpServletResponse response) throws IOException;
	
	public int getStart();
	
	public int getLimit();

}