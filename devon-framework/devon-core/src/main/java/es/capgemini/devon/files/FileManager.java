package es.capgemini.devon.files;

public interface FileManager {

    /**
     * Creates a new FileItem with a temporary File
     * 
     * @return
     * @throws FileException
     */
    public abstract FileItem createTemporaryFileItem() throws FileException;

    /**
     * @param fileItem
     * @return
     * @throws FileException
     */
    public abstract boolean deleteTemporaryFileItem(FileItem fileItem) throws FileException;

}