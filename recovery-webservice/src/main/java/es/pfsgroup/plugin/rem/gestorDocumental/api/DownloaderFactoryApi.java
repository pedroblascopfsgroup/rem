package es.pfsgroup.plugin.rem.gestorDocumental.api;

public interface DownloaderFactoryApi {
	
	Downloader getDownloader(final String key);

}
