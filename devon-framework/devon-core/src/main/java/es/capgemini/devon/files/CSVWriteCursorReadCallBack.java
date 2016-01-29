package es.capgemini.devon.files;

import java.io.IOException;
import java.io.Writer;

import es.capgemini.devon.utils.StringUtils;

public class CSVWriteCursorReadCallBack implements CursorReadCallBack {

    FileItem fileItem;
    Writer writer;

    @SuppressWarnings("unused")
    private CSVWriteCursorReadCallBack() {
        // Constructor vacio para que funcionen los tests (SpringTests)
    }

    //FIXME : eeeepa, cambiar el filemanager por un fileItemFactory
    public CSVWriteCursorReadCallBack(String name, FileManager fileManager) {
        fileItem = fileManager.createTemporaryFileItem();
        fileItem.setContentType("application/vnd.ms-excel");
        fileItem.setFileName(name);

        writer = fileItem.getWriter();
    }

    @Override
    public void doWithLine(Object[] row) throws FileException {
        try {
            writer.append(StringUtils.arrayToSemiColonDelimitedString(row)).append("\n");
        } catch (IOException e) {
            try {
                writer.flush();
                writer.close();
            } catch (IOException e2) {
            }
            throw new FileException(e);
        }
    }

    @Override
    public void afterLast() throws FileException {
        try {
            writer.flush();
            writer.close();
        } catch (IOException e) {
            throw new FileException(e);
        }
    }

    public FileItem getFileItem() {
        return fileItem;
    }

    @Override
    public void beforeFirst() {
        //en este caso la faena la hacemos en el constructor

    }

}
